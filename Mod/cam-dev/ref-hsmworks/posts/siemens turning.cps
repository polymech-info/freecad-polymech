/**
  Copyright (C) 2012-2022 by Autodesk, Inc.
  All rights reserved.

  Siemens Lathe post processor configuration.

  $Revision: 43701 83ef305dbd685ac5903538365ed7de9a08636e84 $
  $Date: 2022-01-20 16:04:52 $

  FORKID {3505AD38-4010-4F6B-8F14-9CE36B9375F7}
*/

description = "Siemens Turning";
vendor = "Siemens";
vendorUrl = "http://www.siemens.com";
legal = "Copyright (C) 2012-2022 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45702;

longDescription = "Generic lathe post for Siemens. Use Turret 0 for Positional Turret, Turret 101 for QCTP on X- Post, Turret 102 for QCTP on X+ Post, Turret 103 for Gang Tooling on X- Post, Turret 104 for Gang Tooling on X+ Tool Post.";

extension = "mpf";
setCodePage("ascii");

capabilities = CAPABILITY_TURNING;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(179);
allowHelicalMoves = false;
allowedCircularPlanes = 1 << PLANE_ZX; // allow ZX plane only

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
  safePositionStyle: {
    title      : "Safe retract style",
    description: "Select your desired order for the axes to retract.",
    type       : "enum",
    group      : 0,
    values     : [
      {title:"Only X", id:"X"},
      {title:"Only Z", id:"Z"},
      {title:"Both X then Z", id:"XZ"},
      {title:"Both Z then X", id:"ZX"},
      {title:"Both same line", id:"singleLineXZ"}
    ],
    value: "XZ",
    scope: "post"
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
  separateWordsWithSpace: {
    title      : "Separate words with space",
    description: "Adds spaces between words if 'yes' is selected.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  useRadius: {
    title      : "Radius arcs",
    description: "If yes is selected, arcs are outputted using radius values rather than IJK.",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  maximumSpindleSpeed: {
    title      : "Max spindle speed",
    description: "Defines the maximum spindle speed allowed by your machines.",
    type       : "integer",
    range      : [0, 999999999],
    value      : 6000,
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
  threadCycleType: {
    title      : "Threading canned cycle",
    description: "Select threading canned cycle type.",
    type       : "enum",
    values     : [
      {title:"CYCLE97", id:"CYCLE97"},
      {title:"CYCLE99", id:"CYCLE99"}
    ],
    value: "CYCLE97",
    scope: "post"
  },
  useCycles: {
    title      : "Use cycles",
    description: "Specifies if canned drilling cycles should be used.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  g53HomePositionX: {
    title      : "G53 home position X",
    description: "G53 X-axis home position.",
    type       : "number",
    value      : 0,
    scope      : "post"
  },
  g53HomePositionZ: {
    title      : "G53 home position Z",
    description: "G53 Z-axis home position.",
    type       : "number",
    value      : 0,
    scope      : "post"
  }
};

// wcs definiton
wcsDefinitions = {
  useZeroOffset: false,
  wcs          : [
    {name:"Standard", format:"G", range:[54, 59]}
  ]
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

var gFormat = createFormat({prefix:"G", decimals:1});
var mFormat = createFormat({prefix:"M", decimals:1});
var dFormat = createFormat({prefix:"D", decimals:0});

var spatialFormat = createFormat({decimals:(unit == MM ? 3 : 4)});
var xFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true, scale:2}); // diameter mode
var yFormat = createFormat({decimals:(unit == MM ? 3 : 4)});
var zFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var rFormat = createFormat({decimals:(unit == MM ? 3 : 4)}); // radius
var fprFormat = createFormat({decimals:(unit == MM ? 4 : 5), forceDecimal:true});
var fpmFormat = createFormat({decimals:(unit == MM ? 0 : 1), forceDecimal:true});
var feedFormat = createFormat({decimals:(unit == MM ? 4 : 5), forceDecimal:true});
var iFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true, scale:1});
var pitchFormat = createFormat({decimals:(unit == MM ? 3 : 4)});
var toolFormat = createFormat({decimals:0});
var rpmFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:3}); // seconds - range 0.001-99999.999
var taperFormat = createFormat({decimals:1, scale:DEG});
var integerFormat = createFormat({decimals:0});

var xOutput; // xOutput is defined in setDirectionX()
var yOutput = createVariable({prefix:"Y"}, yFormat);
var zOutput = createVariable({onchange:function () {retracted[Z] = false;}, prefix:"Z"}, zFormat);
var feedOutput = createVariable({prefix:"F"}, feedFormat);
var pitchOutput = createVariable({prefix:"K", force:true}, pitchFormat);
var sOutput = createVariable({prefix:"S", force:true}, rpmFormat);

// circular output
var kOutput = createReferenceVariable({prefix:"K"}, iFormat);
var iOutput; // iOutput is defined in setDirectionX()

var gMotionModal = createModal({}, gFormat); // modal group 1 // G0-G3, ...
var gPlaneModal = createModal({onchange:function () {gMotionModal.reset();}}, gFormat); // modal group 2 // G17-19
var gAbsIncModal = createModal({}, gFormat); // modal group 3 // G90-91 // only for B and C mode
var gFeedModeModal = createModal({}, gFormat); // modal group 5 // G94-95
var gSpindleModeModal = createModal({}, gFormat); // modal group 5 // G96-97
var gUnitModal = createModal({}, gFormat); // modal group 6 // G70-71
var gCycleModal = createModal({}, gFormat); // modal group 9 // G81, ...
var gRetractModal = createModal({}, gFormat); // modal group 10 // G98-99

// fixed settings
var firstFeedParameter = 1;
var gotSecondarySpindle = false;
var gotDoorControl = false;
var gotTailStock = false;
var gotBarFeeder = false;

var WARNING_WORK_OFFSET = 0;

var QCTP = 0;
var TURRET = 1;
var GANG = 2;

var FRONT = -1;
var REAR = 1;

// collected state
var sequenceNumber;
var currentWorkOffset;
var optionalSection = false;
var forceSpindleSpeed = false;
var tapping = false;
var activeMovements; // do not use by default
var currentFeedId;
var toolingData;
var previousToolingData;
var retracted = new Array(false, false, false); // specifies that the tool has been retracted to the safe plane
var fpmCode = 94;
var fprCode = 95;

