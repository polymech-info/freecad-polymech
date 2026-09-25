/**
  Copyright (C) 2012-2021 by Autodesk, Inc.
  All rights reserved.

  MultiCam HPGL post processor configuration.

  $Revision: 43569 147f5cf60e9217cf9c3365dc511a0f631d89bb16 $
  $Date: 2021-10-13 13:53:32 $

  FORKID {07A5CBE6-B093-419b-8CAB-3EF48FF73927}
*/

description = "MultiCam HPGL";
vendor = "MultiCam";
vendorUrl = "http://www.multicam.com";
legal = "Copyright (C) 2012-2021 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45702;

longDescription = "Generic milling post for MultiCam HPGL.";

extension = "plt";
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
    value      : true,
    scope      : "post"
  },
  writeTools: {
    title      : "Write tool list",
    description: "Output a tool list in the header of the code.",
    group      : 0,
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  separateWordsWithSpace: {
    title      : "Separate words with space",
    description: "Adds spaces between words if 'yes' is selected.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  rapidFeed: {
    title      : "Rapid feed",
    description: "Specifies the rapid traversal feed.",
    type       : "number",
    value      : 3810,
    scope      : "post"
  },
  safeZ: {
    title      : "Safe Z",
    description: "Specifies the safety distance above the stock",
    type       : "number",
    value      : 10,
    scope      : "post"
  }
};

var numberOfToolSlots = 9999;

var WARNING_WORK_OFFSET = 0;
var WARNING_COOLANT = 1;

var gFormat = createFormat({prefix:"G", decimals:0});
var mFormat = createFormat({prefix:"M", decimals:0});
var hFormat = createFormat({prefix:"H", decimals:0});
var dFormat = createFormat({prefix:"D", decimals:0});

/** Returns the spatial value in HPGL unit. */
function toHPGL(value) {
  // 1 inch = 1016 HPGL;
  return value * 40;
}

var xyzFormat = createFormat({decimals:0, scale:40});
var zFormat = createFormat({decimals:0, scale:-40});
var angleFormat = createFormat({decimals:3, scale:DEG});
var feedFormat = createFormat({decimals:0});
var toolFormat = createFormat({decimals:0});
var rpmFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:3, forceDecimal:true}); // seconds - range 0.001-1000
var taperFormat = createFormat({decimals:1, scale:DEG});

var xOutput = createVariable({force:true}, xyzFormat);
var yOutput = createVariable({force:true}, xyzFormat);
var zOutput = createVariable({onchange:function () {retracted = false;}, force:true}, zFormat);
var feedOutput = createVariable({}, feedFormat);

// collected state
var retracted = false; // specifies that the tool has been retracted to the safe plane

/**
  Output a comment.
*/
function writeComment(text) {
  // not supported
}

