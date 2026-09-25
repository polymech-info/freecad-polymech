/**
  Copyright (C) 2012-2021 by Autodesk, Inc.
  All rights reserved.

  CAMplete APT post processor configuration.

  $Revision: 43569 147f5cf60e9217cf9c3365dc511a0f631d89bb16 $
  $Date: 2021-10-13 13:53:32 $

  FORKID {ADF192AD-B49D-44CF-9FB0-75F7AB9D2059}
*/

// ATTENTION: this post requires CAMplete TruePath build 677 or later

description = "CAMplete APT";
vendor = "CAMplete";
vendorUrl = "http://www.camplete.com";
legal = "Copyright (C) 2012-2021 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45702;

longDescription = "This post interfaces to CAMplete TruePath build 677 or later. The post creates the required project files with the tool information and model and stock for automatic import into CAMplete TruePath. If no fixture is selected, the part will get placed in the center of the table. If a fixture is selected without a fixture coordinate system, the part will get placed relative to the global part origin. If a fixture and a fixture coordinate system is selected, the part will get placed relative to the fixture coordinate system.";

unit = ORIGINAL_UNIT; // do not map unit
extension = "apt";
setCodePage("utf-8");

capabilities = CAPABILITY_INTERMEDIATE;

allowHelicalMoves = true;
allowedCircularPlanes = (1 << PLANE_XY) | (1 << PLANE_ZX) | (1 << PLANE_YZ); // only XY, ZX, and YZ planes

// user-defined properties
properties = {
  campleteInstallationPath: {
    title      : "CAMplete installation path",
    description: "Specifies the CAMplete installation path.",
    type       : "string",
    value      : "",
    scope      : "post"
  },
  includeOffsets: {
    title      : "Include offsets",
    description: "Select the desired offset method:" + EOL +
    "'None' to ignore any offsets," + EOL +
    "'Use auto align' to offset the model position automatically," + EOL +
    "'Use manual offset' to offset the model by the specified values in the XYZ manual offset properties," + EOL +
    "'Use fixture attachment point' to use the model postion of fixture attachment point specified in the setup.",
    type  : "enum",
    values: [
      {title:"None", id:"none"},
      {title:"Use auto align", id:"useAutoAlign"},
      {title:"Use manual offset", id:"useManualOffset"},
      {title:"Use fixture attachment point", id:"useFixtureAttachment"}
    ],
    value: "useAutoAlign",
    scope: "post",
    group: "preferences"
  },
  startCAMpleteAfterPostprocessing: {
    title      : "Start CAMplete after post processing",
    description: "Starts CAMplete immediately after post processing is complete.",
    type       : "boolean",
    value      : false,
    scope      : "post",
    group      : "preferences"
  },
  autoCompleteImport: {
    title      : "Auto complete import",
    description: "Automatically imports the model to CAMplete.",
    type       : "boolean",
    value      : false,
    visible    : false,
    scope      : "post",
    group      : "preferences"
  },
  skipProbeOperation: {
    title      : "Skip probing operations",
    description: "Skip probing and inspection operations for post processing.",
    type       : "boolean",
    value      : true,
    scope      : "post",
    group      : "preferences"
  },
  onlyXYArcs: {
    title      : "Only use XY arcs",
    description: "Only allow arc output on the XY plane.",
    type       : "boolean",
    value      : true,
    scope      : "post",
    group      : "preferences"
  },
  highAccuracy: {
    title      : "High accuracy",
    description: "Specifies short (no) or long (yes) numeric format.",
    type       : "boolean",
    value      : true,
    scope      : "post",
    group      : "preferences"
  },
  useG95forTapping: {
    title      : "Use G95 for tapping",
    description: "use IPR/MPR instead of IPM/MPM for tapping",
    type       : "boolean",
    value      : true,
    scope      : "post",
    group      : "preferences"
  },
  exportPart: {
    title      : "Export part",
    description: "Specifies whether or not to export the part STL with the project.",
    type       : "boolean",
    value      : true,
    scope      : "post",
    group      : "preferences"
  },
  exportStock: {
    title      : "Export stock",
    description: "Specifies whether or not to export the stock model with the project.",
    type       : "boolean",
    value      : true,
    scope      : "post",
    group      : "preferences"
  },
  exportFixture: {
    title      : "Export fixture",
    description: "Specifies whether or not to export the fixture STL with the project.",
    type       : "boolean",
    value      : true,
    scope      : "post",
    group      : "preferences"
  },
  xManualOffset: {
    title      : "X manual offset",
    description: "Offset distance in X.",
    type       : "number",
    value      : 0,
    scope      : "post",
    group      : "preferences"
  },
  yManualOffset: {
    title      : "Y manual offset",
    description: "Offset distance in Y.",
    type       : "number",
    value      : 0,
    scope      : "post",
    group      : "preferences"
  },
  zManualOffset: {
    title      : "Z manual offset",
    description: "Offset distance in Z.",
    type       : "number",
    value      : 0,
    scope      : "post",
    group      : "preferences"
  },
  machineName: {
    title      : "Machine name",
    description: "Specifies the machine name for CAMplete Autocomplete.",
    type       : "string",
    value      : "",
    visible    : false,
    scope      : "post"
  },
  postFile: {
    title      : "NC format name",
    description: "Specifies the NC format name for CAMplete Autocomplete.",
    type       : "string",
    value      : "",
    visible    : false,
    scope      : "post"
  }
};

// group 'preferences' for properties is used internally in the Fusion Add-In for CAMplete. Do not change or rename that group
groupDefinitions = {
  preferences: {title:"Preferences", description:"User preferences", order:0}
};

this.exportStock = true;
this.exportPart = true;
this.exportFixture = true;

var xyzFormat = createFormat({decimals:(unit == MM ? 3 : 4)});
var mainFormat = createFormat({decimals:6, forceDecimal:true});
var ijkFormat = createFormat({decimals:9, forceDecimal:true});

// collected state
var currentFeed;
var feedUnit;
var coolantActive = false;
var radiusCompensationActive = false;
var destPath = FileSystem.getFolderPath(getOutputPath());

