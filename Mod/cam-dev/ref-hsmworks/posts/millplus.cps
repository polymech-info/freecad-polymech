/**
  Copyright (C) 2012-2021 by Autodesk, Inc.
  All rights reserved.

  MillPlus post processor configuration.

  $Revision: 43654 a19c569c9f7fe055fc222095112d3f1eebc74b63 $
  $Date: 2021-12-02 09:56:05 $

  FORKID {72356D88-2414-401a-805E-5842DB111BB6}
*/

description = "MillPlus";
vendor = "Heidenhain";
vendorUrl = "http://www.millplus.de";
legal = "Copyright (C) 2012-2021 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45702;

longDescription = "Generic milling post for MillPlus.";

extension = "nc";
programNameIsInteger = true;
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
mapWorkOrigin = true; // set to false to get G93 blocks

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
  preloadTool: {
    title      : "Preload tool",
    description: "Preloads the next tool at a tool change (if any).",
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
  MC84: {
    title      : "MC84 Parameter",
    description: "Sets the MC84 machine parameter",
    type       : "integer",
    value      : 0,
    scope      : "post"
  },
  useParametricFeed: {
    title      : "Parametric feed",
    description: "Specifies the feed value that should be output using a Q value.",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  showNotes: {
    title      : "Show notes",
    description: "Writes operation notes as comments in the outputted code.",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  safePositionMethod: {
    title      : "Safe Retracts",
    description: "Select your desired retract option. 'Clearance Height' retracts to the operation clearance height.",
    type       : "enum",
    values     : [
      // {title: "G28", id: "G28"},
      // {title: "G53", id: "G53"},
      {title:"Clearance Height", id:"clearanceHeight"},
      {title:"G74", id:"G74"}
    ],
    value: "G74",
    scope: "post"
  }
};

var singleLineCoolant = false; // specifies to output multiple coolant codes in one line rather than in separate lines
// samples:
// {id: COOLANT_THROUGH_TOOL, on: 88, off: 89}
// {id: COOLANT_THROUGH_TOOL, on: [8, 88], off: [9, 89]}
// {id: COOLANT_THROUGH_TOOL, on: "M88 P3 (myComment)", off: "M89"}
var coolants = [
  {id:COOLANT_FLOOD, on:8},
  {id:COOLANT_MIST, on:7},
  {id:COOLANT_THROUGH_TOOL},
  {id:COOLANT_AIR},
  {id:COOLANT_AIR_THROUGH_TOOL},
  {id:COOLANT_SUCTION},
  {id:COOLANT_FLOOD_MIST},
  {id:COOLANT_FLOOD_THROUGH_TOOL},
  {id:COOLANT_OFF, off:9}
];

var gFormat = createFormat({prefix:"G", decimals:0});
var mFormat = createFormat({prefix:"M", decimals:0});
var hFormat = createFormat({prefix:"H", decimals:0});
var dFormat = createFormat({prefix:"D", decimals:0});

var xyzFormat = createFormat({decimals:(unit == MM ? 3 : 4)});
var abcFormat = createFormat({decimals:3, forceDecimal:true, scale:DEG});
var feedFormat = createFormat({decimals:(unit == MM ? 1 : 2)});
var toolFormat = createFormat({decimals:0});
var rpmFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:1}); // seconds - range 0.1-900
var taperFormat = createFormat({decimals:1, scale:DEG});

// for 5-axis motion
var tFormat = createFormat({decimals:6, forceDecimal:true, scale:100}); // unitless
var txOutput = createVariable({prefix:"I1=", force:true}, tFormat);
var tyOutput = createVariable({prefix:"J1=", force:true}, tFormat);
var tzOutput = createVariable({prefix:"K1=", force:true}, tFormat);