function getCode(code) {
  switch (code) {
  // case "PART_CATCHER_ON":
  // return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "PART_CATCHER_OFF":
  // return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "TAILSTOCK_ON":
  // return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "TAILSTOCK_OFF":
  // return mFormat.format(SPECIFY YOUR CODE HERE);
  // case "ENGAGE_C_AXIS":
  // machineState.cAxisIsEngaged = true;
  // return cAxisEngageModal.format(UNSUPPORTED);
  // case "DISENGAGE_C_AXIS":
  // machineState.cAxisIsEngaged = false;
  // return cAxisEngageModal.format(UNSUPPORTED);
  // case "POLAR_INTERPOLATION_ON":
  // return gPolarModal.format(UNSUPPORTED);
  // case "POLAR_INTERPOLATION_OFF":
  // return gPolarModal.format(UNSUPPORTED);
  // case "STOP_LIVE_TOOL":
  // machineState.liveToolIsActive = false;
  // return mFormat.format(UNSUPPORTED);
  // case "STOP_MAIN_SPINDLE":
  // machineState.mainSpindleIsActive = false;
  // return mFormat.format(UNSUPPORTED);
  // case "STOP_SUB_SPINDLE":
  // machineState.subSpindleIsActive = false;
  // return mFormat.format(UNSUPPORTED);
  // case "START_LIVE_TOOL_CW":
  // machineState.liveToolIsActive = true;
  // return mFormat.format(UNSUPPORTED);
  // case "START_LIVE_TOOL_CCW":
  // machineState.liveToolIsActive = true;
  // return mFormat.format(UNSUPPORTED);
  case "START_MAIN_SPINDLE_CW":
    // machineState.mainSpindleIsActive = true;
    return mFormat.format(3);
  case "START_MAIN_SPINDLE_CCW":
    // machineState.mainSpindleIsActive = true;
    return mFormat.format(4);
  // case "START_SUB_SPINDLE_CW":
    // machineState.subSpindleIsActive = true;
    // return mFormat.format(UNSUPPORTED);
  // case "START_SUB_SPINDLE_CCW":
    // machineState.subSpindleIsActive = true;
    // return mFormat.format(UNSUPPORTED);
  // case "MAIN_SPINDLE_BRAKE_ON":
    // machineState.mainSpindleBrakeIsActive = true;
    // return cAxisBrakeModal.format(UNSUPPORTED);
  // case "MAIN_SPINDLE_BRAKE_OFF":
    // machineState.mainSpindleBrakeIsActive = false;
    // return cAxisBrakeModal.format(UNSUPPORTED);
  // case "SUB_SPINDLE_BRAKE_ON":
    // machineState.subSpindleBrakeIsActive = true;
    // return cAxisBrakeModal.format(UNSUPPORTED);
  // case "SUB_SPINDLE_BRAKE_OFF":
    // machineState.subSpindleBrakeIsActive = false;
    // return cAxisBrakeModal.format(UNSUPPORTED);
  case "FEED_MODE_UNIT_REV":
    return gFeedModeModal.format(fprCode);
  case "FEED_MODE_UNIT_MIN":
    return gFeedModeModal.format(fpmCode);
  case "CONSTANT_SURFACE_SPEED_ON":
    return gSpindleModeModal.format(96);
  case "CONSTANT_SURFACE_SPEED_OFF":
    return gSpindleModeModal.format(97);
  // case "MAINSPINDLE_AIR_BLAST_ON":
    // return mFormat.format(UNSUPPORTED);
  // case "MAINSPINDLE_AIR_BLAST_OFF":
    // return mFormat.format(UNSUPPORTED);
  // case "SUBSPINDLE_AIR_BLAST_ON":
    // return mFormat.format(UNSUPPORTED);
  // case "SUBSPINDLE_AIR_BLAST_OFF":
    // return mFormat.format(UNSUPPORTED);
  // case "CLAMP_PRIMARY_CHUCK":
    // return mFormat.format(UNSUPPORTED);
  // case "UNCLAMP_PRIMARY_CHUCK":
    // return mFormat.format(UNSUPPORTED);
  // case "CLAMP_SECONDARY_CHUCK":
    // return mFormat.format(UNSUPPORTED);
  // case "UNCLAMP_SECONDARY_CHUCK":
    // return mFormat.format(UNSUPPORTED);
  // case "SPINDLE_SYNCHRONIZATION_ON":
    // machineState.spindleSynchronizationIsActive = true;
    // return gSynchronizedSpindleModal.format(UNSUPPORTED);
  // case "SPINDLE_SYNCHRONIZATION_OFF":
    // machineState.spindleSynchronizationIsActive = false;
    // return gSynchronizedSpindleModal.format(UNSUPPORTED);
  // case "START_CHIP_TRANSPORT":
    // return mFormat.format(UNSUPPORTED);
  // case "STOP_CHIP_TRANSPORT":
    // return mFormat.format(UNSUPPORTED);
  // case "OPEN_DOOR":
    // return mFormat.format(UNSUPPORTED);
  // case "CLOSE_DOOR":
    // return mFormat.format(UNSUPPORTED);
  default:
    error(localize("Command " + code + " is not defined."));
    return 0;
  }
}

function isSpindleSpeedDifferent() {
  if (isFirstSection()) {
    return true;
  }
  if (getPreviousSection().getTool().clockwise != tool.clockwise) {
    return true;
  }
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    if ((getPreviousSection().getTool().getSpindleMode() != SPINDLE_CONSTANT_SURFACE_SPEED) ||
        rpmFormat.areDifferent(getPreviousSection().getTool().surfaceSpeed, tool.surfaceSpeed)) {
      return true;
    }
  } else {
    if ((getPreviousSection().getTool().getSpindleMode() != SPINDLE_CONSTANT_SPINDLE_SPEED) ||
        rpmFormat.areDifferent(getPreviousSection().getTool().spindleRPM, spindleSpeed)) {
      return true;
    }
  }
  return false;
}

/**
  Writes the specified block.
*/
function writeBlock() {
  var text = formatWords(arguments);
  if (!text) {
    return;
  }
  if (getProperty("showSequenceNumbers")) {
    if (optionalSection) {
      if (text) {
        writeWords("/", "N" + sequenceNumber, text);
      }
    } else {
      writeWords2("N" + sequenceNumber, arguments);
    }
    sequenceNumber += getProperty("sequenceNumberIncrement");
  } else {
    if (optionalSection) {
      writeWords2("/", arguments);
    } else {
      writeWords(arguments);
    }
  }
}

/**
  Writes the specified optional block.
*/
function writeOptionalBlock() {
  if (getProperty("showSequenceNumbers")) {
    var words = formatWords(arguments);
    if (words) {
      writeWords("/", "N" + sequenceNumber, words);
      sequenceNumber += getProperty("sequenceNumberIncrement");
    }
  } else {
    writeWords2("/", arguments);
  }
}

function formatComment(text) {
  return "; " + String(text);
}

function formatCSV() {
  var words = "";
  for (var i in arguments) {
    words += arguments[i] + conditional(i < arguments.length - 1, ", ");
  }
  return words;
}

/**
  Output a comment.
*/
function writeComment(text) {
  writeln(formatComment(text));
}

function onOpen() {
  if (getProperty("useRadius")) {
    maximumCircularSweep = toRad(90); // avoid potential center calculation errors for CNC
  }

  yOutput.disable();

  if (!getProperty("separateWordsWithSpace")) {
    setWordSeparator("");
  }

  sequenceNumber = getProperty("sequenceNumberStart");

  // if (!((programName.length >= 2) && (isAlpha(programName[0]) || (programName[0] == "_")) && isAlpha(programName[1]))) {
  //   error(localize("Program name must begin with 2 letters."));
  // }
  writeln("; %_N_" + translateText(String(programName).toUpperCase(), " ", "_") + "_MPF");

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

  if ((getNumberOfSections() > 0) && (getSection(0).workOffset == 0)) {
    for (var i = 0; i < getNumberOfSections(); ++i) {
      if (getSection(i).workOffset > 0) {
        error(localize("Using multiple work offsets is not possible if the initial work offset is 0."));
        return;
      }
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
        var comment = "T" + toolFormat.format(tool.number) + " " +
          (tool.diameter != 0 ? "D=" + spatialFormat.format(tool.diameter) + " " : "") +
          (tool.isTurningTool() ? localize("NR") + "=" + spatialFormat.format(tool.noseRadius) : localize("CR") + "=" + spatialFormat.format(tool.cornerRadius)) +
          (tool.taperAngle > 0 && (tool.taperAngle < Math.PI) ? " " + localize("TAPER") + "=" + taperFormat.format(tool.taperAngle) + localize("deg") : "") +
          (zRanges[tool.number] ? " - " + localize("ZMIN") + "=" + spatialFormat.format(zRanges[tool.number].getMinimum()) : "") +
          " - " + localize(getToolTypeName(tool.type));
        writeComment(comment);
      }
    }
  }

  // absolute coordinates and feed per min
  writeBlock(gAbsIncModal.format(90), getCode("FEED_MODE_UNIT_MIN"), gPlaneModal.format(18));

  switch (unit) {
  case IN:
    writeBlock(gUnitModal.format(70));
    break;
  case MM:
    writeBlock(gUnitModal.format(71));
    break;
  }

  if (getProperty("maximumSpindleSpeed") > 0) {
    writeBlock("LIMS=" + rpmFormat.format(getProperty("maximumSpindleSpeed")));
  }

  onCommand(COMMAND_START_CHIP_TRANSPORT);
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

