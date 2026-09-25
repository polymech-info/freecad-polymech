/**
  Copyright (C) 2012-2021 by Autodesk, Inc.
  All rights reserved.

  DynaPath post processor configuration.

  $Revision: 43569 147f5cf60e9217cf9c3365dc511a0f631d89bb16 $
  $Date: 2021-10-13 13:53:32 $

  FORKID {5F1E6C60-D016-4b56-9185-06567E057238}
*/

description = "DynaPath Delta";
vendor = "DynaPath";
vendorUrl = "http://www.dynapath.com";
legal = "Copyright (C) 2012-2021 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45702;

longDescription = "Generic milling post for DynaPath Delta.";

extension = "txt";
setCodePage("ascii");

capabilities = CAPABILITY_MILLING;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(180);
allowHelicalMoves = true;
allowedCircularPlanes = undefined; // allow any circular motion

// user-defined properties
properties = {
  writeMachine: {
    title      : "Write machine",
    description: "Output the machine settings in the header of the code.",
    group      : 0,
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  writeTools: {
    title      : "Write tool list",
    description: "Output a tool list in the header of the code.",
    group      : 0,
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  sequenceNumberStart: {
    title      : "Start sequence number",
    description: "The number at which to start the sequence numbers.",
    group      : 1,
    type       : "integer",
    value      : 100,
    scope      : "post"
  },
  sequenceNumberIncrement: {
    title      : "Sequence number increment",
    description: "The amount by which the sequence number is incremented by in each block.",
    group      : 1,
    type       : "integer",
    value      : 1,
    scope      : "post"
  },
  optionalStop: {
    title      : "Optional stop",
    description: "Outputs optional stop code during when necessary in the code.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  separateWordsWithSpace: {
    title      : "Separate words with space",
    description: "Adds spaces between words if 'yes' is selected.",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useToolChanger: {
    title      : "Use tool changer",
    description: "Specifies that a tool changer is available.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  useCoolant: {
    title      : "Use coolant",
    description: "Specifies that coolant should be output",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  useChipBreaking: {
    title      : "Use chip breaking",
    description: "Enable to output chip breaking cycles, the cycle will be expanded if disabled.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  useRS274: {
    title      : "Use RS274",
    description: "Enable to output RS-274 code.",
    type       : "boolean",
    value      : false,
    scope      : "post"
  }
};

var numberOfToolSlots = 99;

var gFormat = createFormat({prefix:"G", decimals:0});
var idFormat = createFormat({prefix:"(", suffix:")", decimals:0});
var mFormat = createFormat({prefix:"M", decimals:0});
var planeFormat = createFormat({prefix:"P", decimals:0});

var xyzFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var feedFormat = createFormat({decimals:1, forceDecimal:true});
var toolFormat = createFormat({decimals:0});
var rpmFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:1}); // seconds
var taperFormat = createFormat({decimals:1, scale:DEG});

var xOutput = createVariable({prefix:"X"}, xyzFormat);
var yOutput = createVariable({prefix:"Y"}, xyzFormat);
var zOutput = createVariable({onchange:function() {retracted = false;}, prefix:"Z"}, xyzFormat);
var feedOutput = createVariable({prefix:"F"}, feedFormat);
var sOutput = createVariable({prefix:"S", force:true}, rpmFormat);

// circular output
var iOutput = createVariable({prefix:"I", force:true}, xyzFormat);
var jOutput = createVariable({prefix:"J", force:true}, xyzFormat);
var kOutput = createVariable({prefix:"K", force:true}, xyzFormat);

var planeModal = createModal({}, planeFormat); // P0, P1, P2

// RS274
var gMotionModal = createModal({force:true}, gFormat); // G0-G3, ...
var gPlaneModal = createModal({onchange:function () {gMotionModal.reset();}}, gFormat); // G17-19
var gAbsIncModal = createModal({}, gFormat); // G90-91
var gFeedModeModal = createModal({}, gFormat); // G93-94
var gUnitModal = createModal({}, gFormat); // G70-71

var WARNING_WORK_OFFSET = 0;

// collected state
var sequenceNumber;
var currentWorkOffset;
var retracted = false; // specifies that the tool has been retracted to the safe plane

/**
  Writes the specified block.
*/
function writeBlock() {
  var text = formatWords(arguments);
  if (!text) {
    return;
  }
  writeWords2("N" + (sequenceNumber % 10000), arguments, "$");
  sequenceNumber += getProperty("sequenceNumberIncrement");
  if (sequenceNumber > 10000) {
    sequenceNumber = getProperty("sequenceNumberStart");
  }
}

/**
  Writes the specified block.
*/
function writeOptionalBlock() {
  writeWords2("/N" + (sequenceNumber % 10000), arguments, "$");
  sequenceNumber += getProperty("sequenceNumberIncrement");
  if (sequenceNumber > 10000) {
    sequenceNumber = getProperty("sequenceNumberStart");
  }
}

function formatComment(text) {
  return String(text).replace(/[()]/g, "");
}

/**
  Output a comment.
*/
function writeComment(text) {
  writeWords2("N" + (sequenceNumber % 10000), "(T)", formatComment(text), "$");
  sequenceNumber += getProperty("sequenceNumberIncrement");
  if (sequenceNumber > 10000) {
    sequenceNumber = getProperty("sequenceNumberStart");
  }
}

/**
  Output text block.
*/
function writeText(text) {
  writeWords2("N" + (sequenceNumber % 10000), "(T)", "$");
  sequenceNumber += getProperty("sequenceNumberIncrement");
  if (sequenceNumber > 10000) {
    sequenceNumber = getProperty("sequenceNumberStart");
  }
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
      writeComment("  " + localize("description") + ": "  + description);
    }
  }

  // dump tool information
  if (getProperty("writeTools")) {
    var zRanges = {};
    if (is3D()) {
      var numberOfSections = getNumberOfSections();
      for (var i = 0; i < numberOfSections; ++i) {
        var section = getSection(i);
        var zRange = section.getGlobalZRange();
        var tool = section.getTool();
        if (zRanges[tool.number]) {
          zRanges[tool.number].expandToRange(zRange);
        } else {
          zRanges[tool.number] = zRange;
        }
      }
    }

    var tools = getToolTable();
    if (tools.getNumberOfTools() > 0) {
      for (var i = 0; i < tools.getNumberOfTools(); ++i) {
        var tool = tools.getTool(i);
        var comment = "T" + toolFormat.format(tool.number) + "  " +
          "D=" + xyzFormat.format(tool.diameter) + " " +
          localize("CR") + "=" + xyzFormat.format(tool.cornerRadius);
        if ((tool.taperAngle > 0) && (tool.taperAngle < Math.PI)) {
          comment += " " + localize("TAPER") + "=" + taperFormat.format(tool.taperAngle) + localize("deg");
        }
        if (zRanges[tool.number]) {
          comment += " - " + localize("ZMIN") + "=" + xyzFormat.format(zRanges[tool.number].getMinimum());
        }
        comment += " - " + getToolTypeName(tool.type);
        writeComment(comment);
      }
    }
  }

  if ((getNumberOfSections() > 0) && (getSection(0).workOffset == 0)) {
    for (var i = 0; i < getNumberOfSections(); ++i) {
      if (getSection(i).workOffset > 0) {
        error(localize("Using multiple work offsets is not possible if the initial work offset is 0."));
        return;
      }
    }
  }

  if (getProperty("useRS274")) {
    // absolute coordinates and feed per min
    writeBlock("(E)", gAbsIncModal.format(90));
    writeBlock("(E)", gFeedModeModal.format(94));
    writeBlock("(E)", gPlaneModal.format(17));

    switch (unit) {
    case IN:
      writeBlock("(E)", gUnitModal.format(70));
      break;
    case MM:
      writeBlock("(E)", gUnitModal.format(71));
      break;
    }
  }
}

