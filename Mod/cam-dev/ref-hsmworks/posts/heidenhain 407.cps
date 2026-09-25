/**
  Copyright (C) 2012-2021 by Autodesk, Inc.
  All rights reserved.

  Heidenhain post processor configuration.

  $Revision: 43654 a19c569c9f7fe055fc222095112d3f1eebc74b63 $
  $Date: 2021-12-02 09:56:05 $

  FORKID {E3B36C97-FF8E-483a-B063-3F7E73B62424}
*/

description = "Heidenhain TNC 407";
vendor = "Heidenhain";
vendorUrl = "http://www.heidenhain.com";
legal = "Copyright (C) 2012-2021 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45702;

longDescription = "Generic post for Heidenhain 407 controls.";

extension = "h";
if (getCodePage() == 932) { // shift-jis is not supported
  setCodePage("ascii");
} else {
  setCodePage("ansi"); // setCodePage("utf-8");
}

capabilities = CAPABILITY_MILLING;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(5400); // 15 revolutions
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
    value      : true,
    scope      : "post"
  },
  writeVersion: {
    title      : "Write version",
    description: "Write the version number in the header of the code.",
    group      : 0,
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  preloadTool: {
    title      : "Preload tool",
    description: "Preloads the next tool at a tool change (if any).",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  expandCycles: {
    title      : "Expand cycles",
    description: "If enabled, unhandled cycles are expanded.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  useRigidTapping: {
    title      : "Use rigid tapping",
    description: "Enable to allow rigid tapping.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  optionalStop: {
    title      : "Optional stop",
    description: "Outputs optional stop code during when necessary in the code.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  structureComments: {
    title      : "Structure comments",
    description: "Shows structure comments.",
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
      {title:"M91", id:"M91"},
      {title:"M92", id:"M92"}
    ],
    value: "M91",
    scope: "post"
  },
  useParametricFeed: {
    title      : "Parametric feed",
    description: "Specifies the feed value that should be output using a Q value.",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  homeXYAtEnd: {
    title      : "Home XY at end",
    description: "Specifies that the machine moves to the home position in XY at the end of the program.",
    type       : "boolean",
    value      : false,
    scope      : "post"
  }
};

var singleLineCoolant = false; // specifies to output multiple coolant codes in one line rather than in separate lines
// samples:
// {id: COOLANT_THROUGH_TOOL, on: 88, off: 89}
// {id: COOLANT_THROUGH_TOOL, on: [8, 88], off: [9, 89]}
// {id: COOLANT_THROUGH_TOOL, on: "M88 P3 (myComment)", off: "M89"}
var coolants = [
  {id:COOLANT_FLOOD, on:8},
  {id:COOLANT_MIST},
  {id:COOLANT_THROUGH_TOOL},
  {id:COOLANT_AIR},
  {id:COOLANT_AIR_THROUGH_TOOL},
  {id:COOLANT_SUCTION},
  {id:COOLANT_FLOOD_MIST},
  {id:COOLANT_FLOOD_THROUGH_TOOL},
  {id:COOLANT_OFF, off:9}
];

var WARNING_WORK_OFFSET = 0;

// collected state
var blockNumber = 0;
var activeMovements; // do not use by default
var workOffsetLabels = {};
var nextLabel = 1;
var retracted = false; // specifies that the tool has been retracted to the safe plane

var radiusCompensationTable = new Table(
  [" R0", " RL", " RR"],
  {initial:RADIUS_COMPENSATION_OFF},
  "Invalid radius compensation"
);

var xyzFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceSign:true});
var abcFormat = createFormat({decimals:3, forceSign:true, scale:DEG});
var feedFormat = createFormat({decimals:(unit == MM ? 0 : 2), scale:(unit == MM ? 1 : 10)});
var rpmFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:3});
var paFormat = createFormat({decimals:3, forceSign:true, scale:DEG});
var angleFormat = createFormat({decimals:0, scale:DEG});
var pitchFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceSign:true});
var mFormat = createFormat({prefix:"M", decimals:0});

// presentation formats
var spatialFormat = createFormat({decimals:(unit == MM ? 3 : 4)});
var taperFormat = angleFormat; // share format

var xOutput = createVariable({prefix:" X"}, xyzFormat);
var yOutput = createVariable({prefix:" Y"}, xyzFormat);
var zOutput = createVariable({onchange:function () {retracted = false;}, prefix:" Z"}, xyzFormat);
var aOutput = createVariable({prefix:" A"}, abcFormat);
var bOutput = createVariable({prefix:" B"}, abcFormat);
var cOutput = createVariable({prefix:" C"}, abcFormat);
var feedOutput = createVariable({prefix:" F"}, feedFormat);

// fixed settings
var closestABC = false; // choose closest machine angles

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

/**
  Writes the specified block.
*/
function writeBlock(block) {
  var text = formatWords(block);
  if (!text) {
    return;
  }
  writeln(blockNumber + SP + block);
  ++blockNumber;
}

/**
  Writes the specified block as optional.
*/
function writeOptionalBlock(block) {
  writeln("/" + blockNumber + SP + block);
  ++blockNumber;
}

/** Output a comment. */
function writeComment(text) {
  if (isTextSupported(text)) {
    writeln(blockNumber + SP + "; " + text); // some controls may require a block number
    ++blockNumber;
  }
}

/** Adds a structure comment. */
function writeStructureComment(text) {
  if (getProperty("structureComments")) {
    if (isTextSupported(text)) {
      writeBlock("* - " + text);
    }
  }
}

/** Writes a separator. */
function writeSeparator() {
  writeComment("-------------------------------------");
}

/** Writes the specified text through the data interface. */
function printData(text) {
  if (isTextSupported(text)) {
    writeln("FN15: PRINT " + text);
  }
}