var xOutput = createVariable({prefix:"X"}, xyzFormat);
var yOutput = createVariable({prefix:"Y"}, xyzFormat);
var zOutput = createVariable({onchange:function () {retracted = false;}, prefix:"Z"}, xyzFormat);
var aOutput = createVariable({prefix:"A"}, abcFormat);
var bOutput = createVariable({prefix:"B"}, abcFormat);
var cOutput = createVariable({prefix:"C"}, abcFormat);
var feedOutput = createVariable({prefix:"F"}, feedFormat);
var sOutput = createVariable({prefix:"S", force:true}, rpmFormat);

// circular output
var iOutput = createVariable({prefix:"I", force:true}, xyzFormat);
var jOutput = createVariable({prefix:"J", force:true}, xyzFormat);
var kOutput = createVariable({prefix:"K", force:true}, xyzFormat);

var gMotionModal = createModal({force:true}, gFormat); // modal group 1 // G0-G3, ...
var gPlaneModal = createModal({onchange:function () {gMotionModal.reset();}}, gFormat); // modal group 2 // G17-19
var gAbsIncModal = createModal({}, gFormat); // modal group 3 // G90-91
var gFeedModeModal = createModal({}, gFormat); // modal group 5 // G94-95
var gUnitModal = createModal({}, gFormat); // modal group 6 // G70-71
var gCycleModal = createModal({}, gFormat); // modal group 9 // G81, ...

// fixed settings
var firstFeedParameter = 1;

var WARNING_WORK_OFFSET = 0;
var WARNING_LENGTH_OFFSET = 1;
var WARNING_DIAMETER_OFFSET = 2;

// collected state
var sequenceNumber;
var currentWorkOffset;
var forceSpindleSpeed = false;
var activeMovements; // do not use by default
var currentFeedId;
var retracted = false; // specifies that the tool has been retracted to the safe plane

/**
  Writes the specified block.
*/
function writeBlock() {
  if (!formatWords(arguments)) {
    return;
  }
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
  if (getProperty("showSequenceNumbers")) {
    writeWords2("N" + sequenceNumber, formatComment(text));
    sequenceNumber += getProperty("sequenceNumberIncrement");
  } else {
    writeWords(formatComment(text));
  }
}