function onComment(message) {
  writeComment(message);
}

/** Force output of X, Y, and Z. */
function forceXYZ() {
  xOutput.reset();
  yOutput.reset();
  zOutput.reset();
}

/** Force output of X, Y, Z, and F on next output. */
function forceAny() {
  forceXYZ();
  feedOutput.reset();
}

function onSection() {
  var insertToolCall = isFirstSection() ||
    currentSection.getForceToolChange && currentSection.getForceToolChange() ||
    (tool.number != getPreviousSection().getTool().number);

  retracted = false;
  var newWorkOffset = isFirstSection() ||
    (getPreviousSection().workOffset != currentSection.workOffset); // work offset changes
  var newWorkPlane = isFirstSection() ||
    !isSameDirection(getPreviousSection().getGlobalFinalToolAxis(), currentSection.getGlobalInitialToolAxis()) ||
    (currentSection.isOptimizedForMachine() && getPreviousSection().isOptimizedForMachine() &&
      Vector.diff(getPreviousSection().getFinalToolAxisABC(), currentSection.getInitialToolAxisABC()).length > 1e-4) ||
    (!machineConfiguration.isMultiAxisConfiguration() && currentSection.isMultiAxis()) ||
    (!getPreviousSection().isMultiAxis() && currentSection.isMultiAxis() ||
      getPreviousSection().isMultiAxis() && !currentSection.isMultiAxis()); // force newWorkPlane between indexing and simultaneous operations

  if (insertToolCall || newWorkOffset || newWorkPlane) {

    // stop spindle before retract during tool change
    if (insertToolCall && !isFirstSection()) {
      onCommand(COMMAND_STOP_SPINDLE);
    }

    // retract to safe plane
    // writeRetract(Z);
    // zOutput.reset();
  }

  if (hasParameter("operation-comment")) {
    var comment = getParameter("operation-comment");
    if (comment) {
      writeComment(comment);
    }
  }

  if (insertToolCall) {
    onCommand(COMMAND_COOLANT_OFF);

    if (!isFirstSection()) {
      onCommand(COMMAND_STOP_SPINDLE);
    }

    if (getProperty("useToolChanger")) {
      if (!isFirstSection() && getProperty("optionalStop")) {
        onCommand(COMMAND_OPTIONAL_STOP);
      }
    }

    if (tool.number > numberOfToolSlots) {
      warning(localize("Tool number exceeds maximum value."));
    }
    if (getProperty("useToolChanger")) {
      if (getProperty("useRS274")) {
        writeBlock("(E)", "T" + toolFormat.format(tool.number), mFormat.format(6));
      } else {
        if (!isFirstSection()) {
          writeBlock(idFormat.format(9), mFormat.format(6), "T" + toolFormat.format(tool.number));
        }
      }
    }
    if (tool.comment) {
      writeComment(tool.comment);
    }
    var showToolZMin = false;
    if (showToolZMin) {
      if (is3D()) {
        var numberOfSections = getNumberOfSections();
        var zRange = currentSection.getGlobalZRange();
        var number = tool.number;
        for (var i = currentSection.getId() + 1; i < numberOfSections; ++i) {
          var section = getSection(i);
          if (section.getTool().number != number) {
            break;
          }
          zRange.expandToRange(section.getGlobalZRange());
        }
        writeComment(localize("ZMIN") + "=" + zRange.getMinimum());
      }
    }

    if (!getProperty("useToolChanger")) {
      onCommand(COMMAND_STOP);
    }
  }

  if (insertToolCall ||
      isFirstSection() ||
      (rpmFormat.areDifferent(spindleSpeed, sOutput.getCurrent())) ||
      (tool.clockwise != getPreviousSection().getTool().clockwise)) {
    if (spindleSpeed < 1) {
      error(localize("Spindle speed out of range."));
    }
    if (spindleSpeed > 99999) {
      warning(localize("Spindle speed exceeds maximum value."));
    }

    if (getProperty("useRS274")) {
      writeBlock(
        "(E)", sOutput.format(spindleSpeed), mFormat.format(tool.clockwise ? 3 : 4)
      );
    } else {
      writeBlock(
        idFormat.format(9), mFormat.format(tool.clockwise ? 3 : 4), sOutput.format(spindleSpeed), "T" + toolFormat.format(tool.number)
      );
    }
  }

  // wcs
  if (insertToolCall) { // force work offset when changing tool
    currentWorkOffset = undefined;
  }
  var workOffset = currentSection.workOffset;
  if (workOffset == 0) {
    warningOnce(localize("Work offset is not specified."), WARNING_WORK_OFFSET);
  }
  if (workOffset > 0) {
    if (workOffset > 14) {
      error(localize("Work offset out of range."));
      return;
    } else {
      if (workOffset != currentWorkOffset) {
        if (getProperty("useRS274")) {
          writeBlock("(E)", "E" + workOffset); // E1-E14
        } else {
          writeBlock(idFormat.format(9), "E" + workOffset); // E1-E14
        }
        currentWorkOffset = workOffset;
      }
    }
  }

  forceXYZ();

  { // pure 3D
    var remaining = currentSection.workPlane;
    if (!isSameDirection(remaining.forward, new Vector(0, 0, 1))) {
      error(localize("Tool orientation is not supported."));
      return;
    }
    setRotation(remaining);
  }

  // set coolant after we have positioned at Z
  if (tool.coolant != COOLANT_OFF) {
    onCommand(COMMAND_COOLANT_ON);
  } else {
    onCommand(COMMAND_COOLANT_OFF);
  }

  forceAny();

  var initialPosition = getFramePosition(currentSection.getInitialPosition());
  if (!retracted && !insertToolCall) {
    if (getCurrentPosition().z < initialPosition.z) {
      if (getProperty("useRS274")) {
        writeBlock("(E)", gMotionModal.format(0), zOutput.format(initialPosition.z));
      } else {
        writeBlock(idFormat.format(0), zOutput.format(initialPosition.z));
      }
    }
  }

  if (insertToolCall || retracted) {
    if (getProperty("useRS274")) {
      gMotionModal.reset();
      var g = gPlaneModal.format(17);
      if (g) {
        writeBlock("(E)", g);
      }
    }

    if (!machineConfiguration.isHeadConfiguration()) {
      if (getProperty("useRS274")) {
        writeBlock(
          "(E)",
          gAbsIncModal.format(90),
          gMotionModal.format(0), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y)
        );
        writeBlock("(E)", gMotionModal.format(0), zOutput.format(initialPosition.z));
      } else {
        writeBlock(
          idFormat.format(0), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y)
        );
        writeBlock(idFormat.format(0), zOutput.format(initialPosition.z));
      }
    } else {
      if (getProperty("useRS274")) {
        writeBlock(
          "(E)",
          gAbsIncModal.format(90),
          gMotionModal.format(0),
          xOutput.format(initialPosition.x),
          yOutput.format(initialPosition.y),
          zOutput.format(initialPosition.z)
        );
      } else {
        writeBlock(
          idFormat.format(0),
          xOutput.format(initialPosition.x),
          yOutput.format(initialPosition.y),
          zOutput.format(initialPosition.z)
        );
      }
    }
  } else {
    if (getProperty("useRS274")) {
      writeBlock(
        gAbsIncModal.format(90),
        gMotionModal.format(0),
        xOutput.format(initialPosition.x),
        yOutput.format(initialPosition.y)
      );
    } else {
      writeBlock(
        idFormat.format(0),
        xOutput.format(initialPosition.x),
        yOutput.format(initialPosition.y)
      );
    }
  }
}