function onOpen() {

  if (false) { // note: setup your machine here
    var aAxis = createAxis({coordinate:0, table:true, axis:[-1, 0, 0], range:[-30 - 0.0001, 120 + 0.0001], preference:1});
    var cAxis = createAxis({coordinate:1, table:true, axis:[0, 0, 1], range:[-999.999, 999.999], preference:0});
    machineConfiguration = new MachineConfiguration(aAxis, cAxis);

    setMachineConfiguration(machineConfiguration);
    optimizeMachineAngles2(1); // map tip mode
  }

  /*
  // NOTE: setup your home positions here
  machineConfiguration.setRetractPlane(-20.415); // home position Z
  machineConfiguration.setHomePositionX(-200); // home position X
  machineConfiguration.setHomePositionY(-5); // home position Y
*/

  if (!machineConfiguration.isMachineCoordinate(0)) {
    aOutput.disable();
  }
  if (!machineConfiguration.isMachineCoordinate(1)) {
    bOutput.disable();
  }
  if (!machineConfiguration.isMachineCoordinate(2)) {
    cOutput.disable();
  }

  writeBlock(
    "BEGIN PGM" + (programName ? (SP + programName) : "") + ((unit == MM) ? " MM" : " INCH")
  );
  if (programComment) {
    writeComment(programComment);
  }

  { // stock - workpiece
    var workpiece = getWorkpiece();
    var delta = Vector.diff(workpiece.upper, workpiece.lower);
    if (delta.isNonZero()) {
      writeBlock("BLK FORM 0.1 Z X" + xyzFormat.format(workpiece.lower.x) + " Y" + xyzFormat.format(workpiece.lower.y) + " Z" + xyzFormat.format(workpiece.lower.z));
      writeBlock("BLK FORM 0.2 X" + xyzFormat.format(workpiece.upper.x) + " Y" + xyzFormat.format(workpiece.upper.y) + " Z" + xyzFormat.format(workpiece.upper.z));
    }
  }

  if (getProperty("writeVersion")) {
    if ((typeof getHeaderVersion == "function") && getHeaderVersion()) {
      writeComment(localize("post version") + ": " + getHeaderVersion());
    }
    if ((typeof getHeaderDate == "function") && getHeaderDate()) {
      writeComment(localize("post modified") + ": " + getHeaderDate());
    }
  }

  // dump machine configuration
  var vendor = machineConfiguration.getVendor();
  var model = machineConfiguration.getModel();
  var description = machineConfiguration.getDescription();

  if (getProperty("writeMachine") && (vendor || model || description)) {
    writeSeparator();
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
    writeSeparator();
    writeComment("");
  }

  // dump tool information
  if (getProperty("writeTools")) {
    var tools = getToolTable();
    if (tools.getNumberOfTools() > 0) {
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

      writeSeparator();
      writeComment(localize("Tools"));
      for (var i = 0; i < tools.getNumberOfTools(); ++i) {
        var tool = tools.getTool(i);
        var comment = "  #" + tool.number + " " +
          localize("D") + "=" + spatialFormat.format(tool.diameter) +
          conditional(tool.cornerRadius > 0, " " + localize("CR") + "=" + spatialFormat.format(tool.cornerRadius)) +
          conditional((tool.taperAngle > 0) && (tool.taperAngle < Math.PI), " " + localize("TAPER") + "=" + taperFormat.format(tool.taperAngle) + localize("deg"));
          // conditional(tool.tipAngle > 0, " " + localize("TIP:") + "=" + taperFormat.format(tool.tipAngle) + localize("deg"));
        if (zRanges[tool.number]) {
          comment += " - " + localize("ZMIN") + "=" + xyzFormat.format(zRanges[tool.number].getMinimum());
          comment += " - " + localize("ZMAX") + "=" + xyzFormat.format(zRanges[tool.number].getMaximum());
        }
        comment += " - " + getToolTypeName(tool.type);
        writeComment(comment);
        if (tool.comment) {
          writeComment("    " + tool.comment);
        }
        if (tool.vendor) {
          writeComment("    " + tool.vendor);
        }
        if (tool.productId) {
          writeComment("    " + tool.productId);
        }
      }
      writeSeparator();
      writeComment("");
    }
  }
}

function onComment(message) {
  writeComment(message);
}

function invalidateXYZ() {
  xOutput.reset();
  yOutput.reset();
  zOutput.reset();
}

function forceFeed() {
  currentFeedId = undefined;
  feedOutput.reset();
}

/**
  Invalidates the current position and feedrate. Invoke this function to
  force X, Y, Z, A, B, C, and F in the following block.
*/
function invalidate() {
  xOutput.reset();
  yOutput.reset();
  zOutput.reset();
  aOutput.reset();
  bOutput.reset();
  cOutput.reset();
  forceFeed();
}

var currentTolerance = undefined;

function setTolerance(tolerance) {
  if (tolerance == currentTolerance) {
    return;
  }
  currentTolerance = tolerance;
}

function getSpindleAxisLetter(axis) {
  if (isSameDirection(axis, new Vector(1, 0, 0))) {
    return "X";
  } else if (isSameDirection(axis, new Vector(0, 1, 0))) {
    return "Y";
  } else if (isSameDirection(axis, new Vector(0, 0, 1))) {
    return "Z";
  } else {
    error(localize("Unsuported spindle axis."));
    return 0;
  }
}

var currentWorkPlaneABC = undefined;
var currentWorkPlaneABCTurned = false;

function forceWorkPlane() {
  currentWorkPlaneABC = undefined;
}

