/**
  Copyright (C) 2012-2021 by Autodesk, Inc.
  All rights reserved.

  ProtoTRAK Conversional post processor configuration.

  $Revision: 43569 147f5cf60e9217cf9c3365dc511a0f631d89bb16 $
  $Date: 2021-10-13 13:53:32 $

  FORKID {71D542DC-B699-42cf-B133-E50A0E0F63FE}
*/

description = "ProtoTRAK Conversational";
vendor = "Southwestern Industries";
vendorUrl = "http://www.southwesternindustries.com";
legal = "Copyright (C) 2012-2021 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45702;

longDescription = "Generic milling post for ProtoTRAK conversational format.";

extension = "mx2";
programNameIsInteger = true;
setCodePage("ascii");

capabilities = CAPABILITY_MILLING;
tolerance = spatial(0.002, MM);

highFeedrate = (unit == IN) ? 100 : 1000;
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
  useG90: {
    title      : "Use G90",
    description: "Enable to use G90 instead of A suffices.",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  connectingRadius: {
    title      : "Connecting radius",
    description: "Sets the connecting radius.",
    type       : "number",
    value      : 0,
    scope      : "post"
  },
  useZAxis: {
    title      : "Use Z-axis",
    description: "Specifies to enable the output for Z coordinates.",
    type       : "boolean",
    value      : false,
    scope      : "post"
  }
};

var permittedCommentChars = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,=_-";

var gFormat = createFormat({prefix:"G", decimals:0});
var mFormat = createFormat({prefix:"M", decimals:0});
var dFormat = createFormat({prefix:"D", decimals:0});
var nFormat = createFormat({prefix:"N", decimals:0});

var xyzFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var crFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var feedFormat = createFormat({decimals:(unit == MM ? 0 : 1), forceDecimal:true});
var toolFormat = createFormat({decimals:0});
var taperFormat = createFormat({decimals:1, scale:DEG});

var xOutput = createVariable({}, xyzFormat);
var yOutput = createVariable({}, xyzFormat);
var zOutput = createVariable({}, xyzFormat);
var feedOutput = createVariable({prefix:"F", force:true}, feedFormat);
var dOutput = createVariable({force:true}, dFormat);

var gMotionModal = createModal({force:true}, gFormat);

// collected state
var sequenceNumber;
var moves = [];

/**
  Writes the specified block.
*/
function writeBlock() {
  if (!formatWords(arguments)) {
    return;
  }
  if (true) {
    writeWords2(nFormat.format(sequenceNumber), arguments, ";");
    sequenceNumber += 1;
    if (sequenceNumber > 9999) {
      sequenceNumber = 1;
    }
  } else {
    writeWords(arguments, ";");
  }
}

/**
  Output a comment.
*/
function writeComment(text) {
  writeln("(" + filterText(String(text).toUpperCase(), permittedCommentChars) + ")");
}