function onDwell(seconds) {
  if (seconds > 999.9) {
    warning(localize("Dwelling time is out of range."));
  }
  seconds = clamp(0.1, seconds, 999.9);
  if (getProperty("useRS274")) {
    writeBlock(gFormat.format(4), "P" + secFormat.format(seconds));
  } else {
    writeBlock(idFormat.format(8), "L" + secFormat.format(seconds));
  }
}

function onSpindleSpeed(spindleSpeed) {
  writeBlock(idFormat.format(9), /*mFormat.format(tool.clockwise ? 3 : 4), "T" + toolFormat.format(tool.number),*/ sOutput.format(spindleSpeed));
}

var pendingRadiusCompensation = -1;

function onRadiusCompensation() {
  pendingRadiusCompensation = radiusCompensation;
}

function onRapid(_x, _y, _z) {
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      error(localize("Radius compensation mode cannot be changed at rapid traversal."));
      return;
    }
    if (getProperty("useRS274")) {
      writeBlock("(E)", gMotionModal.format(0), x, y, z);
    } else {
      writeBlock(idFormat.format(0), x, y, z);
    }
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
  var z = zOutput.format(_z);
  var f = feedOutput.format(feed);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      var d = tool.diameterOffset;
      if (d > numberOfToolSlots) {
        warning(localize("The diameter offset exceeds the maximum value."));
      }
      if (getProperty("useRS274")) {
        var g = gPlaneModal.format(17);
        if (g) {
          writeBlock("(E)", g);
        }
      }
      switch (radiusCompensation) {
      case RADIUS_COMPENSATION_LEFT:
        if (getProperty("useRS274")) {
          writeBlock("(E)", gFormat.format(41));
          writeBlock("(E)", gMotionModal.format(1), x, y, z, f);
        } else {
          writeBlock(idFormat.format(1), planeModal.format(0), "C1", x, y, z, f);
        }
        break;
      case RADIUS_COMPENSATION_RIGHT:
        if (getProperty("useRS274")) {
          writeBlock("(E)", gFormat.format(42));
          writeBlock("(E)", gMotionModal.format(1), x, y, z, f);
        } else {
          writeBlock(idFormat.format(1), planeModal.format(0), "C2", x, y, z, f);
        }
        break;
      default:
        if (getProperty("useRS274")) {
          writeBlock("(E)", gFormat.format(40));
          writeBlock("(E)", gMotionModal.format(1), x, y, z, f);
        } else {
          writeBlock(idFormat.format(1), planeModal.format(0), "C0", x, y, z, f);
        }
      }
    } else {
      if (getProperty("useRS274")) {
        writeBlock("(E)", gMotionModal.format(1), x, y, z, f);
      } else {
        writeBlock(idFormat.format(1), x, y, z, f);
      }
    }
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      feedOutput.reset(); // force feed on next line
    } else {
      if (getProperty("useRS274")) {
        writeBlock("(E)", gMotionModal.format(1), f);
      } else {
        writeBlock(idFormat.format(1), f);
      }
    }
  }
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
    return;
  }

  if (getProperty("useRS274")) {
    var start = getCurrentPosition();

    if (isFullCircle()) {
      if (isHelical()) {
        linearize(tolerance);
        return;
      }
      switch (getCircularPlane()) {
      case PLANE_XY:
        var g = gPlaneModal.format(17);
        if (g) {
          writeBlock("(E)", g);
        }
        writeBlock("(E)", gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), iOutput.format(cx), jOutput.format(cy), feedOutput.format(feed));
        break;
      case PLANE_ZX:
        var g = gPlaneModal.format(18);
        if (g) {
          writeBlock("(E)", g);
        }
        writeBlock("(E)", gMotionModal.format(clockwise ? 2 : 3), zOutput.format(z), iOutput.format(cx), kOutput.format(cz), feedOutput.format(feed));
        break;
      case PLANE_YZ:
        var g = gPlaneModal.format(19);
        if (g) {
          writeBlock("(E)", g);
        }
        writeBlock("(E)", gMotionModal.format(clockwise ? 2 : 3), yOutput.format(y), jOutput.format(cy), kOutput.format(cz), feedOutput.format(feed));
        break;
      default:
        linearize(tolerance);
      }
    } else {
      switch (getCircularPlane()) {
      case PLANE_XY:
        var g = gPlaneModal.format(17);
        if (g) {
          writeBlock("(E)", g);
        }
        writeBlock("(E)", gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx), jOutput.format(cy), feedOutput.format(feed));
        break;
      case PLANE_ZX:
        var g = gPlaneModal.format(18);
        if (g) {
          writeBlock("(E)", g);
        }
        writeBlock("(E)", gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx), kOutput.format(cz), feedOutput.format(feed));
        break;
      case PLANE_YZ:
        var g = gPlaneModal.format(19);
        if (g) {
          writeBlock("(E)", g);
        }
        writeBlock("(E)", gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), jOutput.format(cy), kOutput.format(cz), feedOutput.format(feed));
        break;
      default:
        linearize(tolerance);
      }
    }
    return;
  }

  switch (getCircularPlane()) {
  case PLANE_XY:
    writeBlock(idFormat.format(2), planeModal.format(0), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx), jOutput.format(cy), feedOutput.format(feed), "D" + (clockwise ? 0 : 1));
    break;
  case PLANE_ZX:
    if (isHelical()) {
      linearize(tolerance);
    } else {
      planeModal.reset();
      writeBlock(idFormat.format(2), planeModal.format(2), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx), kOutput.format(cz), feedOutput.format(feed), "D" + (clockwise ? 0 : 1));
    }
    break;
  case PLANE_YZ:
    if (isHelical()) {
      linearize(tolerance);
    } else {
      planeModal.reset();
      writeBlock(idFormat.format(2), planeModal.format(1), xOutput.format(x), yOutput.format(y), zOutput.format(z), jOutput.format(cy), kOutput.format(cz), feedOutput.format(feed), "D" + (clockwise ? 0 : 1));
    }
    break;
  default:
    linearize(tolerance);
  }
}

