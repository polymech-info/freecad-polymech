/**
  Copyright (C) 2012-2017 by Autodesk, Inc.
  All rights reserved.

  JavaScript Object Notation post processor configuration.

  $Revision: 43569 147f5cf60e9217cf9c3365dc511a0f631d89bb16 $
  $Date: 2021-10-13 13:53:32 $

  FORKID {6F22B39A-3B1F-4cc7-A048-75950D66719F}
*/

description = "JSON JavaScript Object Notation";
vendor = "Autodesk";
vendorUrl = "http://www.autodesk.com";
legal = "Copyright (C) 2012-2017 by Autodesk, Inc.";
certificationLevel = 2;

longDescription = "Example post demonstrating how to export the program in the JSON (JavaScript Object Notation) format.";

unit = ORIGINAL_UNIT; // do not map unit
capabilities = CAPABILITY_INTERMEDIATE;
extension = "json";
setCodePage("utf-8");

properties = {
};

allowHelicalMoves = true;
allowedCircularPlanes = undefined; // allow any circular motion

/** Map spatial coordinate. */
function f(value) {
  return Math.round(value * 1000000) / 1000000;
}

/** Map feedrate. */
function ff(value) {
  return Math.round(value * 1000000) / 1000000;
}

/** Map vector coordinate. */
function nf(value) {
  return Math.round(value * 1000000000) / 1000000000;
}

/** Map angle. */
function af(value) {
  return Math.round(value * 180 / Math.PI * 1000000) / 1000000;
}

/** Map time in seconds. */
function sf(value) {
  return Math.round(value * 1000000) / 1000000;
}

/** Map spindle speed. */
function rpmf(value) {
  return Math.round(value * 1000000) / 1000000;
}

/** Map spatial vector. */
function toVector(x, y, z) {
  return [f(x), f(y), f(z)];
}

/** Map vector. */
function toNVector(x, y, z) {
  return [nf(x), nf(y), nf(z)];
}

function onOpen() {
  var program = {};
  program.type = "hsm";
  program.version = 1;
  program.unit = (unit == IN) ? "in" : "mm";

  if (programName) {
    program.name = programName;
  }
  if (programComment) {
    program.comment = programComment;
  }

  var output = JSON.stringify(program);
  output = output.substr(0, output.length - 1); // remove ending } since we write that in onClose()
  write(output);

  write(",\"toolpath\":["); // start of toolpath
}

var first = true;

/** Writes the given map to the current section. */
function push(v) {
  if (!first) {
    write(",");
  }
  first = false;
  write(JSON.stringify(v));
}

function onComment(comment) {
  if (comment) {
    push({comment:comment});
  }
}

function onCommand(command) {
  switch (command) {
  case COMMAND_STOP:
    push({command:"stop"});
    break;
  case COMMAND_OPTIONAL_STOP:
    push({command:"optional stop"});
    break;
  case COMMAND_SPINDLE_CLOCKWISE:
    push({spindle:{direction:"cw"}});
    break;
  case COMMAND_SPINDLE_COUNTERCLOCKWISE:
    push({spindle:{direction:"ccw"}});
    break;
  case COMMAND_START_SPINDLE:
    push({spindle:{power:"on"}});
    break;
  case COMMAND_STOP_SPINDLE:
    push({spindle:{power:"off"}});
    break;
  case COMMAND_ORIENTATE_SPINDLE:
    push({spindle:{orientation:0}});
    break;
  case COMMAND_COOLANT_ON:
    push({coolant:{active:true}});
    break;
  case COMMAND_COOLANT_OFF:
    push({coolant:{active:false}});
    break;
  case COMMAND_START_CHIP_TRANSPORT:
    push({command:"start chip transport"});
    break;
  case COMMAND_STOP_CHIP_TRANSPORT:
    push({command:"stop chip transport"});
    break;
  case COMMAND_OPEN_DOOR:
    push({command:"open door"});
    break;
  case COMMAND_CLOSE_DOOR:
    push({command:"close door"});
    break;
  case COMMAND_CALIBRATE:
    push({command:"calibrate"});
    break;
  case COMMAND_VERIFY:
    push({command:"verify"});
    break;
  case COMMAND_CLEAN:
    push({command:"clean"});
    break;
  case COMMAND_ALARM:
    push({command:"alarm"});
    break;
  case COMMAND_ALERT:
    push({command:"alert"});
    break;
  default:
    warning(localize("Unsupported command."));
  }
}