function writeComment(text) {
  writeln("PPRINT/'" + filterText(text, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789(.,)/-+*= \t") + "'");
}

function onOpen() {
  if (getProperty("onlyXYArcs")) {
    allowedCircularPlanes = 1 << PLANE_XY; // arcs on XY plane only
  }

  var machineId = machineConfiguration.getModel();
  writeln("MACHIN/" + machineId);
  writeln("MODE/" + (isMilling() ? "MILL" : "TURN")); // first statement for an operation
  writeln("PARTNO/'" + programName + "'");
  if (programComment) {
    writeln("CSI_PROGRAM_COMMENT/" + programComment);
  }
  writeComment(programName);
  writeComment(programComment);
  if ((typeof getHeaderVersion == "function") && getHeaderVersion()) {
    writeComment(localize("post version") + ": " + getHeaderVersion());
  }
  if ((typeof getHeaderDate == "function") && getHeaderDate()) {
    writeComment(localize("post modified") + ": " + getHeaderDate());
  }

  if (!getProperty("highAccuracy")) {
    mainFormat = createFormat({decimals:4, forceDecimal:true});
    ijkFormat = createFormat({decimals:7, forceDecimal:true});
  }

  // check for duplicate tool number
  for (var i = 0; i < getNumberOfSections(); ++i) {
    var sectioni = getSection(i);
    var tooli = sectioni.getTool();
    for (var j = i + 1; j < getNumberOfSections(); ++j) {
      var sectionj = getSection(j);
      var toolj = sectionj.getTool();
      if (tooli.number == toolj.number) {
        if (xyzFormat.areDifferent(tooli.diameter, toolj.diameter) ||
          xyzFormat.areDifferent(tooli.cornerRadius, toolj.cornerRadius) ||
          (tooli.numberOfFlutes != toolj.numberOfFlutes)) {
          error(
            subst(
              localize("Using the same tool number for different cutter geometry for operation '%1' and '%2'."),
              sectioni.hasParameter("operation-comment") ? sectioni.getParameter("operation-comment") : ("#" + (i + 1)),
              sectionj.hasParameter("operation-comment") ? sectionj.getParameter("operation-comment") : ("#" + (j + 1))
            )
          );
          return;
        }
      }
    }
  }
}

var manualNC = [];

function onManualNC(command, value) {
  manualNC.push({command:command, value:value});
}

function executeManualNC(command) {
  for (var i = 0; i < manualNC.length; ++i) {
    if (!command || (command == manualNC[i].command)) {
      switch (manualNC[i].command) {
      case COMMAND_PASS_THROUGH: // sample on explicit execution of Manual NC command
        writeln("CSI_INSERT_CUSTOM_GCODE/" + manualNC[i].value);
        break;
      case COMMAND_COMMENT:
        writeComment(manualNC[i].value);
        break;
      default:
        expandManualNC(manualNC[i].command, manualNC[i].value);
      }
    }
  }
  for (var i = manualNC.length - 1; i >= 0; --i) {
    if (!command || (command == manualNC[i].command)) {
      manualNC.splice(i, 1);
    }
  }
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
    writeln("CSI_SET_PATH_PARAM/TOOL_BREAK=ON");
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

function onSection() {
  if (getProperty("skipProbeOperation") && (isProbeOperation() || isInspectionOperation())) {
    warning(localize("CAMplete TruePath does not support Probing/Inspection toolpaths, those operations will be skipped."));
    skipRemainingSection();
    return;
  }
  writeln("");
  writeln("PPRINT/'NEW SECTION'");
  // writeln("PPRINT/'Type: " + currentSection.getType() + "'")
  if (hasParameter("operation-strategy")) {
    var strategy = getParameter("operation-strategy");
    if (strategy) {
      writeln("PPRINT/'Strategy: " + strategy + "'");
    }
  }
  if (hasParameter("operation-comment")) {
    var comment = getParameter("operation-comment");
    if (comment) {
      writeln("PPRINT/'Comment: " + comment + "'");
      writeln("CSI_TOOL_PATH/" + comment);
    }
  }

  executeManualNC();

  if (currentSection.getForceToolChange()) {
    writeln("CSI_SET_PATH_PARAM/CSI_FORCE_TOOL_CHANGE=1");
  }

  writeln("");
  writeln("UNITS/" + ((unit == IN) ? "INCHES" : "MM"));
  feedUnit = (unit == IN) ? "IPM" : "MMPM";

  if (currentSection.isMultiAxis()) {
    writeln("MULTAX/ON");
  } else {
    writeln("MULTAX/OFF");
  }

  var w = currentSection.workPlane;
  var o = currentSection.workOrigin;
  writeln("");
  writeln("PPRINT/'MATRIX DEFINITION'");
  writeln("PPRINT/'Output x(i),y(i),z(i)'");
  writeln("PPRINT/'Output x(j),y(j),z(j)'");
  writeln("PPRINT/'Output x(k),y(k),z(k)'");
  writeln("PPRINT/'Output dx,dy,dz'");
  writeln("MCS/" + (ijkFormat.format(w.right.x) + ", " + ijkFormat.format(w.right.y) + ", " + ijkFormat.format(w.right.z) + ", $"));
  writeln(ijkFormat.format(w.up.x) + ", " + ijkFormat.format(w.up.y) + ", " + ijkFormat.format(w.up.z) + ", $");
  writeln(ijkFormat.format(w.forward.x) + ", " + ijkFormat.format(w.forward.y) + ", " + ijkFormat.format(w.forward.z) + ", $");
  writeln(mainFormat.format(o.x) + ", " + mainFormat.format(o.y) + ", " + mainFormat.format(o.z));
  writeln("");

  var d = tool.diameter;
  var r = tool.cornerRadius;
  var e = 0;
  var f = 0;
  var a = 0;
  var b = 0;
  var h = tool.bodyLength;
  writeln("CUTTER/" +
    mainFormat.format(d) + ", " +
    mainFormat.format(r) + ", " +
    mainFormat.format(e) + ", " +
    mainFormat.format(f) + ", " +
    mainFormat.format(a) + ", " +
    mainFormat.format(b) + ", " +
    mainFormat.format(h)
  );
  writeln("CSI_SET_FLUTE_LENGTH/" + mainFormat.format(tool.fluteLength));

  var t = tool.number;
  var p = 0;
  var l = tool.bodyLength;
  var o = tool.lengthOffset;
  writeln("LOADTL/" + t + ", " + p + ", " + mainFormat.format(l) + ", " + o);
  // writeln("OFSTNO/" + 0); // not used

  if (tool.breakControl) {
    onCommand(COMMAND_BREAK_CONTROL);
  }

  if (isMilling()) {
    writeln("SPINDL/" + "RPM," + (tool.type == TOOL_TAP_LEFT_HAND ? (spindleSpeed * -1) :  spindleSpeed) + "," + (tool.clockwise ? "CLW" : "CCLW"));
  }

  if (isTurning()) {
    writeln(
      "SPINDL/" + mainFormat.format(spindleSpeed) + ", " + ((unit == IN) ? "SFM" : "SMM") + ", " + (tool.clockwise ? "CLW" : "CCLW")
    );
  }

  // CSI - Coolant Support
  switch (tool.coolant) {
  case COOLANT_OFF:
    // TAG: make sure we disabled coolant between sections
    break;
  case COOLANT_FLOOD:
    writeln("COOLNT/FLOOD");
    break;
  case COOLANT_MIST:
    writeln("COOLNT/MIST");
    break;
  case COOLANT_THROUGH_TOOL:
    writeln("COOLNT/THRU");
    break;
  case COOLANT_AIR:
    writeln("COOLNT/CUSTOM1");
    break;
  case COOLANT_AIR_THROUGH_TOOL:
    writeln("COOLNT/CUSTOM2");
    break;
  case COOLANT_SUCTION:
    writeln("COOLNT/CUSTOM3");
    break;
  case COOLANT_FLOOD_MIST:
    writeln("COOLNT/FLOOD");
    writeln("COOLNT/MIST");
    break;
  case COOLANT_FLOOD_THROUGH_TOOL:
    writeln("COOLNT/FLOOD");
    writeln("COOLNT/THRU");
    break;
  default:
    warning(localize("Unsupported coolant."));
  }
  // CSI - End Coolant Support

  if (currentSection.workOffset != 0) {
    writeln("ZERO/" + currentSection.workOffset);
  }

  // writeln("ORIGIN/" + mainFormat.format(currentSection.workOrigin.x) + ", " + mainFormat.format(currentSection.workOrigin.y) + ", " + mainFormat.format(currentSection.workOrigin.z));

  if (hasParameter("operation:tolerance")) {
    var operationTolerance = hasParameter("operation:tolerance") && getParameter("operation:tolerance");
    writeln("CSI_PATH_TOLERANCE/" + mainFormat.format(operationTolerance));
  }
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
      writeln("CUTCOM/" + direction + ", " + mainFormat.format(tool.diameterOffset));
    } else {
      writeln("CUTCOM/" + direction);
    }
  }
}

function onRapid(x, y, z) {
  writeln("RAPID");
  writeln("GOTO/" + mainFormat.format(x) + ", " + mainFormat.format(y) + ", " + mainFormat.format(z));
  currentFeed = undefined; // avoid potential problems if user overrides settings within CAMplete
}

function onLinear(x, y, z, feed) {
  if (feed != currentFeed) {
    currentFeed = feed;
    writeln("FEDRAT/" + mainFormat.format(feed) + ", " + feedUnit);
  }
  writeln("GOTO/" +  mainFormat.format(x) + ", " +  mainFormat.format(y) + ", " +  mainFormat.format(z));
}

function onRapid5D(x, y, z, dx, dy, dz) {
  writeln("RAPID");
  writeln(
    "GOTO/" + mainFormat.format(x) + ", " + mainFormat.format(y) + ", " + mainFormat.format(z) + ", " +
    ijkFormat.format(dx) + ", " + ijkFormat.format(dy) + ", " + ijkFormat.format(dz)
  );
  currentFeed = undefined; // avoid potential problems if user overrides settings within CAMplete
}

function onLinear5D(x, y, z, dx, dy, dz, feed) {
  if (feed != currentFeed) {
    currentFeed = feed;
    writeln("FEDRAT/" + mainFormat.format(feed) + ", " + feedUnit);
  }
  writeln(
    "GOTO/" + mainFormat.format(x) + ", " + mainFormat.format(y) + ", " + mainFormat.format(z) + ", " +
    ijkFormat.format(dx) + ", " + ijkFormat.format(dy) + ", " + ijkFormat.format(dz)
  );
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  if (feed != currentFeed) {
    currentFeed = feed;
    writeln("FEDRAT/" + mainFormat.format(feed) + ", " + feedUnit);
  }

  var n = getCircularNormal();
  if (isClockwise()) {
    dir = 1;
  } else {
    dir = -1;
  }
  writeln(
    "CIRCLE/" + mainFormat.format(cx) + ", " + mainFormat.format(cy) + ", " + mainFormat.format(cz) + ", " +
    ijkFormat.format(n.x * dir) + ", " + ijkFormat.format(n.y * dir) + ", " + ijkFormat.format(n.z * dir) + ", " +
    mainFormat.format(getCircularRadius()) + ", " + mainFormat.format(toDeg(getCircularSweep())) + ", 0.0, 0.0, 0.0"
  );
  writeln("GOTO/" + mainFormat.format(x) + ", " + mainFormat.format(y) + ", " + mainFormat.format(z));
}

function onSpindleSpeed(spindleSpeed) {
  if (isMilling()) {
    writeln("SPINDL/" + "RPM," + mainFormat.format(spindleSpeed) + "," + (tool.clockwise ? "CLW" : "CCLW"));
  }

  if (isTurning()) {
    writeln(
      "SPINDL/" + mainFormat.format(spindleSpeed) + ", " + ((unit == IN) ? "SFM" : "SMM") + ", " + (tool.clockwise ? "CLW" : "CCLW")
    );
  }
}

var expandCurrentCycle = false;

function onCycle() {
  var d = mainFormat.format(cycle.depth);
  var f = mainFormat.format(cycle.feedrate);
  var c = mainFormat.format(cycle.clearance);
  var r = mainFormat.format(c - cycle.retract);
  var q = mainFormat.format(cycle.dwell);
  var i = mainFormat.format(cycle.incrementalDepth); // for pecking
  var p = mainFormat.format(tool.threadPitch);

  var RAPTO = mainFormat.format(cycle.retract - cycle.stock);
  var RTRCTO = mainFormat.format(cycle.clearance - cycle.stock);
  var RETURN = mainFormat.format(cycle.clearance - cycle.stock);

  var statement;

  expandCurrentCycle = false;
  switch (cycleType) {
  case "drilling":
    statement = "CYCLE/DRILL, FEDTO, " + d + ", " + feedUnit + ", " + f + ", CLEAR, " + c + ", RTRCTO, " + RTRCTO + ", RETURN, " + RETURN;
    if (mainFormat.getResultingValue(cycle.retract - cycle.stock) > 0) {
      statement += ", RAPTO, " + RAPTO;
    }
    break;
  case "counter-boring":
    statement = "CYCLE/DRILL, FEDTO, " + d + ", " + feedUnit + ", " + f + ", CLEAR, " + c + ", RETURN, " + RETURN;
    if (mainFormat.getResultingValue(cycle.retract - cycle.stock) > 0) {
      statement += ", RAPTO, " + RAPTO;
    }
    if (q > 0) {
      statement += ", DWELL, " + q;
    }
    break;
  case "reaming":
    statement = "CYCLE/REAM, FEDTO, " + d + ", " + feedUnit + ", " + f + ", CLEAR, " + c + ", RETURN, " + RETURN;
    if (mainFormat.getResultingValue(cycle.retract - cycle.stock) > 0) {
      statement += ", RAPTO, " + RAPTO;
    }
    if (q > 0) {
      statement += ", DWELL, " + q;
    }
    break;
  case "boring":
    statement = "CYCLE/BORE, FEDTO, " + d + ", " + feedUnit + ", " + f + ", CLEAR, " + c + ", RETURN, " + RETURN;
    if (mainFormat.getResultingValue(cycle.retract - cycle.stock) > 0) {
      statement += ", RAPTO, " + RAPTO;
    }
    statement += ", ORIENT, " + 0; // unknown orientation
    if (q > 0) {
      statement += ", DWELL, " + q;
    }
    break;
  case "fine-boring":
    statement = "CYCLE/BORE, FEDTO, " + d + ", " + feedUnit + ", " + f + ", CLEAR, " + c + ", " + cycle.shift + ", RETURN, " + RETURN;
    if (mainFormat.getResultingValue(cycle.retract - cycle.stock) > 0) {
      statement += ", RAPTO, " + RAPTO;
    }
    statement += ", ORIENT, " + 0; // unknown orientation
    if (q > 0) {
      statement += ", DWELL, " + q;
    }
    break;
  case "deep-drilling":
    statement = "CYCLE/DRILL,DEEP, FEDTO, " + d + ", INCR, " + i + ", " + feedUnit + ", " + f + ", CLEAR, " + c + ", RETURN, " + RETURN;
    if (mainFormat.getResultingValue(cycle.retract - cycle.stock) > 0) {
      statement += ", RAPTO, " + RAPTO;
    }
    if (q > 0) {
      statement += ", DWELL, " + q;
    }
    break;
  case "chip-breaking":
    statement = "CYCLE/BRKCHP, FEDTO, " + d + ", INCR, " + i + ", " + feedUnit + ", " + f + ", CLEAR, " + c + ", RETURN, " + RETURN;
    if (mainFormat.getResultingValue(cycle.retract - cycle.stock) > 0) {
      statement += ", RAPTO, " + RAPTO;
    }
    if (q > 0) {
      statement += ", DWELL, " + q;
    }
    break;
  case "tapping":
    if (tool.type == TOOL_TAP_LEFT_HAND) {
      cycleNotSupported();
    } else {
      if (getProperty("useG95forTapping")) {
        statement = "CYCLE/RIGID, DEPTH, " + d + ", PITCH" + ", " + p + ", CLEAR, " + c + ", RETURN, " + RETURN;
      } else {
        statement = "CYCLE/TAP, DEPTH, " + d + ", " + feedUnit + ", " + f + ", CLEAR, " + c + ", RETURN, " + RETURN;
      }
      if (mainFormat.getResultingValue(cycle.retract - cycle.stock) > 0) {
        statement += ", RAPTO, " + RAPTO;
      }
    }
    break;
  case "left-tapping":
  case "right-tapping":
    if (getProperty("useG95forTapping")) {
      statement = "CYCLE/RIGID, DEPTH, " + d + ", PITCH" + ", " + p + ", CLEAR, " + c + ", RETURN, " + RETURN;
    } else {
      statement = "CYCLE/TAP, DEPTH, " + d + ", " + feedUnit + ", " + f + ", CLEAR, " + c + ", RETURN, " + RETURN;
    }
    if (mainFormat.getResultingValue(cycle.retract - cycle.stock) > 0) {
      statement += ", RAPTO, " + RAPTO;
    }
    break;
  case "gun-drilling":
    expandCurrentCycle = true;
    break;
  default:
    cycleNotSupported();
  }
  writeln(statement);
}

function onCyclePoint(x, y, z) {
  if (expandCurrentCycle) {
    expandCyclePoint(x, y, z);
  } else {
    writeln("GOTO/" + mainFormat.format(x) + ", " + mainFormat.format(y) + ", " + mainFormat.format(cycle.stock));
  }
}

function onCycleEnd() {
  if (!expandCurrentCycle) {
    writeln("CYCLE/OFF");
  }
  currentFeed = undefined; // avoid potential problems if user overrides settings within CAMplete
}

function onSectionEnd() {
}

function onClose() {

  executeManualNC();

  if (coolantActive) {
    coolantActive = false;
    writeln("COOLNT/OFF");
  }
  writeln("END");
  writeln("FINI");
  createVerificationJob();
  createProjectFile();
  createToolDatabaseFile();
}

var charMap = {
  "<" : "&lt;",
  ">" : "&gt;",
  "&" : "&amp;",
  "'" : "&apos;",
  "\"": "&quot;"
};

/** Map specific chars. */
function mapCharacters(text) {
  var result = "";
  for (var i = 0; i < text.length; ++i) {
    var ch = charMap[text[i]];
    result += ch ? ch : text[i];
  }
  return result;
}

function createToolDatabaseFile() {
  var xOutput = createVariable({force:true}, xyzFormat);
  var yOutput = createVariable({force:true}, xyzFormat);

  var path = FileSystem.replaceExtension(getOutputPath(), "tdb");
  var file = new TextFile(path, true, "ansi");

  file.writeln("<?xml version='1.0' encoding='utf-8' standalone='yes'?>");
  file.writeln("<TOOLDB VER=" + "\"" + "1" + "\"" + ">");

  var tools = getToolTable();
  if (tools.getNumberOfTools() > 0) {
    for (var i = 0; i < tools.getNumberOfTools(); ++i) {
      var tool = tools.getTool(i);
      var toolType = tool.getType();
      var holder = tool.holder;
      var shaft = tool.shaft;
      var toolTypeName = "";
      switch (toolType) {
      case TOOL_DRILL:
        toolTypeName = "DRILL";
        break;
      case TOOL_DRILL_CENTER:
        toolTypeName = "CENTER DRIL";
        break;
      case TOOL_DRILL_SPOT:
        toolTypeName = "SPOT DRILL";
        break;
      case TOOL_TAP_LEFT_HAND:
        toolTypeName = "LEFT-HAND TAP";
        break;
      case TOOL_TAP_RIGHT_HAND:
        toolTypeName = "RIGHT-HAND TAP";
        break;
      case TOOL_PROBE:
        toolTypeName = "PROBE";
        break;
      case TOOL_COUNTER_SINK:
      case TOOL_MILLING_END_FLAT:
      case TOOL_COUNTER_BORE:
      case TOOL_REAMER:
      case TOOL_BORING_BAR:
      case TOOL_MILLING_FORM:
      case TOOL_MILLING_THREAD:
      case TOOL_MILLING_END_BULLNOSE:
      case TOOL_MILLING_END_BALL:
      case TOOL_MILLING_CHAMFER:
      case TOOL_MILLING_SLOT:
      case TOOL_MILLING_RADIUS:
      case TOOL_MILLING_FACE:
      case TOOL_MILLING_TAPERED:
      case TOOL_MILLING_DOVETAIL:
      case TOOL_MILLING_LOLLIPOP:
      default:
        toolTypeName = "MILL";
        break;
      }

      var toolCode;
      if (tool.description) {
        toolCode = " CODE2=" + "\"" + mapCharacters(tool.description) + "\"" + " ID=" + "\"" + mapCharacters(tool.description) + "\"";
      } else {
        toolCode = " ID=" + "\"" + getToolTypeName(tool.type) + "-" + (i + 1) + "\"";
      }

      file.writeln(
        "<TOOL CODE=" + "\"" + tool.number + "\"" +
        toolCode +
        " TYPE=" + "\"" + toolTypeName + "\"" +
        " VER=" + "\"" + "6" + "\"" +
        " TOLERANCE=" + "\"" + "-1" + "\"" +
        " UNITS=" + "\"" + ((unit == IN) ? "IN" : "MM") + "\"" +
        " OFFSETZ=" + "\"" + "0" + "\"" +
        " DIAMETER=" + "\"" + xyzFormat.format(tool.diameter) + "\"" + " >"
      );
      file.writeln("  <CUTTER TYPE=" + "\"" + "CUSTOM_REVOLUTED" + "\"" + " CSI_FLUTE_LENGTH=\"" + xyzFormat.format(tool.fluteLength) + "\"" + ">");
      file.writeln("    <PROFILE>");

      if (revision < 41761) {
        xOutput.format(0); // inital xOutput
        yOutput.format(0); // inital yOutput

        var arcGeometry = [];
        var cuttingGeometry = [];
        var shaftGeometry = [];
        var arcDir = "CCW";

        switch (toolType) {
        case TOOL_DRILL:
        case TOOL_DRILL_CENTER:
        case TOOL_DRILL_SPOT:
        case TOOL_COUNTER_SINK:
          cuttingGeometry.push({x:[tool.tipDiameter / 2], y:[0]});
          cuttingGeometry.push({x:[tool.diameter / 2], y:[(tool.diameter / 2 - tool.tipDiameter / 2) / Math.tan(tool.taperAngle / 2)]});
          cuttingGeometry.push({x:[tool.diameter / 2], y:[tool.fluteLength]});
          shaftGeometry.push({x:[tool.diameter / 2], y:[tool.shoulderLength]});
          break;
        case TOOL_MILLING_END_FLAT:
        case TOOL_TAP_LEFT_HAND:
        case TOOL_TAP_RIGHT_HAND:
        case TOOL_COUNTER_BORE:
        case TOOL_REAMER:
        case TOOL_BORING_BAR:
        case TOOL_MILLING_FORM:
        case TOOL_MILLING_THREAD:
          cuttingGeometry.push({x:[tool.diameter / 2], y:[0]});
          cuttingGeometry.push({x:[tool.diameter / 2], y:[tool.fluteLength]});
          shaftGeometry.push({x:[tool.diameter / 2], y:[tool.shoulderLength]});
          break;
        case TOOL_MILLING_END_BULLNOSE:
        case TOOL_MILLING_END_BALL:
          arcGeometry.push({x:[tool.diameter / 2 - tool.cornerRadius], y:[0]}); // start
          arcGeometry.push({x:[(tool.diameter / 2)], y:[tool.cornerRadius]}); // end
          arcGeometry.push({x:[tool.diameter / 2 - tool.cornerRadius], y:[tool.cornerRadius]}); // center
          cuttingGeometry.push({x:[tool.diameter / 2], y:[tool.fluteLength]});
          shaftGeometry.push({x:[tool.diameter / 2], y:[tool.shoulderLength]});
          break;
        case TOOL_MILLING_CHAMFER:
          var y1 = ((tool.diameter - tool.tipDiameter) / 2 * (Math.tan(tool.taperAngle)));
          var y2 = ((tool.diameter - tool.shaftDiameter) / 2 * (Math.tan(tool.taperAngle)) + y1);
          cuttingGeometry.push({x:[tool.tipDiameter / 2], y:[0]});
          cuttingGeometry.push({x:[tool.diameter / 2], y:[y1]});
          cuttingGeometry.push({x:[tool.shaftDiameter / 2], y:[y2]});
          cuttingGeometry.push({x:[tool.shaftDiameter / 2], y:[tool.fluteLength]});
          cuttingGeometry.push({x:[tool.shaftDiameter / 2], y:[tool.shoulderLength]});
          break;
        case TOOL_MILLING_SLOT:
          // special case with a lower and upper tool corner radius
          file.writeln("      <ARC DIR=" + "\"" + arcDir + "\"" + ">");
          file.writeln("        <START>" + xOutput.format(tool.diameter / 2 - tool.cornerRadius) + " " +  yOutput.format(0) + "</START>");
          file.writeln("        <END>" + xOutput.format(tool.diameter / 2) + " " + yOutput.format(tool.cornerRadius) + "</END>");
          file.writeln("        <CENTER>" + xyzFormat.format(tool.diameter / 2 - tool.cornerRadius) + " " + xyzFormat.format(tool.cornerRadius) + "</CENTER>");
          file.writeln("      </ARC>");
          file.writeln("      <LINE>" +
            "<START>" + xyzFormat.format(xOutput.getCurrent()) + " " + xyzFormat.format(yOutput.getCurrent()) + "</START>" +
            "<END>" + xOutput.format(tool.diameter / 2) + " " + yOutput.format(tool.fluteLength - tool.cornerRadius) + "</END></LINE>"
          );
          file.writeln("      <ARC DIR=" + "\"" + arcDir + "\"" + ">");
          file.writeln("        <START>" + xOutput.getCurrent() + " " +  yOutput.getCurrent() + "</START>");
          file.writeln("        <END>" + xOutput.format(tool.diameter / 2 - tool.cornerRadius) + " " + yOutput.format(tool.fluteLength) + "</END>");
          file.writeln("        <CENTER>" + xyzFormat.format(tool.diameter / 2 - tool.cornerRadius) + " " + xyzFormat.format(tool.fluteLength - tool.cornerRadius) + "</CENTER>");
          file.writeln("      </ARC>");
          shaftGeometry.push({x:[tool.shaftDiameter / 2], y:[tool.fluteLength]});
          shaftGeometry.push({x:[tool.shaftDiameter / 2], y:[tool.shoulderLength]});
          break;
        case TOOL_MILLING_RADIUS:
          arcDir = "CW";
          arcGeometry.push({x:[tool.diameter / 2], y:[0]}); // start
          arcGeometry.push({x:[(tool.diameter / 2 + tool.cornerRadius)], y:[tool.cornerRadius]}); // end
          arcGeometry.push({x:[tool.diameter / 2 + tool.cornerRadius], y:[0]}); // center
          shaftGeometry.push({x:[tool.diameter / 2 + tool.cornerRadius], y:[tool.fluteLength]});
          shaftGeometry.push({x:[tool.diameter / 2 + tool.cornerRadius], y:[tool.shoulderLength]});
          shaftGeometry.push({x:[tool.shaftDiameter / 2 + tool.cornerRadius], y:[tool.shoulderLength]});
          break;
        case TOOL_MILLING_FACE:
        case TOOL_MILLING_TAPERED:
          if (tool.taperAngle > 0 && tool.cornerRadius > 0) {
            var y = (tool.cornerRadius * Math.cos(toRad(90) - tool.taperAngle));
            var x = Math.sqrt((tool.cornerRadius * tool.cornerRadius) - (y * y));
            arcGeometry.push({x:[(tool.diameter / 2 - tool.cornerRadius / 2)], y:[0]}); // start
            arcGeometry.push({x:[(tool.diameter / 2 - tool.cornerRadius / 2) + x], y:[tool.cornerRadius - y]}); // end
            arcGeometry.push({x:[((tool.diameter - tool.cornerRadius) / 2)], y:[tool.cornerRadius]}); // center
            cuttingGeometry.push({x:[((tool.diameter / 2 - tool.cornerRadius / 2) + x)], y:[tool.cornerRadius - y]}); // to flute length
            cuttingGeometry.push({x:[(((tool.fluteLength - tool.cornerRadius - y) * Math.tan(tool.taperAngle) + tool.diameter / 2 - tool.cornerRadius / 2) + x)], y:[tool.fluteLength]});
            shaftGeometry.push({x:[(((tool.shoulderLength - tool.cornerRadius - y) * Math.tan(tool.taperAngle) + tool.diameter / 2 - tool.cornerRadius / 2) + x)], y:[tool.shoulderLength]});
          } else if (tool.taperAngle > 0 && tool.cornerRadius == 0) {
            var y = (tool.cornerRadius * Math.cos(toRad(90) - tool.taperAngle));
            cuttingGeometry.push({x:[((tool.diameter / 2 - tool.cornerRadius / 2))], y:[tool.cornerRadius]}); // to flute length
            cuttingGeometry.push({x:[(((tool.fluteLength - tool.cornerRadius - y) * Math.tan(tool.taperAngle) + tool.diameter / 2 - tool.cornerRadius / 2))], y:[tool.fluteLength]});
            shaftGeometry.push({x:[(((tool.shoulderLength - tool.cornerRadius - y) * Math.tan(tool.taperAngle) + tool.diameter / 2 - tool.cornerRadius / 2))], y:[tool.shoulderLength]});
          } else if (tool.cornerRadius > 0 && tool.taperAngle == 0) {
            arcGeometry.push({x:[tool.diameter / 2 - tool.cornerRadius], y:[0]}); // start
            arcGeometry.push({x:[(tool.diameter / 2)], y:[tool.cornerRadius]}); // end
            arcGeometry.push({x:[tool.diameter / 2 - tool.cornerRadius], y:[tool.cornerRadius]}); // center
            cuttingGeometry.push({x:[tool.diameter / 2], y:[tool.fluteLength]});
            shaftGeometry.push({x:[tool.diameter / 2], y:[tool.shoulderLength]});
          } else {
            cuttingGeometry.push({x:[tool.diameter / 2], y:[0]});
            cuttingGeometry.push({x:[tool.diameter / 2], y:[tool.fluteLength]});
            shaftGeometry.push({x:[tool.diameter / 2], y:[tool.shoulderLength]});
          }
          break;
        case TOOL_MILLING_DOVETAIL:
          var y = (tool.cornerRadius * Math.cos(toRad(90) - tool.taperAngle));
          var x = Math.sqrt((tool.cornerRadius * tool.cornerRadius) - (y * y));
          if (tool.cornerRadius > 0) {
            arcGeometry.push({x:[(tool.diameter / 2 - tool.cornerRadius / 2)], y:[0]}); // start
            arcGeometry.push({x:[(tool.diameter / 2 - tool.cornerRadius / 2) + x], y:[tool.cornerRadius - y]}); // end
            arcGeometry.push({x:[((tool.diameter - tool.cornerRadius) / 2)], y:[tool.cornerRadius]}); // center
            cuttingGeometry.push({x:[(tool.diameter / 2) - (tool.fluteLength * Math.cos(toRad(90) - tool.taperAngle))], y:[tool.fluteLength]});
          } else {
            cuttingGeometry.push({x:[tool.diameter / 2], y:[0]});
            cuttingGeometry.push({x:[(tool.diameter / 2) - (tool.fluteLength * Math.cos(toRad(90) - tool.taperAngle))], y:[tool.fluteLength]});
          }
          shaftGeometry.push({x:[(tool.diameter / 2) - (tool.fluteLength * Math.cos(toRad(90) - tool.taperAngle))], y:[tool.shoulderLength]});
          break;
        case TOOL_MILLING_LOLLIPOP:
          arcGeometry.push({x:[(0)], y:[0]}); // start
          arcGeometry.push({x:[tool.shaftDiameter / 2], y:[(Math.sqrt((tool.diameter / 2 * tool.diameter / 2) - (tool.shaftDiameter / 2 * tool.shaftDiameter / 2)) + tool.diameter / 2)]}); // end
          arcGeometry.push({x:[(0)], y:[tool.diameter / 2]}); // center
          break;
        default:
          error(localize("Unsupported tool type."));
          return;
        }
        if (arcGeometry.length > 0) {
          file.writeln("      <ARC DIR=" + "\"" + arcDir + "\"" + ">");
          file.writeln("        <START>" + xOutput.format(parseFloat(arcGeometry[0].x)) + " " +  yOutput.format(parseFloat(arcGeometry[0].y)) + "</START>");
          file.writeln("        <END>" + xOutput.format(parseFloat(arcGeometry[1].x)) + " " + yOutput.format(parseFloat(arcGeometry[1].y)) + "</END>");
          file.writeln("        <CENTER>" + xyzFormat.format(parseFloat(arcGeometry[2].x)) + " " + xyzFormat.format(parseFloat(arcGeometry[2].y)) + "</CENTER>");
          file.writeln("      </ARC>");
        }
        for (var j = 0; j < cuttingGeometry.length; ++j) {
          var o = cuttingGeometry[j];
          file.writeln("      <LINE>" +
            "<START>" + xyzFormat.format(xOutput.getCurrent()) + " " + xyzFormat.format(yOutput.getCurrent()) + "</START>" +
            "<END>" + xOutput.format(parseFloat(o.x)) + " " + yOutput.format(parseFloat(o.y)) + "</END></LINE>"
          );
        }
        file.writeln("    </PROFILE>");
        file.writeln("  </CUTTER>");

        file.writeln("  <SHANK TYPE=" + "\"" + "CUSTOM_REVOLUTED" + "\"" + ">");
        file.writeln("    <PROFILE>");
        for (var j = 0; j < shaftGeometry.length; ++j) {
          var o = shaftGeometry[j];
          file.writeln("      <LINE>" +
              "<START>" + xyzFormat.format(xOutput.getCurrent()) + " " + xyzFormat.format(yOutput.getCurrent()) + "</START>" +
              "<END>" + xOutput.format(parseFloat(o.x)) + " " + yOutput.format(parseFloat(o.y)) + "</END></LINE>");
        }

        if (shaft && shaft.hasSections()) {
          var n = shaft.getNumberOfSections();
          for (var j = 1; j < n; ++j) {
            file.writeln("      <LINE>" +
              "<START>" + xyzFormat.format(xOutput.getCurrent()) + " " + xyzFormat.format(yOutput.getCurrent()) + "</START>" +
              "<END>" + xOutput.format(shaft.getDiameter(j) / 2) + " " + yOutput.format(yOutput.getCurrent() + shaft.getLength(j)) + "</END></LINE>");
          }
        }
        file.writeln("      <LINE>" +
          "<START>" + xyzFormat.format(xOutput.getCurrent()) + " " + xyzFormat.format(yOutput.getCurrent()) + "</START>" +
          "<END>" + xOutput.format(tool.shaftDiameter / 2) + " " + xyzFormat.format(yOutput.getCurrent()) + "</END></LINE>"
        );
        file.writeln("      <LINE>" +
          "<START>" + xyzFormat.format(xOutput.getCurrent()) + " " + xyzFormat.format(yOutput.getCurrent()) + "</START>" +
          "<END>" + xOutput.format(tool.shaftDiameter / 2) + " " + yOutput.format(tool.bodyLength) + "</END></LINE>"
        );
        file.writeln("    </PROFILE>");
        file.writeln("  </SHANK>");
      } else {
        var cutter = tool.getCutterProfile();
        var isCuttingElement = true;
        for (var k = 0; k < cutter.getNumberOfEntities() / 2; ++k) {
          var arc = ((cutter.getEntity(k).clockwise == true) || cutter.getEntity(k).center.length > 1e-4);
          var startX = cutter.getEntity(k).start.x;
          var startY = cutter.getEntity(k).start.y;
          var endX = cutter.getEntity(k).end.x;
          var endY = cutter.getEntity(k).end.y;
          var centerX = cutter.getEntity(k).center.x;
          var centerY = cutter.getEntity(k).center.y;
          var arcDir = cutter.getEntity(k).clockwise ? "CW" : "CCW";
          var skip = false;

          // code below is disabled since the tool flute length is now specified by the CSI_FLUTE_LENGTH parameter
          if (false && (xyzFormat.getResultingValue(endY) >= xyzFormat.getResultingValue(tool.fluteLength)) && isCuttingElement) { // split a single segment if the fluteLength is smaller than the endY position
            skip = (xyzFormat.getResultingValue(endY) == xyzFormat.getResultingValue(tool.fluteLength));
            var endYTemp = endY - tool.fluteLength;
            if (arc) {
              var radius = Vector.diff(cutter.getEntity(k).start, cutter.getEntity(k).center).length;
              var endXTemp = Math.sqrt(radius * radius - endYTemp * endYTemp);
              var q = Math.abs(endX > startX ? (startX + endXTemp) : (startX - endXTemp));
              file.writeln("      <ARC DIR=" + "\"" + arcDir + "\"" + ">");
              file.writeln("        <START>" + xOutput.format(startX) + " " + yOutput.format(startY) + "</START>");
              file.writeln("        <END>" + xOutput.format(q) + " " + yOutput.format(tool.fluteLength) + "</END>");
              file.writeln("        <CENTER>" + xyzFormat.format(centerX) + " " + xyzFormat.format(centerY) + "</CENTER>");
              file.writeln("      </ARC>");
            } else {
              var q = tool.taperAngle ? (endX - (endYTemp * Math.tan(tool.taperAngle / 2))) : endX;
              file.writeln("      <LINE>" +
                "<START>" + xyzFormat.format(startX) + " " + xyzFormat.format(startY) + "</START>" +
                "<END>" + xOutput.format(q) + " " + yOutput.format(tool.fluteLength) + "</END></LINE>"
              );
            }
            startX = q;
            startY = tool.fluteLength;
            isCuttingElement = false;
            file.writeln("    </PROFILE>");
            file.writeln("  </CUTTER>");
            file.writeln("  <SHANK TYPE=" + "\"" + "CUSTOM_REVOLUTED" + "\"" + ">");
            file.writeln("    <PROFILE>");
          }
          if (!skip) {
            if (arc) {
              file.writeln("      <ARC DIR=" + "\"" + arcDir + "\"" + ">");
              file.writeln("        <START>" + xOutput.format(startX) + " " + yOutput.format(startY) + "</START>");
              file.writeln("        <END>" + xOutput.format(endX) + " " + yOutput.format(endY) + "</END>");
              file.writeln("        <CENTER>" + xyzFormat.format(centerX) + " " + xyzFormat.format(centerY) + "</CENTER>");
              file.writeln("      </ARC>");
            } else {
              file.writeln("      <LINE>" +
                "<START>" + xyzFormat.format(startX) + " " + xyzFormat.format(startY) + "</START>" +
                "<END>" + xOutput.format(endX) + " " + yOutput.format(endY) + "</END></LINE>"
              );
            }
          }
        }
        file.writeln("    </PROFILE>");
        file.writeln("  </CUTTER>");
      }
      file.writeln(
        "  <HOLDER TYPE=" + "\"" + "CUSTOM_REVOLUTED" + "\"" +
      " VER=" + "\"" + "2" + "\"" +
      " POSX=" + "\"" + "0" + "\"" +
      " POSY=" + "\"" + "0" + "\"" +
      " POSZ=" + "\"" + xyzFormat.format(yOutput.getCurrent()) + "\"" +
      " RZ=" + "\"" + "0" + "\"" +
      " RY=" + "\"" + "0" + "\"" +
      " RX=" + "\"" + "0" + "\"" + ">");
      file.writeln("    <CODE>DEFAULT HOLDER</CODE>");
      file.writeln("      <PROFILE>");

      var hCurrent = 0;
      if (holder && holder.hasSections()) {
        var n = holder.getNumberOfSections();
        for (var j = 0; j < n; ++j) {
          if (j == 0) {
            file.writeln("        <LINE><START>0 0</START><END>" + xyzFormat.format(tool.shaftDiameter / 2) + " 0</END></LINE>");
          } else {
            hCurrent += holder.getLength(j - 1);
            file.writeln("        <LINE>" +
              "<START>" + xyzFormat.format(holder.getDiameter(j - 1) / 2) + " " + xyzFormat.format(hCurrent) + "</START>" +
              "<END>" + xyzFormat.format(holder.getDiameter(j) / 2) + " " + xyzFormat.format(hCurrent + holder.getLength(j)) + "</END></LINE>"
            );
          }
        }
      }
      file.writeln("      </PROFILE>");
      file.writeln("  </HOLDER>");
      file.writeln("</TOOL>");
    }
  }
  file.writeln("</TOOLDB>");
  file.close();
}

var projPath;

function createProjectFile() {
  projPath = FileSystem.replaceExtension(getOutputPath(), "proj");
  var file = new TextFile(projPath, true, "ansi");
  var workpiece = getWorkpiece();
  var delta = Vector.diff(workpiece.upper, workpiece.lower);

  if (hasGlobalParameter("autodeskcam:fixture-path")) {
    var x = (getSection(0).getFCSOrigin().x * -1);
    var y = (getSection(0).getFCSOrigin().y * -1);
    var z = Math.abs(getSection(0).getFCSOrigin().z);
  } else {
    var x = delta.x / 2 - workpiece.upper.x;
    var y = delta.y / 2 - workpiece.upper.y;
    var z = Math.abs(workpiece.lower.z);
  }

  if (getProperty("includeOffsets") == "useManualOffset") {
    x = parseFloat(getProperty("xManualOffset"));
    y = parseFloat(getProperty("yManualOffset"));
    z = parseFloat(getProperty("zManualOffset"));
  }

  if (!programName) {
    error(localize("Program name is not specified."));
    return;
  }

  file.writeln("<?xml version='1.0' encoding='utf-8' standalone='yes'?>");
  file.writeln("<PROJECTCONFIG>");
  file.writeln(" <SOURCE>");
  file.writeln("  <CAMSYSTEM>Autodesk CAM</CAMSYSTEM>");
  file.writeln("  <VERSION>2016</VERSION>");
  file.writeln("  <PLUGINCREATOR></PLUGINCREATOR>");
  file.writeln("  <PLUGINNAME MAJ_VER=" + "\"" + "1" + "\"" + " MIN_VER=" + "\"" + "1" + "\"" + ">" + description + "</PLUGINNAME>");
  file.writeln(" </SOURCE>");
  file.writeln(" <NAME>" + programName + "</NAME>");
  file.writeln(" <TOOLING>");
  file.writeln("  <TOOLLIBRARY LOADER=" + "\"" + "AUTODESKCAM_CAMPLETE_XML_TOOLING" + "\"" + ">" + ".\\" + programName + ".tdb</TOOLLIBRARY>");
  file.writeln(" </TOOLING>");
  file.writeln(" <TOOLPATHS>");
  file.writeln("  <TOOLPATH LOADER=" + "\"" + "AUTODESKCAM_CAMPLETE_APT" + "\"" + " UNITS=" + "\"" + ((unit == IN) ? "INCHES" : "MM") + "\"" + ">" + ".\\" + programName + "." + extension + "</TOOLPATH>");
  file.writeln(" </TOOLPATHS>");
  if (getProperty("includeOffsets") == "useFixtureAttachment" || getProperty("includeOffsets") == "useManualOffset") {
    file.writeln(" <OFFSETS>");
    file.writeln("  <OFFSET TYPE=\"PALLETTOGCODESHIFT\" X=" + "\""  + xyzFormat.format(x) + "\"" + " Y=" + "\""  + xyzFormat.format(y) + "\"" + " Z=" + "\""  + xyzFormat.format(z) + "\"" + " UNITS=\"" + ((unit == IN) ? "INCHES" : "MM") + "\"></OFFSET>");
    file.writeln(" </OFFSETS>");
  }
  file.writeln(" <PARTINFO>");
  if (getProperty("exportPart")) {
    file.writeln("  <TARGETMODEL LOADER=" + "\"" + "GENERIC_STL" + "\"" + " UNITS=" + "\"" + ((unit == IN) ? "INCHES" : "MM") + "\"" + ">" + ".\\" + programName + "_PART.stl</TARGETMODEL>");
  }
  if (getProperty("exportStock") && hasGlobalParameter("autodeskcam:stock-path")) {
    file.writeln("  <STOCK LOADER=" + "\"" + "GENERIC_STL" + "\"" + " UNITS=" + "\"" + ((unit == IN) ? "INCHES" : "MM") + "\"" + ">" + ".\\" + programName + "_STOCK.stl</STOCK>");
  }
  if (getProperty("exportFixture") && hasGlobalParameter("autodeskcam:fixture-path")) {
    file.writeln("  <FIXTURE LOADER=" + "\"" + "GENERIC_STL" + "\"" + " UNITS=" + "\"" + ((unit == IN) ? "INCHES" : "MM") + "\"" + ">" + ".\\" + programName + "_FIXTURE.stl</FIXTURE>");
  }
  file.writeln(" </PARTINFO>");

  file.writeln(" <COMMANDS>");
  if (getProperty("autoCompleteImport")) {
    file.writeln("  <AUTOCOMPLETEIMPORT>TRUE</AUTOCOMPLETEIMPORT>");
  }
  if (getProperty("machineName") != "") {
    file.writeln("  <SELECTMACHINESETUP NAME=" + "\"" + getProperty("machineName") + "\"" + ">TRUE</SELECTMACHINESETUP>");
  }
  if (getProperty("postFile") != "") {
    file.writeln("  <SELECTNCFORMAT NAME=" + "\"" + getProperty("postFile") + "\"" + ">TRUE</SELECTNCFORMAT>");
  }
  if (getProperty("includeOffsets") == "useAutoAlign") {
    file.writeln("  <AUTOALIGNGEOMETRY LOCATEGCS=" + "\"" + "TRUE" + "\"" + " LOCATEMCS=" + "\"" + "TRUE" + "\"" + ">TRUE</AUTOALIGNGEOMETRY>");
  }
  file.writeln(" </COMMANDS>");

  file.writeln("</PROJECTCONFIG>");
  file.close();
}

var destStockPath = "";
var destPartPath = "";
var destFixturePath = "";

function createVerificationJob() {
  var stockPath;
  if (hasGlobalParameter("autodeskcam:stock-path")) {
    stockPath = getGlobalParameter("autodeskcam:stock-path");
  }
  var partPath;
  if (hasGlobalParameter("autodeskcam:part-path")) {
    partPath = getGlobalParameter("autodeskcam:part-path");
  }
  var fixturePath;
  if (hasGlobalParameter("autodeskcam:fixture-path")) {
    fixturePath = getGlobalParameter("autodeskcam:fixture-path");
  }

  if (!FileSystem.isFolder(destPath)) {
    error(subst(localize("NC verification job folder '%1' does not exist."), destPath));
    return;
  }

  if (!programName) {
    error(localize("Program name is not specified."));
    return;
  }

  if (getProperty("exportStock") && FileSystem.isFile(stockPath)) {
    destStockPath = FileSystem.getCombinedPath(destPath, programName + "_STOCK.stl");
    FileSystem.copyFile(stockPath, destStockPath);
  }

  if (getProperty("exportPart") && FileSystem.isFile(partPath)) {
    destPartPath = FileSystem.getCombinedPath(destPath, programName + "_PART.stl");
    FileSystem.copyFile(partPath, destPartPath);
  }

  if (getProperty("exportFixture") && FileSystem.isFile(fixturePath)) {
    destFixturePath = FileSystem.getCombinedPath(destPath, programName + "_FIXTURE.stl");
    FileSystem.copyFile(fixturePath, destFixturePath);
  }
}

function onTerminate() {
  if (getProperty("startCAMpleteAfterPostprocessing")) {
    if (getPlatform() != "WIN32") {
      return;
    }
    var exePath;
    if (getProperty("campleteInstallationPath") == "") {
      var date = new Date();
      var currentYear = date.getFullYear();
      for (var i = currentYear + 1; i >= currentYear - 2; --i) {
        var registryString = "HKEY_CURRENT_USER\\SOFTWARE\\CAMplete\\x64\\CAMplete TruePath " + i;
        if (hasRegistryValue(registryString, "")) {
          exePath = FileSystem.getCombinedPath(FileSystem.getFolderPath(getRegistryString(registryString, "")), "CampleteTruePath.exe");
          if (FileSystem.isFile(exePath)) {
            break;
          }
        }
      }
      if (!FileSystem.isFile(exePath)) {
        error(localize("CAMplete was not found on your machine. Use property 'campleteInstallationPath' to set the full path to the executable."));
        return;
      }
    } else {
      exePath = getProperty("campleteInstallationPath");
      if (!FileSystem.isFile(exePath)) {
        error(localize("The specified path in property 'campleteInstallationPath' is invalid."));
        return;
      }
    }
    executeNoWait(exePath, "\"" + projPath + "\"", false, "");
  }
}

function setProperty(property, value) {
  properties[property].current = value;
}