function forceFeed() {
  currentFeedId = undefined;
  feedOutput.reset();
}

/** Force output of X, Y, Z, and F on next output. */
function forceAny() {
  forceXYZ();
  forceFeed();
}

function formatFeedMode(mode) {
  var fMode = (mode == FEED_PER_REVOLUTION) ? getCode("FEED_MODE_UNIT_REV") : getCode("FEED_MODE_UNIT_MIN");
  if (fMode) {
    if (mode == FEED_PER_REVOLUTION) {
      feedFormat = createFormat({inherit:fprFormat});
      feedOutput = createVariable({prefix:"F"}, feedFormat);
    } else {
      feedFormat = createFormat({inherit:fpmFormat});
      feedOutput = createVariable({prefix:"F"}, feedFormat);
    }
  }
  return fMode;
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
        return "F=R" + (firstFeedParameter + feedContext.id);
      }
    }
    currentFeedId = undefined; // force Q feed next time
  }
  if (gFeedModeModal.getCurrent() == fprCode) {
    f = (feedFormat.format(f) <= 0) ? (Math.pow(10, feedFormat.getNumberOfDecimals() * -1)) : f;
  }
  return feedOutput.format(f); // use feed value
}

function initializeActiveFeeds() {
  activeMovements = new Array();
  var movements = currentSection.getMovements();
  var feedPerRev = currentSection.feedMode == FEED_PER_REVOLUTION;

  var id = 0;
  var activeFeeds = new Array();
  if (hasParameter("operation:tool_feedCutting")) {
    if (movements & ((1 << MOVEMENT_CUTTING) | (1 << MOVEMENT_LINK_TRANSITION) | (1 << MOVEMENT_EXTENDED))) {
      var feedContext = new FeedContext(id, localize("Cutting"), feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_CUTTING] = feedContext;
      activeMovements[MOVEMENT_LINK_TRANSITION] = feedContext;
      activeMovements[MOVEMENT_EXTENDED] = feedContext;
    }
    ++id;
    if (movements & (1 << MOVEMENT_PREDRILL)) {
      feedContext = new FeedContext(id, localize("Predrilling"), feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"));
      activeMovements[MOVEMENT_PREDRILL] = feedContext;
      activeFeeds.push(feedContext);
    }
    ++id;
  }

  if (hasParameter("operation:finishFeedrate")) {
    if (movements & (1 << MOVEMENT_FINISH_CUTTING)) {
      var finishFeedrateRel;
      if (hasParameter("operation:finishFeedrateRel")) {
        finishFeedrateRel = getParameter("operation:finishFeedrateRel");
      } else if (hasParameter("operation:finishFeedratePerRevolution")) {
        finishFeedrateRel = getParameter("operation:finishFeedratePerRevolution");
      }
      var feedContext = new FeedContext(id, localize("Finish"), feedPerRev ? finishFeedrateRel : getParameter("operation:finishFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_FINISH_CUTTING] = feedContext;
    }
    ++id;
  } else if (hasParameter("operation:tool_feedCutting")) {
    if (movements & (1 << MOVEMENT_FINISH_CUTTING)) {
      var feedContext = new FeedContext(id, localize("Finish"), feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_FINISH_CUTTING] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedEntry")) {
    if (movements & (1 << MOVEMENT_LEAD_IN)) {
      var feedContext = new FeedContext(id, localize("Entry"), feedPerRev ? getParameter("operation:tool_feedEntryRel") : getParameter("operation:tool_feedEntry"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LEAD_IN] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedExit")) {
    if (movements & (1 << MOVEMENT_LEAD_OUT)) {
      var feedContext = new FeedContext(id, localize("Exit"), feedPerRev ? getParameter("operation:tool_feedExitRel") : getParameter("operation:tool_feedExit"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LEAD_OUT] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:noEngagementFeedrate")) {
    if (movements & (1 << MOVEMENT_LINK_DIRECT)) {
      var feedContext = new FeedContext(id, localize("Direct"), feedPerRev ? getParameter("operation:noEngagementFeedrateRel") : getParameter("operation:noEngagementFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LINK_DIRECT] = feedContext;
    }
    ++id;
  } else if (hasParameter("operation:tool_feedCutting") &&
             hasParameter("operation:tool_feedEntry") &&
             hasParameter("operation:tool_feedExit")) {
    if (movements & (1 << MOVEMENT_LINK_DIRECT)) {
      var feedContext = new FeedContext(
        id,
        localize("Direct"),
        Math.max(
          feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"),
          feedPerRev ? getParameter("operation:tool_feedEntryRel") : getParameter("operation:tool_feedEntry"),
          feedPerRev ? getParameter("operation:tool_feedExitRel") : getParameter("operation:tool_feedExit")
        )
      );
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LINK_DIRECT] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:reducedFeedrate")) {
    if (movements & (1 << MOVEMENT_REDUCED)) {
      var feedContext = new FeedContext(id, localize("Reduced"), feedPerRev ? getParameter("operation:reducedFeedrateRel") : getParameter("operation:reducedFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_REDUCED] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedRamp")) {
    if (movements & ((1 << MOVEMENT_RAMP) | (1 << MOVEMENT_RAMP_HELIX) | (1 << MOVEMENT_RAMP_PROFILE) | (1 << MOVEMENT_RAMP_ZIG_ZAG))) {
      var feedContext = new FeedContext(id, localize("Ramping"), feedPerRev ? getParameter("operation:tool_feedRampRel") : getParameter("operation:tool_feedRamp"));
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
      var feedContext = new FeedContext(id, localize("Plunge"), feedPerRev ? getParameter("operation:tool_feedPlungeRel") : getParameter("operation:tool_feedPlunge"));
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
    writeBlock("R" + (firstFeedParameter + feedContext.id) + "=" + feedFormat.format(feedContext.feed), formatComment(feedContext.description));
  }
}

function getSpindle() {
  if (getNumberOfSections() == 0) {
    return SPINDLE_PRIMARY;
  }
  if (getCurrentSectionId() < 0) {
    return getSection(getNumberOfSections() - 1).spindle == 0;
  }
  if (currentSection.getType() == TYPE_TURNING) {
    return currentSection.spindle;
  } else {
    if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1))) {
      return SPINDLE_PRIMARY;
    } else if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, -1))) {
      if (!gotSecondarySpindle) {
        error(localize("Secondary spindle is not available."));
      }
      return SPINDLE_SECONDARY;
    } else {
      return SPINDLE_PRIMARY;
    }
  }
}

function ToolingData(_tool) {
  switch (_tool.turret) {
  // Positional Turret
  case 0:
    this.tooling = TURRET;
    this.toolPost = REAR;
    break;
  // QCTP X-
  case 101:
    this.tooling = QCTP;
    this.toolPost = FRONT;
    break;
  // QCTP X+
  case 102:
    this.tooling = QCTP;
    this.toolPost = REAR;
    break;
  // Gang Tooling X-
  case 103:
    this.tooling = GANG;
    this.toolPost = FRONT;
    break;
  // Gang Tooling X+
  case 104:
    this.tooling = GANG;
    this.toolPost = REAR;
    break;
  default:
    error(localize("Turret number must be 0 (main turret), 101 (QCTP X-), 102 (QCTP X+, 103 (gang tooling X-), or 104 (gang tooling X+)."));
    break;
  }
  this.number = _tool.number;
  this.comment = _tool.comment;
  this.toolLength = _tool.bodyLength;
  // HSMWorks returns 0 in tool.bodyLength
  if ((tool.bodyLength == 0) && hasParameter("operation:tool_bodyLength")) {
    this.toolLength = getParameter("operation:tool_bodyLength");
  }
}

function setDirectionX() {
  xFormat.setScale(toolingData.toolPost == FRONT ? Math.abs(xFormat.getScale()) * -1 : Math.abs(xFormat.getScale()));
  iFormat.setScale(toolingData.toolPost == FRONT ? Math.abs(iFormat.getScale()) * -1 : Math.abs(iFormat.getScale()));
  xOutput = createVariable({onchange:function() {retracted[X] = false;}, prefix:"X"}, xFormat);
  iOutput = createReferenceVariable({prefix:"I"}, iFormat);
}

function onSection() {
  if (currentSection.getType() != TYPE_TURNING) {
    if (!hasParameter("operation-strategy") || (getParameter("operation-strategy") != "drill")) {
      if (currentSection.getType() == TYPE_MILLING) {
        error(localize("Milling toolpath is not supported."));
      } else {
        error(localize("Non-turning toolpath is not supported."));
      }
      return;
    }
  }

  var forceToolAndRetract = optionalSection && !currentSection.isOptional();
  optionalSection = currentSection.isOptional();

  var turning = (currentSection.getType() == TYPE_TURNING);

  var insertToolCall = forceToolAndRetract || isFirstSection() ||
    currentSection.getForceToolChange && currentSection.getForceToolChange() ||
    (tool.number != getPreviousSection().getTool().number) ||
    (tool.compensationOffset != getPreviousSection().getTool().compensationOffset) ||
    (tool.diameterOffset != getPreviousSection().getTool().diameterOffset) ||
    (tool.lengthOffset != getPreviousSection().getTool().lengthOffset);

  var newSpindle = isFirstSection() ||
    (getPreviousSection().spindle != currentSection.spindle);
  var newWorkOffset = isFirstSection() ||
    (getPreviousSection().workOffset != currentSection.workOffset); // work offset changes

  // determine which tooling holder is used
  if (!isFirstSection()) {
    previousToolingData = toolingData;
  }
  toolingData = new ToolingData(tool);
  toolingData.operationComment = "";
  if (hasParameter("operation-comment")) {
    toolingData.operationComment = getParameter("operation-comment");
  }
  toolingData.toolChange = insertToolCall;
  if (isFirstSection()) {
    previousToolingData = toolingData;
  }

  tapping = hasParameter("operation:cycleType") &&
    ((getParameter("operation:cycleType") == "tapping") ||
     (getParameter("operation:cycleType") == "right-tapping") ||
     (getParameter("operation:cycleType") == "left-tapping") ||
     (getParameter("operation:cycleType") == "tapping-with-chip-breaking"));

  setDirectionX();

  if (insertToolCall || newSpindle || newWorkOffset) {
    // retract to safe plane
    if (!isFirstSection() && insertToolCall) {
      onCommand(COMMAND_COOLANT_OFF);
    }
    writeRetract();
    forceXYZ();
  }

  writeln("");

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
      for (var line in lines) {
        var comment = lines[line].replace(r1, "").replace(r2, "");
        if (comment) {
          writeComment(comment);
        }
      }
    }
  }

  if (insertToolCall) {

    if (!isFirstSection() && getProperty("optionalStop")) {
      onCommand(COMMAND_OPTIONAL_STOP);
    }

    if (tool.number > 99) {
      warning(localize("Tool number exceeds maximum value."));
    }

    if ((toolingData.tooling == QCTP) || tool.getManualToolChange()) {
      var comment = formatComment(localize("CHANGE TO T") + tool.number + " " + localize("ON") + " " +
        localize((toolingData.toolPost == REAR) ? "REAR TOOL POST" : "FRONT TOOL POST"));
      writeBlock(mFormat.format(0), comment);
    }

    var compensationOffset = 1; // optional, use tool.isTurningTool() ? tool.compensationOffset : tool.lengthOffset
    if (compensationOffset > 99) {
      error(localize("Compensation offset is out of range."));
      return;
    }
    writeBlock("T" + toolFormat.format(tool.number), dFormat.format(compensationOffset));
    if (tool.comment) {
      writeComment(tool.comment);
    }
  }

  // wcs
  if (insertToolCall) { // force work offset when changing tool
    currentWorkOffset = undefined;
  }

  if (currentSection.workOffset != currentWorkOffset) {
    writeBlock(currentSection.wcs);
    currentWorkOffset = currentSection.workOffset;
  }

  // set coolant after we have positioned at Z
  setCoolant(tool.coolant);

  forceAny();
  gMotionModal.reset();

  gFeedModeModal.reset();

  writeBlock(formatFeedMode(currentSection.feedMode));

  if (gotTailStock) {
    writeBlock(getCode(currentSection.tailstock ? "TAILSTOCK_ON" : "TAILSTOCK_OFF"));
  }

  // writeBlock(mFormat.format(clampPrimaryChuck ? x : x));
  // writeBlock(mFormat.format(clampSecondaryChuck ? x : x));

  var initialPosition = getFramePosition(currentSection.getInitialPosition());
  var spindleChanged = forceSpindleSpeed || newSpindle || isSpindleSpeedDifferent();
  if (insertToolCall || spindleChanged) {
    forceSpindleSpeed = false;
    startSpindle(false, true, initialPosition);
  }

  setRotation(currentSection.workPlane);

  if (currentSection.partCatcher) {
    engagePartCatcher(true);
  }

  gMotionModal.reset();

  if (insertToolCall || tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {

    writeBlock(
      gAbsIncModal.format(90),
      gMotionModal.format(0), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y), zOutput.format(initialPosition.z)
    );

    gMotionModal.reset();
  }

  // enable SFM spindle speed
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    startSpindle(false, false);
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

function onDwell(seconds) {
  if (seconds > 99999.999) {
    warning(localize("Dwelling time is out of range."));
  }
  writeBlock(gFormat.format(4), "F" + secFormat.format(seconds));
}

var pendingRadiusCompensation = -1;

function onRadiusCompensation() {
  pendingRadiusCompensation = radiusCompensation;
}

var resetFeed = false;

function onRapid(_x, _y, _z) {
  // don't output starts for threading
  if (threadNumber > 0) {
    return;
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      switch (radiusCompensation) {
      case RADIUS_COMPENSATION_LEFT:
        writeBlock(gMotionModal.format(0), gFormat.format(41), x, y, z);
        break;
      case RADIUS_COMPENSATION_RIGHT:
        writeBlock(gMotionModal.format(0), gFormat.format(42), x, y, z);
        break;
      default:
        writeBlock(gMotionModal.format(0), gFormat.format(40), x, y, z);
      }
    } else {
      writeBlock(gMotionModal.format(0), x, y, z);
    }
    forceFeed();
  }
}

function onLinear(_x, _y, _z, feed) {
  // don't output starts for threading
  if (threadNumber > 0) {
    return;
  }
  if (isSpeedFeedSynchronizationActive()) {
    resetFeed = true;
    var threadPitch = getParameter("operation:threadPitch");
    var threadsPerInch = 1.0 / threadPitch; // per mm for metric
    writeBlock(gMotionModal.format(33), xOutput.format(_x), yOutput.format(_y), zOutput.format(_z), pitchOutput.format(1 / threadsPerInch));
    return;
  }
  if (resetFeed) {
    resetFeed = false;
    forceFeed();
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var f = getFeed(feed);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      writeBlock(gPlaneModal.format(18));
      switch (radiusCompensation) {
      case RADIUS_COMPENSATION_LEFT:
        writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), gFormat.format(41), x, y, z, f);
        break;
      case RADIUS_COMPENSATION_RIGHT:
        writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), gFormat.format(42), x, y, z, f);
        break;
      default:
        writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), gFormat.format(40), x, y, z, f);
      }
    } else {
      writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), x, y, z, f);
    }
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      forceFeed(); // force feed on next line
    } else {
      writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), f);
    }
  }
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  if (isSpeedFeedSynchronizationActive()) {
    error(localize("Speed-feed synchronization is not supported for circular moves."));
    return;
  }

  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
    return;
  }

  var start = getCurrentPosition();
  var directionCode = (toolingData.toolPost == REAR) ? (clockwise ? 2 : 3) : (clockwise ? 3 : 2);

  if (isFullCircle()) {
    if (getProperty("useRadius") || isHelical()) { // radius mode does not support full arcs
      linearize(tolerance);
      return;
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gAbsIncModal.format(90), gPlaneModal.format(17), gMotionModal.format(directionCode), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), getFeed(feed));
      break;
    case PLANE_ZX:
      writeBlock(gAbsIncModal.format(90), gPlaneModal.format(18), gMotionModal.format(directionCode), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    case PLANE_YZ:
      writeBlock(gAbsIncModal.format(90), gPlaneModal.format(19), gMotionModal.format(directionCode), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  } else if (!getProperty("useRadius")) {
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gAbsIncModal.format(90), gPlaneModal.format(17), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), getFeed(feed));
      break;
    case PLANE_ZX:
      writeBlock(gAbsIncModal.format(90), gPlaneModal.format(18), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    case PLANE_YZ:
      writeBlock(gAbsIncModal.format(90), gPlaneModal.format(19), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  } else { // use radius mode
    var r = getCircularRadius();
    if (toDeg(getCircularSweep()) > (180 + 1e-9)) {
      r = -r; // allow up to <360 deg arcs
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gPlaneModal.format(17), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), "CR=" + rFormat.format(r), getFeed(feed));
      break;
    case PLANE_ZX:
      writeBlock(gPlaneModal.format(18), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), "CR=" + rFormat.format(r), getFeed(feed));
      break;
    case PLANE_YZ:
      writeBlock(gPlaneModal.format(19), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), "CR=" + rFormat.format(r), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  }
}