var currentCoolant;

function setCoolant(coolant) {
  if (currentCoolant == coolant) {
    return;
  }
  push({coolant:{active:(coolant != COOLANT_OFF)}});
  switch (coolant) {
  case COOLANT_OFF:
    break;
  case COOLANT_FLOOD:
    push({coolant:{mode:"flood"}});
    break;
  case COOLANT_MIST:
    push({coolant:{mode:"mist"}});
    break;
  case COOLANT_THROUGH_TOOL:
    push({coolant:{mode:"through tool"}});
    break;
  case COOLANT_AIR:
    push({coolant:{mode:"air"}});
    break;
  case COOLANT_AIR_THROUGH_TOOL:
    push({coolant:{mode:"air through tool"}});
    break;
  case COOLANT_SUCTION:
    push({coolant:{mode:"suction"}});
    break;
  case COOLANT_FLOOD_MIST:
    push({coolant:{mode:"flood mist"}});
    break;
  case COOLANT_FLOOD_THROUGH_TOOL:
    push({coolant:{mode:"flood through tool"}});
    break;
  default:
    warning(localize("Unsupported coolant."));
  }
}

function onCoolant(coolant) {
  setCoolant(coolant);
}

function onPassThrough(text) {
  push({passThrough:{data:text}});
}

var probeOutputWorkOffset = 1;

function onParameter(name, value) {
  if (name == "probe-output-work-offset") {
    probeOutputWorkOffset = (value > 0) ? value : 1;
  }

  /*
  if (getCurrentSectionId() > 0) {
    return;
  }
*/

  if (typeof value == "number") {
    push({p:{name:name, value:nf(value)}});
  } else {
    push({p:{name:name, value:value}});
  }
}