function onCycle() {
}

function onCyclePoint(x, y, z) {
  if (!isSameDirection(getRotation().forward, new Vector(0, 0, 1))) {
    expandCyclePoint(x, y, z);
    return;
  }
  if (getProperty("useRS274")) {
    expandCyclePoint(x, y, z);
    return;
  }

  var P = !cycle.dwell ? 0 : clamp(0.1, cycle.dwell, 999.9); // seconds

  // e.g. N1390(0)X0.5Y-0.25Z-0.68F10.G3W.3K.1$

  switch (cycleType) {
  case "drilling":
    xOutput.reset(); // make sure at least one coordinate is output
    zOutput.reset();
    writeBlock(
      idFormat.format(0),
      xOutput.format(x), yOutput.format(y), zOutput.format(z),
      feedOutput.format(cycle.feedrate),
      gFormat.format(1),
      "W" + xyzFormat.format(cycle.clearance)
    );
    break;
  case "counter-boring":
    xOutput.reset(); // make sure at least one coordinate is output
    zOutput.reset();
    if (P > 0) {
      writeBlock(
        idFormat.format(0),
        xOutput.format(x), yOutput.format(y), zOutput.format(z),
        feedOutput.format(cycle.feedrate),
        gFormat.format(2),
        "W" + xyzFormat.format(cycle.clearance),
        "L" + secFormat.format(P)
      );
    } else {
      writeBlock(
        idFormat.format(0),
        xOutput.format(x), yOutput.format(y), zOutput.format(z),
        feedOutput.format(cycle.feedrate),
        gFormat.format(1),
        "W" + xyzFormat.format(cycle.clearance)
      );
    }
    break;
  case "chip-breaking":
    if ((cycle.accumulatedDepth < cycle.depth) || (P > 0)) {
      expandCyclePoint(x, y, z);
    } else if (getProperty("useChipBreaking")) {
      xOutput.reset(); // make sure at least one coordinate is output
      zOutput.reset();
      writeBlock(
        idFormat.format(0),
        xOutput.format(x), yOutput.format(y), zOutput.format(z),
        feedOutput.format(cycle.feedrate),
        gFormat.format(3),
        "W" + xyzFormat.format(cycle.clearance),
        "K" + xyzFormat.format(cycle.incrementalDepth) + "/"
      );
    } else {
      expandCyclePoint(x, y, z);
    }
    break;
  case "deep-drilling":
    xOutput.reset(); // make sure at least one coordinate is output
    zOutput.reset();
    writeBlock(
      idFormat.format(0),
      xOutput.format(x), yOutput.format(y), zOutput.format(z),
      feedOutput.format(cycle.feedrate),
      gFormat.format(3),
      "W" + xyzFormat.format(cycle.clearance),
      "K" + xyzFormat.format(cycle.incrementalDepth)
    );
    break;
  case "tapping":
  case "right-tapping":
    if (tool.type == TOOL_TAP_LEFT_HAND) {
      error(localize("Only right handed tapping is supporrted."));
      break;
    }
    xOutput.reset(); // make sure at least one coordinate is output
    zOutput.reset();
    writeBlock(
      idFormat.format(0),
      xOutput.format(x), yOutput.format(y), zOutput.format(z),
      feedOutput.format(tool.getTappingFeedrate()),
      gFormat.format(4),
      "W" + xyzFormat.format(cycle.clearance),
      "L" + secFormat.format(P)
    );
    break;
  case "reaming":
    if (P > 0) {
      expandCyclePoint(x, y, z);
    } else {
      xOutput.reset(); // make sure at least one coordinate is output
      zOutput.reset();
      writeBlock(
        idFormat.format(0),
        xOutput.format(x), yOutput.format(y), zOutput.format(z),
        feedOutput.format(cycle.feedrate),
        gFormat.format(5),
        "W" + xyzFormat.format(cycle.clearance)
      );
    }
    break;
  default:
    expandCyclePoint(x, y, z);
  }
}