function onOpen() {

  if (false) { // note: setup your machine here
    var aAxis = createAxis({coordinate:0, table:false, axis:[1, 0, 0], range:[-360, 360], preference:1});
    var cAxis = createAxis({coordinate:2, table:false, axis:[0, 0, 1], range:[-360, 360], preference:1});
    machineConfiguration = new MachineConfiguration(aAxis, cAxis);

    setMachineConfiguration(machineConfiguration);
    optimizeMachineAngles2(0); // TCP mode - using G141
  }

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

  if (programName) {
    var programId;
    try {
      programId = getAsInt(programName);
    } catch (e) {
      error(localize("Program name must be a number."));
      return;
    }
    if (!((programId >= 1) && (programId <= 9999999))) {
      error(localize("Program number is out of range."));
      return;
    }
    writeln("%PM" + programId);
    writeln("N" + programId + " (" + programName + ")");
  } else {
    error(localize("Program name has not been specified."));
    return;
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

  // absolute coordinates and feed per min
  writeBlock(gAbsIncModal.format(90));
  writeBlock(gFeedModeModal.format(94));
  writeBlock(gPlaneModal.format(17));

  switch (unit) {
  case IN:
    writeBlock(gUnitModal.format(70));
    break;
  case MM:
    writeBlock(gUnitModal.format(71));
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

function forceFeed() {
  currentFeedId = undefined;
  feedOutput.reset();
}

/** Force output of X, Y, Z, A, B, C, and F on next output. */
function forceAny() {
  forceXYZ();
  forceABC();
  forceFeed();
}

function onParameter(name, value) {
}

function FeedContext(id, description, feed) {
  this.id = id;
  this.description = description;
  this.feed = feed;
}

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
        return "F=E" + (firstFeedParameter + feedContext.id);
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
    writeBlock("E" + (firstFeedParameter + feedContext.id) + "=" + feedFormat.format(feedContext.feed), formatComment(feedContext.description));
  }
}

var currentWorkPlaneABC = undefined;
var currentWorkPlaneXYZ = new Vector(0, 0, 0);
var currentWorkPlaneABCTurned = false;

function forceWorkPlane() {
  currentWorkPlaneABC = undefined;
}

function resetWorkOffset() {
  currentWorkOffset.x = 0;
  currentWorkOffset.y = 0;
  currentWorkOffset.z = 0;
}

function setWorkPlane(xyz, abc, turn) {
  if (is3D() && !machineConfiguration.isMultiAxisConfiguration()) {
    return; // ignore
  }

  if (!((currentWorkPlaneABC == undefined) ||
        abcFormat.areDifferent(abc.x, currentWorkPlaneABC.x) ||
        abcFormat.areDifferent(abc.y, currentWorkPlaneABC.y) ||
        abcFormat.areDifferent(abc.z, currentWorkPlaneABC.z) ||
        (!currentWorkPlaneABCTurned && turn) ||
        xyzFormat.areDifferent(xyz.x, currentWorkPlaneXYZ.x) ||
        xyzFormat.areDifferent(xyz.y, currentWorkPlaneXYZ.y) ||
        xyzFormat.areDifferent(xyz.z, currentWorkPlaneXYZ.z))) {
    return; // no change
  }
  currentWorkPlaneABC = abc;
  currentWorkPlaneABCTurned = turn;

  if (turn) {
    onCommand(COMMAND_UNLOCK_MULTI_AXIS);
  }

  if (!mapWorkOrigin && (xyzFormat.areDifferent(xyz.x, currentWorkPlaneXYZ.x) ||
      xyzFormat.areDifferent(xyz.y, currentWorkPlaneXYZ.y) ||
      xyzFormat.areDifferent(xyz.z, currentWorkPlaneXYZ.z))) {
    writeBlock(gFormat.format(93),
      conditional(xyzFormat.areDifferent(xyz.x, currentWorkPlaneXYZ.x), "X" + xyzFormat.format(xyz.x)),
      conditional(xyzFormat.areDifferent(xyz.y, currentWorkPlaneXYZ.y), "Y" + xyzFormat.format(xyz.y)),
      conditional(xyzFormat.areDifferent(xyz.z, currentWorkPlaneXYZ.z), "Z" + xyzFormat.format(xyz.z))
    );
  }
  currentWorkPlaneXYZ = xyz;

  if (abc.isZero()) {
    // reset working plane
    writeBlock(gFormat.format(7), "L1=" + (turn ? 1 : 0));
    forceABC();
  } else {
    writeBlock(
      gFormat.format(7),
      "A5=" + abcFormat.format(abc.x),
      "B5=" + abcFormat.format(abc.y),
      "C5=" + abcFormat.format(abc.z),
      "L1=" + (turn ? 1 : 0)
    );
  }

  if (turn) {
    //if (!currentSection.isMultiAxis()) {
    onCommand(COMMAND_LOCK_MULTI_AXIS);
    //}
  }
}

function isProbeOperation() {
  return hasParameter("operation-strategy") && (getParameter("operation-strategy") == "probe");
}

function onSection() {
  if (firstToolChange) { // stock - workpiece
    var workpiece = getWorkpiece();
    var delta = Vector.diff(workpiece.upper, workpiece.lower);
    if (delta.isNonZero()) {
      // G196-199 are recommended
      var offset = 10;
      writeBlock(
        gFormat.format(99), "X" + xyzFormat.format(workpiece.lower.x - offset),
        "Y" + xyzFormat.format(workpiece.lower.y - offset),
        "Z" + xyzFormat.format(workpiece.lower.z - offset),
        "I" + xyzFormat.format(delta.x + 2 * offset),
        "J" + xyzFormat.format(delta.y + 2 * offset),
        "K" + xyzFormat.format(delta.z + 2 * offset)
      );
      writeBlock(
        gFormat.format(98), "X" + xyzFormat.format(workpiece.lower.x),
        "Y" + xyzFormat.format(workpiece.lower.y),
        "Z" + xyzFormat.format(workpiece.lower.z),
        "I" + xyzFormat.format(delta.x),
        "J" + xyzFormat.format(delta.y),
        "K" + xyzFormat.format(delta.z)
      );
    }
  }

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

    // retract to safe plane
    if (isMultiAxis()) {
      writeBlock(gFormat.format(40));
    }

    // retract to safe plane
    writeRetract(Z);
    zOutput.reset();
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

  if (insertToolCall) {
    forceWorkPlane();

    setCoolant(COOLANT_OFF);

    if (!isFirstSection() && getProperty("optionalStop")) {
      onCommand(COMMAND_OPTIONAL_STOP);
    }

    if (tool.number > 99999999) {
      warning(localize("Tool number exceeds maximum value."));
    }

    writeBlock("T" + toolFormat.format(tool.number), mFormat.format(6));
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

    if (getProperty("preloadTool")) {
      var nextTool = getNextTool(tool.number);
      if (nextTool) {
        writeBlock("T" + toolFormat.format(nextTool.number));
      } else {
        // preload first tool
        var section = getSection(0);
        var firstToolNumber = section.getTool().number;
        if (tool.number != firstToolNumber) {
          writeBlock("T" + toolFormat.format(firstToolNumber));
        }
      }
    }
  }

  if (insertToolCall ||
      forceSpindleSpeed ||
      isFirstSection() ||
      (rpmFormat.areDifferent(spindleSpeed, sOutput.getCurrent())) ||
      (tool.clockwise != getPreviousSection().getTool().clockwise)) {
    forceSpindleSpeed = false;

    if (spindleSpeed < 1) {
      error(localize("Spindle speed out of range."));
      return;
    }
    if (spindleSpeed > 99999) { // machine specific
      warning(localize("Spindle speed exceeds maximum value."));
    }
    writeBlock(
      sOutput.format(spindleSpeed), mFormat.format(tool.clockwise ? 3 : 4)
    );
  }

  // wcs
  if (insertToolCall) { // force work offset when changing tool
    currentWorkOffset = undefined;
  }
  var workOffset = currentSection.workOffset;
  if (workOffset == 0) {
    if (getProperty("MC84") == 0) {
      warningOnce(localize("Work offset has not been specified. Using G54 as WCS."), WARNING_WORK_OFFSET);
    } else {
      warningOnce(localize("Work offset has not been specified. Using G54 I0 as WCS."), WARNING_WORK_OFFSET);
    }
    workOffset = 1;
  }
  if (workOffset > 0) {
    if (getProperty("MC84") == 0) {
      if (workOffset > 6) {
        error(localize("Work offset out of range."));
        return;
      }
      if (workOffset != currentWorkOffset) {
        writeBlock(gFormat.format(53 + workOffset)); // G54->G59
        currentWorkOffset = workOffset;
      }
    } else {
      if (workOffset > 99) {
        error(localize("Work offset out of range."));
        return;
      }
      if (workOffset != currentWorkOffset) {
        writeBlock(gFormat.format(54), "I" + (workOffset - 1));
        currentWorkOffset = workOffset;
      }
    }
    resetWorkOffset();
  }

  forceXYZ();

  if (!is3D() || machineConfiguration.isMultiAxisConfiguration()) { // use 5-axis indexing for multi-axis mode
    // set working plane after datum shift

    var abc = new Vector(0, 0, 0);
    var xyz = currentSection.workOrigin;
    cancelTransformation();
    if (!currentSection.isMultiAxis()) {
      abc = currentSection.workPlane.getEuler2(EULER_XYZ_S);
    }
    setWorkPlane(xyz, abc, true); // turn
  } else { // pure 3D
    var remaining = currentSection.workPlane;
    if (!isSameDirection(remaining.forward, new Vector(0, 0, 1))) {
      error(localize("Tool orientation is not supported."));
      return;
    }
    setRotation(remaining);
  }

  // set coolant after we have positioned at Z
  setCoolant(tool.coolant);

  forceAny();

  if (tool.lengthOffset != 0) {
    warningOnce(localize("Length offset is not supported."), WARNING_LENGTH_OFFSET);
  }

  if (currentSection.isMultiAxis()) {
    writeBlock(gFormat.format(141)); // TCPM - absolute positions
  }

  var initialPosition = getFramePosition(currentSection.getInitialPosition());
  if (!retracted && !insertToolCall) {
    if (getCurrentPosition().z < initialPosition.z) {
      writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
    }
  }

  if (!machineConfiguration.isHeadConfiguration()) {
    writeBlock(gAbsIncModal.format(90));
    writeBlock(
      gMotionModal.format(0), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y)
    );
    var z = zOutput.format(initialPosition.z);
    if (z) {
      writeBlock(gMotionModal.format(0), z);
    }
  } else {
    writeBlock(gAbsIncModal.format(90));
    writeBlock(
      gMotionModal.format(0),
      xOutput.format(initialPosition.x),
      yOutput.format(initialPosition.y),
      zOutput.format(initialPosition.z)
    );
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

  if (insertToolCall) {
    gPlaneModal.reset();
  }
}

var expandCycle;

function onDrilling(cycle) {
  onCounterBoring(cycle);
}

function onCounterBoring(cycle) {
  writeBlock(gAbsIncModal.format(90));
  writeBlock(
    gCycleModal.format(81),
    "Z" + xyzFormat.format(-cycle.depth),
    "Y" + xyzFormat.format(cycle.retract - cycle.stock),
    conditional(cycle.clearance > cycle.retract, "B" + xyzFormat.format(cycle.clearance - cycle.retract)),
    conditional(cycle.dwell > 0, "X" + secFormat.format(clamp(0.1, cycle.dwell, 900))),
    feedOutput.format(cycle.feedrate)
  );
}

function onChipBreaking(cycle) {
  writeBlock(gAbsIncModal.format(90));
  writeBlock(
    gCycleModal.format(83),
    "Z" + xyzFormat.format(-cycle.depth),
    "Y" + xyzFormat.format(cycle.retract - cycle.stock),
    conditional(cycle.clearance > cycle.retract, "B" + xyzFormat.format(cycle.clearance - cycle.retract)),
    "K" + xyzFormat.format(cycle.incrementalDepth),
    "I0",
    "J" + xyzFormat.format((cycle.chipBreakDistance != undefined) ? cycle.chipBreakDistance : machineParameters.chipBreakingDistance),
    "K1=" + cycle.plungesPerRetract,
    conditional(cycle.dwell > 0, "X" + secFormat.format(clamp(0.1, cycle.dwell, 900))),
    feedOutput.format(cycle.feedrate)
  );
}

function onDeepDrilling(cycle) {
  writeBlock(gAbsIncModal.format(90));
  writeBlock(
    gCycleModal.format(83),
    "Z" + xyzFormat.format(-cycle.depth),
    "Y" + xyzFormat.format(cycle.retract - cycle.stock),
    conditional(cycle.clearance > cycle.retract, "B" + xyzFormat.format(cycle.clearance - cycle.retract)),
    "K" + xyzFormat.format(cycle.incrementalDepth),
    "I0",
    "J0",
    conditional(cycle.dwell > 0, "X" + secFormat.format(clamp(0.1, cycle.dwell, 900))),
    feedOutput.format(cycle.feedrate)
  );
}

function onLeftTapping(cycle) {
  writeBlock(gAbsIncModal.format(90));
  writeBlock(
    gCycleModal.format(84),
    "Z" + xyzFormat.format(-cycle.depth),
    "Y" + xyzFormat.format(cycle.retract - cycle.stock),
    conditional(cycle.clearance > cycle.retract, "B" + xyzFormat.format(cycle.clearance - cycle.retract)),
    conditional(cycle.dwell > 0, "X" + secFormat.format(clamp(0.1, cycle.dwell, 900))),
    // feedOutput.format(cycle.feedrate),
    "J" + xyzFormat.format(tool.threadPitch),
    "I1=1"
  );
}

function onRightTapping(cycle) {
  writeBlock(gAbsIncModal.format(90));
  writeBlock(
    gCycleModal.format(84),
    "Z" + xyzFormat.format(-cycle.depth),
    "Y" + xyzFormat.format(cycle.retract - cycle.stock),
    conditional(cycle.clearance > cycle.retract, "B" + xyzFormat.format(cycle.clearance - cycle.retract)),
    conditional(cycle.dwell > 0, "X" + secFormat.format(clamp(0.1, cycle.dwell, 900))),
    // feedOutput.format(cycle.feedrate),
    "J" + xyzFormat.format(tool.threadPitch),
    "I1=1"
  );
}

function onReaming(cycle) {
  onBoring(cycle);
}

function onStopBoring(cycle) {
  writeBlock(gAbsIncModal.format(90));
  writeBlock(
    gCycleModal.format(86),
    "Z" + xyzFormat.format(-cycle.depth),
    "Y" + xyzFormat.format(cycle.retract - cycle.stock),
    conditional(cycle.clearance > cycle.retract, "B" + xyzFormat.format(cycle.clearance - cycle.retract)),
    conditional(cycle.dwell > 0, "X" + secFormat.format(clamp(0.1, cycle.dwell, 900))),
    feedOutput.format(cycle.feedrate)
  );
}

function onBoring(cycle) {
  writeBlock(gAbsIncModal.format(90));
  writeBlock(
    gCycleModal.format(85),
    "Z" + xyzFormat.format(-cycle.depth),
    "Y" + xyzFormat.format(cycle.retract - cycle.stock),
    conditional(cycle.clearance > cycle.retract, "B" + xyzFormat.format(cycle.clearance - cycle.retract)),
    conditional(cycle.dwell > 0, "X" + secFormat.format(clamp(0.1, cycle.dwell, 900))),
    feedOutput.format(cycle.feedrate),
    conditional(cycle.retractFeedrate != cycle.feedrate, "F2=" + feedFormat.format(cycle.retractFeedrate))
  );
}

function onDwell(seconds) {
  if (seconds > 900) {
    warning(localize("Dwelling time is out of range."));
  }
  seconds = clamp(0.1, seconds, 900);
  writeBlock(gFormat.format(4), "X" + secFormat.format(seconds));
}

function onSpindleSpeed(spindleSpeed) {
  writeBlock(sOutput.format(spindleSpeed));
}

function onCycle() {
  if (!isSameDirection(getRotation().forward, new Vector(0, 0, 1))) {
    expandCurrentCycle = getProperty("expandCycles");
    if (!expandCurrentCycle) {
      cycleNotSupported();
    }
    return;
  }
  writeBlock(gPlaneModal.format(17));

  // go to the initial retract level
  if (getCurrentPosition().z > cycle.clearance) {
    if (getNumberOfCyclePoints() > 0) {
      var p = getCyclePoint(0);
      writeBlock(gMotionModal.format(0), xOutput.format(p.x), yOutput.format(p.y));
    }
  }
  writeBlock(gMotionModal.format(0), zOutput.format(cycle.clearance));
  setCurrentPositionZ(cycle.clearance);

  expandCycle = false;

  switch (cycleType) {
  case "drilling": // G81 style
    onDrilling(cycle);
    break;
  case "counter-boring":
    onCounterBoring(cycle);
    break;
  case "chip-breaking":
    onChipBreaking(cycle);
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
  case "back-boring":
    var revolutions = 0;
    if (cycle.dwell > 0) {
      revolutions = sOutput.getCurrent() * cycle.dwell / 60;
    }
    writeBlock(gAbsIncModal.format(90));
    writeBlock(
      gCycleModal.format(790),
      "L" + xyzFormat.format(cycle.backBoreDistance),
      "Z" + xyzFormat.format(-cycle.depth),
      "L1=" + xyzFormat.format(cycle.retract - cycle.stock),
      conditional(cycle.clearance > cycle.retract, "L2=" + xyzFormat.format(cycle.clearance - cycle.retract)),
      "C1=" + xyzFormat.format(cycle.shift),
      "C2=0",
      "D" + angleFormat.format(cycle.shiftDirection),
      conditional(revolutions > 0, "D3=" + revFormat.format(revolutions)),
      feedOutput.format(cycle.feedrate)
    );
    break;
  case "reaming":
    onReaming(cycle);
    break;
  case "stop-boring":
    onStopBoring(cycle);
    break;
  case "fine-boring":
    expandCyclePoint(x, y, z);
    break;
  case "boring":
    onBoring(cycle);
    break;
  default:
    expandCycle = true;
  }
}

function onCyclePoint(x, y, z) {
  if (!expandCycle) {
    xOutput.reset();
    yOutput.reset();
    zOutput.reset();
    writeBlock(
      gFormat.format(79),
      xOutput.format(x),
      yOutput.format(y),
      zOutput.format(cycle.stock)
    );
  } else {
    expandCyclePoint(x, y, z);
  }
}

function onCycleEnd() {
  expandCycle = false;
  zOutput.reset();
  gCycleModal.reset();

  switch (cycleType) {
  case "tapping":
    if (tool.type == TOOL_TAP_LEFT_HAND) {
      // not supported
    } else {
      onCommand(COMMAND_SPINDLE_CLOCKWISE);
    }
    break;
  case "left-tapping":
    // not supported
    break;
  case "right-tapping":
    onCommand(COMMAND_SPINDLE_CLOCKWISE);
    break;
  }
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
    writeBlock(gMotionModal.format(0), x, y, z);
    forceFeed();
  }
}

