/**
  Copyright (C) 2012-2021 by Autodesk, Inc.
  All rights reserved.

  Mori APT post processor configuration.

  $Revision: 43898 8a6a8a924f86fab9397f9d69d17b1e07897a7fe6 $
  $Date: 2022-04-20 16:35:00 $

  FORKID {CA87E621-8476-4a08-B127-3B3592563184}
*/

description = "Mori APT (MfgSuite)";
vendor = "DMG MORI";
vendorUrl = "http://www.dmgmori.com";
legal = "Copyright (C) 2012-2021 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45702;

longDescription = "Use this post to interface with MfgSuite from DMG MORI using the APT-CL format.";

capabilities = CAPABILITY_INTERMEDIATE;
extension = "apt";
setCodePage("ansi");

// user-defined properties
properties = {
  useTailStock: {
    title      : "Use tail stock",
    description: "Enable to use the tail stock.",
    group      : "configuration",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useBarFeeder: {
    title      : "Use bar feeder",
    description: "Enable to use the bar feeder.",
    group      : "configuration",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  usePartCatcher: {
    title      : "Use part catcher",
    description: "Enable to use the part catcher.",
    group      : "configuration",
    type       : "boolean",
    value      : false,
    scope      : "post"
  }
};

allowHelicalMoves = true;
allowedCircularPlanes = undefined; // allow any circular motion
allowSpiralMoves = true;
maximumCircularSweep = toRad(270);

var xyzFormat = createFormat({decimals:(unit == MM ? 6 : 7)});
var txyzFormat = createFormat({decimals:8});
var feedFormat = createFormat({decimals:(unit == MM ? 0 : 2)});
var rpmFormat = createFormat({decimals:3}); // spindle speed
var secFormat = createFormat({decimals:3}); // time

// collected state
var currentFeed;
var coolantActive = false;
var radiusCompensationActive = false;

function formatComment(text) {
  return filterText(text, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789(.,)/-+*= \t");
}

function writeComment(text) {
  writeln("PPRINT/ '" + formatComment(text) + "'");
}

function onOpen() {
  writeln("PARTNO/ '" + programName + "'");
  writeComment(programComment);
  writeln("BEGIN");

  writeln("UNITS/ " + ((unit == IN) ? "INCH" : "MM"));

  { // stock - workpiece
    var workpiece = getWorkpiece();
    var delta = Vector.diff(workpiece.upper, workpiece.lower);
    if (delta.isNonZero()) {
      writeln("MATERL/ TYPE, 5, COND, 6, XDIM, " + xyzFormat.format(delta.x) + ", YDIM, " + xyzFormat.format(delta.y) + ", ZDIM, " + xyzFormat.format(delta.z));
    }
  }

  /*
  if (machineId) {
    var machineId = machineConfiguration.getModel();
    writeln("MACHIN/ " + machineId); // not required
  }
  */
}

function onComment(comment) {
  writeComment(comment);
}

var mapCommand = {
  COMMAND_STOP         : "STOP",
  COMMAND_OPTIONAL_STOP: "OPSTOP",
  COMMAND_STOP_SPINDLE : "SPINDL/ ON",
  COMMAND_START_SPINDLE: "SPINDL/ OFF",

  // COMMAND_ORIENTATE_SPINDLE

  COMMAND_SPINDLE_CLOCKWISE       : "SPINDL/ CLW",
  COMMAND_SPINDLE_COUNTERCLOCKWISE: "SPINDL/ CCLW"

  // COMMAND_ACTIVATE_SPEED_FEED_SYNCHRONIZATION
  // COMMAND_DEACTIVATE_SPEED_FEED_SYNCHRONIZATION
};

function onCommand(command) {
  switch (command) {
  case COMMAND_LOCK_MULTI_AXIS:
    writeln("CLAMP/ TABLE, ALL, AUTO");
    return;
  case COMMAND_UNLOCK_MULTI_AXIS:
    writeln("CLAMP/ TABLE, ALL, OFF");
    return;
  case COMMAND_BREAK_CONTROL:
    return;
  case COMMAND_TOOL_MEASURE:
    return;
  }

  if (mapCommand[command]) {
    writeln(mapCommand[command]);
  } else {
    warning("Unsupported command: " + getCommandStringId(command));
    writeComment("Unsupported command: " + getCommandStringId(command));
  }
}

function setCoolant(coolant) {
  if (coolant == COOLANT_OFF) {
    if (coolantActive) {
      writeln("COOLNT/ OFF");
      coolantActive = false;
    }
  } else {
    switch (coolant) {
    case COOLANT_FLOOD:
      writeln("COOLNT/ " + "FLOOD");
      break;
    case COOLANT_MIST:
      writeln("COOLNT/ " + "MIST");
      break;
    case COOLANT_TOOL:
      writeln("COOLNT/ " + "THRU");
      break;
    default:
      warning("Unsupported coolant mode: " + coolant);
      writeComment("Unsupported coolant mode: " + coolant);
    }
    if (!coolantActive) {
      writeln("COOLNT/ ON");
      coolantActive = true;
    }
  }
}

function onCoolant() {
  setCoolant(coolant);
}

function onSection() {
  writeln("");

  if (hasParameter("operation-comment")) {
    var comment = getParameter("operation-comment");
    if (comment) {
      writeln("OPNAME/ '" + formatComment(comment) + "'"); // quotes are not required
    }
  }

  writeln("APPLY/ " + ((currentSection.getType() == TYPE_TURNING) ? "TURN" : "MILL"));
  // writeln("OPSKIP");

  if (currentSection.getType() != TYPE_TURNING) {
    writeln(
      "MCSYS/ NUM, " + ((currentSection.workOffset > 0) ? currentSection.workOffset : 1) +
      ", POINT, " + xyzFormat.format(currentSection.workOrigin.x) + ", " + xyzFormat.format(currentSection.workOrigin.y) + ", " + xyzFormat.format(currentSection.workOrigin.z) +
      ", VECTOR, " + txyzFormat.format(currentSection.workPlane.right.x) + ", " + txyzFormat.format(currentSection.workPlane.right.y) + ", " + txyzFormat.format(currentSection.workPlane.right.z) +
      ", VECTOR, " + txyzFormat.format(currentSection.workPlane.up.x) + ", " + txyzFormat.format(currentSection.workPlane.up.y) + ", " + txyzFormat.format(currentSection.workPlane.up.z)
    );
  }

  if (currentSection.isMultiAxis()) {
    writeln("MULTAX/ ON");
    writeln("TCP/ ON"); // alternatively TCPCTL
  }

  if ((currentSection.getType() != TYPE_TURNING) && !currentSection.isMultiAxis()) {
    onCommand(COMMAND_LOCK_MULTI_AXIS);
  }

  /*
  var d = tool.diameter;
  var r = tool.cornerRadius;
  var e = 0;
  var f = 0;
  var a = 0;
  var b = 0;
  var h = tool.bodyLength;
  writeln("CUTTER/ " + d + ", " + r + ", " + e + ", " + f + ", " + a + ", " + b + ", " + h);
*/

  if (currentSection.getType() == TYPE_TURNING) {
    writeln("SELECT/ TRSPND, " + currentSection.spindle);
  }

  if (currentSection.getType() != TYPE_TURNING) {
    writeln("TOOLNO/ " + tool.number + ", MILL, OSETNO, " + tool.lengthOffset + ", " + tool.diameterOffset);
  }

  setCoolant(tool.coolant);

  var nextTool = getNextTool(tool.number);
  if (!nextTool) {
    nextTool = getSection(0).getTool();
  }
  writeln("LOAD/ TOOL, " + tool.number + ", '" + tool.comment + "', NEXTTL, " + nextTool.number);

  if (currentSection.getType() != TYPE_TURNING) {
    writeln("SPINDL/ RPM, " + rpmFormat.format(spindleSpeed) + ", " + (tool.clockwise ? "CLW" : "CCLW"));
  }

  if (currentSection.getType() == TYPE_TURNING) {
    writeln(
      "SPINDL/ " + rpmFormat.format(spindleSpeed) + ", " + ((unit == IN) ? "SFM" : "SMM") + ", " + (tool.clockwise ? "CLW" : "CCLW")
    );

    writeln("TLSTCK/ QUILL, " + (getProperty("useTailStock") ? "IN" : "OUT")); // TAG: customize
  }

  writeln("CUTCOM/ ON, LENGTH, " + tool.lengthOffset); // also required for multi-axis
}

function onDwell(time) {
  writeln("DELAY/ " + secFormat.format(time)); // in seconds / REV is also supported
}

function onRadiusCompensation() {
  if (radiusCompensation == RADIUS_COMPENSATION_OFF) {
    if (radiusCompensationActive) {
      radiusCompensationActive = false;
      writeln("CUTCOM/ OFF"); // only turns off diameter compensation
    }
  } else {
    if (!radiusCompensationActive) {
      radiusCompensationActive = true;
      writeln("CUTCOM/ ON");
    }
    var direction = (radiusCompensation == RADIUS_COMPENSATION_LEFT) ? "LEFT" : "RIGHT";
    if (true || (tool.diameterOffset != 0)) {
      writeln("CUTCOM/ " + direction + ", XYPLAN, OSETNO, " + tool.diameterOffset);
    } else {
      writeln("CUTCOM/ " + direction + ", XYPLAN");
    }
  }
}

function onSpindleSpeed(spindleSpeed) {
  if (currentSection.getType() != TYPE_TURNING) {
    writeln("SPINDL/ RPM, " + rpmFormat.format(spindleSpeed));
  }
  if (currentSection.getType() == TYPE_TURNING) {
    writeln("SPINDL/ " + rpmFormat.format(spindleSpeed) + ", " + ((unit == IN) ? "SFM" : "SMM"));
  }
}

function onRapid(x, y, z) {
  writeln("RAPID");
  writeln("GOTO/ " + xyzFormat.format(x) + ", " + xyzFormat.format(y) + ", " + xyzFormat.format(z));
}

function onLinear(x, y, z, feed) {
  if (feed != currentFeed) {
    currentFeed = feed;
    writeln("FEDRAT/ PERMIN, " + feedFormat.format(feed));
  }
  writeln("GOTO/ " + xyzFormat.format(x) + ", " + xyzFormat.format(y) + ", " + xyzFormat.format(z));
}

function onRapid5D(x, y, z, dx, dy, dz) {
  writeln("RAPID");
  writeln("GOTO/ " + xyzFormat.format(x) + ", " + xyzFormat.format(y) + ", " + xyzFormat.format(z) + ", " + txyzFormat.format(dx) + ", " + txyzFormat.format(dy) + ", " + txyzFormat.format(dz));
}

function onLinear5D(x, y, z, dx, dy, dz, feed) {
  if (feed != currentFeed) {
    currentFeed = feed;
    writeln("FEDRAT/ PERMIN, " + feedFormat.format(feed));
  }
  writeln("GOTO/ " + xyzFormat.format(x) + ", " + xyzFormat.format(y) + ", " + xyzFormat.format(z) + ", " + txyzFormat.format(dx) + ", " + txyzFormat.format(dy) + ", " + txyzFormat.format(dz));
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  if (feed != currentFeed) {
    currentFeed = feed;
    writeln("FEDRAT/ PERMIN, " + feedFormat.format(feed));
  }

  if (isHelical()) {
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeln("ARCSLP/ " + xyzFormat.format((clockwise ? 1 : -1) * getHelicalDistance()));
      break;
    default:
      linearize(tolerance);
      return;
    }
  }

  switch (getCircularPlane()) {
  case PLANE_XY:
  case PLANE_ZX:
  case PLANE_YZ:
    break;
  default:
    linearize(tolerance);
    return;
  }

  var n = getCircularNormal();
  if (clockwise) {
    n = Vector.product(n, -1);
  }
  writeln(
    "MOVARC/ CENTER, " + xyzFormat.format(cx) + ", " + xyzFormat.format(cy) + ", " + xyzFormat.format(cz) +
    ", AXIS, " + txyzFormat.format(n.x) + ", " + txyzFormat.format(n.y) + ", " + txyzFormat.format(n.z) + // ccw
    ", RADIUS, " + xyzFormat.format(getCircularRadius())
    // ", TIMES, " + n
  );
  writeln("GOTO/ " + xyzFormat.format(x) + ", " + xyzFormat.format(y) + ", " + xyzFormat.format(z));
}

function onCycle() {
  var d = cycle.depth - cycle.stock;
  var f = cycle.feedrate;
  var c = cycle.clearance - cycle.stock;
  var r = cycle.clearance - cycle.retract;
  var q = cycle.dwell;
  var i = cycle.incrementalDepth; // for pecking

  var statement;

  switch (cycleType) {
  case "drilling":
    statement = "CYCLE/ DRILL, DEPTH, " + xyzFormat.format(d) + ", PERMIN, " + feedFormat.format(f) + ", CLEAR, " + xyzFormat.format(c) + ", RETURN, " + xyzFormat.format(c);
    if (r > 0) {
      statement += ", RAPTO, " + xyzFormat.format(r);
    }
    break;
  case "counter-boring":
    statement = "CYCLE/ FACE, DEPTH, " + xyzFormat.format(d) + ", PERMIN, " + feedFormat.format(f) + ", CLEAR, " + xyzFormat.format(c) + ", RETURN, " + xyzFormat.format(c);
    if (r > 0) {
      statement += ", RAPTO, " + xyzFormat.format(r);
    }
    if (q > 0) {
      statement += ", DWELL, " + secFormat.format(q);
    }
    break;
  case "reaming":
    statement = "CYCLE/ REAM, DEPTH, " + xyzFormat.format(d) + ", PERMIN, " + feedFormat.format(f) + ", CLEAR, " + xyzFormat.format(c) + ", RETURN, " + xyzFormat.format(c);
    if (r > 0) {
      statement += ", RAPTO, " + xyzFormat.format(r);
    }
    if (q > 0) {
      statement += ", DWELL, " + secFormat.format(q);
    }
    break;
  case "boring":
    statement = "CYCLE/ BORE, DEPTH, " + xyzFormat.format(d) + ", PERMIN, " + feedFormat.format(f) + ", CLEAR, " + xyzFormat.format(c) + ", RETURN, " + xyzFormat.format(c);
    if (r > 0) {
      statement += ", RAPTO, " + xyzFormat.format(r);
    }
    if (q > 0) {
      statement += ", DWELL, " + secFormat.format(q);
    }
    break;
  case "deep-drilling":
    statement = "CYCLE/ DEEP, DEPTH, " + xyzFormat.format(d) + ", STEP, " + xyzFormat.format(i) + ", PERMIN, " + feedFormat.format(f) + ", CLEAR, " + xyzFormat.format(c) + ", RETURN, " + xyzFormat.format(c);
    if (r > 0) {
      statement += ", RAPTO, " + xyzFormat.format(r);
    }
    if (q > 0) {
      statement += ", DWELL, " + secFormat.format(q);
    }
    break;
  case "chip-breaking":
    statement = "CYCLE/ BRKCHP, DEPTH, " + xyzFormat.format(d) + ", STEP, " + xyzFormat.format(i) + ", PERMIN, " + feedFormat.format(f) + ", CLEAR, " + xyzFormat.format(c) + ", RETURN, " + xyzFormat.format(c);
    if (r > 0) {
      statement += ", RAPTO, " + xyzFormat.format(r);
    }
    if (q > 0) {
      statement += ", DWELL, " + secFormat.format(q);
    }
    break;
  case "tapping":
    if (tool.type == TOOL_TAP_LEFT_HAND) {
      cycleNotSupported();
    } else {
      statement = "CYCLE/ TAP, DEPTH, " + xyzFormat.format(d) + ", PERMIN, " + feedFormat.format(f) + ", CLEAR, " + xyzFormat.format(c) + ", RETURN, " + xyzFormat.format(c);
      if (r > 0) {
        statement += ", RAPTO, " + xyzFormat.format(r);
      }
    }
    break;
  case "right-tapping":
    statement = "CYCLE/ TAP, DEPTH, " + xyzFormat.format(d) + ", PERMIN, " + feedFormat.format(f) + ", CLEAR, " + xyzFormat.format(c) + ", RETURN, " + xyzFormat.format(c);
    if (r > 0) {
      statement += ", RAPTO, " + xyzFormat.format(r);
    }
    break;
  default:
    cycleNotSupported();
  }
  writeln(statement);
}

function onCyclePoint(x, y, z) {
  writeln("FEDRAT/ " + feedFormat.format(cycle.feedrate));
  writeln("GOTO/ " + xyzFormat.format(x) + ", " + xyzFormat.format(y) + ", " + xyzFormat.format(cycle.stock));
}

function onCycleEnd() {
  writeln("CYCLE/ OFF");
}

function onSectionEnd() {
  if (currentSection.isMultiAxis()) {
    writeln("TCP/ OFF");
    writeln("MULTAX/ OFF");
  }

  if (coolantActive) {
    coolantActive = false;
    writeln("COOLNT/ OFF");
  }

  if (getProperty("usePartCatcher") &&
      hasParameter("operation-strategy") &&
      (getParameter("operation-strategy") == "turningPart")) {
    writeln("");
    writeln("CATCHR/ IN"); // TAG: customize
    forceXYZ();
  }
}

function onClose() {
  writeln("");

  if (coolantActive) {
    coolantActive = false;
    writeln("COOLNT/ OFF");
  }
  writeln("GOHOME/");

  if (getProperty("useBarFeeder")) {
    writeln("BARFED/ 0, TO, 0"); // TAG: customize
  }

  writeln("END/");
}

function setProperty(property, value) {
  properties[property].current = value;
}