function onCycleEnd() {
  if (!cycleExpanded) {
    if (getProperty("useRS274")) {
      writeBlock("(E)", gFormat.format(80));
    } else {
      writeBlock(idFormat.format(0), gFormat.format(0));
    }
  }
}

var mapCommand = {
  COMMAND_STOP                    : 0,
  COMMAND_OPTIONAL_STOP           : 1,
  COMMAND_END                     : 2,
  COMMAND_SPINDLE_CLOCKWISE       : 3,
  COMMAND_SPINDLE_COUNTERCLOCKWISE: 4,
  COMMAND_STOP_SPINDLE            : 5
};

var coolantEnabled;

function onCommand(command) {
  switch (command) {
  case COMMAND_COOLANT_ON:
    if (getProperty("useCoolant")) {
      if (!coolantEnabled) {
        coolantEnabled = true;
        if (getProperty("useRS274")) {
          writeBlock("(E)", mFormat.format(8));
        } else {
          writeBlock(idFormat.format(9), mFormat.format(8));
        }
      }
    }
    return;
  case COMMAND_COOLANT_OFF:
    if (getProperty("useCoolant")) {
      if (coolantEnabled) {
        if (getProperty("useRS274")) {
          writeBlock("(E)", mFormat.format(9));
        } else {
          writeBlock(idFormat.format(9), mFormat.format(9));
        }
        coolantEnabled = false;
      }
    }
    return;
  case COMMAND_START_SPINDLE:
    onCommand(tool.clockwise ? COMMAND_SPINDLE_CLOCKWISE : COMMAND_SPINDLE_COUNTERCLOCKWISE);
    return;
  }

  var stringId = getCommandStringId(command);
  var mcode = mapCommand[stringId];
  if (mcode != undefined) {
    if (getProperty("useRS274")) {
      writeBlock("(E)", mFormat.format(mcode));
    } else {
      writeBlock(idFormat.format(9), mFormat.format(mcode));
    }
  } else {
    onUnsupportedCommand(command);
  }
}