function onLinear(_x, _y, _z, feed) {
  if (pendingRadiusCompensation >= 0) {
    // ensure that we end at desired position when compensation is turned off
    xOutput.reset();
    yOutput.reset();
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var f = getFeed(feed);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      if (tool.diameterOffset) {
        warningOnce(localize("Diameter offset is not supported."), WARNING_DIAMETER_OFFSET);
      }
      writeBlock(gPlaneModal.format(17));
      switch (radiusCompensation) {
      case RADIUS_COMPENSATION_LEFT:
        writeBlock(gFormat.format(41));
        writeBlock(gMotionModal.format(1), x, y, z, f);
        break;
      case RADIUS_COMPENSATION_RIGHT:
        writeBlock(gFormat.format(42));
        writeBlock(gMotionModal.format(1), x, y, z, f);
        break;
      default:
        writeBlock(gFormat.format(40));
        writeBlock(gMotionModal.format(1), x, y, z, f);
      }
    } else {
      writeBlock(gMotionModal.format(1), x, y, z, f);
    }
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      forceFeed(); // force feed on next line
    } else {
      writeBlock(gMotionModal.format(1), f);
    }
  }
}

function onRapid5D(_x, _y, _z, _a, _b, _c) {
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation mode cannot be changed at rapid traversal."));
    return;
  }
  if (currentSection.isOptimizedForMachine()) {
    var x = xOutput.format(_x);
    var y = yOutput.format(_y);
    var z = zOutput.format(_z);
    var a = aOutput.format(_a);
    var b = bOutput.format(_b);
    var c = cOutput.format(_c);
    writeBlock(gMotionModal.format(0), x, y, z, a, b, c);
  } else {
    forceXYZ(); // required
    var x = xOutput.format(_x);
    var y = yOutput.format(_y);
    var z = zOutput.format(_z);
    var i = txOutput.format(_a);
    var j = tyOutput.format(_b);
    var k = tzOutput.format(_c);
    writeBlock(gMotionModal.format(0), x, y, z, i, j, k);
  }
  forceFeed();
}