function positionABC(abc, force) {
  if (typeof unwindABC == "function") {
    unwindABC(abc, false);
  }
  if (force) {
    forceABC();
  }
  var a = aOutput.format(abc.x);
  var b = bOutput.format(abc.y);
  var c = cOutput.format(abc.z);
  if (a || b || c) {
    if (!retracted) {
      if (typeof moveToSafeRetractPosition == "function") {
        moveToSafeRetractPosition();
      } else {
        writeRetract(Z);
      }
    }
    onCommand(COMMAND_UNLOCK_MULTI_AXIS);
    writeBlock("L" + a + b + c + " R0 FMAX");
    currentMachineABC = new Vector(abc);
    setCurrentABC(abc); // required for machine simulation
  }
}

function setWorkPlane(abc) {
  if (is3D() && !machineConfiguration.isMultiAxisConfiguration()) {
    return; // ignore
  }

  if (!((currentWorkPlaneABC == undefined) ||
        abcFormat.areDifferent(abc.x, currentWorkPlaneABC.x) ||
        abcFormat.areDifferent(abc.y, currentWorkPlaneABC.y) ||
        abcFormat.areDifferent(abc.z, currentWorkPlaneABC.z))) {
    return; // no change
  }

  positionABC(abc, true);
  onCommand(COMMAND_LOCK_MULTI_AXIS);
  currentWorkPlaneABC = abc;
}

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

function FeedContext(id, description, feed) {
  this.id = id;
  this.description = description;
  this.feed = feed;
}

/** Maps the specified feed value to Q feed or formatted feed. */
function getFeed(f) {
  if (activeMovements) {
    var feedContext = activeMovements[movement];
    if (feedContext != undefined) {
      if (!feedFormat.areDifferent(feedContext.feed, f)) {
        if (feedContext.id == currentFeedId) {
          return ""; // nothing has changed
        }
        forceFeed();
        currentFeedId = feedContext.id;
        return " FQ" + (50 + feedContext.id);
      }
    }
    currentFeedId = undefined; // force Q feed next time
  }
  return feedOutput.format(f); // use feed value
}