function onSectionEnd() {
  forceAny();
}

/** Output block to do safe retract and/or move to home position. */
function writeRetract() {
  if (arguments.length == 0) {
    error(localize("No axis specified for writeRetract()."));
    return;
  }
  var words = []; // store all retracted axes in an array
  for (var i = 0; i < arguments.length; ++i) {
    let instances = 0; // checks for duplicate retract calls
    for (var j = 0; j < arguments.length; ++j) {
      if (arguments[i] == arguments[j]) {
        ++instances;
      }
    }
    if (instances > 1) { // error if there are multiple retract calls for the same axis
      error(localize("Cannot retract the same axis twice in one line"));
      return;
    }
    switch (arguments[i]) {
    case X:
      words.push("X" + xyzFormat.format(machineConfiguration.hasHomePositionX() ? machineConfiguration.getHomePositionX() : 0));
      break;
    case Y:
      words.push("Y" + xyzFormat.format(machineConfiguration.hasHomePositionY() ? machineConfiguration.getHomePositionY() : 0));
      break;
    case Z:
      words.push("Z" + xyzFormat.format(machineConfiguration.getRetractPlane()));
      retracted = true; // specifies that the tool has been retracted to the safe plane
      break;
    default:
      error(localize("Bad axis specified for writeRetract()."));
      return;
    }
  }
  if (words.length > 0) {
    // handle retract block here
  }
  zOutput.reset();
}

function onClose() {
  onCommand(COMMAND_COOLANT_OFF);

  writeRetract(Z);

  if (getProperty("useRS274")) {
    writeBlock("(E)", mFormat.format(30));
  } else {
    writeBlock(idFormat.format(9), mFormat.format(30));
  }

  writeln("END");
}

function setProperty(property, value) {
  properties[property].current = value;
}