function onLinear5D(_x, _y, _z, _a, _b, _c, feed) {
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for 5-axis move."));
    return;
  }

  if (currentSection.isOptimizedForMachine()) {
    var x = xOutput.format(_x);
    var y = yOutput.format(_y);
    var z = zOutput.format(_z);
    var a = aOutput.format(_a);
    var b = bOutput.format(_b);
    var c = cOutput.format(_c);
    var f = getFeed(feed);
    writeBlock(gMotionModal.format(1), x, y, z, a, b, c, f);
  } else {
    forceXYZ(); // required
    var x = xOutput.format(_x);
    var y = yOutput.format(_y);
    var z = zOutput.format(_z);
    var i = txOutput.format(_a);
    var j = tyOutput.format(_b);
    var k = tzOutput.format(_c);
    var f = getFeed(feed);
    writeBlock(gMotionModal.format(1), x, y, z, i, j, k, f);
  }
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
    return;
  }

  writeBlock(gAbsIncModal.format(90));
  var start = getCurrentPosition();

  if (isFullCircle()) {
    if (isHelical()) {
      linearize(tolerance);
      return;
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), iOutput.format(cx), jOutput.format(cy), "B5=360", getFeed(feed));
      break;
    case PLANE_ZX:
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), iOutput.format(cx), kOutput.format(cz), "B5=360", getFeed(feed));
      break;
    case PLANE_YZ:
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), jOutput.format(cy), kOutput.format(cz), "B5=360", getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  } else {
    forceXYZ();
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx), jOutput.format(cy), getFeed(feed));
      break;
    case PLANE_ZX:
      if (isHelical()) {
        linearize(tolerance);
        return;
      }
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), zOutput.format(z), iOutput.format(cx), kOutput.format(cz), getFeed(feed));
      break;
    case PLANE_YZ:
      if (isHelical()) {
        linearize(tolerance);
        return;
      }
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), yOutput.format(y), zOutput.format(z), jOutput.format(cy), kOutput.format(cz), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  }
}