var expandCurrentCycle = false;

function onCycle() {

  expandCurrentCycle = false;

  if (cycleType != "thread-turning") {
    if (!getProperty("useCycles")) {
      expandCurrentCycle = true;
      return;
    }
  }

  if ((cycleType != "tapping") &&
      (cycleType != "right-tapping") &&
      (cycleType != "left-tapping") &&
      (cycleType != "turning-canned-rough") &&
      (cycleType != "thread-turning")) {
    writeBlock(feedOutput.format(cycle.feedrate));
  }

  var RTP = cycle.clearance; // return plane (absolute)
  var RFP = cycle.stock; // reference plane (absolute)
  var SDIS = cycle.retract - cycle.stock; // safety distance
  var DP = cycle.bottom; // depth (absolute)
  // var DPR = RFP - cycle.bottom; // depth (relative to reference plane)
  var DTB = cycle.dwell;
  var SDIR = tool.clockwise ? 3 : 4; // direction of rotation: M3:3 and M4:4

  switch (cycleType) {
  case "drilling":
    writeBlock(
      "CYCLE81(" + zFormat.format(RTP) +
      ", " + zFormat.format(RFP) +
      ", " + zFormat.format(SDIS) +
      ", " + zFormat.format(DP) +
      ", " /*+ zFormat.format(DPR)*/ + ")"
    );
    break;
  case "counter-boring":
    writeBlock(
      "CYCLE82(" + zFormat.format(RTP) +
      ", " + zFormat.format(RFP) +
      ", " + zFormat.format(SDIS) +
      ", " + zFormat.format(DP) +
      ", " /*+ zFormat.format(DPR)*/ +
      ", " + conditional(DTB > 0, secFormat.format(DTB)) + ")"
    );
    break;
  case "chip-breaking":
    if (cycle.accumulatedDepth < cycle.depth) {
      expandCurrentCycle = true;
    } else {
      var FDEP = cycle.stock - cycle.incrementalDepth;
      var FDPR = cycle.incrementalDepth; // relative to reference plane (unsigned)
      var DAM = 0; // degression (unsigned)
      var DTS = 0; // dwell time at start
      var FRF = 1; // feedrate factor (unsigned)
      var VARI = 0; // chip breaking
      var _AXN = 3; // tool axis
      var _MDEP = cycle.incrementalDepth; // minimum drilling depth
      var _VRT = 0; // retraction distance
      var _DTD = (cycle.dwell != undefined) ? cycle.dwell : 0;
      var _DIS1 = 0; // limit distance

      writeBlock(
        "CYCLE83(" + zFormat.format(RTP) +
        ", " + zFormat.format(RFP) +
        ", " + zFormat.format(SDIS) +
        ", " + zFormat.format(DP) +
        ", " /*+ zFormat.format(DPR)*/ +
        ", " + zFormat.format(FDEP) +
        ", " /*+ zFormat.format(FDPR)*/ +
        ", " + zFormat.format(DAM) +
        ", " + /*conditional(DTB > 0, secFormat.format(DTB))*/ // only dwell at bottom
        ", " + conditional(DTS > 0, secFormat.format(DTS)) +
        ", " + zFormat.format(FRF) +
        ", " + zFormat.format(VARI) +
        ", " + /*_AXN +*/
        ", " + zFormat.format(_MDEP) +
        ", " + zFormat.format(_VRT) +
        ", " + secFormat.format(_DTD) +
        ", 0" + /*zFormat.format(_DIS1) +*/
        ")"
      );
    }
    break;
  case "deep-drilling":
    var FDEP = cycle.stock - cycle.incrementalDepth;
    var FDPR = cycle.incrementalDepth; // relative to reference plane (unsigned)
    var DAM = 0; // degression (unsigned)
    var DTS = 0; // dwell time at start
    var FRF = 1; // feedrate factor (unsigned)
    var VARI = 1; // full retract
    var _MDEP = cycle.incrementalDepth; // minimum drilling depth
    var _VRT = 0; // retraction distance
    var _DTD = (cycle.dwell != undefined) ? cycle.dwell : 0;
    var _DIS1 = 0; // limit distance

    writeBlock(
      "CYCLE83(" + zFormat.format(RTP) +
      ", " + zFormat.format(RFP) +
      ", " + zFormat.format(SDIS) +
      ", " + zFormat.format(DP) +
      ", " /*+ zFormat.format(DPR)*/ +
      ", " + zFormat.format(FDEP) +
      ", " /*+ zFormat.format(FDPR)*/ +
      ", " + zFormat.format(DAM) +
      ", " + /*conditional(DTB > 0, secFormat.format(DTB)) +*/ // only dwell at bottom
      ", " + conditional(DTS > 0, secFormat.format(DTS)) +
      ", " + zFormat.format(FRF) +
      ", " + zFormat.format(VARI) +
      ", " + /*_AXN +*/
      ", " + zFormat.format(_MDEP) +
      ", " + zFormat.format(_VRT) +
      ", " + secFormat.format(_DTD) +
      ", 0" + /*zFormat.format(_DIS1) +*/
      ")"
    );
    break;
  case "tapping":
  case "left-tapping":
  case "right-tapping":
    var SDAC = SDIR; // direction of rotation after end of cycle
    var MPIT = 0; // thread pitch as thread size
    var PIT = ((tool.type == TOOL_TAP_LEFT_HAND) ? -1 : 1) * tool.threadPitch; // thread pitch
    var POSS = 0; // spindle position for oriented spindle stop in cycle (in degrees)
    var SST = spindleSpeed; // speed for tapping
    var SST1 = spindleSpeed; // speed for return
    writeBlock(
      "CYCLE84(" + zFormat.format(RTP) +
      ", " + zFormat.format(RFP) +
      ", " + zFormat.format(SDIS) +
      ", " + zFormat.format(DP) +
      ", " /*+ zFormat.format(DPR)*/ +
      ", " + conditional(DTB > 0, secFormat.format(DTB)) +
      ", " + zFormat.format(SDAC) +
      ", " /*+ zFormat.format(MPIT)*/ +
      ", " + zFormat.format(PIT) +
      ", " + zFormat.format(POSS) +
      ", " + zFormat.format(SST) +
      ", " + zFormat.format(SST1) + ")"
    );
    break;
  case "reaming":
    var FFR = cycle.feedrate;
    var RFF = cycle.retractFeedrate;
    writeBlock(
      "CYCLE85(" + zFormat.format(RTP) +
      ", " + zFormat.format(RFP) +
      ", " + zFormat.format(SDIS) +
      ", " + zFormat.format(DP) +
      ", " /*+ zFormat.format(DPR)*/ +
      ", " + conditional(DTB > 0, secFormat.format(DTB)) +
      ", " + zFormat.format(FFR) +
      ", " + zFormat.format(RFF) + ")"
    );
    break;
  case "stop-boring":
    if (cycle.dwell > 0) {
      expandCurrentCycle = true;
    } else {
      writeBlock(
        "CYCLE87(" + zFormat.format(RTP) +
        ", " + zFormat.format(RFP) +
        ", " + zFormat.format(SDIS) +
        ", " + zFormat.format(DP) +
        ", " /*+ zFormat.format(DPR)*/ +
        ", " + SDIR + ")"
      );
    }
    break;
  case "fine-boring":
    var RPA = 0; // return path in abscissa of the active plane (enter incrementally with)
    var RPO = 0; // return path in the ordinate of the active plane (enter incrementally sign)
    var RPAP = 0; // return plane in the applicate (enter incrementally with sign)
    var POSS = 0; // spindle position for oriented spindle stop in cycle (in degrees)
    writeBlock(
      "CYCLE86(" + zFormat.format(RTP) +
      ", " + zFormat.format(RFP) +
      ", " + zFormat.format(SDIS) +
      ", " + zFormat.format(DP) +
      ", " /*+ zFormat.format(DPR)*/ +
      ", " + conditional(DTB > 0, secFormat.format(DTB)) +
      ", " + SDIR +
      ", " + zFormat.format(RPA) +
      ", " + zFormat.format(RPO) +
      ", " + zFormat.format(RPAP) +
      ", " + zFormat.format(POSS) + ")"
    );
    break;
  case "boring":
    // retract feed is ignored
    writeBlock(
      "CYCLE89(" + zFormat.format(RTP) +
      ", " + zFormat.format(RFP) +
      ", " + zFormat.format(SDIS) +
      ", " + zFormat.format(DP) +
      ", " /*+ zFormat.format(DPR)*/ +
      ", " + conditional(DTB > 0, secFormat.format(DTB)) + ")"
    );
    break;
  default:
    if (tapping) {
      error(localize("Tapping cycles cannot be expanded."));
      return;
    }
    expandCurrentCycle = true;
  }
  if (!expandCurrentCycle) {
    xOutput.reset();
    yOutput.reset();
  }
}