function onOpen() {
  if (!getProperty("separateWordsWithSpace")) {
    setWordSeparator("");
  }

  writeln(";IN;");
  writeln("ZZ1;"); // 3D mode
  writeln("PA;"); // absolute coordinate mode

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
          comment += " - " + localize("ZMIN") + "=" + zFormat.format(zRanges[tool.number].getMinimum());
        }
        comment += " - " + getToolTypeName(tool.type);
        writeComment(comment);
      }
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
  setTranslation(currentSection.workOrigin);
  setRotation(currentSection.workPlane);

  var insertToolCall = isFirstSection() ||
    currentSection.getForceToolChange && currentSection.getForceToolChange() ||
    (tool.number != getPreviousSection().getTool().number);

  retracted = false;
  if (isFirstSection() || insertToolCall) {
    // retract to safe plane
    writeRetract(Z);
    zOutput.reset();
  }

  if (insertToolCall) {
    onCommand(COMMAND_COOLANT_OFF);

    if (tool.number > numberOfToolSlots) {
      warning(localize("Tool number exceeds maximum value."));
    }

    writeln("SP" + toolFormat.format(tool.number) + ";");
    // TAG: add support writeln("TCInsert tool " + toolFormat.format(tool.number) + ";");

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
  }

  if (insertToolCall ||
      isFirstSection() ||
      (rpmFormat.areDifferent(spindleSpeed, getPreviousSection().getTool().spindleRPM)) ||
      (tool.clockwise != getPreviousSection().getTool().clockwise)) {
    if (spindleSpeed < 1) {
      error(localize("Spindle speed out of range."));
    }
    if (spindleSpeed > 99999) {
      warning(localize("Spindle speed exceeds maximum value."));
    }
    writeln("ZO100," + rpmFormat.format(spindleSpeed) + ";");
    if (!tool.clockwise) {
      error(localize("Spindle direction not supported."));
      return;
    }
  }

  // wcs
  if (currentSection.workOffset != 0) {
    warningOnce(localize("Work offset is not supported."), WARNING_WORK_OFFSET);
  }

  forceXYZ();

  if (tool.coolant != COOLANT_OFF) {
    warningOnce(localize("Coolant not supported."), WARNING_COOLANT);
  }

  forceAny();

  {
    var remaining = currentSection.workPlane;
    if (!isSameDirection(remaining.forward, new Vector(0, 0, 1))) {
      error(localize("Tool orientation is not supported."));
      return;
    }
    setRotation(remaining);
  }

  var initialPosition = getFramePosition(currentSection.getInitialPosition());
  if (!retracted && !insertToolCall) {
    if (getCurrentPosition().z < initialPosition.z) {
      //writeln("ZD" + zOutput.format(initialPosition.z) + ";");
      writeln("PD" + xOutput.format(getCurrentPosition().x) + "," + yOutput.format(getCurrentPosition().y) + "," + zOutput.format(initialPosition.z) + ";");
      //setCurrentPositionZ(initialPosition.z);
    }
  }

  if (insertToolCall) {
    writeln("PD" + xOutput.format(initialPosition.x) + "," + yOutput.format(initialPosition.y) + "," + zOutput.format(getProperty("safeZ")) + ";");
    writeln("PD" + xOutput.format(initialPosition.x) + "," + yOutput.format(initialPosition.y) + "," + zOutput.format(initialPosition.z) + ";");
    //writeln("ZD" + zOutput.format(initialPosition.z) + ";");
  }
}

function onSpindleSpeed(spindleSpeed) {
  writeln("ZO100," + rpmFormat.format(spindleSpeed) + ";");
}

function onRadiusCompensation() {
  if (radiusCompensation != RADIUS_COMPENSATION_OFF) {
    error(localize("Radius compensation mode not supported."));
  }
}

function onRapid(_x, _y, _z) {
  var f = feedOutput.format(getProperty("rapidFeed") / 60.0);
  if (f) {
    writeln("SF" + f + ";");
  }

  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  writeln("PD" + x + "," + y + "," + z + ";");
  feedOutput.reset();
}

function onLinear(_x, _y, _z, feed) {
  var f = feedOutput.format(feed / 60.0);
  if (f) {
    writeln("SF" + f + ";");
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  writeln("PD" + x + "," + y + "," + z + ";");
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  var f = feedOutput.format(feed / 60.0);
  if (f) {
    writeln("SF" + f + ";");
  }

  if (isHelical() || (getCircularPlane() != PLANE_XY)) {
    var t = tolerance;
    if (hasParameter("operation:tolerance")) {
      t = getParameter("operation:tolerance");
    }
    linearize(t);
    return;
  }
  writeln("AA" + xOutput.format(cx) + "," + yOutput.format(cy) + "," + angleFormat.format((clockwise ? -1 : 1) * getCircularSweep()) + ";");
}

function onCommand(command) {
  if (command != COMMAND_COOLANT_OFF) {
    error(localize("Unsupported command"));
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
      writeln("PU;");
      retracted = true; // specifies that the tool has been retracted to the safe plane
      break;
    default:
      error(localize("Bad axis specified for writeRetract()."));
      return;
    }
  }
  if (words.length > 0) {
    writeln("PD" + words.join(",") + ";");
  }
  zOutput.reset();
}

function onClose() {
  onCommand(COMMAND_COOLANT_OFF);

  writeRetract(Z);
  zOutput.reset();
  if (machineConfiguration.hasHomePositionX() || machineConfiguration.hasHomePositionY()) {
    writeRetract(X, Y);
  }

  onImpliedCommand(COMMAND_STOP_SPINDLE);
  writeln("SP0;"); // spindle stop
}

function setProperty(property, value) {
  properties[property].current = value;
}