function onSection() {
  currentFeed = undefined;

  var _section = {};

  _section.jobId = currentSection.getJobId();
  _section.patternId = currentSection.getPatternId();
  // future _section.channel = currentSection.getChannel();
  if (currentSection.getForceToolChange()) {
    _section.forceToolChange = currentSection.getForceToolChange();
  }
  if (currentSection.isOptional()) {
    _section.optional = currentSection.isOptional();
  }

  switch (currentSection.getType()) {
  case TYPE_MILLING:
    _section.type = "milling";
    break;
  case TYPE_TURNING:
    _section.type = "turning";
    break;
  case TYPE_WIRE:
    _section.type = "wire";
    break;
  case TYPE_JET:
    _section.type = "cutting";

    if (currentSection.getQuality()) {
      _section.quality = currentSection.getQuality();
    }

    switch (currentSection.getJetMode()) {
    case JET_MODE_THROUGH:
      _section.jetMode = "through";
      break;
    case JET_MODE_ETCHING:
      _section.jetMode = "etch";
      break;
    case JET_MODE_VAPORIZE:
      _section.jetMode = "vaporize";
      break;
    default:
      error(localize("Unsupported cutting mode."));
      return;
    }

    break;
  default:
    error(localize("Unsupported section type."));
    return;
  }

  if ((currentSection.getType() == TYPE_MILLING) || (currentSection.getType() == TYPE_TURNING)) {
    if (currentSection.getTailstock()) {
      _section.tailstock = currentSection.getTailstock();
    }
    if (currentSection.getPartCatcher()) {
      _section.partCatcher = currentSection.getPartCatcher();
    }
    _section.spindle = currentSection.getSpindle();
    switch (currentSection.getFeedMode()) {
    case FEED_PER_MINUTE:
      _section.feedMode = "per min";
      break;
    case FEED_PER_REVOLUTION:
      _section.feedMode = "per rev";
      break;
    default:
      error(localize("Invalid feed mode."));
      return;
    }
    if (currentSection.getToolOrientation() != 0) {
      _section.toolOrientation = af(currentSection.getToolOrientation()); // B-axis support
    }
    if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
      _section.constantSurfaceSpeed = true;
    }
  }

  var _tool = {};
  if (tool.type == TOOL_WIRE) {
    _tool.type = "wire";
    _tool.diameter = f(tool.diameter);

  } else if (tool.isJetTool()) { // cutting
    _tool.type = "jet";
    _tool.number = tool.number;
    _tool.lengthOffset = tool.lengthOffset;
    _tool.diameterOffset = tool.diameterOffset;
    _tool.diameter = f(tool.jetDiameter);
    _tool.distance = f(tool.jetDistance);

    switch (tool.type) {
    case TOOL_WATER_JET:
      _tool.type = "waterjet";
      break;
    case TOOL_LASER_CUTTER:
      _tool.type = "laser";
      break;
    case TOOL_WELDER:
      _tool.type = "welder";
      break;
    case TOOL_PLASMA_CUTTER:
      _tool.type = "plasma";
      break;
    case TOOL_MARKER:
      _tool.type = "marker";
      break;
    default:
      error(localize("Unsupported tool type."));
      return;
    }

  } else if (tool.isTurningTool()) { // turning
    _tool.type = "turn";

    var insertDescriptions = [
      "custom", "iso a", "iso b", "iso c", "iso d", "iso e", "iso h", "iso k", "iso l", "iso m", "iso o", "iso p", "iso r", "iso s", "iso t", "iso v", "iso w",
      "round", "radius", "square", "chamfer", "40deg",
      "iso double", "iso triple", "uts double", "uts triple", "iso double v", "iso triple v", "uts double v", "uts triple v"
    ];

    var holderDescriptions = [
      "none", "iso a", "iso b", "iso c", "iso d", "iso e", "iso f", "iso g", "iso h", "iso j", "iso k", "iso l", "iso m", "iso n", "iso p", "iso q", "iso r", "iso s", "iso t", "iso u", "iso v", "iso w", "iso y", "offset", "straight",
      "external", "internal", "face",
      "straight", "offset", "face",
      "boring bar iso f", "boring bar iso g", "boring bar iso j", "boring bar iso k", "boring bar iso l", "boring bar iso p", "boring bar iso q", "boring bar iso s", "boring bar iso u", "boring bar iso w", "boring bar iso y", "boring bar iso x"
    ];

    switch (tool.type) {
    case TOOL_TURNING_GENERAL:
      _tool.type = "general";
      break;
    case TOOL_TURNING_THREADING:
      _tool.type = "thread";
      break;
    case TOOL_TURNING_GROOVING:
      _tool.type = "groove";
      break;
    case TOOL_TURNING_BORING:
      _tool.type = "boring";
      break;
    case TOOL_TURNING_CUSTOM:
      _tool.type = "custom";
      break;
    default:
      error(localize("Unsupported tool type."));
      return;
    }

    _tool.number = tool.number;
    _tool.insertType = insertDescriptions[tool.insertType];
    _tool.holderType = holderDescriptions[tool.holderType];
    _tool.compensationOffset = tool.compensationOffset;
    _tool.secondaryCompensationOffset = tool.secondaryCompensationOffset;
    if (tool.inscribedCircleDiameter > 0) {
      _tool.diameter = f(tool.inscribedCircleDiameter);
    }
    if (tool.grooveWidth > 0) {
      _tool.grooveWidth = f(tool.grooveWidth);
    }
    _tool.noseRadius = f(tool.noseRadius);
    _tool.reliefAngle = af(tool.reliefAngle);
    _tool.thickness = tool.thickness;
    _tool.crossSection = tool.crossSection;
    _tool.tolerance = tool.tolerance;
    _tool.hand = tool.hand;
    _tool.clamping = tool.clamping;
    if (tool.turret) {
      _tool.turret = tool.turret;
    }
  } else { // mill/drill

    switch (tool.type) {
    case TOOL_DRILL:
      _tool.type = "drill";
      break;
    case TOOL_DRILL_CENTER:
      _tool.type = "center drill";
      break;
    case TOOL_DRILL_SPOT:
      _tool.type = "spot drill";
      break;
    case TOOL_DRILL_BLOCK:
      _tool.type = "block drill";
      break;
    case TOOL_COUNTER_BORE:
      _tool.type = "counterbore";
      break;
    case TOOL_COUNTER_SINK:
      _tool.type = "countersink";
      break;
    case TOOL_TAP_RIGHT_HAND:
      _tool.type = "right tap";
      break;
    case TOOL_TAP_LEFT_HAND:
      _tool.type = "left tap";
      break;
    case TOOL_REAMER:
      _tool.type = "reamer";
      break;
    case TOOL_BORING_BAR:
      _tool.type = "boring bar";
      break;

    case TOOL_MILLING_END_FLAT:
      _tool.type = "flat mill";
      break;
    case TOOL_MILLING_END_BALL:
      _tool.type = "ball mill";
      break;
    case TOOL_MILLING_END_BULLNOSE:
      _tool.type = "bullnose mill";
      break;
    case TOOL_MILLING_CHAMFER:
      _tool.type = "chamfer mill";
      break;
    case TOOL_MILLING_FACE:
      _tool.type = "face mill";
      break;
    case TOOL_MILLING_SLOT:
      _tool.type = "slot mill";
      break;
    case TOOL_MILLING_RADIUS:
      _tool.type = "radius mill";
      break;
    case TOOL_MILLING_DOVETAIL:
      _tool.type = "dovetail mill";
      break;
    case TOOL_MILLING_TAPERED:
      _tool.type = "tapered mill";
      break;
    case TOOL_MILLING_LOLLIPOP:
      _tool.type = "lollipop mill";
      break;
    case TOOL_MILLING_FORM:
      _tool.type = "form mill";
      break;
    case TOOL_MILLING_THREAD:
      _tool.type = "thread mill";
      break;

    case TOOL_HOLDER_ONLY:
      _tool.type = "holder";
      break;
    case TOOL_PROBE:
      _tool.type = "probe";
      break;

    default:
      error(localize("Unsupported tool type."));
      return;
    }

    _tool.number = tool.number;
    _tool.lengthOffset = tool.lengthOffset;
    _tool.diameterOffset = tool.diameterOffset;
    _tool.diameter = f(tool.diameter);
    _tool.cornerRadius = f(tool.cornerRadius);
    _tool.tipDiameter = f(tool.tipDiameter);
    if (tool.taperAngle != 0) {
      _tool.taperAngle = af(tool.taperAngle);
    }
    _tool.fluteLength = f(tool.fluteLength);
    _tool.bodyLength = f(tool.bodyLength);

    if (tool.turret) {
      _tool.turret = tool.turret;
    }
    _tool.live = tool.isLiveTool();
  }

  if (tool.getManualToolChange()) {
    _tool.manualToolChange = tool.getManualToolChange();
  }
  if (tool.getBreakControl()) {
    _tool.breakControl = tool.getBreakControl();
  }

  _section.tool = _tool;

  _section.wcs = {
    right  : toNVector(currentSection.wcsPlane.right.x, currentSection.wcsPlane.right.y, currentSection.wcsPlane.right.z),
    up     : toNVector(currentSection.wcsPlane.up.x, currentSection.wcsPlane.up.y, currentSection.wcsPlane.up.z),
    forward: toNVector(currentSection.wcsPlane.forward.x, currentSection.wcsPlane.forward.y, currentSection.wcsPlane.forward.z),
    origin : toVector(currentSection.wcsOrigin.x, currentSection.wcsOrigin.y, currentSection.wcsOrigin.z)
  };

  _section.fcs = {
    right  : toNVector(currentSection.fcsPlane.right.x, currentSection.fcsPlane.right.y, currentSection.fcsPlane.right.z),
    up     : toNVector(currentSection.fcsPlane.up.x, currentSection.fcsPlane.up.y, currentSection.fcsPlane.up.z),
    forward: toNVector(currentSection.fcsPlane.forward.x, currentSection.fcsPlane.forward.y, currentSection.fcsPlane.forward.z),
    origin : toVector(currentSection.fcsOrigin.x, currentSection.fcsOrigin.y, currentSection.fcsOrigin.z)
  };

  _section.work = {
    right  : toNVector(currentSection.workPlane.right.x, currentSection.workPlane.right.y, currentSection.workPlane.right.z),
    up     : toNVector(currentSection.workPlane.up.x, currentSection.workPlane.up.y, currentSection.workPlane.up.z),
    forward: toNVector(currentSection.workPlane.forward.x, currentSection.workPlane.forward.y, currentSection.workPlane.forward.z),
    origin : toVector(currentSection.workOrigin.x, currentSection.workOrigin.y, currentSection.workOrigin.z)
  };

  _section.workOffset = currentSection.workOffset;
  if (currentSection.hasDynamicWorkOffset()) {
    _section.dynamicWorkOffset = currentSection.getDynamicWorkOffset();
  }

  if ((currentSection.type == TYPE_MILLING) || (currentSection.type == TYPE_TURNING)) {
    _section.spindle = {speed:rpmf(tool.spindleRPM), direction:(tool.clockwise ? "cw" : "ccw")};
  }

  push({section:_section});

  currentCoolant = undefined; // force coolant
  setCoolant(tool.coolant);
}

