/**
  Copyright (C) 2012-2021 by Autodesk, Inc.
  All rights reserved.

  ISEL post processor configuration.

  $Revision: 43654 a19c569c9f7fe055fc222095112d3f1eebc74b63 $
  $Date: 2021-12-02 09:56:05 $

  FORKID {FF26919F-F5E0-4fcc-9408-035EEE34FAB4}
*/

description = "ISEL Intermediate";
vendor = "ISEL";
vendorUrl = "https://www.isel.com";
legal = "Copyright (C) 2012-2021 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45702;

longDescription = "Generic milling post for ISEL intermediate format.";

extension = "ncp";
setCodePage("ascii");

capabilities = CAPABILITY_MILLING;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(360);
allowHelicalMoves = true;
allowedCircularPlanes = undefined; // allow any circular motion
highFeedrate = (unit == IN) ? 300 : 3000;

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
  showSequenceNumbers: {
    title      : "Use sequence numbers",
    description: "Use sequence numbers for each block of outputted code.",
    group      : 1,
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  sequenceNumberStart: {
    title      : "Start sequence number",
    description: "The number at which to start the sequence numbers.",
    group      : 1,
    type       : "integer",
    value      : 10,
    scope      : "post"
  },
  sequenceNumberIncrement: {
    title      : "Sequence number increment",
    description: "The amount by which the sequence number is incremented by in each block.",
    group      : 1,
    type       : "integer",
    value      : 5,
    scope      : "post"
  },
  forceCycleExpansion: {
    title      : "Expand drilling cycles",
    description: "If enabled, all drilling cycles are expanded.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  fastvel: {
    title      : "Rapid feedrate",
    description: "User defined rapid feedrate.",
    type       : "number",
    value      : 0,
    scope      : "post"
  },
  useHelicalArcs: {
    title      : "Use helical arcs",
    description: "Specifies if helical arcs are supported.",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  extendedCoolants: {
    title      : "Use extended coolant codes",
    description: "If enabled, Air (COOLANT), Flood (COOLANT2), and Mist (COOLANT2) coolants are supported.",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  safePositionMethod: {
    title      : "Safe Retracts",
    description: "Select your desired retract option. 'Clearance Height' retracts to the operation clearance height.",
    type       : "enum",
    values     : [
      {title:"Clearance Height", id:"clearanceHeight"},
      {title:"WPCLEAR", id:"wpclear"}
    ],
    value: "wpclear",
    scope: "post"
  }
};

/** Returns the feed in micrometers/s. */
function toVel(feed) {
  return feed / 60 * 1000;
}

/** Returns the spatial coordinate in micrometers. */
function toUM(spatial) {
  return spatial * 1000;
}

/** Returns the angular coordinate in angular seconds. */
function toAS(angular) {
  return angular * 60 * 60;
}

var xyzFormat = createFormat({decimals:0, forceDecimal:false});
var abcFormat = createFormat({decimals:0, forceSign:false, forceDecimal:false, scale:DEG});
var sweepFormat = createFormat({decimals:0, scale:DEG});
var feedFormat = createFormat({decimals:0, forceDecimal:false});
var toolFormat = createFormat({decimals:0});
var rpmFormat = createFormat({decimals:0});
var milliFormat = createFormat({decimals:0}); // milliseconds // range 1-9999
var taperFormat = createFormat({decimals:1, scale:DEG});

var xOutput = createVariable({prefix:"X"}, xyzFormat);
var yOutput = createVariable({prefix:"Y"}, xyzFormat);
var zOutput = createVariable({onchange:function () {retracted = false;}, prefix:"Z"}, xyzFormat);
var aOutput = createVariable({prefix:"A"}, abcFormat);
var bOutput = createVariable({prefix:"B"}, abcFormat);
var cOutput = createVariable({prefix:"C"}, abcFormat);
var feedOutput = createVariable({}, feedFormat);

// circular output
var iOutput = createVariable({prefix:"I", force:true}, xyzFormat);
var jOutput = createVariable({prefix:"J", force:true}, xyzFormat);
var kOutput = createVariable({prefix:"K", force:true}, xyzFormat);

// collected state
var sequenceNumber;
var currentPlane;
var lastSpindleSpeed = 0;
var retracted = false; // specifies that the tool has been retracted to the safe plane

/**
  Writes the specified plane.
*/
function writePlane(plane) {
  if (plane != currentPlane) {
    currentPlane = plane;
    writeBlock("PLANE " + plane);
  }
}

/**
  Writes the specified block.
*/
function writeBlock() {
  if (getProperty("showSequenceNumbers")) {
    // up to 6 digits
    writeWords2("N" + sequenceNumber, arguments);
    sequenceNumber += getProperty("sequenceNumberIncrement");
  } else {
    writeWords(arguments);
  }
}

/**
  Output a comment.
*/
function writeComment(text) {
  writeBlock("; " + text);
}

function formatCycleTime(cycleTime) {
  cycleTime += 0.5; // round up
  var seconds = cycleTime % 60 | 0;
  var minutes = ((cycleTime - seconds) / 60 | 0) % 60;
  var hours = (cycleTime - minutes * 60 - seconds) / (60 * 60) | 0;
  if (hours > 0) {
    return subst(localize("%1h:%2m:%3s"), hours, minutes, seconds);
  } else if (minutes > 0) {
    return subst(localize("%1m:%2s"), minutes, seconds);
  } else {
    return subst(localize("%1s"), seconds);
  }
}

function onOpen() {
  machineConfiguration.setRetractPlane(0);
  machineConfiguration.setHomePositionX(0);
  machineConfiguration.setHomePositionY(0);

  if (!machineConfiguration.isMachineCoordinate(0)) {
    aOutput.disable();
  }
  if (!machineConfiguration.isMachineCoordinate(1)) {
    bOutput.disable();
  }
  if (!machineConfiguration.isMachineCoordinate(2)) {
    cOutput.disable();
  }

  sequenceNumber = getProperty("sequenceNumberStart");
  writeBlock("IMF_PBL", programName);

  if (!programName) {
    error(localize("Program name has not been specified."));
  }
  if (programComment) {
    writeComment(programComment);
  }

  var cycleTime = 0;
  var currentTool;
  var toolChangeTime = 15; // specifies the time needed for a tool change
  for (var i = 0; i < getNumberOfSections(); ++i) {
    var section = getSection(i);
    cycleTime += section.getCycleTime();
    var tool = section.getTool();
    if (currentTool != tool.number) {
      currentTool = tool.number;
      // cycleTime += toolChangeTime;
    }
    if (getProperty("fastvel") > 0) {
      // cycleTime += section.getRapidDistance()/getProperty("fastvel") * 60;
    }
  }
  writeComment(localize("Estimated Cycle Time") + ": " + formatCycleTime(cycleTime));

  if (getProperty("fastvel")) {
    writeBlock("FASTVEL " + feedFormat.format(toVel(getProperty("fastvel"))));
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

  switch (unit) {
  case IN:
    writeBlock("INCH");
    break;
  case MM:
    writeBlock("METRIC");
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
  zOutput.reset();
}

/** Force output of A, B, and C. */
function forceABC() {
  aOutput.reset();
  bOutput.reset();
  cOutput.reset();
}

/** Force output of X, Y, Z, A, B, C, and VEL on next output. */
function forceAny() {
  forceXYZ();
  forceABC();
  feedOutput.reset();
}

function onParameter(name, value) {
}

var currentWorkPlaneABC = undefined;

function forceWorkPlane() {
  currentWorkPlaneABC = undefined;
}

var currentCoolantMode = COOLANT_OFF;

function setCoolant(coolant) {
  if (coolant == currentCoolantMode) {
    return; // coolant is already active
  }

  var m;
  switch (coolant) {
  case COOLANT_OFF:
    if (getProperty("extendedCoolants") && (currentCoolantMode == COOLANT_FLOOD || currentCoolantMode == COOLANT_MIST)) {
      m = "COOLANT2 OFF";
    } else {
      m = "COOLANT OFF";
    }
    break;
  case COOLANT_FLOOD:
    if (getProperty("extendedCoolants")) {
      setCoolant(COOLANT_OFF);
      m = "COOLANT2 ON";
    } else {
      m = "COOLANT ON";
    }
    break;
  case COOLANT_MIST:
    if (getProperty("extendedCoolants")) {
      setCoolant(COOLANT_OFF);
      m = "COOLANT2 ON";
    } else {
      onUnsupportedCoolant(coolant);
      m = "COOLANT_OFF";
      break;
    }
    break;
  case COOLANT_AIR:
    if (getProperty("extendedCoolants")) {
      setCoolant(COOLANT_OFF);
      m = "COOLANT ON";
    } else {
      onUnsupportedCoolant(coolant);
      m = "COOLANT_OFF";
      break;
    }
    break;
  default:
    onUnsupportedCoolant(coolant);
    m = "COOLANT OFF";
  }

  if (m) {
    writeBlock(m);
    currentCoolantMode = coolant;
  }
}

function setWorkPlane(abc) {
  if (!machineConfiguration.isMultiAxisConfiguration()) {
    return; // ignore
  }

  if (!((currentWorkPlaneABC == undefined) ||
        abcFormat.areDifferent(abc.x, currentWorkPlaneABC.x) ||
        abcFormat.areDifferent(abc.y, currentWorkPlaneABC.y) ||
        abcFormat.areDifferent(abc.z, currentWorkPlaneABC.z))) {
    return; // no change
  }

  onCommand(COMMAND_UNLOCK_MULTI_AXIS);

  // NOTE: add retract here

  writeBlock(
    "FASTABS",
    conditional(machineConfiguration.isMachineCoordinate(0), "A" + abcFormat.format(abc.x)),
    conditional(machineConfiguration.isMachineCoordinate(1), "B" + abcFormat.format(abc.y)),
    conditional(machineConfiguration.isMachineCoordinate(2), "C" + abcFormat.format(abc.z))
  );

  onCommand(COMMAND_LOCK_MULTI_AXIS);

  currentWorkPlaneABC = abc;
}

var closestABC = false; // choose closest machine angles
var currentMachineABC;

function getWorkPlaneMachineABC(workPlane) {
  var W = workPlane; // map to global frame

  var abc = machineConfiguration.getABC(W);
  if (closestABC) {
    if (currentMachineABC) {
      abc = machineConfiguration.remapToABC(abc, currentMachineABC);
    } else {
      abc = machineConfiguration.getPreferredABC(abc);
    }
  } else {
    abc = machineConfiguration.getPreferredABC(abc);
  }

  try {
    abc = machineConfiguration.remapABC(abc);
    currentMachineABC = abc;
  } catch (e) {
    error(
      localize("Machine angles not supported") + ":"
      + conditional(machineConfiguration.isMachineCoordinate(0), " A" + abcFormat.format(abc.x))
      + conditional(machineConfiguration.isMachineCoordinate(1), " B" + abcFormat.format(abc.y))
      + conditional(machineConfiguration.isMachineCoordinate(2), " C" + abcFormat.format(abc.z))
    );
  }

  var direction = machineConfiguration.getDirection(abc);
  if (!isSameDirection(direction, W.forward)) {
    error(localize("Orientation not supported."));
  }

  if (!machineConfiguration.isABCSupported(abc)) {
    error(
      localize("Work plane is not supported") + ":"
      + conditional(machineConfiguration.isMachineCoordinate(0), " A" + abcFormat.format(abc.x))
      + conditional(machineConfiguration.isMachineCoordinate(1), " B" + abcFormat.format(abc.y))
      + conditional(machineConfiguration.isMachineCoordinate(2), " C" + abcFormat.format(abc.z))
    );
  }

  var tcp = false;
  if (tcp) {
    setRotation(W); // TCP mode
  } else {
    var O = machineConfiguration.getOrientation(abc);
    var R = machineConfiguration.getRemainingOrientation(abc, W);
    setRotation(R);
  }

  return abc;
}

function writeWCS() {
  // wcs
  if (currentSection.workOffset > 0) {
    writeBlock("WPREG" + currentSection.workOffset + "ACT");
  } else {
    writeBlock("WPZERO STANDARD");
  }
}

function onSection() {
  var insertToolCall = isFirstSection() ||
    currentSection.getForceToolChange && currentSection.getForceToolChange() ||
    (tool.number != getPreviousSection().getTool().number);

  retracted = false; // specifies that the tool has been retracted to the safe plane
  var newWorkOffset = isFirstSection() ||
    (getPreviousSection().workOffset != currentSection.workOffset); // work offset changes
  var newWorkPlane = isFirstSection() ||
    !isSameDirection(getPreviousSection().getGlobalFinalToolAxis(), currentSection.getGlobalInitialToolAxis());
  if (newWorkOffset || newWorkPlane) {
    // retract to safe plane
    writeRetract(Z);
    if (getProperty("safePositionMethod") == "clearanceHeight") {
      writeWCS();
    }
  }

  if (hasParameter("operation-comment")) {
    var comment = getParameter("operation-comment");
    if (comment) {
      writeComment(comment);
    }
  }

  if (insertToolCall) {
    forceWorkPlane();
    onCommand(COMMAND_COOLANT_OFF);
    if (!isFirstSection()) {
      writeBlock("SPINDLE", "OFF");
    }
    /*
    if (!isFirstSection() && getProperty("optionalStop")) {
      onCommand(COMMAND_OPTIONAL_STOP);
    }
*/

    if (tool.number > 99) {
      warning(localize("Tool number exceeds maximum value."));
    }

    writeBlock("GETTOOL", toolFormat.format(tool.number));
    if (tool.comment) {
      writeComment(tool.comment);
    }
  }

  if (insertToolCall ||
      isFirstSection() ||
      (rpmFormat.areDifferent(spindleSpeed, lastSpindleSpeed)) ||
      (tool.clockwise != getPreviousSection().getTool().clockwise)) {
    if (spindleSpeed < 1) {
      error(localize("Spindle speed out of range."));
    }
    if (spindleSpeed > 99999) {
      warning(localize("Spindle speed exceeds maximum value."));
    }
    // SCLW / SCCLW
    writeBlock("SPINDLE", (tool.clockwise ? "CW" : "CCW"), "RPM" + rpmFormat.format(spindleSpeed));
    lastSpindleSpeed = spindleSpeed;
  }

  // wcs
  if (currentSection.workOffset > 0) {
    // warning(localize("Ignoring work offset."));
    if (currentSection.workOffset > 8) {
      error(localize("Work offset out of range."));
    } else {
      // output above
      // writeBlock("WPREG" + currentSection.workOffset + "ACT");
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

  forceAny();

  var initialPosition = getFramePosition(currentSection.getInitialPosition());
  if (!retracted && !insertToolCall) {
    if (getCurrentPosition().z < initialPosition.z) {
      writeBlock("FASTABS", zOutput.format(toUM(initialPosition.z)));
    }
  }

  var x = xOutput.format(toUM(initialPosition.x));
  var y = yOutput.format(toUM(initialPosition.y));
  var z = zOutput.format(toUM(initialPosition.z));
  if (!machineConfiguration.isHeadConfiguration()) {
    if (x || y) {
      writeBlock("FASTABS", x, y);
    }
    // handle length offset
    if (z) {
      writeBlock("FASTABS", z);
    }
  } else {
    if (x || y || z) {
      writeBlock("FASTABS", x, y, z);
    }
  }
  setCoolant(tool.coolant);
}

function onSpindleSpeed(spindleSpeed) {
  writeBlock("SPINDLE", (tool.clockwise ? "CW" : "CCW"), "RPM" + rpmFormat.format(spindleSpeed));
  lastSpindleSpeed = spindleSpeed;
}

function onDwell(seconds) {
  if (seconds > 99999.999) {
    warning(localize("Dwelling time is out of range."));
  }
  milliseconds = clamp(1, seconds * 1000, 99999999);
  writeBlock("WAIT", milliFormat.format(milliseconds));
}

function onCycle() {
  // go to the initial retract level
  if (!getProperty("forceCycleExpansion")) {
    writeBlock("FASTABS", zOutput.format(toUM(cycle.clearance)));
  }
}

function onCyclePoint(x, y, z) {
  if (!isSameDirection(getRotation().forward, new Vector(0, 0, 1))) {
    expandCyclePoint(x, y, z);
    return;
  }
  if (getProperty("forceCycleExpansion")) {
    expandCyclePoint(x, y, z);
    return;
  }

  if (isFirstCyclePoint()) {

    var F = cycle.feedrate;
    var P = !cycle.dwell ? 0 : clamp(1, cycle.dwell * 1000, 99999999); // in milliseconds

    switch (cycleType) {
    case "drilling":
    case "counter-boring":
      writeBlock(
        "DRILLDEF", "C1",
        "P" + xyzFormat.format(toUM(cycle.stock)), // um
        "D" + xyzFormat.format(cycle.depth), // mm - positive is down
        "T" + milliFormat.format(cycle.dwell * 1000), // ms
        "V" + feedFormat.format(toVel(F)), // mm/s
        "L" + xyzFormat.format(cycle.clearance) // mm
      );
      break;
    case "chip-breaking":
      if (cycle.accumulatedDepth < cycle.depth) {
        expandCyclePoint(x, y, z);
      } else {
        writeBlock(
          "DRILLDEF", "C2",
          "P" + xyzFormat.format(toUM(cycle.stock)), // um
          "D" + xyzFormat.format(cycle.depth), // mm - positive is down
          "T" + milliFormat.format(cycle.dwell * 1000), // ms
          "V" + feedFormat.format(toVel(F)), // mm/s
          "L" + xyzFormat.format(cycle.clearance), // mm
          "F" + xyzFormat.format(cycle.incrementalDepth), // mm
          "O" + xyzFormat.format(cycle.incrementalDepth), // mm
          "I" + xyzFormat.format(0) // mm
        );
      }
      break;
    case "deep-drilling":
      writeBlock(
        "DRILLDEF", "C2",
        "P" + xyzFormat.format(toUM(cycle.stock)), // um
        "D" + xyzFormat.format(cycle.depth), // mm - positive is down
        "T" + milliFormat.format(cycle.dwell * 1000), // ms
        "V" + feedFormat.format(toVel(F)), // mm/s
        "L" + xyzFormat.format(cycle.clearance), // mm
        "F" + xyzFormat.format(cycle.incrementalDepth), // mm
        "O" + xyzFormat.format(cycle.incrementalDepth), // mm
        "I" + xyzFormat.format(0) // mm
      );
      break;
    case "tapping":
    case "left-tapping":
    case "right-tapping":
    case "fine-boring":
    case "back-boring":
    case "reaming":
    case "stop-boring":
    case "manual-boring":
    case "boring":
    default:
      expandCyclePoint(x, y, z);
    }
  } else {
    if (cycleExpanded) {
      expandCyclePoint(x, y, z);
    } else {
      var _x = xOutput.format(toUM(x));
      var _y = yOutput.format(toUM(y));
      if (_x || _y) {
        writeBlock("DRILL", _x, _y);
      }
    }
  }
}

function onCycleEnd() {
  zOutput.reset();
}

function onRadiusCompensation() {
  if (radiusCompensation != RADIUS_COMPENSATION_OFF) {
    error(localize("Radius compensation in the controller is not supported."));
  }
}

function onRapid(_x, _y, _z) {
  var x = xOutput.format(toUM(_x));
  var y = yOutput.format(toUM(_y));
  var z = zOutput.format(toUM(_z));
  if (x || y || z) {
    writeBlock("FASTABS", x, y, z);
    feedOutput.reset();
  }
}

function onLinear(_x, _y, _z, feed) {
  var x = xOutput.format(toUM(_x));
  var y = yOutput.format(toUM(_y));
  var z = zOutput.format(toUM(_z));
  var vel = feedOutput.format(toVel(feed));
  if (vel) {
    writeBlock("VEL", vel);
  }
  if (x || y || z) {
    writeBlock("MOVEABS", x, y, z);
  }
}

function onRapid5D(_x, _y, _z, _a, _b, _c) {
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("This post configuration has not been customized for 5-axis simultaneous toolpath."));
    return;
  }
  var x = xOutput.format(toUM(_x));
  var y = yOutput.format(toUM(_y));
  var z = zOutput.format(toUM(_z));
  var a = aOutput.format(toAS(_a));
  var b = bOutput.format(toAS(_b));
  var c = cOutput.format(toAS(_c));
  var vel = feedOutput.format(toVel(feed));
  if (x || y || z || a || b || c) {
    writeBlock("MOVEABS", x, y, z, a, b, c);
    feedOutput.reset();
  }
}

function onLinear5D(_x, _y, _z, _a, _b, _c, feed) {
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("This post configuration has not been customized for 5-axis simultaneous toolpath."));
    return;
  }
  var x = xOutput.format(toUM(_x));
  var y = yOutput.format(toUM(_y));
  var z = zOutput.format(toUM(_z));
  var a = aOutput.format(toAS(_a));
  var b = bOutput.format(toAS(_b));
  var c = cOutput.format(toAS(_c));
  var vel = feedOutput.format(toVel(feed));
  if (vel) {
    writeBlock("VEL", vel);
  }
  if (x || y || z || a || b || c) {

    writeBlock("MOVEABS", x, y, z, a, b, c);
  }
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  var vel = feedOutput.format(toVel(feed));
  if (vel) {
    writeBlock("VEL", vel);
  }

  if (isHelical()) {
    if (getProperty("useHelicalArcs")) {
      switch (getCircularPlane()) {
      case PLANE_XY:
        writePlane("XY");
        writeBlock(clockwise ? "CWHLXABS" : "CCWHLXABS", iOutput.format(toUM(cx)), jOutput.format(toUM(cy)), "W" + sweepFormat.format(getCircularSweep()), xOutput.format(toUM(x)), yOutput.format(toUM(y)), zOutput.format(toUM(z)));
        break;
      case PLANE_ZX: // note: left hand coordinate system
        writePlane("XZ");
        writeBlock(clockwise ? "CCWHLXABS" : "CWHLXABS", iOutput.format(toUM(cx)), kOutput.format(toUM(cz)), "W" + sweepFormat.format(getCircularSweep()), xOutput.format(toUM(x)), yOutput.format(toUM(y)), zOutput.format(toUM(z)));
        break;
      case PLANE_YZ:
        writePlane("YZ");
        writeBlock(clockwise ? "CWHLXABS" : "CCWHLXABS", jOutput.format(toUM(cy)), kOutput.format(toUM(cz)), "W" + sweepFormat.format(getCircularSweep()), xOutput.format(toUM(x)), yOutput.format(toUM(y)), zOutput.format(toUM(z)));
        break;
      default:
        linearize(tolerance);
      }
    } else {
      linearize(tolerance);
      return;
    }
  } else {
    switch (getCircularPlane()) {
    case PLANE_XY:
      writePlane("XY");
      writeBlock(clockwise ? "CWABS" : "CCWABS", iOutput.format(toUM(cx)), jOutput.format(toUM(cy)), xOutput.format(toUM(x)), yOutput.format(toUM(y)), zOutput.format(toUM(z)));
      break;
    case PLANE_ZX: // note: left hand coordinate system
      writePlane("XZ");
      writeBlock(clockwise ? "CCWABS" : "CWABS", iOutput.format(toUM(cx)), kOutput.format(toUM(cz)), xOutput.format(toUM(x)), yOutput.format(toUM(y)), zOutput.format(toUM(z)));
      break;
    case PLANE_YZ:
      writePlane("YZ");
      writeBlock(clockwise ? "CWABS" : "CCWABS", jOutput.format(toUM(cy)), kOutput.format(toUM(cz)), xOutput.format(toUM(x)), yOutput.format(toUM(y)), zOutput.format(toUM(z)));
      break;
    default:
      linearize(tolerance);
    }
  }
}

var mapCommand = {
  COMMAND_STOP                    : "HALT",
  COMMAND_SPINDLE_CLOCKWISE       : "SPINDLE CW",
  COMMAND_SPINDLE_COUNTERCLOCKWISE: "SPINDLE CCW",
  COMMAND_START_SPINDLE           : "SPINDLE ON",
  COMMAND_STOP_SPINDLE            : "SPINDLE OFF"
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
  case COMMAND_COOLANT_OFF:
    setCoolant(COOLANT_OFF);
    return;
  case COMMAND_COOLANT_ON:
    setCoolant(COOLANT_FLOOD);
    return;
  }

  /*
  if (command == COMMAND_START_SPINDLE) {
    writeBlock("SPINDLE", (tool.clockwise ? "CW" : "CCW"));
    return;
  }
*/
  if (command == COMMAND_STOP_SPINDLE) {
    lastSpindleSpeed = 0;
  }
  var stringId = getCommandStringId(command);
  var mcode = mapCommand[stringId];
  if (mcode != undefined) {
    writeBlock(mcode);
  } else {
    onUnsupportedCommand(command);
  }
}

function onSectionEnd() {
  forceAny();
}

/** Output block to do safe retract and/or move to home position. */
function writeRetract() {
  var words = []; // store all retracted axes in an array
  var retractAxes = new Array(false, false, false);
  var method = getProperty("safePositionMethod");
  if (method == "clearanceHeight") {
    if (!is3D()) {
      error(localize("Safe retract option 'Clearance Height' is only supported when all operations are along the setup Z-axis."));
    }
    return;
  }
  validate(arguments.length != 0, "No axis specified for writeRetract().");

  for (i in arguments) {
    retractAxes[arguments[i]] = true;
  }
  if ((retractAxes[0] || retractAxes[1]) && !retracted) { // retract Z first before moving to X/Y home
    error(localize("Retracting in X/Y is not possible without being retracted in Z."));
    return;
  }
  // special conditions
  /*
  if (retractAxes[2]) { // Z doesn't use G53
    method = "G28";
  }
  */

  // define home positions
  var _xHome;
  var _yHome;
  var _zHome;
  if (method == "G28") {
    _xHome = toPreciseUnit(0, MM);
    _yHome = toPreciseUnit(0, MM);
    _zHome = toPreciseUnit(0, MM);
  } else {
    _xHome = machineConfiguration.hasHomePositionX() ? machineConfiguration.getHomePositionX() : toPreciseUnit(0, MM);
    _yHome = machineConfiguration.hasHomePositionY() ? machineConfiguration.getHomePositionY() : toPreciseUnit(0, MM);
    _zHome = machineConfiguration.getRetractPlane() != 0 ? machineConfiguration.getRetractPlane() : toPreciseUnit(0, MM);
  }
  for (var i = 0; i < arguments.length; ++i) {
    switch (arguments[i]) {
    case X:
      words.push("X" + xyzFormat.format(toUM(_xHome)));
      xOutput.reset();
      break;
    case Y:
      words.push("Y" + xyzFormat.format(toUM(_yHome)));
      yOutput.reset();
      break;
    case Z:
      words.push("Z" + xyzFormat.format(toUM(_zHome)));
      zOutput.reset();
      retracted = true;
      break;
    default:
      error(localize("Unsupported axis specified for writeRetract()."));
      return;
    }
  }
  if (words.length > 0) {
    switch (method) {
    case "G28":
      gMotionModal.reset();
      gAbsIncModal.reset();
      writeBlock(gFormat.format(28), gAbsIncModal.format(91), words);
      writeBlock(gAbsIncModal.format(90));
      break;
    case "G53":
      gMotionModal.reset();
      writeBlock(gAbsIncModal.format(90), gFormat.format(53), gMotionModal.format(0), words);
      break;
    case "wpclear":
      writeBlock("WPCLEAR");
      writeBlock("FASTABS", words);
      writeWCS();
      break;
    default:
      error(localize("Unsupported safe position method."));
      return;
    }
  }
}

function onClose() {
  onCommand(COMMAND_COOLANT_OFF);
  writeBlock("SPINDLE", "OFF");

  setWorkPlane(new Vector(0, 0, 0)); // reset working plane

  onImpliedCommand(COMMAND_STOP_SPINDLE);
  onImpliedCommand(COMMAND_END);
  writeBlock("PROGEND");
}

function setProperty(property, value) {
  properties[property].current = value;
}