function getThreadStockPoints(x, y, z) {
  // check for parameters
  if (!hasParameter("operation:threadDepth") ||
      !hasParameter("operation:stockOffsetBack") ||
      !hasParameter("operation:stockOffsetFront")) {
    error(localize("Mandatory cycle property not defined."));
    return undefined;
  }

  // calculate axial and radial offset directions
  var axialOffset = new Vector(-cycle.incrementalX, 0, -cycle.incrementalZ);
  var axialDirection = axialOffset.getNormalized();
  var radialDirection = new Vector(1, 0, 0);

  // get required parameters
  var threadHeight = getParameter("operation:threadDepth");
  var backOffset = getParameter("operation:stockOffsetBack") / axialDirection.z;
  var frontOffset = getParameter("operation:stockOffsetFront") / axialDirection.z;
  var lengthOfCut = (axialOffset.length - (backOffset + frontOffset));

  // final position at depth of threading moves
  var endPoint = new Vector(x, y, z);

  // calculate top of stock points
  var stockEnd = Vector.sum(endPoint, Vector.product(axialDirection, backOffset));
  var stockPoint = {};
  stockPoint.second = Vector.sum(stockEnd, Vector.product(radialDirection, threadHeight));
  stockPoint.first = Vector.sum(stockPoint.second, Vector.product(axialDirection, lengthOfCut));
  return stockPoint;
}