function onDwell(seconds) {
  push({dwell:{time:sf(seconds)}}); // in seconds
}

function onRadiusCompensation() {
  switch (radiusCompensation) {
  case RADIUS_COMPENSATION_OFF:
    push({cutterCompensation:{mode:"center"}});
    break;
  case RADIUS_COMPENSATION_LEFT:
    push({cutterCompensation:{mode:"left"}});
    break;
  case RADIUS_COMPENSATION_RIGHT:
    push({cutterCompensation:{mode:"right"}});
    break;
  }
}

function onSpindleSpeed(spindleSpeed) {
  push({rpm:rpmf(spindleSpeed)});
}

var currentFeed;

function onFeedrate(feed) {
  if (currentFeed != feed) {
    currentFeed = feed;
    if (feed >= 0) {
      push({f:ff(feed)});
    } else {
      push({f:"fast"}); // rapid
    }
  }
}

function onPower(_power) {
  push({power:_power});
}

function onRapid(x, y, z) {
  // onFeedrate(-1);
  push({lf:toVector(x, y, z)});
}

function onLinear(x, y, z, feed) {
  onFeedrate(feed);
  push({l:toVector(x, y, z)});
}

function onRapid5D(x, y, z, dx, dy, dz) {
  // onFeedrate(-1);
  push({mf:{e:toVector(x, y, z), z:toNVector(dx, dy, dz)}});
}