var mapCommand = {
  COMMAND_STOP                    : 0,
  COMMAND_OPTIONAL_STOP           : 1,
  COMMAND_END                     : 30,
  COMMAND_SPINDLE_CLOCKWISE       : 3,
  COMMAND_SPINDLE_COUNTERCLOCKWISE: 4,
  COMMAND_STOP_SPINDLE            : 5,
  COMMAND_ORIENTATE_SPINDLE       : 19,
  COMMAND_LOAD_TOOL               : 6
};

function onCommand(command) {
  switch (command) {
  case COMMAND_STOP:
    writeBlock(mFormat.format(0));
    forceSpindleSpeed = true;
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
  if (isMultiAxis()) {
    writeBlock(gFormat.format(40));
  }
  if (!isLastSection() && (getNextSection().getTool().coolant != tool.coolant)) {
    setCoolant(COOLANT_OFF);
  }
  writeBlock(gPlaneModal.format(17));
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
  if (method == "G28" || method == "G74") {
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
    case "G74":
      gMotionModal.reset();
      writeBlock(gFormat.format(74), words, "L1");
      break;
    default:
      error(localize("Unsupported safe position method."));
      return;
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

function onClose() {
  setCoolant(COOLANT_OFF);

  writeRetract(Z);

  setWorkPlane(new Vector(0, 0, 0), new Vector(0, 0, 0), true); // reset working plane

  if (machineConfiguration.hasHomePositionX() || machineConfiguration.hasHomePositionY()) {
    writeRetract(X, Y);
  }
  onImpliedCommand(COMMAND_END);
  onImpliedCommand(COMMAND_STOP_SPINDLE);
  writeBlock(mFormat.format(30)); // stop program, spindle stop, coolant off
}

function setProperty(property, value) {
  properties[property].current = value;
}
