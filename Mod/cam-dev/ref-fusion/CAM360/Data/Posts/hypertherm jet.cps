/**
  Copyright (C) 2012-2025 by Autodesk, Inc.
  All rights reserved.

  Hypertherm jet post processor configuration.

  $Revision: 45583 10f6400eaf1c75a27c852ee82b57479e7a9134c0 $
  $Date: 2025-08-21 13:23:15 $

  FORKID {B9932870-E8DA-4805-9AFD-C639CB6FF089}
*/

description = "Hypertherm Jet";
vendor = "Hypertherm";
vendorUrl = "https://www.hypertherm.com/";
legal = "Copyright (C) 2012-2025 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45702;

longDescription = "Generic jet post for Hypertherm.";

extension = "nc";
setCodePage("ascii");

capabilities = CAPABILITY_JET;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(180);
allowHelicalMoves = false;
allowedCircularPlanes = undefined; // allow any circular motion

// user-defined properties
properties = {
  writeMachine: {
    title      : "Write machine",
    description: "Output the machine settings in the header of the code.",
    group      : "formats",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showSequenceNumbers: {
    title      : "Use sequence numbers",
    description: "Use sequence numbers for each block of outputted code.",
    group      : "formats",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  sequenceNumberStart: {
    title      : "Start sequence number",
    description: "The number at which to start the sequence numbers.",
    group      : "formats",
    type       : "integer",
    value      : 10,
    scope      : "post"
  },
  sequenceNumberIncrement: {
    title      : "Sequence number increment",
    description: "The amount by which the sequence number is incremented by in each block.",
    group      : "formats",
    type       : "integer",
    value      : 5,
    scope      : "post"
  },
  allowHeadSwitches: {
    title      : "Allow head switches",
    description: "Enable to output code to allow heads to be manually switched for piercing and cutting.",
    group      : "preferences",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  separateWordsWithSpace: {
    title      : "Separate words with space",
    description: "Adds spaces between words if 'yes' is selected.",
    group      : "formats",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  pierceTime: {
    title      : "Pierce time",
    description: "Specifies the pierce time.  Specifying a value of 0 will use the Setup Dwell Time defined in the controller.",
    group      : "preferences",
    type       : "number",
    value      : 5,
    range      : [0, 99999.999],
    scope      : "post"
  },
};

// wcs definiton
wcsDefinitions = {
  useZeroOffset: false,
  wcs          : [
    {name:"Standard", format:"#", range:[1, 1]}
  ]
};

var gFormat = createFormat({prefix:"G", decimals:0});
var mFormat = createFormat({prefix:"M", decimals:0});
var dFormat = createFormat({prefix:"D", decimals:0}); // kerf index

var xyzFormat = createFormat({decimals:(unit == MM ? 3 : 4)});
var feedFormat = createFormat({decimals:(unit == MM ? 1 : 2)});
var toolFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:3, forceDecimal:true}); // seconds - range 0.001-1000

var xOutput = createVariable({prefix:"X"}, xyzFormat);
var yOutput = createVariable({prefix:"Y"}, xyzFormat);
var feedOutput = createVariable({prefix:"F"}, feedFormat);

// circular output
var iOutput = createReferenceVariable({prefix:"I"}, xyzFormat);
var jOutput = createReferenceVariable({prefix:"J"}, xyzFormat);

var gMotionModal = createModal({}, gFormat); // modal group 1 // G0-G3, ...
var gAbsIncModal = createModal({}, gFormat); // modal group 3 // G90-91
var gUnitModal = createModal({}, gFormat); // modal group 6 // G20-21

// collected state
var sequenceNumber;
var currentWorkOffset;

/**
  Writes the specified block.
*/
function writeBlock() {
  if (getProperty("showSequenceNumbers")) {
    writeWords2("N" + sequenceNumber, arguments);
    sequenceNumber += getProperty("sequenceNumberIncrement");
  } else {
    writeWords(arguments);
  }
}

function formatComment(text) {
  return "(" + String(text).replace(/[()]/g, "") + ")";
}

/**
  Output a comment.
*/
function writeComment(text) {
  writeln(formatComment(text));
}

function onOpen() {

  if (!getProperty("separateWordsWithSpace")) {
    setWordSeparator("");
  }

  sequenceNumber = getProperty("sequenceNumberStart");

  if (programName) {
    writeComment(programName);
  }
  if (programComment) {
    writeComment(programComment);
  }

  // dump machine configuration
  var vendor = machineConfiguration.getVendor();
  var model = machineConfiguration.getModel();
  var description = machineConfiguration.getDescription();

  if (getProperty("writeMachine") && (vendor || model || description)) {
    writeComment(localize("Machine"));
    if (vendor) {
      writeComment("  " + localize("vendor") + ": " + vendor);
    }
    if (model) {
      writeComment("  " + localize("model") + ": " + model);
    }
    if (description) {
      writeComment("  " + localize("description") + ": " + description);
    }
  }

  // absolute coordinates and feed per min
  writeBlock(gAbsIncModal.format(90));

  switch (unit) {
  case IN:
    writeBlock(gUnitModal.format(20));
    break;
  case MM:
    writeBlock(gUnitModal.format(21));
    break;
  }
}

function onComment(message) {
  writeComment(message);
}

/** Force output of X, Y, and Z. */
function forceXYZ() {
  xOutput.reset();
  yOutput.reset();
}

/** Force output of X, Y, Z, A, B, C, and F on next output. */
function forceAny() {
  forceXYZ();
  feedOutput.reset();
}

function onSection() {
  var insertToolCall = isFirstSection() ||
    currentSection.getForceToolChange && currentSection.getForceToolChange() ||
    (tool.number != getPreviousSection().getTool().number);

  var retracted = false; // specifies that the tool has been retracted to the safe plane
  var newWorkOffset = isFirstSection() ||
    (getPreviousSection().workOffset != currentSection.workOffset); // work offset changes
  var newWorkPlane = isFirstSection() ||
    !isSameDirection(getPreviousSection().getGlobalFinalToolAxis(), currentSection.getGlobalInitialToolAxis());

  writeln("");

  if (hasParameter("operation-comment")) {
    var comment = getParameter("operation-comment");
    if (comment) {
      writeComment(comment);
    }
  }

  if (insertToolCall) {
    retracted = true;
    onCommand(COMMAND_COOLANT_OFF);

    switch (tool.type) {
    case TOOL_WATER_JET:
      writeBlock(mFormat.format(36), "T" + toolFormat.format(6)); // waterjet
      break;
    case TOOL_LASER_CUTTER:
      writeBlock(mFormat.format(36), "T" + toolFormat.format(5)); // laser
      break;
    case TOOL_PLASMA_CUTTER:
      // process 1 - use T2 for process 2
      writeBlock(mFormat.format(36), "T" + toolFormat.format(1)); // plasma
      break;
    /*
    case TOOL_MARKER:
      writeBlock(mFormat.format(36), "T" + toolFormat.format(3)); // marker 1 - use 4 for marker 2
      break;
    */
    default:
      error(localize("The CNC does not support the required tool."));
      return;
    }

    // use could use - G59 Dxxx Xkerf to set kerf

    if (tool.comment) {
      writeComment(tool.comment);
    }
    switch (currentSection.jetMode) {
    case JET_MODE_THROUGH:
      writeComment("Through cutting");
      break;
    case JET_MODE_ETCHING:
      writeComment("Etch cutting");
      break;
    case JET_MODE_VAPORIZE:
      writeComment("Vaporize cutting");
      break;
    default:
      error(localize("Unsupported cutting mode."));
    }
    writeln("");
  }

  // wcs
  /*
  if (insertToolCall) { // force work offset when changing tool
    currentWorkOffset = undefined;
  }

  if (currentSection.workOffset != currentWorkOffset) {
    writeBlock(currentSection.wcs);
    currentWorkOffset = currentSection.workOffset;
  }
 */

  forceXYZ();

  { // pure 3D
    var remaining = currentSection.workPlane;
    if (!isSameDirection(remaining.forward, new Vector(0, 0, 1))) {
      error(localize("Tool orientation is not supported."));
      return;
    }
    setRotation(remaining);
  }

  /*
  // set coolant after we have positioned at Z
  if (false) {
    var c = mapCoolantTable.lookup(tool.coolant);
    if (c) {
      writeBlock(mFormat.format(c));
    } else {
      warning(localize("Coolant not supported."));
    }
  }
*/

  forceAny();

  var initialPosition = getFramePosition(currentSection.getInitialPosition());

  if (insertToolCall || retracted) {
    gMotionModal.reset();

    if (!machineConfiguration.isHeadConfiguration()) {
      writeBlock(
        gAbsIncModal.format(90),
        gMotionModal.format(0), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y)
      );
    } else {
      writeBlock(
        gAbsIncModal.format(90),
        gMotionModal.format(0),
        xOutput.format(initialPosition.x),
        yOutput.format(initialPosition.y)
      );
    }
  } else {
    writeBlock(
      gAbsIncModal.format(90),
      gMotionModal.format(0),
      xOutput.format(initialPosition.x),
      yOutput.format(initialPosition.y)
    );
  }
}

function onDwell(seconds) {
  if (seconds > 99999.999) {
    warning(localize("Dwelling time is out of range."));
  }
  seconds = clamp(0, seconds, 99999.999);
  writeBlock(gFormat.format(4), conditional(seconds != 0, "F" + secFormat.format(seconds)));
}

function onCycle() {
  onError("Drilling is not supported by CNC.");
}

var pendingRadiusCompensation = -1;

function onRadiusCompensation() {
  pendingRadiusCompensation = radiusCompensation;
}

var shapeArea = 0;
var shapePerimeter = 0;
var shapeSide = "inner";
var cuttingSequence = "";

function onParameter(name, value) {
  if ((name == "action") && (value == "pierce")) {
    writeComment("POINT-PIERCE");
    onDwell(getProperty("pierceTime")); // wait until cut through
    // for plasma AVC - writeBlock(mFormat.format(51), "T" + secFormat.format(delay)); // wait
  } else if (name == "shapeArea") {
    shapeArea = value;
  } else if (name == "shapePerimeter") {
    shapePerimeter = value;
  } else if (name == "shapeSide") {
    shapeSide = value;
  } else if (name == "beginSequence") {
    if (value == "piercing") {
      if (cuttingSequence != "piercing") {
        if (getProperty("allowHeadSwitches")) {
          writeln("");
          writeComment("Switch to piercing head before continuing");
          onCommand(COMMAND_STOP);
          writeln("");
        }
      }
    } else if (value == "cutting") {
      if (cuttingSequence == "piercing") {
        if (getProperty("allowHeadSwitches")) {
          writeln("");
          writeComment("Switch to cutting head before continuing");
          onCommand(COMMAND_STOP);
          writeln("");
        }
      }
    }
    cuttingSequence = value;
  }
}

var deviceOn = false;

function setDeviceMode(enable) {
  if (enable != deviceOn) {
    deviceOn = enable;
    if (enable) {
      switch (tool.type) {
      /*
      case TOOL_MARKER:
        writeComment("TURN ON MARKER 1");
        writeBlock(mFormat.format(9)); // enable marker 1
        break;
      */
      default:
        writeComment((currentSection.jetMode == JET_MODE_ETCHING) ? "TURN ON ETCHING" : "TURN ON CUTTING");
        if (currentSection.jetMode == JET_MODE_ETCHING) {
          writeBlock(mFormat.format(63));
        }
        writeBlock(mFormat.format(7)); // DEVICE ON
        // writeBlock(mFormat.format(15)); // CUT ON
      }
    } else {
      switch (tool.type) {
      /*
      case TOOL_MARKER:
        writeComment("TURN OFF MARKER 1");
        writeBlock(mFormat.format(10)); // disable marker 1
        break;
      */
      default:
        writeComment((currentSection.jetMode == JET_MODE_ETCHING) ? "TURN OFF ETCHING" : "TURN OFF CUTTING");
        writeBlock(mFormat.format(8)); // DEVICE OFF - could add delay here
        if (currentSection.jetMode == JET_MODE_ETCHING) {
          writeBlock(mFormat.format(64));
        }
        // writeBlock(mFormat.format(16)); // CUT OFF
      }
    }
  }
}

function onPower(power) {
  setDeviceMode(power);
}

function onRapid(_x, _y, _z) {
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  if (x || y) {
    if (pendingRadiusCompensation >= 0) {
      error(localize("Radius compensation mode cannot be changed at rapid traversal."));
      return;
    }
    writeBlock(gMotionModal.format(0), x, y);
    feedOutput.reset();
  }
}

function onLinear(_x, _y, _z, feed) {

  // at least one axis is required
  if (pendingRadiusCompensation >= 0) {
    // ensure that we end at desired position when compensation is turned off
    xOutput.reset();
    yOutput.reset();
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var f = feedOutput.format(feed);
  if (x || y) {
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      switch (radiusCompensation) {
      case RADIUS_COMPENSATION_LEFT:
        writeBlock(gFormat.format(41));
        // use dFormat for keft offset - which is currently not supported
        writeBlock(gMotionModal.format(1), x, y, f);
        break;
      case RADIUS_COMPENSATION_RIGHT:
        writeBlock(gFormat.format(42));
        // use dFormat for keft offset - which is currently not supported
        writeBlock(gMotionModal.format(1), x, y, f);
        break;
      default:
        writeBlock(gFormat.format(40));
        writeBlock(gMotionModal.format(1), x, y, f);
      }
    } else {
      writeBlock(gMotionModal.format(1), x, y, f);
    }
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      feedOutput.reset(); // force feed on next line
    } else {
      writeBlock(gMotionModal.format(1), f);
    }
  }
}