function onLinear5D(x, y, z, dx, dy, dz, feed) {
  onFeedrate(feed);
  push({m:{e:toVector(x, y, z), z:toNVector(dx, dy, dz)}});
  // future push({m:{e:toVector(x, y, z), z:toNVector(dx, dy, dz), x:toNVector(xx, xy, xz)}});
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  onFeedrate(feed);
  var n = getCircularNormal();
  if (clockwise) {
    n = Vector.product(n, -1);
  }
  push(
    {c:{e:toVector(x, y, z), c:toVector(cx, cy, cz), n:toVector(n.x, n.y, n.z), a:af(getCircularSweep())}}
  );
}

var cannedCycle;

function onCycle() {

  cannedCycle = {};
  cannedCycle.clearance = f(cycle.clearance);
  cannedCycle.retract = f(cycle.retract);
  if (cycle.stock !== undefined) {
    cannedCycle.stock = f(cycle.stock);
  }
  if (cycle.depth !== undefined) {
    cannedCycle.depth = f(cycle.depth);
  }
  if (cycle.feedrate !== undefined) {
    cannedCycle.feedrate = ff(cycle.feedrate);
  }
  if (cycle.retractFeedrate !== undefined) {
    cannedCycle.retractFeedrate = ff(cycle.retractFeedrate);
  }
  if (cycle.dwell !== undefined) {
    cannedCycle.dwell = sf(cycle.dwell);
  }
  if (cycle.dwellTop !== undefined) {
    cannedCycle.dwellTop = sf(cycle.dwellTop);
  }
  if (cycle.incrementalDepth !== undefined) {
    cannedCycle.incrementalDepth = f(cycle.incrementalDepth);
  }
  if (cycle.incrementalDepthReduction !== undefined) {
    cannedCycle.incrementalDepthReduction = f(cycle.incrementalDepthReduction);
  }
  if (cycle.minimumIncrementalDepth !== undefined) {
    cannedCycle.minimumIncrementalDepth = f(cycle.minimumIncrementalDepth);
  }
  if (cycle.accumulatedDepth !== undefined) {
    cannedCycle.accumulatedDepth = f(cycle.accumulatedDepth);
  }
  if (cycle.chipBreakDistance !== undefined) {
    cannedCycle.chipBreakDistance = f(cycle.chipBreakDistance);
  }
  if (cycle.shift !== undefined) {
    cannedCycle.shift = f(cycle.shift);
  }
  if (cycle.shiftOrientation !== undefined) {
    cannedCycle.shiftOrientation = af(cycle.shiftOrientation);
  }
  if (cycle.backBoreDistance !== undefined) {
    cannedCycle.backBoreDistance = f(cycle.backBoreDistance);
  }
  if (cycle.dwellBeforeRetract !== undefined) {
    cannedCycle.dwellBeforeRetract = cycle.dwellBeforeRetract;
  }

  switch (cycleType) {
  case "drilling":
    cannedCycle.type = "drilling";
    break;
  case "counter-boring":
    cannedCycle.type = "counter-boring";
    break;
  case "chip-breaking":
    cannedCycle.type = "chip-breaking";
    break;
  case "deep-drilling":
    cannedCycle.type = "deep-drilling";
    break;
  case "break-through-drilling":
    cannedCycle.type = "break-through-drilling";
    break;

  case "tapping":
  case "left-tapping":
  case "right-tapping":
    cannedCycle.type = "tapping";
    break;
  case "tapping-with-chip-breaking":
  case "left-tapping-with-chip-breaking":
  case "right-tapping-with-chip-breaking":
    cannedCycle.type = "tapping-with-chip-breaking";
    break;

  case "reaming":
    cannedCycle.type = "reaming";
    break;
  case "boring":
    cannedCycle.type = "boring";
    break;
  case "stop-boring":
    cannedCycle.type = "stop-boring";
    break;
  case "fine-boring":
    cannedCycle.type = "fine-boring";
    break;
  case "back-boring":
    cannedCycle.type = "back-boring";
    break;
  case "manual-boring":
    cannedCycle.type = "manual-boring";
    break;

  case "probe": // legacy
    error(localize("Unsupported canned cycle."));
    break;

  case "probing-x":
  case "probing-y":
  case "probing-z":
  case "probing-x-channel":
  case "probing-x-channel-not-symmetric":
  case "probing-x-channel-with-island":
  case "probing-x-wall":
  case "probing-x-wall-not-symmetric":
  case "probing-y-channel":
  case "probing-y-channel-not-symmetric":
  case "probing-y-channel-with-island":
  case "probing-y-wall":
  case "probing-y-wall-not-symmetric":
  case "probing-xy-inner-corner":
  case "probing-xy-outer-corner":
  case "probing-xy-circular-hole":
  case "probing-xy-circular-hole-with-island":
  case "probing-xy-circular-boss":
  case "probing-xy-circular-hole-with-z":
  case "probing-xy-circular-hole-island-with-z":
  case "probing-xy-circular-boss-with-z":
  case "probing-xy-rectangular-hole":
  case "probing-xy-rectangular-hole-with-island":
  case "probing-xy-rectangular-boss":
  case "probing-xy-rectangular-hole-with-z":
  case "probing-xy-rectangular-hole-island-with-z":
  case "probing-xy-rectangular-boss-with-z":
  case "probing-xyz-corner":
  case "probing-x-plane-angle":
  case "probing-y-plane-angle":
    cannedCycle.type = cycleType; // map IDs
    if (cycle.width1 !== undefined) {
      cannedCycle.width1 = f(cycle.width1);
    }
    if (cycle.width2 !== undefined) {
      cannedCycle.width2 = f(cycle.width2);
    }
    if (cycle.probeOvertravel !== undefined) {
      cannedCycle.probeOvertravel = f(cycle.probeOvertravel);
    }
    if (cycle.probeClearance !== undefined) {
      cannedCycle.probeClearance = f(cycle.probeClearance);
    }
    if (cycle.probeSpacing !== undefined) {
      cannedCycle.probeSpacing = f(cycle.probeSpacing);
    }
    if (cycle.probeOrientation !== undefined) {
      cannedCycle.probeOrientation = af(cycle.probeOrientation);
    }
    if (probeOutputWorkOffset !== undefined) {
      cannedCycle.probeOutputWorkOffset = probeOutputWorkOffset;
    }
    // future - add support for tool probing
    break;

    // future - add support for milling cycles

  default:
    warning(localize("Unsupported canned cycle."));
    cycleExpanded = true;
  }
}

function onCyclePoint(x, y, z) {
  if (cycleExpanded) {
    expandCyclePoint(x, y, z);
    return;
  }
  // for turning canned cycle we would use profile
  if (cannedCycle.points === undefined) {
    cannedCycle.points = [];
  }
  cannedCycle.points.push(
    {p:toVector(x, y, z)}
  );
}

function onCycleEnd() {
  if (!cycleExpanded) {
    push({cycle:cannedCycle});
  }
}

function onSectionEnd() {
}

function onClose() {
  write("]"); // end of toolpath
  write("}"); // end of map
}