function initializeActiveFeeds() {
  activeMovements = new Array();
  var movements = currentSection.getMovements();

  var id = 0;
  var activeFeeds = new Array();
  if (hasParameter("operation:tool_feedCutting")) {
    if (movements & ((1 << MOVEMENT_CUTTING) | (1 << MOVEMENT_LINK_TRANSITION) | (1 << MOVEMENT_EXTENDED))) {
      var feedContext = new FeedContext(id, localize("Cutting"), getParameter("operation:tool_feedCutting"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_CUTTING] = feedContext;
      activeMovements[MOVEMENT_LINK_TRANSITION] = feedContext;
      activeMovements[MOVEMENT_EXTENDED] = feedContext;
    }
    ++id;
    if (movements & (1 << MOVEMENT_PREDRILL)) {
      feedContext = new FeedContext(id, localize("Predrilling"), getParameter("operation:tool_feedCutting"));
      activeMovements[MOVEMENT_PREDRILL] = feedContext;
      activeFeeds.push(feedContext);
    }
    ++id;
  }

  if (hasParameter("operation:finishFeedrate")) {
    if (movements & (1 << MOVEMENT_FINISH_CUTTING)) {
      var feedContext = new FeedContext(id, localize("Finish"), getParameter("operation:finishFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_FINISH_CUTTING] = feedContext;
    }
    ++id;
  } else if (hasParameter("operation:tool_feedCutting")) {
    if (movements & (1 << MOVEMENT_FINISH_CUTTING)) {
      var feedContext = new FeedContext(id, localize("Finish"), getParameter("operation:tool_feedCutting"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_FINISH_CUTTING] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedEntry")) {
    if (movements & (1 << MOVEMENT_LEAD_IN)) {
      var feedContext = new FeedContext(id, localize("Entry"), getParameter("operation:tool_feedEntry"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LEAD_IN] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedExit")) {
    if (movements & (1 << MOVEMENT_LEAD_OUT)) {
      var feedContext = new FeedContext(id, localize("Exit"), getParameter("operation:tool_feedExit"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LEAD_OUT] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:noEngagementFeedrate")) {
    if (movements & (1 << MOVEMENT_LINK_DIRECT)) {
      var feedContext = new FeedContext(id, localize("Direct"), getParameter("operation:noEngagementFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LINK_DIRECT] = feedContext;
    }
    ++id;
  } else if (hasParameter("operation:tool_feedCutting") &&
             hasParameter("operation:tool_feedEntry") &&
             hasParameter("operation:tool_feedExit")) {
    if (movements & (1 << MOVEMENT_LINK_DIRECT)) {
      var feedContext = new FeedContext(id, localize("Direct"), Math.max(getParameter("operation:tool_feedCutting"), getParameter("operation:tool_feedEntry"), getParameter("operation:tool_feedExit")));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LINK_DIRECT] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:reducedFeedrate")) {
    if (movements & (1 << MOVEMENT_REDUCED)) {
      var feedContext = new FeedContext(id, localize("Reduced"), getParameter("operation:reducedFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_REDUCED] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedRamp")) {
    if (movements & ((1 << MOVEMENT_RAMP) | (1 << MOVEMENT_RAMP_HELIX) | (1 << MOVEMENT_RAMP_PROFILE) | (1 << MOVEMENT_RAMP_ZIG_ZAG))) {
      var feedContext = new FeedContext(id, localize("Ramping"), getParameter("operation:tool_feedRamp"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_RAMP] = feedContext;
      activeMovements[MOVEMENT_RAMP_HELIX] = feedContext;
      activeMovements[MOVEMENT_RAMP_PROFILE] = feedContext;
      activeMovements[MOVEMENT_RAMP_ZIG_ZAG] = feedContext;
    }
    ++id;
  }
  if (hasParameter("operation:tool_feedPlunge")) {
    if (movements & (1 << MOVEMENT_PLUNGE)) {
      var feedContext = new FeedContext(id, localize("Plunge"), getParameter("operation:tool_feedPlunge"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_PLUNGE] = feedContext;
    }
    ++id;
  }
  if (true) { // high feed
    if ((movements & (1 << MOVEMENT_HIGH_FEED)) || (highFeedMapping != HIGH_FEED_NO_MAPPING)) {
      var feed;
      if (hasParameter("operation:highFeedrateMode") && getParameter("operation:highFeedrateMode") != "disabled") {
        feed = getParameter("operation:highFeedrate");
      } else {
        feed = this.highFeedrate;
      }
      var feedContext = new FeedContext(id, localize("High Feed"), feed);
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_HIGH_FEED] = feedContext;
      activeMovements[MOVEMENT_RAPID] = feedContext;
    }
    ++id;
  }

  for (var i = 0; i < activeFeeds.length; ++i) {
    var feedContext = activeFeeds[i];
    writeBlock("FN0: Q" + (50 + feedContext.id) + "=" + feedFormat.format(feedContext.feed) + " ; " + feedContext.description);
  }
}

function onSection() {
  var insertToolCall = isFirstSection() ||
   (currentSection.getForceToolChange && currentSection.getForceToolChange()) ||
   (tool.number != getPreviousSection().getTool().number) ||
   (tool.clockwise != getPreviousSection().getTool().clockwise);

  if (insertToolCall) {
    setCoolant(COOLANT_OFF);
  }

  retracted = false; // specifies that the tool has been retracted to the safe plane
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

    // retract to safe plane
    writeRetract(Z);
  }

  if (hasParameter("operation-comment")) {
    var comment = getParameter("operation-comment");
    if (comment) {
      writeStructureComment(comment);
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

  if (insertToolCall) {
    forceWorkPlane();

    onCommand(COMMAND_STOP_SPINDLE);

    if (!isFirstSection() && getProperty("optionalStop")) {
      onCommand(COMMAND_STOP_CHIP_TRANSPORT);
      onCommand(COMMAND_OPTIONAL_STOP);
    }

    if (!isFirstSection()) {
      onCommand(COMMAND_BREAK_CONTROL);
    }

    if (false) {
      var zRange = currentSection.getGlobalZRange();
      var numberOfSections = getNumberOfSections();
      for (var i = getCurrentSectionId() + 1; i < numberOfSections; ++i) {
        var section = getSection(i);
        var _tool = section.getTool();
        if (_tool.number != tool.number) {
          break;
        }
        zRange.expandToRange(section.getGlobalZRange());
      }

      writeStructureComment("T" + tool.number + "-D" + spatialFormat.format(tool.diameter) + "-CR:" + spatialFormat.format(tool.cornerRadius) + "-ZMIN:" + spatialFormat.format(zRange.getMinimum()) + "-ZMAX:" + spatialFormat.format(zRange.getMaximum()));
    }

    writeBlock(
      "TOOL CALL " + tool.number + SP + getSpindleAxisLetter(machineConfiguration.getSpindleAxis()) + conditional(!isProbeOperation(), " S" + rpmFormat.format(spindleSpeed))
    );
    if (tool.comment) {
      writeComment(tool.comment);
    }

    onCommand(COMMAND_TOOL_MEASURE);

    if (getProperty("preloadTool")) {
      var nextTool = getNextTool(tool.number);
      if (nextTool) {
        writeBlock("TOOL DEF " + nextTool.number);
      } else {
        // preload first tool
        var section = getSection(0);
        var firstToolNumber = section.getTool().number;
        if (tool.number != firstToolNumber) {
          writeBlock("TOOL DEF " + firstToolNumber);
        }
      }
    }
    onCommand(COMMAND_START_CHIP_TRANSPORT);
  } else {
    if (rpmFormat.areDifferent(spindleSpeed, getPreviousSection().getInitialSpindleSpeed ? getPreviousSection().getInitialSpindleSpeed() : getPreviousSection().getTool().spindleRPM)) {
      onSpindleSpeed(spindleSpeed);
    }
  }

  onCommand(tool.clockwise ? COMMAND_SPINDLE_CLOCKWISE : COMMAND_SPINDLE_COUNTERCLOCKWISE);

  // wcs
  if (currentSection.workOffset > 0) {
    if (currentSection.workOffset > 9999) {
      error(localize("Work offset out of range."));
      return;
    }
    // datum shift after tool call
    writeBlock("CYCL DEF 7.0 " + localize("DATUM SHIFT"));
    writeBlock("CYCL DEF 7.1 #" + currentSection.workOffset);
  } else {
    // warningOnce(localize("Work offset has not been specified."), WARNING_WORK_OFFSET);
  }

  if (!is3D() || machineConfiguration.isMultiAxisConfiguration()) { // use 5-axis indexing for multi-axis mode
    var abc = new Vector(0, 0, 0);
    if (currentSection.isMultiAxis()) {
      forceWorkPlane();
      cancelTransformation();
      if (currentSection.isOptimizedForMachine()) {
        abc = currentSection.getInitialToolAxisABC();
        positionABC(abc, true);
      }
    } else {
      abc = getWorkPlaneMachineABC(currentSection.workPlane);
      setWorkPlane(abc);
    }
    radiusCompensationTable.lookup(RADIUS_COMPENSATION_OFF);
  } else { // pure 3D
    var remaining = currentSection.workPlane;
    if (!isSameDirection(remaining.forward, new Vector(0, 0, 1))) {
      error(localize("Tool orientation is not supported."));
      return;
    }
    setRotation(remaining);
    radiusCompensationTable.lookup(RADIUS_COMPENSATION_OFF);
  }

  if (!currentSection.isMultiAxis()) {
    onCommand(COMMAND_LOCK_MULTI_AXIS);
  }

  invalidate();

  var initialPosition = getFramePosition(currentSection.getInitialPosition());

  if (!retracted && !insertToolCall) {
    if (getCurrentPosition().z < initialPosition.z) {
      writeBlock("L" + zOutput.format(initialPosition.z) + " FMAX");
    }
  }

  if (!machineConfiguration.isHeadConfiguration()) {
    writeBlock("L" + xOutput.format(initialPosition.x) + yOutput.format(initialPosition.y) + " R0 FMAX");
    z = zOutput.format(initialPosition.z);
    if (z) {
      writeBlock("L" + z + " R0 FMAX");
    }
  } else {
    writeBlock("L" + xOutput.format(initialPosition.x) + yOutput.format(initialPosition.y) + zOutput.format(initialPosition.z) + " R0 FMAX");
  }

  // set coolant after we have positioned at Z
  setCoolant(tool.coolant);

  if (hasParameter("operation-strategy") && (getParameter("operation-strategy") == "drill")) {
    setTolerance(0);
  } else if (hasParameter("operation:tolerance")) {
    setTolerance(Math.max(getParameter("operation:tolerance"), 0));
  } else {
    setTolerance(0);
  }

  if (getProperty("useParametricFeed") &&
      hasParameter("operation-strategy") &&
      (getParameter("operation-strategy") != "drill") && // legacy
      !(currentSection.hasAnyCycle && currentSection.hasAnyCycle())) {
    if (!insertToolCall &&
        activeMovements &&
        (getCurrentSectionId() > 0) &&
        ((getPreviousSection().getPatternId() == currentSection.getPatternId()) && (currentSection.getPatternId() != 0))) {
      // use the current feeds
    } else {
      initializeActiveFeeds();
    }
  } else {
    activeMovements = undefined;
  }
  retracted = false;
}

function onDwell(seconds) {
  validate(seconds >= 0);
  writeBlock("CYCL DEF 9.0 " + localize("DWELL TIME"));
  writeBlock("CYCL DEF 9.1 DWELL " + secFormat.format(seconds));
}

function isProbeOperation() {
  // isProbingCycle && isProbingCycle(cycleType)
  return hasParameter("operation-strategy") && (getParameter("operation-strategy") == "probe");
}

function onParameter(name, value) {
  if (name == "operation-comment") {
    writeStructureComment(value);
  } else if (name == "operation-structure-comment") {
    writeStructureComment("  " + value);
  }
}

function onSpindleSpeed(spindleSpeed) {
  writeBlock(
    "TOOL CALL " + getSpindleAxisLetter(machineConfiguration.getSpindleAxis()) + " S" + rpmFormat.format(spindleSpeed)
  );
}

function onDrilling(cycle) {
  writeBlock("CYCL DEF 1.0 PECKING");
  writeBlock("CYCL DEF 1.1 SET UP " + xyzFormat.format(cycle.clearance - cycle.stock));
  writeBlock("CYCL DEF 1.2 DEPTH " + xyzFormat.format(-cycle.depth));
  writeBlock("CYCL DEF 1.3 PECKG " + xyzFormat.format(cycle.depth));
  writeBlock("CYCL DEF 1.4 DWELL " + secFormat.format(cycle.dwell));
  writeBlock("CYCL DEF 1.5 F" + feedFormat.format(cycle.feedrate));
}

function onCounterBoring(cycle) {
  writeBlock("CYCL DEF 1.0 PECKING");
  writeBlock("CYCL DEF 1.1 SET UP " + xyzFormat.format(cycle.clearance - cycle.stock));
  writeBlock("CYCL DEF 1.2 DEPTH " + xyzFormat.format(-cycle.depth));
  writeBlock("CYCL DEF 1.3 PECKG " + xyzFormat.format(cycle.depth));
  writeBlock("CYCL DEF 1.4 DWELL " + secFormat.format(cycle.dwell));
  writeBlock("CYCL DEF 1.5 F" + feedFormat.format(cycle.feedrate));
}

function onChipBreaking(cycle) {
  writeBlock("CYCL DEF 1.0 PECKING");
  writeBlock("CYCL DEF 1.1 SET UP " + xyzFormat.format(cycle.clearance - cycle.stock));
  writeBlock("CYCL DEF 1.2 DEPTH " + xyzFormat.format(-cycle.depth));
  writeBlock("CYCL DEF 1.3 PECKG " + xyzFormat.format(cycle.incrementalDepth));
  writeBlock("CYCL DEF 1.4 DWELL " + secFormat.format(cycle.dwell));
  writeBlock("CYCL DEF 1.5 F" + feedFormat.format(cycle.feedrate));
}

function onDeepDrilling(cycle) {
  writeBlock("CYCL DEF 1.0 PECKING");
  writeBlock("CYCL DEF 1.1 SET UP " + xyzFormat.format(cycle.clearance - cycle.stock));
  writeBlock("CYCL DEF 1.2 DEPTH " + xyzFormat.format(-cycle.depth));
  writeBlock("CYCL DEF 1.3 PECKG " + xyzFormat.format(cycle.incrementalDepth));
  writeBlock("CYCL DEF 1.4 DWELL " + secFormat.format(cycle.dwell));
  writeBlock("CYCL DEF 1.5 F" + feedFormat.format(cycle.feedrate));
}

function onLeftTapping(cycle) {
  if (getProperty("useRigidTapping")) {
    writeBlock("CYCL DEF 17.0 TAPPING");
    writeBlock("CYCL DEF 17.1 SET UP " + xyzFormat.format(cycle.clearance - cycle.stock));
    writeBlock("CYCL DEF 17.2 DEPTH " + xyzFormat.format(-cycle.depth));
    writeBlock("CYCL DEF 17.3 PITCH " + pitchFormat.format(-tool.threadPitch));
  } else {
    expandCurrentCycle = getProperty("expandCycles");
    if (!expandCurrentCycle) {
      cycleNotSupported();
    }
  }
}

function onRightTapping(cycle) {
  if (getProperty("useRigidTapping")) {
    writeBlock("CYCL DEF 17.0 TAPPING");
    writeBlock("CYCL DEF 17.1 SET UP " + xyzFormat.format(cycle.clearance - cycle.stock));
    writeBlock("CYCL DEF 17.2 DEPTH " + xyzFormat.format(-cycle.depth));
    writeBlock("CYCL DEF 17.3 PITCH " + pitchFormat.format(tool.threadPitch));
  } else {
    writeBlock("CYCL DEF 2.0 TAPPING");
    writeBlock("CYCL DEF 2.1 SET UP " + xyzFormat.format(cycle.clearance - cycle.stock));
    writeBlock("CYCL DEF 2.2 DEPTH " + xyzFormat.format(-cycle.depth));
    writeBlock("CYCL DEF 2.3 DWELL 0");
    writeBlock("CYCL DEF 2.4 F" + feedFormat.format(tool.getTappingFeedrate()));
  }
}

function onCircularPocketMilling(cycle) {
  if (tool.taperAngle > 0) {
    error(localize("Circular pocket milling is not supported for taper tools."));
    return;
  }
  writeBlock("CYCL DEF 5.0 CIRCULAR POCKET");
  writeBlock("CYCL DEF 5.1 SET UP " + xyzFormat.format(cycle.clearance));
  writeBlock("CYCL DEF 5.2 DEPTH " + xyzFormat.format(-cycle.depth));
  writeBlock("CYCL DEF 5.3 PECKG " + xyzFormat.format(cycle.stepover) +  " F" + feedFormat.format(cycle.feedrate / 3));
  writeBlock("CYCL DEF 5.4 RADIUS " + xyzFormat.format(cycle.diameter / 2));
  writeBlock("CYCL DEF 5.5 F" + feedFormat.format(cycle.feedrate) + " DR+");
}

/** Returns the best discrete disengagement direction for the specified direction. */
function getDisengagementDirection(direction) {
  switch (getQuadrant(direction + 45 * Math.PI / 180)) {
  case 0:
    return 3;
  case 1:
    return 4;
  case 2:
    return 1;
  case 3:
    return 2;
  }
  error(localize("Invalid disengagement direction."));
  return 3;
}

var expandCurrentCycle = false;

function onCycle() {
  if (!isSameDirection(getRotation().forward, new Vector(0, 0, 1))) {
    expandCurrentCycle = getProperty("expandCycles");
    if (!expandCurrentCycle) {
      cycleNotSupported();
    }
    return;
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for a cycle."));
    return;
  }

  expandCurrentCycle = false;

  if (cycle.clearance != undefined) {
    if (getCurrentPosition().z < cycle.clearance) {
      writeBlock("L" + zOutput.format(cycle.clearance) + radiusCompensationTable.lookup(radiusCompensation) + " FMAX");
      setCurrentPositionZ(cycle.clearance);
    }
  }

  switch (cycleType) {
  case "drilling": // G81 style
    onDrilling(cycle);
    break;
  case "counter-boring":
    onCounterBoring(cycle);
    break;
  case "chip-breaking":
    if (cycle.accumulatedDepth < cycle.depth) {
      expandCurrentCycle = getProperty("expandCycles");
    } else {
      onChipBreaking(cycle);
    }
    break;
  case "deep-drilling":
    onDeepDrilling(cycle);
    break;
  case "tapping":
    if (tool.type == TOOL_TAP_LEFT_HAND) {
      onLeftTapping(cycle);
    } else {
      onRightTapping(cycle);
    }
    break;
  case "left-tapping":
    onLeftTapping(cycle);
    break;
  case "right-tapping":
    onRightTapping(cycle);
    break;
    /*
  case "reaming":
    onReaming(cycle);
    break;
  case "stop-boring":
    onStopBoring(cycle);
    break;
  case "fine-boring":
    onFineBoring(cycle);
    break;
  case "back-boring":
    onBackBoring(cycle);
    break;
  case "boring":
    onBoring(cycle);
    break;
*/
  case "circular-pocket-milling":
    onCircularPocketMilling(cycle);
    break;
  default:
    expandCurrentCycle = getProperty("expandCycles");
    if (!expandCurrentCycle) {
      cycleNotSupported();
    }
  }
}

function onCyclePoint(x, y, z) {
  if (!expandCurrentCycle) {
    var xy = xOutput.format(x) + yOutput.format(y);
    // execute current cycle after this positioning block
    if (spatialFormat.areDifferent(getCurrentPosition().z, cycle.clearance)) { // old heidenhain cycles do not support "2nd set-up clearance"
      if (xy) {
        writeBlock("L" + xy + " FMAX");
      }
      writeBlock("L" + zOutput.format(cycle.clearance) + radiusCompensationTable.lookup(radiusCompensation) + " FMAX " + mFormat.format(99));
    } else {
      writeBlock("L" + xy + " FMAX " + mFormat.format(99));
    }
  } else {
    expandCyclePoint(x, y, z);
  }
}

function onCycleEnd() {
  zOutput.reset();
}

var pendingRadiusCompensation = -1;

function onRadiusCompensation() {
  pendingRadiusCompensation = radiusCompensation;
}

function onRapid(x, y, z) {
  var xyz = xOutput.format(x) + yOutput.format(y) + zOutput.format(z);
  if (xyz) {
    pendingRadiusCompensation = -1;
    writeBlock("L" + xyz + radiusCompensationTable.lookup(radiusCompensation) + " FMAX");
  }
  forceFeed();
}

function onLinear(x, y, z, feed) {
  var xyz = xOutput.format(x) + yOutput.format(y) + zOutput.format(z);
  var f = getFeed(feed);
  if (xyz) {
    pendingRadiusCompensation = -1;
    writeBlock("L" + xyz + radiusCompensationTable.lookup(radiusCompensation) + f);
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      forceFeed(); // force feed on next line
    } else {
      pendingRadiusCompensation = -1;
      writeBlock("L" + radiusCompensationTable.lookup(radiusCompensation) + f);
    }
  }
}

function onRapid5D(x, y, z, a, b, c) {
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for 5-axis move."));
    return;
  }

  if (currentSection.isOptimizedForMachine()) {
    var xyzabc = xOutput.format(x) + yOutput.format(y) + zOutput.format(z) + aOutput.format(a) + bOutput.format(b) + cOutput.format(c);
    if (xyzabc) {
      writeBlock("L" + xyzabc + radiusCompensationTable.lookup(radiusCompensation) + " FMAX");
    }
  } else {
    error(localize("This post configuration has not been customized for 5-axis simultaneous toolpath."));
    return;
  }
  forceFeed(); // force feed on next line
}

function onLinear5D(x, y, z, a, b, c, feed) {
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for 5-axis move."));
    return;
  }

  if (currentSection.isOptimizedForMachine()) {
    var xyzabc = xOutput.format(x) + yOutput.format(y) + zOutput.format(z) + aOutput.format(a) + bOutput.format(b) + cOutput.format(c);
    var f = getFeed(feed);
    if (xyzabc) {
      writeBlock("L" + xyzabc + radiusCompensationTable.lookup(radiusCompensation) + f);
    } else if (f) {
      if (getNextRecord().isMotion()) { // try not to output feed without motion
        forceFeed(); // force feed on next line
      } else {
        pendingRadiusCompensation = -1;
        writeBlock("L" + radiusCompensationTable.lookup(radiusCompensation) + f);
      }
    }
  } else {
    error(localize("This post configuration has not been customized for 5-axis simultaneous toolpath."));
    return;
  }
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
    return;
  }

  switch (getCircularPlane()) {
  case PLANE_XY:
    writeBlock("CC X" + xyzFormat.format(cx) + " Y" + xyzFormat.format(cy));
    break;
  case PLANE_ZX:
    if (isHelical()) {
      var t = tolerance;
      if ((t == 0) && hasParameter("operation:tolerance")) {
        t = getParameter("operation:tolerance");
      }
      linearize(t);
      return;
    }
    writeBlock("CC X" + xyzFormat.format(cx) + " Z" + xyzFormat.format(cz));
    break;
  case PLANE_YZ:
    if (isHelical()) {
      var t = tolerance;
      if ((t == 0) && hasParameter("operation:tolerance")) {
        t = getParameter("operation:tolerance");
      }
      linearize(t);
      return;
    }
    writeBlock("CC Y" + xyzFormat.format(cy) + " Z" + xyzFormat.format(cz));
    break;
  default:
    var t = tolerance;
    if ((t == 0) && hasParameter("operation:tolerance")) {
      t = getParameter("operation:tolerance");
    }
    linearize(t);
    return;
  }

  if (!isHelical() && (Math.abs(getCircularSweep()) <= 2 * Math.PI * 0.9)) {
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(
        "C" + xOutput.format(x) + yOutput.format(y) +
        (clockwise ? " DR-" : " DR+") +
        radiusCompensationTable.lookup(radiusCompensation) +
        getFeed(feed)
      );
      break;
    case PLANE_ZX:
      writeBlock(
        "C" + xOutput.format(x) + zOutput.format(z) +
        (clockwise ? " DR-" : " DR+") +
        radiusCompensationTable.lookup(radiusCompensation) +
        getFeed(feed)
      );
      break;
    case PLANE_YZ:
      writeBlock(
        "C" + yOutput.format(y) + zOutput.format(z) +
        (clockwise ? " DR-" : " DR+") +
        radiusCompensationTable.lookup(radiusCompensation) +
        getFeed(feed)
      );
      break;
    default:
      var t = tolerance;
      if ((t == 0) && hasParameter("operation:tolerance")) {
        t = getParameter("operation:tolerance");
      }
      linearize(t);
    }
    return;
  }

  if (isHelical()) {
    if (getCircularPlane() == PLANE_XY) {
      // IPA must have same sign as DR
      var sweep = (clockwise ? -1 : 1) * Math.abs(getCircularSweep());
      var block = "CP IPA" + paFormat.format(sweep) + zOutput.format(z);
      block += clockwise ? " DR-" : " DR+";
      block += /*radiusCompensationTable.lookup(radiusCompensation) +*/ getFeed(feed);
      writeBlock(block);
      xOutput.reset();
      yOutput.reset();
    } else {
      var t = tolerance;
      if ((t == 0) && hasParameter("operation:tolerance")) {
        t = getParameter("operation:tolerance");
      }
      linearize(t);
    }
  } else {
    // IPA must have same sign as DR
    var sweep = (clockwise ? -1 : 1) * Math.abs(getCircularSweep());
    var block = "CP IPA" + paFormat.format(sweep);
    block += clockwise ? " DR-" : " DR+";
    block += /*radiusCompensationTable.lookup(radiusCompensation) +*/ getFeed(feed);
    writeBlock(block);

    switch (getCircularPlane()) {
    case PLANE_XY:
      xOutput.reset();
      yOutput.reset();
      break;
    case PLANE_ZX:
      xOutput.reset();
      zOutput.reset();
      break;
    case PLANE_YZ:
      yOutput.reset();
      zOutput.reset();
      break;
    default:
      invalidateXYZ();
    }
  }
}

var currentCoolantMode = COOLANT_OFF;
var coolantOff = undefined;

function setCoolant(coolant) {
  var coolantCodes = getCoolantCodes(coolant);
  if (Array.isArray(coolantCodes)) {
    if (singleLineCoolant) {
      writeBlock(coolantCodes.join(getWordSeparator()));
    } else {
      for (var c in coolantCodes) {
        writeBlock(coolantCodes[c]);
      }
    }
    return undefined;
  }
  return coolantCodes;
}

function getCoolantCodes(coolant) {
  var multipleCoolantBlocks = new Array(); // create a formatted array to be passed into the outputted line
  if (!coolants) {
    error(localize("Coolants have not been defined."));
  }
  if (tool.type == TOOL_PROBE) { // avoid coolant output for probing
    coolant = COOLANT_OFF;
  }
  if (coolant == currentCoolantMode) {
    return undefined; // coolant is already active
  }
  if ((coolant != COOLANT_OFF) && (currentCoolantMode != COOLANT_OFF) && (coolantOff != undefined)) {
    if (Array.isArray(coolantOff)) {
      for (var i in coolantOff) {
        multipleCoolantBlocks.push(coolantOff[i]);
      }
    } else {
      multipleCoolantBlocks.push(coolantOff);
    }
  }

  var m;
  var coolantCodes = {};
  for (var c in coolants) { // find required coolant codes into the coolants array
    if (coolants[c].id == coolant) {
      coolantCodes.on = coolants[c].on;
      if (coolants[c].off != undefined) {
        coolantCodes.off = coolants[c].off;
        break;
      } else {
        for (var i in coolants) {
          if (coolants[i].id == COOLANT_OFF) {
            coolantCodes.off = coolants[i].off;
            break;
          }
        }
      }
    }
  }
  if (coolant == COOLANT_OFF) {
    m = !coolantOff ? coolantCodes.off : coolantOff; // use the default coolant off command when an 'off' value is not specified
  } else {
    coolantOff = coolantCodes.off;
    m = coolantCodes.on;
  }

  if (!m) {
    onUnsupportedCoolant(coolant);
    m = 9;
  } else {
    if (Array.isArray(m)) {
      for (var i in m) {
        multipleCoolantBlocks.push(m[i]);
      }
    } else {
      multipleCoolantBlocks.push(m);
    }
    currentCoolantMode = coolant;
    for (var i in multipleCoolantBlocks) {
      if (typeof multipleCoolantBlocks[i] == "number") {
        multipleCoolantBlocks[i] = mFormat.format(multipleCoolantBlocks[i]);
      }
    }
    return multipleCoolantBlocks; // return the single formatted coolant value
  }
  return undefined;
}

var mapCommand = {
  COMMAND_STOP                    : 0,
  COMMAND_OPTIONAL_STOP           : 1,
  COMMAND_END                     : 30,
  COMMAND_SPINDLE_CLOCKWISE       : 3,
  COMMAND_SPINDLE_COUNTERCLOCKWISE: 4,
  // COMMAND_START_SPINDLE
  COMMAND_STOP_SPINDLE            : 5
  //COMMAND_ORIENTATE_SPINDLE:19,
  //COMMAND_LOAD_TOOL:6, // do not use
  //COMMAND_COOLANT_ON,
  //COMMAND_COOLANT_OFF,
  //COMMAND_ACTIVATE_SPEED_FEED_SYNCHRONIZATION
  //COMMAND_DEACTIVATE_SPEED_FEED_SYNCHRONIZATION
};

function onCommand(command) {
  switch (command) {
  case COMMAND_COOLANT_OFF:
    setCoolant(COOLANT_OFF);
    return;
  case COMMAND_COOLANT_ON:
    setCoolant(COOLANT_FLOOD);
    return;
  case COMMAND_START_SPINDLE:
    onCommand(tool.clockwise ? COMMAND_SPINDLE_CLOCKWISE : COMMAND_SPINDLE_COUNTERCLOCKWISE);
    return;
  case COMMAND_LOCK_MULTI_AXIS:
    return;
  case COMMAND_UNLOCK_MULTI_AXIS:
    return;
  case COMMAND_START_CHIP_TRANSPORT:
    return;
  case COMMAND_STOP_CHIP_TRANSPORT:
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
  if (!isLastSection() && (getNextSection().getTool().coolant != tool.coolant)) {
    setCoolant(COOLANT_OFF);
  }
  // the code below gets the machine angles from previous operation.  closestABC must also be set to true
  if (currentSection.isMultiAxis() && currentSection.isOptimizedForMachine()) {
    currentMachineABC = currentSection.getFinalToolAxisABC();
  }
  invalidate();
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
  if (false && method == "G28") { // always use machine home positions
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
      words.push("X" + xyzFormat.format(_xHome));
      xOutput.reset();
      break;
    case Y:
      words.push("Y" + xyzFormat.format(_yHome));
      yOutput.reset();
      break;
    case Z:
      words.push("Z" + xyzFormat.format(_zHome));
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
    case "M91":
    case "M92":
      writeBlock("L " + words.join(getWordSeparator()) + SP + "R0 FMAX " + mFormat.format(method == "M92" ? 92 : 91));
      break;
    default:
      error(localize("Unsupported safe position method."));
      return;
    }
  }
}

function onClose() {
  setTolerance(0);
  setCoolant(COOLANT_OFF);
  if (getNumberOfSections() > 0) {
    onCommand(COMMAND_BREAK_CONTROL);
  }

  onCommand(COMMAND_STOP_SPINDLE);

  //writeBlock("CYCL DEF 7.0 " + localize("DATUM SHIFT"));
  //writeBlock("CYCL DEF 7.1 #" + 0);
  onCommand(COMMAND_UNLOCK_MULTI_AXIS);

  writeRetract(Z);

  if (getProperty("homeXYAtEnd")) {
    writeRetract(X, Y);
  }

  setWorkPlane(new Vector(0, 0, 0)); // reset working plane

  onCommand(COMMAND_STOP_CHIP_TRANSPORT);
  writeBlock(mFormat.format(30)); // stop program, spindle stop, coolant off

  writeBlock(
    "END PGM" + (programName ? (SP + programName) : "") + ((unit == MM) ? " MM" : " INCH")
  );
}

function setProperty(property, value) {
  properties[property].current = value;
}