function onRapid5D(_x, _y, _z, _a, _b, _c) {
  error(localize("The CNC does not support 5-axis simultaneous toolpath."));
}

function onLinear5D(_x, _y, _z, _a, _b, _c, feed) {
  error(localize("The CNC does not support 5-axis simultaneous toolpath."));
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {

  // one of X/Y and I/J are required and likewise

  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
    return;
  }

  var start = getCurrentPosition();
  if (isFullCircle()) {
    if (isHelical()) {
      linearize(tolerance);
      return;
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), feedOutput.format(feed));
      break;
    default:
      linearize(tolerance);
    }
  } else {
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), feedOutput.format(feed));
      break;
    default:
      linearize(tolerance);
    }
  }
}

var mapCommand = {
  COMMAND_STOP         : 0,
  COMMAND_OPTIONAL_STOP: 1,
  COMMAND_END          : 2
};

function onCommand(command) {
  switch (command) {
  case COMMAND_POWER_ON:
    return;
  case COMMAND_POWER_OFF:
    return;
  case COMMAND_COOLANT_ON:
    return;
  case COMMAND_COOLANT_OFF:
    return;
  case COMMAND_LOCK_MULTI_AXIS:
    return;
  case COMMAND_UNLOCK_MULTI_AXIS:
    return;
  case COMMAND_BREAK_CONTROL:
    return;
  case COMMAND_TOOL_MEASURE:
    return;
  }

  var stringId = getCommandStringId(command);
  var mcode = mapCommand[stringId];
  if (mcode != undefined) {
    writeBlock(mFormat.format(mcode));
  } else {
    onUnsupportedCommand(command);
  }
}

function onSectionEnd() {
  setDeviceMode(false);
  forceAny();
}

function onClose() {
  writeln("");

  onCommand(COMMAND_COOLANT_OFF);

  writeBlock(mFormat.format(19));
  // writeBlock(gFormat.format(280), gFormat.format(281));

  onImpliedCommand(COMMAND_END);
  writeBlock(mFormat.format(30)); // stop program
}

function setProperty(property, value) {
  properties[property].current = value;
}