var threadNumber = 0;
function onCyclePoint(x, y, z) {
  if (tapping && !getProperty("useCycles")) {
    error(localize("Tapping cycles cannot be expanded."));
    return;
  }
  switch (cycleType) {
  case "thread-turning":
    if (isFirstCyclePoint()) {
      // increment thread number for multiple threads
      threadNumber += 1;
    }
    var numberOfThreads = 1;
    if ((hasParameter("operation:doMultipleThreads") && (getParameter("operation:doMultipleThreads") != 0))) {
      numberOfThreads = getParameter("operation:numberOfThreads");
    }
    if (isLastCyclePoint() && threadNumber == numberOfThreads) {
      var threadInfeedMode = "constant";
      if (hasParameter("operation:infeedMode")) {
        threadInfeedMode = getParameter("operation:infeedMode");
      }

      // thread height and depth of cut
      var threadHeight = getParameter("operation:threadDepth");
      var steps = getParameter("operation:numberOfStepdowns");
      var repeatPass = hasParameter("operation:nullPass") ? getParameter("operation:nullPass") : 0;
      var chamferWidth = 0; // Pullout-width is 1*thread-lead in 1/10's; // Math.round((threadHeight * 10) / cycle.pitch) // calculated for 45 degrees.
      var materialAllowance = 0; // Material allowance for finishing pass
      var cuttingAngle = 30; // Angle is not stored with tool. toDeg(tool.getTaperAngle());
      if (hasParameter("operation:infeedAngle")) {
        cuttingAngle = getParameter("operation:infeedAngle");
      }
      var id = hasParameter("operation:machineInside") && getParameter("operation:machineInside") == 1;

      // start and end of thread on physical part
      var stockPoints = getThreadStockPoints(x, y, z);

      var MPIT = "";
      var SPL = stockPoints.first.z;
      var FPL = stockPoints.second.z;
      var DM1 = stockPoints.first.x;
      var DM2 = stockPoints.second.x;
      var APP = getParameter("operation:stockOffsetFront");
      var ROP = chamferWidth;
      var TDEP = threadHeight;
      var FAL = materialAllowance;
      var NSP = 0;
      var NRC = steps;
      var NID = repeatPass;
      var VARI = 1 + (id ? 1 : 0) + (threadInfeedMode != "constant" ? 2 : 0);
      var NUMT = numberOfThreads;

      if (getProperty("threadCycleType") == "CYCLE97") {
        var PIT = cycle.pitch; // cycle97
        var IANG = cuttingAngle * (threadInfeedMode == "alternate" ? -1 : 1); // cycle97
        writeBlock(
          "CYCLE97(" +
          formatCSV(
            spatialFormat.format(PIT),
            MPIT,
            spatialFormat.format(SPL),
            spatialFormat.format(FPL),
            xFormat.format(DM1),
            xFormat.format(DM2),
            spatialFormat.format(APP),
            spatialFormat.format(ROP),
            spatialFormat.format(TDEP),
            spatialFormat.format(FAL),
            spatialFormat.format(IANG),
            spatialFormat.format(NSP),
            integerFormat.format(NRC),
            integerFormat.format(NID),
            integerFormat.format(VARI),
            integerFormat.format(NUMT)
          )
          + ")"
        );

      } else {
        if (threadInfeedMode == "alternate") {
          error(localize("Alternate infeed mode is not supported by Cycle99."));
          return;
        }
        var PIT = unit == MM ? cycle.pitch : 1 / cycle.pitch; // cycle99
        var IANG = cuttingAngle * -1; // cycle99
        var PITA = unit == MM ? 1 : 2; // cycle99
        var _VRT = Math.abs(cycle.clearance - x) + threadHeight; // cycle99
        var INT = !xFormat.areDifferent(cycle.incrementalX, 0) ? 0 : (!zFormat.areDifferent(cycle.incrementalZ, 0) ? 10 : 20); // cycle99

        writeBlock(
          "CYCLE99(" +
          formatCSV(
            spatialFormat.format(SPL),
            xFormat.format(DM1),
            spatialFormat.format(FPL),
            xFormat.format(DM2),
            spatialFormat.format(APP),
            spatialFormat.format(ROP),
            spatialFormat.format(TDEP),
            spatialFormat.format(FAL),
            spatialFormat.format(IANG),
            spatialFormat.format(NSP),
            integerFormat.format(NRC),
            integerFormat.format(NID),
            spatialFormat.format(PIT),
            integerFormat.format(VARI + 300100),
            integerFormat.format(NUMT),
            spatialFormat.format(_VRT),
            integerFormat.format(0),
            integerFormat.format(0),
            integerFormat.format(0),
            integerFormat.format(0),
            integerFormat.format(0),
            integerFormat.format(0),
            integerFormat.format(0),
            integerFormat.format(PITA),
            "",
            "",
            "",
            integerFormat.format(INT)
          )
          + ")"
        );
      }

      threadNumber = 0;

    }
    return;
  }

  if (!expandCurrentCycle) {
    var _x = xOutput.format(x);
    var _y = yOutput.format(y);
    /*zOutput.format(z)*/
    if (_x || _y) {
      writeBlock(_x, _y);
    }
  } else {
    expandCyclePoint(x, y, z);
  }
}

