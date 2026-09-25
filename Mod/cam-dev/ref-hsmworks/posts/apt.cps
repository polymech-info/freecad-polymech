/**
  Copyright (C) 2012-2021 by Autodesk, Inc.
  All rights reserved.

  Common APT ISO 4343 post processor configuration.

  $Revision: 43569 147f5cf60e9217cf9c3365dc511a0f631d89bb16 $
  $Date: 2021-10-13 13:53:32 $

  FORKID {1E3EF622-47FE-487d-937B-07920048EF52}
*/

description = "Common ISO 4343 APT";
vendor = "Autodesk";
vendorUrl = "http://www.autodesk.com";
legal = "Copyright (C) 2012-2021 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45702;

longDescription = "Post for Common APT ISO 4343.";

unit = ORIGINAL_UNIT; // do not map unit
extension = "apt";
setCodePage("ansi");

capabilities = CAPABILITY_INTERMEDIATE;

allowHelicalMoves = true;
allowedCircularPlanes = undefined; // allow any circular motion

// user-defined properties
properties = {
  highAccuracy: {
    title      : "High accuracy",
    description: "Specifies short (no) or long (yes) numeric format.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showNotes: {
    title      : "Show notes",
    description: "Writes operation notes as comments in the outputted code.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  }
};

var mainFormat = createFormat({decimals:6, forceDecimal:true});
var ijkFormat = createFormat({decimals:9, forceDecimal:true});

// collected state
var currentFeed;
var feedUnit;
var coolantActive = false;
var radiusCompensationActive = false;
var multax = false;

function writeComment(text) {
  writeln("PPRINT/'" + filterText(text, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789(.,)_/-+*= \t") + "'");
}

function onOpen() {
  var machineId = machineConfiguration.getModel();
  if (machineId) {
    writeln("MACHIN/" + machineId);
  }
  writeln("MODE/" + (isMilling() ? "MILL" : "TURN")); // first statement for an operation
  writeln("PARTNO/'" + programName + "'");
  writeComment(programName);
  writeComment(programComment);
  writeln("UNITS/" + ((unit == IN) ? "INCHES" : "MM"));

  if (!getProperty("highAccuracy")) {
    mainFormat = createFormat({decimals:4, forceDecimal:true});
    ijkFormat = createFormat({decimals:7, forceDecimal:true});
  }
}

function onComment(comment) {
  writeComment(comment);
}

var mapCommand = {
  COMMAND_STOP         : "STOP",
  COMMAND_OPTIONAL_STOP: "OPSTOP",
  COMMAND_STOP_SPINDLE : "SPINDL/ON",
  COMMAND_START_SPINDLE: "SPINDL/OFF",

  // COMMAND_ORIENTATE_SPINDLE

  COMMAND_SPINDLE_CLOCKWISE       : "SPINDL/CLW",
  COMMAND_SPINDLE_COUNTERCLOCKWISE: "SPINDL/CCLW"

  // COMMAND_ACTIVATE_SPEED_FEED_SYNCHRONIZATION
  // COMMAND_DEACTIVATE_SPEED_FEED_SYNCHRONIZATION
};

function onCommand(command) {
  switch (command) {
  case COMMAND_LOCK_MULTI_AXIS:
    return;
  case COMMAND_UNLOCK_MULTI_AXIS:
    return;
  case COMMAND_BREAK_CONTROL:
    return;
  case COMMAND_TOOL_MEASURE:
    return;
  }

  var c = mapCommand[getCommandStringId(command)];
  if (c !== undefined) {
    writeln(c);
  } else {
    warning("Unsupported command: " + getCommandStringId(command));
    writeComment("Unsupported command: " + getCommandStringId(command));
  }
}

function onCoolant() {
  if (coolant == COOLANT_OFF) {
    if (coolantActive) {
      writeln("COOLNT/OFF");
      coolantActive = false;
    }
  } else {
    if (!coolantActive) {
      writeln("COOLNT/ON");
      coolantActive = true;
    }

    var mapCoolant = {COOLANT_FLOOD:"flood", COOLANT_MIST:"MIST", COOLANT_TOOL:"THRU"};
    if (mapCoolant[coolant]) {
      writeln("COOLNT/" + mapCoolant[coolant]);
    } else {
      warning("Unsupported coolant mode: " + coolant);
      writeComment("Unsupported coolant mode: " + coolant);
    }
  }
}

/*
  Define 7-Parameter APT Cutter.
*/
function writeCutter() {
  var d = tool.diameter;
  var r = tool.cornerRadius;
  var e = tool.tipDiameter;
  var f = r;
  var a = 0;
  var b = tool.taperAngle;
  var h = tool.fluteLength;

  // Adjust taper angle for drill
  // It is defined as the full inclusive angle
  if ((tool.type == TOOL_DRILL) ||
      (tool.type == TOOL_DRILL_CENTER) ||
      (tool.type == TOOL_DRILL_SPOT)) {
    b /= 2;
  }

  // Adjust diameter for cone cutter
  if ((b > 0) && (b < Math.PI / 2)) {
    d = e + r;
    d = d - (2 * r) + (2 * (r * Math.tan((Math.PI / 2 - b) / 2)));

  // Adjust diameter for bell cutter
  } else if ((b < 0) && (b > Math.PI / 2)) {
    d = e + r;
    d += 2 * (r * (tan(-b / 2) + 1) / (Math.tan(Math.PI / 2 + b)));
  }

  writeln("CUTTER/" + mainFormat.format(d) + ", " + mainFormat.format(r) +
    ", " + mainFormat.format(e) + ", " + mainFormat.format(f) + ", " +
    mainFormat.format(a) + ", " + mainFormat.format(toDeg(b)) + ", " +
    mainFormat.format(h)
  );
}

function onSection() {
  feedUnit = (unit == IN) ? "IPM" : "MMPM";

  if (currentSection.isMultiAxis() || !currentSection.isZOriented()) {
    if (!multax || isFirstSection()) {
      writeln("MULTAX/ON");
    }
    multax = true;
  } else {
    if (multax || isFirstSection()) {
      writeln("MULTAX/OFF");
    }
    multax = false;
  }

  if (hasParameter("operation-comment")) {
    var comment = getParameter("operation-comment");
    if (comment) {
      writeComment(comment);
    }
  }

  if (getProperty("showNotes") && hasParameter("notes")) {
    var notes = getParameter("notes");
    if (notes) {
      var lines = String(notes).split("\n");
      var r1 = new RegExp("^[\\s]+", "g");
      var r2 = new RegExp("[\\s]+$", "g");
      for (line in lines) {
        var comment = lines[line].replace(r1, "").replace(r2, "");
        if (comment) {
          writeComment(comment);
        }
      }
    }
  }

  writeCutter();

  var t = tool.number;
  var p = 0;
  var l = tool.bodyLength;
  var o = tool.lengthOffset;
  writeln("LOADTL/" + t + ", " + p + ", " + mainFormat.format(l) + ", " + o);
  // writeln("OFSTNO/" + 0); // not used

  if (isMilling()) {
    writeln("SPINDL/" + mainFormat.format(spindleSpeed) + ", RPM, " + (tool.clockwise ? "CLW" : "CCLW"));
  }

  if (isTurning()) {
    writeln(
      "SPINDL/" + mainFormat.format(spindleSpeed) + ", " + ((unit == IN) ? "SFM" : "SMM") + ", " + (tool.clockwise ? "CLW" : "CCLW")
    );
  }
  setRotation(currentSection.workPlane);

  // writeln("ORIGIN/" + currentSection.workOrigin.x + ", " + currentSection.workOrigin.y + ", " + currentSection.workOrigin.z);
}

function onDwell(time) {
  writeln("DELAY/" + mainFormat.format(time)); // in seconds
}

function onRadiusCompensation() {
  if (radiusCompensation == RADIUS_COMPENSATION_OFF) {
    if (radiusCompensationActive) {
      radiusCompensationActive = false;
      writeln("CUTCOM/OFF");
    }
  } else {
    if (!radiusCompensationActive) {
      radiusCompensationActive = true;
      writeln("CUTCOM/ON");
    }
    var direction = (radiusCompensation == RADIUS_COMPENSATION_LEFT) ? "LEFT" : "RIGHT";
    if (tool.diameterOffset != 0) {
      writeln("CUTCOM/" + direction + ", " + tool.diameterOffset);
    } else {
      writeln("CUTCOM/" + direction);
    }
  }
}

function writeGOTO(x, y, z, i, j, k) {
  if (multax) {
    writeln("GOTO/" +
      mainFormat.format(x) + ", " +
      mainFormat.format(y) + ", " +
      mainFormat.format(z) + ", " +
      ijkFormat.format(i) + ", " +
      ijkFormat.format(j) + ", " +
      ijkFormat.format(k)
    );
  } else {
    writeln("GOTO/" +
      mainFormat.format(x) + ", " +
      mainFormat.format(y) + ", " +
      mainFormat.format(z)
    );
  }
}

function onRapid(x, y, z) {
  writeln("RAPID");
  writeGOTO(x, y, z, currentSection.workPlane.forward.x, currentSection.workPlane.forward.y, currentSection.workPlane.forward.z);
}

function onLinear(x, y, z, feed) {
  if (feed != currentFeed) {
    currentFeed = feed;
    writeln("FEDRAT/" + mainFormat.format(feed) + ", " + feedUnit);
  }
  writeGOTO(x, y, z, currentSection.workPlane.forward.x, currentSection.workPlane.forward.y, currentSection.workPlane.forward.z);
}

function onRapid5D(x, y, z, dx, dy, dz) {
  writeln("RAPID");
  writeGOTO(x, y, z, dx, dy, dz);
}

function onLinear5D(x, y, z, dx, dy, dz, feed) {
  if (feed != currentFeed) {
    currentFeed = feed;
    writeln("FEDRAT/" + mainFormat.format(feed) + ", " + feedUnit);
  }
  writeGOTO(x, y, z, dx, dy, dz);
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  if (feed != currentFeed) {
    currentFeed = feed;
    writeln("FEDRAT/" + mainFormat.format(feed) + ", " + feedUnit);
  }

  var n = getCircularNormal();
  if (clockwise) {
    n = Vector.product(n, -1);
  }
  writeln(
    "MOVARC/" + mainFormat.format(cx) + ", " + mainFormat.format(cy) + ", " + mainFormat.format(cz) + ", " +
    mainFormat.format(n.x) + ", " + mainFormat.format(n.y) + ", " + mainFormat.format(n.z) + ", " +
    mainFormat.format(getCircularRadius()) + ", ANGLE, " + mainFormat.format(toDeg(getCircularSweep()))
  );
  writeGOTO(x, y, z, currentSection.workPlane.forward.x, currentSection.workPlane.forward.y, currentSection.workPlane.forward.z);
}

function onCycle() {
  var d = mainFormat.format((cycle.depth !== undefined) ? cycle.depth : 0);
  var f = mainFormat.format((cycle.feedrate !== undefined) ? cycle.feedrate : 0);
  var c = mainFormat.format((cycle.clearance !== undefined) ? cycle.clearance : 0);
  var r = mainFormat.format((cycle.retract !== undefined) ? (c - cycle.retract) : 0);
  var q = mainFormat.format((cycle.dwell !== undefined) ? cycle.dwell : 0);
  var i = mainFormat.format((cycle.incrementalDepth !== undefined) ? cycle.incrementalDepth : 0); // for pecking

  var statement;

  switch (cycleType) {
  case "drilling":
    statement = "CYCLE/DRILL, " + d + ", " + feedUnit + ", " + f + ", " + c;
    if (r > 0) {
      statement += ", RAPTO, " + r;
    }
    break;
  case "counter-boring":
    statement = "CYCLE/DRILL, " + d + ", " + feedUnit + ", " + f + ", " + c;
    if (r > 0) {
      statement += ", RAPTO, " + r;
    }
    if (q > 0) {
      statement += ", DWELL, " + q;
    }
    break;
  case "reaming":
    statement = "CYCLE/REAM, " + d + ", " + feedUnit + ", " + f + ", " + c;
    if (r > 0) {
      statement += ", RAPTO, " + r;
    }
    if (q > 0) {
      statement += ", DWELL, " + q;
    }
    break;
  case "boring":
    statement = "CYCLE/BORE, " + d + ", " + feedUnit + ", " + f + ", " + c;
    if (r > 0) {
      statement += ", RAPTO, " + r;
    }
    statement += ", ORIENT, " + 0; // unknown orientation
    if (q > 0) {
      statement += ", DWELL, " + q;
    }
    break;
  case "fine-boring":
    statement = "CYCLE/BORE, " + d + ", " + feedUnit + ", " + f + ", " + c + ", " + cycle.shift;
    if (r > 0) {
      statement += ", RAPTO, " + r;
    }
    statement += ", ORIENT, " + 0; // unknown orientation
    if (q > 0) {
      statement += ", DWELL, " + q;
    }
    break;
  case "deep-drilling":
    statement = "CYCLE/DEEP, " + d + ", INCR, " + i + ", " + feedUnit + ", " + f + ", " + c;
    if (r > 0) {
      statement += ", RAPTO, " + r;
    }
    if (q > 0) {
      statement += ", DWELL, " + q;
    }
    break;
  case "chip-breaking":
    statement = "CYCLE/BRKCHP, " + d + ", INCR, " + i + ", " + feedUnit + ", " + f + ", " + c;
    if (r > 0) {
      statement += ", RAPTO, " + r;
    }
    if (q > 0) {
      statement += ", DWELL, " + q;
    }
    break;
  case "tapping":
    if (tool.type == TOOL_TAP_LEFT_HAND) {
      cycleNotSupported();
    } else {
      statement = "CYCLE/TAP, " + d + ", " + feedUnit + ", " + f + ", " + c;
      if (r > 0) {
        statement += ", RAPTO, " + r;
      }
    }
    break;
  case "right-tapping":
    statement = "CYCLE/TAP, " + d + ", " + feedUnit + ", " + f + ", " + c;
    if (r > 0) {
      statement += ", RAPTO, " + r;
    }
    break;
  default:
    cycleNotSupported();
  }
  writeln(statement);
}

function onCyclePoint(x, y, z) {
  writeln("FEDRAT/" + mainFormat.format(cycle.feedrate) + ", " + feedUnit);
  writeGOTO(x, y, z, currentSection.workPlane.forward.x, currentSection.workPlane.forward.y, currentSection.workPlane.forward.z);
}

function onCycleEnd() {
  writeln("CYCLE/OFF");
}

function onSectionEnd() {
}

function onClose() {
  if (coolantActive) {
    coolantActive = false;
    writeln("COOLNT/OFF");
  }
  writeln("END");
  writeln("FINI");
}

function setProperty(property, value) {
  properties[property].current = value;
}