function onOpen() {
  if (!getProperty("useG90")) {
    xyzFormat = createFormat({decimals:(unit == MM ? 3 : 4), suffix:"A", forceDecimal:true}); // absolute
    xOutput = createVariable({}, xyzFormat);
    yOutput = createVariable({}, xyzFormat);
    zOutput = createVariable({}, xyzFormat);
  }

  setWordSeparator(" ");

  sequenceNumber = 1;

  writeln("%");
  var programId;
  try {
    programId = getAsInt(programName);
  } catch (e) {
    error(localize("Program name must be a number."));
  }
  if (!((programId >= 1) && (programId <= 99999999))) {
    error(localize("Program number is out of range."));
  }
  var oFormat = createFormat({decimals:0});
  if (getProperty("useG90")) {
    writeln(formatWords("PN" + oFormat.format(programId), gFormat.format((unit == IN) ? 20 : 21), gFormat.format(90), ";"));
  } else {
    writeln(formatWords("PN" + oFormat.format(programId), gFormat.format((unit == IN) ? 20 : 21), ";"));
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
          "D=" + crFormat.format(tool.diameter) + " " +
          localize("CR") + "=" + crFormat.format(tool.cornerRadius);
        if ((tool.taperAngle > 0) && (tool.taperAngle < Math.PI)) {
          comment += " " + localize("TAPER") + "=" + taperFormat.format(tool.taperAngle) + localize("deg");
        }
        if (zRanges[tool.number]) {
          comment += " - " + localize("ZMIN") + "=" + crFormat.format(zRanges[tool.number].getMinimum());
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

function onSection() {
  var insertToolCall = isFirstSection() ||
    currentSection.getForceToolChange && currentSection.getForceToolChange() ||
    (tool.number != getPreviousSection().getTool().number);

  if (hasParameter("operation-comment")) {
    var comment = getParameter("operation-comment");
    if (comment) {
      writeComment(comment);
    }
  }

  if (insertToolCall) {
    if (tool.number > 99) {
      warning(localize("Tool number exceeds maximum value."));
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
  }

  { // pure 3D
    var remaining = currentSection.workPlane;
    if (!isSameDirection(remaining.forward, new Vector(0, 0, 1))) {
      error(localize("Tool orientation is not supported."));
      return;
    }
    setRotation(remaining);
  }

  xOutput.reset();
  yOutput.reset();
  zOutput.reset();
}

function onDwell(seconds) {
}

function onCycle() {
}

function onCyclePoint(x, y, z) {
  if (!isSameDirection(getRotation().forward, new Vector(0, 0, 1))) {
    expandCyclePoint(x, y, z);
    return;
  }
  xOutput.reset();
  yOutput.reset();
  zOutput.reset();

  var F = cycle.feedrate;
  switch (cycleType) {
  case "drilling":
    writeBlock(gMotionModal.format(100), "X" + xOutput.format(x), "Y" + yOutput.format(y), dOutput.format(tool.diameter), "T" + toolFormat.format(tool.number));
    writeBlock(gMotionModal.format(100), "Z" + zOutput.format(z), dOutput.format(tool.diameter), "T" + toolFormat.format(tool.number));
    break;
  default:
    expandCyclePoint(x, y, z);
  }
}

function onCycleEnd() {
}

var pendingRadiusCompensation = -1;

function onRadiusCompensation() {
  pendingRadiusCompensation = radiusCompensation;
}

function getTC() {
  var tc = 0;
  switch (radiusCompensation) {
  case RADIUS_COMPENSATION_LEFT:
    tc = 2;
    break;
  case RADIUS_COMPENSATION_RIGHT:
    tc = 1;
    break;
  }
  return tc;
}

function flush() {
  var numberOfMoves = moves.length;
  if (numberOfMoves == 0) {
    return;
  }
  for (var i = 0; i < numberOfMoves; ++i) {
    var words = moves[i];
    for (var j = 0; j < words.length; ++j) {
      if (words[j] == "CR") {
        if ((i + 1) < numberOfMoves) {
          words[j] = "CR" + crFormat.format(getProperty("connectingRadius")); // connected
        } else { // last move
          words[j] = "CR-"; // disconnected
        }
      }
    }
    writeBlock(words);
  }
  moves = []; // clear
}

function onRapid(_x, _y, _z) {
  if (getProperty("useZAxis")) {
    onExpandedLinear(_x, _y, _z, highFeedrate);
  } else {
    flush();
  }
}

function onLinear(_x, _y, _z, feed) {
  var start = getCurrentPosition();
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  if (!getProperty("useZAxis") && z) {
    flush();
  }
  if (x || y || (getProperty("useZAxis") ? z : false)) {
    xOutput.reset();
    yOutput.reset();
    x = xOutput.format(_x);
    y = yOutput.format(_y);
    if (getProperty("useZAxis")) {
      zOutput.reset();
      z = zOutput.format(_z);
    }
    moves.push([
      gMotionModal.format(101),
      "XB" + xyzFormat.format(start.x),
      "YB" + xyzFormat.format(start.y),
      "XE" + x,
      "YE" + y,
      conditional(z, "Z" + z),
      "CR", // + crFormat.format(getProperty("connectingRadius")),
      dOutput.format(tool.diameter),
      "TC" + getTC(),
      feedOutput.format(feed),
      "T" + toolFormat.format(tool.number)
    ]);
  }
}

function onCircular(clockwise, cx, cy, cz, x, y, _z, feed) {
  if (isHelical()) {
    error(localize("Helical arcs are not supported."));
    return;
  }

  var start = getCurrentPosition();
  if (xyzFormat.areDifferent(start.z, _z)) { // only keep horizontal moves
    flush();
    return; // skip
  }

  var z = zOutput.format(_z);
  if (z) {
    flush();
  }

  xOutput.reset();
  yOutput.reset();

  switch (getCircularPlane()) {
  case PLANE_XY:
    moves.push([
      gMotionModal.format(clockwise ? 102 : 103),
      "XB" + xyzFormat.format(start.x),
      "YB" + xyzFormat.format(start.y),
      "XE" + xOutput.format(x),
      "YE" + yOutput.format(y),
      "XC" + xyzFormat.format(cx),
      "YC" + xyzFormat.format(cy),
      conditional(z, "Z" + z),
      "CR", // + crFormat.format(getProperty("connectingRadius")),
      "TC" + getTC(),
      feedOutput.format(feed),
      "T" + toolFormat.format(tool.number)
    ]);
    break;
  default:
    error(localize("Unsupported arc-plane."));
  }
}

function onCommand(command) {
  onUnsupportedCommand(command);
}

function onSectionEnd() {
  flush();
}

function onClose() {
  writeln("%");
}

function setProperty(property, value) {
  properties[property].current = value;
}