function onCycleEnd() {
  if (!expandCurrentCycle) {
    // end modal cycle
  }
  zOutput.reset();
}

var saveShowSequenceNumbers = true;
var pathBlockNumber = {start:0, end:0};

function onCyclePath() {
  saveShowSequenceNumbers = getProperty("showSequenceNumbers");

  // buffer all paths and stop feeds being output
  feedOutput.disable();
  setProperty("showSequenceNumbers", false);
  redirectToBuffer();
  //Adding indice in cases of multiple canned cycles calls
  writeBlock("START" + integerFormat.format(currentSection.getId()) + ":");
  gMotionModal.reset();
  forceXYZ();
}

function onCyclePathEnd() {
  writeBlock("END" + integerFormat.format(currentSection.getId()) + ":");
  setProperty("showSequenceNumbers", saveShowSequenceNumbers); // reset property to initial state
  feedOutput.enable();
  var cyclePath = String(getRedirectionBuffer()).split(EOL); // get cycle path from buffer
  closeRedirection();
  for (var line in cyclePath) { // remove empty elements
    if (cyclePath[line] == "") {
      cyclePath.splice(line);
    }
  }

  var outsideProfiling = cycle.turningMode == 0;
  var verticalPasses;
  if (cycle.profileRoughingCycle == 0) {
    verticalPasses = false;
  } else if (cycle.profileRoughingCycle == 1) {
    verticalPasses = true;
  } else {
    error(localize("Unsupported passes type."));
    return;
  }

  // output cycle data
  switch (cycleType) {
  case "turning-canned-rough":
    var NPP = "\"" + "START" + integerFormat.format(currentSection.getId()) + ":END" + integerFormat.format(currentSection.getId()) + "\""; // Name of contour subroutine
    var MID = spatialFormat.format(cycle.depthOfCut); // Infeed depth (enter without sign)
    //Siemens doesn't use sign for allowance
    var FALZ = Math.abs(spatialFormat.format(cycle.zStockToLeave)); // Finishing allowance in the longitudinal axis (enter without sign)
    var FALX = Math.abs(xFormat.format(cycle.xStockToLeave)); // Finishing allowance in the transverse axis (enter without sign)
    var FAL = 0; // Finishing allowance suitable for contour (enter without sign)
    var FF1 = feedFormat.format(cycle.cutfeedrate); // Feedrate for roughing without relief cut
    var FF2 = feedFormat.format(cycle.cutfeedrate); //Feedrate for plunging into relief cut element
    var FF3 = feedFormat.format(cycle.cutfeedrate); // Feedrate for finishing cut
    var VARI = outsideProfiling ? (verticalPasses ? 2 : 1) : (verticalPasses ? 4 : 3); // Machining typeRange of values: 1 ... 12
    var DT = 0; // Dwell time fore chip breaking when roughing
    var DAM = 0; // Path length after which each roughing step is interrupted for chip breaking
    var _VRT = spatialFormat.format(cycle.retractLength); // Lift-off distance from contour when roughing, incremental (to be entered without sign)

    writeBlock(
      "CYCLE95(" + NPP + ", " + MID + ", " + FALZ + ", " + FALX + ", " + FAL + ", " + FF1 + ", " + FF2 +
        ", " + FF3 + ", " + VARI + ", " + DT + ", " + DAM + ", " + _VRT + ")"
    );
    break;
  default:
    error(localize("Unsupported turning canned cycle."));
  }

  for (var i = 0; i < cyclePath.length; ++i) {
    /*
    if (i == 0 || i == (cyclePath.length - 1)) { // write sequence number on first and last line of the cycle path
      setProperty("showSequenceNumbers", true);
      if ((i == 0 && pathBlockNumber.start != sequenceNumber) || (i == (cyclePath.length - 1) && pathBlockNumber.end != sequenceNumber)) {
        error(localize("Mismatch of start/end block number in turning canned cycle."));
        return;
      }
    }
    */
    writeBlock(cyclePath[i]); // output cycle path
    setProperty("showSequenceNumbers", saveShowSequenceNumbers); // reset property to initial state
  }
}

var currentCoolantMode = COOLANT_OFF;
var coolantOff = undefined;
var forceCoolant = false;

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
  if (coolant == currentCoolantMode && !forceCoolant) {
    return undefined; // coolant is already active
  }
  if ((coolant != COOLANT_OFF) && (currentCoolantMode != COOLANT_OFF) && (coolantOff != undefined) && !forceCoolant) {
    if (Array.isArray(coolantOff)) {
      for (var i in coolantOff) {
        multipleCoolantBlocks.push(coolantOff[i]);
      }
    } else {
      multipleCoolantBlocks.push(coolantOff);
    }
  }

  forceCoolant = false;

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

function onSpindleSpeed(spindleSpeed) {
  if (rpmFormat.areDifferent(spindleSpeed, sOutput.getCurrent())) {
    startSpindle(false, false, getFramePosition(currentSection.getInitialPosition()), spindleSpeed);
  }
}

function startSpindle(tappingMode, forceRPMMode, initialPosition, rpm) {
  var spindleDir;
  var spindleMode;
  var _spindleSpeed = spindleSpeed;
  if (rpm !== undefined) {
    _spindleSpeed = rpm;
  }
  var maxSpeed = "";
  gSpindleModeModal.reset();

  if ((getSpindle() == SPINDLE_SECONDARY) && !gotSecondarySpindle) {
    error(localize("Secondary spindle is not available."));
    return;
  }

  if (false /*tappingMode*/) {
    spindleDir = getCode("RIGID_TAPPING");
  } else {
    if (getSpindle() == SPINDLE_SECONDARY) {
      spindleDir = tool.clockwise ? getCode("START_SUB_SPINDLE_CW") : getCode("START_SUB_SPINDLE_CCW");
    } else {
      spindleDir = tool.clockwise ? getCode("START_MAIN_SPINDLE_CW") : getCode("START_MAIN_SPINDLE_CCW");
    }
  }

  var maximumSpindleSpeed = (tool.maximumSpindleSpeed > 0) ? Math.min(tool.maximumSpindleSpeed, getProperty("maximumSpindleSpeed")) : getProperty("maximumSpindleSpeed");
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    _spindleSpeed = tool.surfaceSpeed * ((unit == MM) ? 1 / 1000.0 : 1 / 12.0);
    if (forceRPMMode) { // RPM mode is forced until move to initial position
      if (xFormat.getResultingValue(initialPosition.x) == 0) {
        _spindleSpeed = maximumSpindleSpeed;
      } else {
        _spindleSpeed = Math.min((_spindleSpeed * ((unit == MM) ? 1000.0 : 12.0) / (Math.PI * Math.abs(initialPosition.x * 2))), maximumSpindleSpeed);
      }
      spindleMode = getCode("CONSTANT_SURFACE_SPEED_OFF");
    } else {
      spindleMode = getCode("CONSTANT_SURFACE_SPEED_ON");
    }
  } else {
    spindleMode = getCode("CONSTANT_SURFACE_SPEED_OFF");
  }
  if (getSpindle(true) == SPINDLE_SECONDARY) {
    writeBlock(
      spindleMode,
      sOutput.format(_spindleSpeed),
      spindleDir
    );
  } else {
    writeBlock(
      spindleMode,
      sOutput.format(_spindleSpeed),
      spindleDir
    );
  }

  if (currentSection.getTool().getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED && !forceRPMMode) {
    if (maximumSpindleSpeed > 0) {
      writeBlock("LIMS=" + rpmFormat.format(maximumSpindleSpeed));
    }
  }
  // wait for spindle here if required
}

function onCommand(command) {
  switch (command) {
  case COMMAND_COOLANT_OFF:
    setCoolant(COOLANT_OFF);
    break;
  case COMMAND_COOLANT_ON:
    setCoolant(COOLANT_FLOOD);
    break;
  case COMMAND_LOCK_MULTI_AXIS:
    break;
  case COMMAND_UNLOCK_MULTI_AXIS:
    break;
  case COMMAND_START_CHIP_TRANSPORT:
    break;
  case COMMAND_STOP_CHIP_TRANSPORT:
    break;
  case COMMAND_BREAK_CONTROL:
    break;
  case COMMAND_TOOL_MEASURE:
    break;
  case COMMAND_ACTIVATE_SPEED_FEED_SYNCHRONIZATION:
    break;
  case COMMAND_DEACTIVATE_SPEED_FEED_SYNCHRONIZATION:
    break;
  case COMMAND_STOP:
    writeBlock(mFormat.format(0));
    forceSpindleSpeed = true;
    forceCoolant = true;
    break;
  case COMMAND_OPTIONAL_STOP:
    writeBlock(mFormat.format(1));
    forceSpindleSpeed = true;
    forceCoolant = true;
    break;
  case COMMAND_END:
    writeBlock(mFormat.format(2));
    break;
  case COMMAND_SPINDLE_CLOCKWISE:
    switch (currentSection.spindle) {
    case SPINDLE_PRIMARY:
      writeBlock(mFormat.format(3));
      break;
    case SPINDLE_SECONDARY:
      break;
    }
    // writeBlock("M2=3"); // live spindle
    break;
  case COMMAND_SPINDLE_COUNTERCLOCKWISE:
    switch (currentSection.spindle) {
    case SPINDLE_PRIMARY:
      writeBlock(mFormat.format(4));
      break;
    case SPINDLE_SECONDARY:
      break;
    }
    // writeBlock("M2=4"); // live spindle
    break;
  case COMMAND_START_SPINDLE:
    onCommand(tool.clockwise ? COMMAND_SPINDLE_CLOCKWISE : COMMAND_SPINDLE_COUNTERCLOCKWISE);
    return;
  case COMMAND_STOP_SPINDLE:
    switch (currentSection.spindle) {
    case SPINDLE_PRIMARY:
      writeBlock(mFormat.format(5));
      break;
    case SPINDLE_SECONDARY:
      break;
    }
    // writeBlock("M2=5"); // live spindle
    break;
  //case COMMAND_ORIENTATE_SPINDLE:
  //case COMMAND_CLAMP: // TAG: add support for clamping
  //case COMMAND_UNCLAMP: // TAG: add support for clamping
  default:
    onUnsupportedCommand(command);
  }
}

function engagePartCatcher(engage) {
  if (engage) {
    // catch part here
    writeBlock(getCode("PART_CATCHER_ON"), formatComment(localize("PART CATCHER ON")));
  } else {
    onCommand(COMMAND_COOLANT_OFF);
    writeRetract(X);
    writeRetract(Z);
    writeBlock(getCode("PART_CATCHER_OFF"), formatComment(localize("PART CATCHER OFF")));
    forceXYZ();
  }
}

function onSectionEnd() {

  // cancel SFM mode to preserve spindle speed
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    startSpindle(false, true, getFramePosition(currentSection.getFinalPosition()));
  }

  if (currentSection.partCatcher) {
    engagePartCatcher(false);
  }

  forceAny();
}

/** Output block to do safe retract and/or move to home position. */
var XZ = 4;
function writeRetract() {
  var words = []; // store all retracted axes in an array
  var singleLineRetract = false; // enables retract of all axes in a single block
  var retractAxes = []; // axes to retract

  // define home positions
  var _xHome = machineConfiguration.hasHomePositionX() ? machineConfiguration.getHomePositionX() : getProperty("g53HomePositionX");
  var _yHome = machineConfiguration.hasHomePositionY() ? machineConfiguration.getHomePositionY() : toPreciseUnit(0, MM);
  var _zHome = machineConfiguration.getRetractPlane() != 0 ? machineConfiguration.getRetractPlane() : getProperty("g53HomePositionZ");

  if (arguments.length > 0) {
    for (var i in arguments) {
      retractAxes.push(arguments[i]);
      singleLineRetract = arguments[i] == XZ ? true : singleLineRetract;
    }
  } else {
    switch (getProperty("safePositionStyle")) {
    case "X":
      retractAxes.push(X);
      break;
    case "Z":
      retractAxes.push(Z);
      break;
    case "XZ":
      retractAxes.push(X, Z);
      break;
    case "ZX":
      retractAxes.push(Z, X);
      break;
    case "singleLineXZ":
      singleLineRetract = true;
      retractAxes.push(X, Z);
      break;
    }
  }

  // format home positions
  for (var i = 0; i < retractAxes.length; ++i) {
    switch (retractAxes[i]) {
    case X:
      words.push("X" + xFormat.format(_xHome));
      retracted[X] = true;
      xOutput.reset();
      break;
    case Y:
      if (yOutput.isEnabled()) {
        words.push("Y" + yFormat.format(_yHome));
        yOutput.reset();
      }
      break;
    case Z:
      words.push("Z" + zFormat.format(_zHome));
      retracted[Z] = true;
      zOutput.reset();
      break;
    case XZ:
      words.push("X" + xFormat.format(_xHome));
      words.push("Z" + zFormat.format(_zHome));
      retracted[X] = true;
      retracted[Z] = true;
      xOutput.reset();
      zOutput.reset();
      break;
    default:
      error(localize("Unsupported axis specified for writeRetract()."));
      return;
    }
  }

  for (var i = 0; i < words.length; ++i) {
    gMotionModal.reset();
    writeBlock(gFormat.format(53), gMotionModal.format(0), singleLineRetract ? words : words[i]);
    if (singleLineRetract) {
      break;
    }
  }
  singleLineRetract = false; // singleLineRetract reset
}

function onClose() {
  writeln("");

  optionalSection = false;

  onCommand(COMMAND_COOLANT_OFF);

  writeRetract();// change this to writeRetract(XZ) to force retract in XZ at the end of the program as a default

  onImpliedCommand(COMMAND_END);
  onImpliedCommand(COMMAND_STOP_SPINDLE);
  writeBlock(mFormat.format(30)); // stop program, spindle stop, coolant off
}

function setProperty(property, value) {
  properties[property].current = value;
}
