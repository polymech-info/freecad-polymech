/**
  Copyright (C) 2012-2021 by Autodesk, Inc.
  All rights reserved.

  OKUMA post processor configuration.

  $Revision: 43654 a19c569c9f7fe055fc222095112d3f1eebc74b63 $
  $Date: 2021-12-02 09:56:05 $

  FORKID {2F9AB8A9-6D4F-4087-81B1-3E14AE260F81}
*/

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                        MANUAL NC COMMANDS
//
// The following ACTION commands are supported by this post.
//
//     spindleLoadMonitor:load        - Changes Spindle Load Monitoring value from default set in getProperty("")
//                                      Will be reset to default property value at the end of the section.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

description = "OKUMA";
vendor = "OKUMA";
vendorUrl = "http://www.okuma.com";
legal = "Copyright (C) 2012-2021 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45702;

longDescription = "Milling post for OKUMA. Supports an optional rotary table. Enable the 'useG16' property to do machine retracts in H0. Enable the 'Use fixture offset function' property to use CALL OO88 for 3+2 machining.";

extension = "MIN";
setCodePage("ascii");

capabilities = CAPABILITY_MILLING;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(180);
allowHelicalMoves = true;
allowedCircularPlanes = (1 << PLANE_XY); // allow XY plane only

highFeedMapping = HIGH_FEED_NO_MAPPING; // must be set if axes are not synchronized
highFeedrate = (unit == IN) ? 100 : 5000;

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
    value      : 1,
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
  dwellAfterStop: {
    title      : "Dwell time after stop",
    description: "Specifies the time in seconds to dwell after a stop.",
    type       : "number",
    value      : 0,
    scope      : "post"
  },
  separateWordsWithSpace: {
    title      : "Separate words with space",
    description: "Adds spaces between words if 'yes' is selected.",
    type       : "boolean",
    value      : true,
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
      {title:"Clearance Height", id:"clearanceHeight"},
      {title:"G16", id:"G16"},
      {title:"G0", id:"G0"}
    ],
    value: "G0",
    scope: "post"
  },
  rotaryTableAxis: {
    title      : "Rotary table axis",
    description: "Select rotary table axis. Check the table direction on the machine and use the (Reversed) selection if the table is moving in the opposite direction.",
    type       : "enum",
    values     : [
      {title:"No rotary", id:"none"},
      {title:"X", id:"x"},
      {title:"Y", id:"y"},
      {title:"Z", id:"z"},
      {title:"X (Reversed)", id:"-x"},
      {title:"Y (Reversed)", id:"-y"},
      {title:"Z (Reversed)", id:"-z"},
      {title:"5 Axis", id:"5axis"}
    ],
    value: "none",
    scope: "post"
  },
  useTableDirectionCodes: {
    title      : "Use table direction codes",
    description: "If enabled, M15/M16 are used to specify table rotation direction.",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useMultiAxisFeatures: {
    title      : "Use fixture offset function",
    description: "Specifies to use CALL OO88 for 3+2 machining.",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useSubroutines: {
    title      : "Use subroutines",
    description: "Select your desired subroutine option. 'All Operations' creates subroutines per each operation, 'Cycles' creates subroutines for cycle operations on same holes, and 'Patterns' creates subroutines for patterned operations.",
    type       : "enum",
    values     : [
      {title:"No", id:"none"},
      {title:"All Operations", id:"allOperations"},
      {title:"Cycles", id:"cycles"},
      {title:"Patterns", id:"patterns"}
    ],
    value: "none",
    scope: "post"
  },
  useFilesForSubprograms: {
    title      : "Use files for subroutines",
    description: "If enabled, subroutines will be saved as individual files.",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  toolLifeMonitor: {
    title      : "Enable tool life monitoring",
    description: "Adds subprograms to monitor tool life",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  loadMonitorVal: {
    title      : "Spindle load monitoring value",
    description: "Set a value here to turn on the spindle load monitoring. Change it for an operation with Manual NC",
    group      : 1,
    type       : "integer",
    value      : 0,
    scope      : "post"
  },
  useSmoothing: {
    title      : "High-Cut mode",
    description: "Select the High-cut contouring mode",
    type       : "enum",
    values     : [
      {title:"Off", id:"-1"},
      {title:"Automatic", id:"9999"},
      {title:"High Quality", id:"0"},
      {title:"Standard", id:"1"},
      {title:"High Speed", id:"2"}
    ],
    value: "-1",
    scope: "post"
  },
  safeToolChange: {
    title      : "Enable safe tool change logic",
    description: "Use logic to check if the tool called is staged or already loaded",
    group      : 0,
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useClampCodes: {
    title      : "Use clamp codes",
    description: "Specifies whether clamp codes for rotary axes should be output",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useCAS: {
    title      : "Enable Collision Avoidance System",
    description: "Use M-codes to switch off CAS before 5axis toolpaths",
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
  {id:COOLANT_MIST, on:7},
  {id:COOLANT_THROUGH_TOOL, on:50},
  {id:COOLANT_AIR, on:51},
  {id:COOLANT_AIR_THROUGH_TOOL, on:59},
  {id:COOLANT_SUCTION},
  {id:COOLANT_FLOOD_MIST},
  {id:COOLANT_FLOOD_THROUGH_TOOL},
  {id:COOLANT_OFF, off:9}
];

var gFormat = createFormat({prefix:"G", width:2, zeropad:true, decimals:0});
var mFormat = createFormat({prefix:"M", width:2, zeropad:true, decimals:0});
var hFormat = createFormat({prefix:"H", width:2, zeropad:true, decimals:0});
var dFormat = createFormat({prefix:"D", width:2, zeropad:true, decimals:0});
var oFormat = createFormat({prefix:"O", width:4, zeropad:true, decimals:0});
var pFormat = createFormat({prefix:"P", width:2, zeropad:true, decimals:0});
var callFormat = createFormat({prefix:"CALL O", width:4, zeropad:true, decimals:0});
var probeWCSFormat = createFormat({decimals:0, forceDecimal:true});

var xyzFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var abcFormat = createFormat({decimals:3, forceDecimal:true, scale:DEG});
var feedFormat = createFormat({decimals:(unit == MM ? 2 : 3)});
var pitchFormat = createFormat({decimals:(unit == MM ? 3 : 4)});
var toolFormat = createFormat({decimals:0});
var rpmFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:3, forceDecimal:true}); // seconds - range 0.001-99999.999
var milliFormat = createFormat({decimals:0}); // milliseconds // range 1-99999999
var taperFormat = createFormat({decimals:1, scale:DEG});

var xOutput = createVariable({prefix:"X"}, xyzFormat);
var yOutput = createVariable({prefix:"Y"}, xyzFormat);
var zOutput = createVariable({onchange:function () {retracted = false;}, prefix:"Z"}, xyzFormat);
var aOutput = createVariable({prefix:"A"}, abcFormat);
var bOutput = createVariable({prefix:"B"}, abcFormat);
var cOutput = createVariable({prefix:"C"}, abcFormat);
var feedOutput = createVariable({prefix:"F"}, feedFormat);
var sOutput = createVariable({prefix:"S", force:true}, rpmFormat);
var dOutput = createVariable({}, dFormat);

// circular output
var iOutput = createReferenceVariable({prefix:"I"}, xyzFormat);
var jOutput = createReferenceVariable({prefix:"J"}, xyzFormat);
var kOutput = createReferenceVariable({prefix:"K"}, xyzFormat);

// cycle output
var z71Output = createVariable({prefix:"Z", force:true}, xyzFormat);

var gMotionModal = createModal({}, gFormat); // modal group 1 // G0-G3, ...
var gPlaneModal = createModal({onchange:function () {gMotionModal.reset();}}, gFormat); // modal group 2 // G17-19
var gAbsIncModal = createModal({}, gFormat); // modal group 3 // G90-91
var gFeedModeModal = createModal({}, gFormat); // modal group 5 // G94-95
var gUnitModal = createModal({}, gFormat); // modal group 6 // G20-21
var gCycleModal = createModal({}, gFormat); // modal group 9 // G81, ...
var gRetractModal = createModal({}, gFormat); // modal group 10 // G98-99
var cAxisDirectionModal = createModal({}, mFormat);
var gRotationModal = createModal({
  onchange: function () {
    if (probeVariables.probeAngleMethod == "G68") {
      probeVariables.outputRotationCodes = true;
    }
  }
}, gFormat); // modal group 3 // G10-11
var mClampModal = createModalGroup(
  {strict:false},
  [
    [10, 11], // 4th axis clamp / unclamp
    [26, 27] // 5th axis clamp / unclamp
  ],
  mFormat
);
var useG284 = false; // use G284 instead of G84

// fixed settings
var firstFeedParameter = 1;
var minimumCyclePoints = 5; // minimum number of points in cycle operation to consider for subprogram
var useMultiAxisFeatures = false;

var WARNING_WORK_OFFSET = 0;

var allowIndexingWCSProbing = false; // specifies that probe WCS with tool orientation is supported
var probeVariables = {
  outputRotationCodes: false, // defines if it is required to output rotation codes
  probeAngleMethod   : "OFF", // OFF, AXIS_ROT, G68, G54.4
  compensationXY     : undefined
};

var SUB_UNKNOWN = 0;
var SUB_PATTERN = 1;
var SUB_CYCLE = 2;

var fixtureOffsetWCS = 51; // recalculated offset coordinate system number (zero point which is always rewritten in fixture offset function CALL OO88)

// collected state
var sequenceNumber;
var currentWorkOffset;
var forceSpindleSpeed = false;
var activeMovements; // do not use by default
var subprograms = [];
var currentPattern = -1;
var firstPattern = false;
var currentSubprogram;
var lastSubprogram = 0;
var definedPatterns = new Array();
var incrementalMode = false;
var saveShowSequenceNumbers;
var cycleSubprogramIsActive = false;
var patternIsActive = false;
var incrementalSubprogram;
var currentFeedId;
var retracted = false; // specifies that the tool has been retracted to the safe plane
var masterAxis;
var loadMonitorVal = 0;
var prevLoadMonitorVal = 0;
probeMultipleFeatures = true;

/**
  Writes the specified block.
*/
function writeBlock() {
  if (getProperty("showSequenceNumbers")) {
    writeWords2("N" + sequenceNumber, arguments);
    sequenceNumber += getProperty("sequenceNumberIncrement");
  } else {
    writeWords(arguments);
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
  return "(" + String(text).replace(/[()]/g, "") + ")";
}

/**
  Output a comment.
*/
function writeComment(text) {
  writeln(formatComment(text));
}

function forceSequenceNumbers(force) {
  if (force) {
    setProperty("showSequenceNumbers", true);
  } else {
    setProperty("showSequenceNumbers", saveShowSequenceNumbers);
  }
}

function skipNLines(n) {
  return (n * getProperty("sequenceNumberIncrement") + sequenceNumber);
}

function onOpen() {
  // setup usage of multiAxisFeatures
  useMultiAxisFeatures = getProperty("useMultiAxisFeatures") != undefined ? getProperty("useMultiAxisFeatures") :
    (typeof useMultiAxisFeatures != "undefined" ? useMultiAxisFeatures : false);

  if (getProperty("useClampCodes")) {
    mClampModal.format(10); // Default 4th axis modal code to be clamped
    mClampModal.format(26); // Default 5th axis modal code to be clamped
  } else {
    mClampModal.disable();
  }

  // Use this for 4th axis rotary
  // Define rotary attributes from properties
  var rotary = parseChoice(getProperty("rotaryTableAxis"), "-Z", "-Y", "-X", "NONE", "X", "Y", "Z", "5AXIS");
  if (rotary < 0) {
    error(localize("Valid rotaryTableAxis values are: None, X, Y, Z, -X, -Y, -Z, 5 Axis"));
    return;
  }
  rotary -= 3;
  masterAxis = Math.abs(rotary) - 1;
  if (getProperty("rotaryTableAxis") == "5axis") {
    // Use this for 3+2 or 5 axis machines
    masterAxis = -1;
    var aAxis = createAxis({coordinate:0, table:true, axis:[1, 0, 0], range:[-120, 90], preference:0});
    if (getProperty("useTableDirectionCodes")) {
      var cAxis = createAxis({coordinate:2, table:true, axis:[0, 0, 1], cyclic:true, range:[0, 360], preference:0});
    } else {
      var cAxis = createAxis({coordinate:2, table:true, axis:[0, 0, 1], cyclic:true, preference:0});
    }
    machineConfiguration = new MachineConfiguration(aAxis, cAxis);
    setMachineConfiguration(machineConfiguration);
    optimizeMachineAngles2(0); // TCP mode
  } else if (masterAxis >= 0) {
    // Define Master (carrier) axis
    var rotaryVector = [0, 0, 0];
    rotaryVector[masterAxis] = rotary / Math.abs(rotary);
    var aAxis;
    if (getProperty("useTableDirectionCodes")) {
      aAxis = createAxis({coordinate:0, table:true, axis:rotaryVector, cyclic:true, range:[0, 360], preference:0});
    } else {
      aAxis = createAxis({coordinate:0, table:true, axis:rotaryVector, cyclic:true, preference:0});
    }
    machineConfiguration = new MachineConfiguration(aAxis);

    setMachineConfiguration(machineConfiguration);
    // Single rotary does not use TCP mode
    optimizeMachineAngles2(1); // 0 = TCP Mode ON, 1 = TCP Mode OFF
  } else if (machineConfiguration.getNumberOfAxes() > 3) {
    optimizeMachineAngles2(0); // TCP mode
  }

  if (getProperty("safePositionMethod") == "G16") {
    machineConfiguration.setRetractPlane(0);
  } else {
    machineConfiguration.setRetractPlane((unit == IN) ? 400 : 9999); // CNC would not fail but move to highest position
    machineConfiguration.setHomePositionX((unit == IN) ? 400 : 9999); // CNC would not fail but move to max position
    machineConfiguration.setHomePositionY((unit == IN) ? 400 : 9999); // CNC would not fail but move to max position
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

  if (!getProperty("separateWordsWithSpace")) {
    setWordSeparator("");
  }

  sequenceNumber = getProperty("sequenceNumberStart");
  saveShowSequenceNumbers = getProperty("showSequenceNumbers");

  if (programName) {
    if (programName.length > 4) {
      warning(localize("Program name exceeds maximum length."));
    }
    programName = String(programName).toUpperCase();
    if (!isSafeText(programName, "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")) {
      error(localize("Program name contains invalid character(s)."));
    }
    if (programName[0] == "O") {
      warning(localize("Using reserved program name."));
    }
    writeln("O" + programName);
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
      writeComment("  " + localize("description") + ": " + description);
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
        if (getProperty("toolLifeMonitor") == true) {
          writeBlock("VC198=", xyzFormat.format(tool.diameter), formatComment("CAM ToolDiameter"));
          writeBlock("VC199=", xyzFormat.format(tool.bodyLength), formatComment("CAM ToolLength"));
          writeBlock("VC200=", toolFormat.format(tool.number), formatComment("CAM ToolNumber"));
          writeBlock("CALL OCHCK");
        }
      }
    }
  }

  if (false) {
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
              abcFormat.areDifferent(tooli.taperAngle, toolj.taperAngle) ||
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

  if ((getNumberOfSections() > 0) && (getSection(0).workOffset == 0)) {
    for (var i = 0; i < getNumberOfSections(); ++i) {
      if (getSection(i).workOffset > 0) {
        error(localize("Using multiple work offsets is not possible if the initial work offset is 0."));
        return;
      }
    }
  }

  // absolute coordinates and feed per min
  writeBlock(gFormat.format(40), gCycleModal.format(80), gAbsIncModal.format(90), gFeedModeModal.format(94), gPlaneModal.format(17));

  switch (unit) {
  case IN:
    writeBlock(gUnitModal.format(20));
    break;
  case MM:
    writeBlock(gUnitModal.format(21));
    break;
  }

  loadMonitorVal = getProperty("loadMonitorVal");

  // Set Tool Life Monitoring ON
  if (getProperty("toolLifeMonitor")) {
    writeBlock("TLFON");
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

// Start of smoothing logic
var smoothingSettings = {
  roughing          : 2, // roughing level for smoothing in automatic mode
  semi              : 2, // semi-roughing level for smoothing in automatic mode
  finishing         : 1, // finishing level for smoothing in automatic mode
  thresholdRoughing : toPreciseUnit(0.01, MM), // operations with stock/tolerance above that threshold will use roughing level in automatic mode
  thresholdFinishing: toPreciseUnit(0.005, MM), // operations with stock/tolerance below that threshold will use finishing level in automatic mode
  differenceCriteria: "both", // options: "level", "tolerance", "both". Specifies criteria when output smoothing codes
  autoLevelCriteria : "stock", // use "stock" or "tolerance" to determine levels in automatic mode
  cancelCompensation: false, // tool length compensation must be canceled prior to changing the smoothing level
  useSuperNURBS     : false // enable if superNURBS is supported on the control
};

// collected state below, do not edit
var smoothing = {
  cancel     : false, // cancel tool length prior to update smoothing for this operation
  isActive   : false, // the current state of smoothing
  isAllowed  : false, // smoothing is allowed for this operation
  isDifferent: false, // tells if smoothing levels/tolerances/both are different between operations
  level      : -1, // the active level of smoothing
  tolerance  : -1, // the current operation tolerance
  force      : false // smoothing needs to be forced out in this operation
};

function initializeSmoothing() {
  var previousLevel = smoothing.level;
  var previousTolerance = smoothing.tolerance;

  // determine new smoothing levels and tolerances
  smoothing.level = parseInt(getProperty("useSmoothing"), 10);
  smoothing.level = isNaN(smoothing.level) ? -1 : smoothing.level;
  smoothing.tolerance = Math.max(getParameter("operation:tolerance", 0), 0);

  // automatically determine smoothing level
  if (smoothing.level == 9999) {
    if (smoothingSettings.autoLevelCriteria == "stock") { // determine auto smoothing level based on stockToLeave
      var stockToLeave = xyzFormat.getResultingValue(getParameter("operation:stockToLeave", 0));
      var verticalStockToLeave = xyzFormat.getResultingValue(getParameter("operation:verticalStockToLeave", 0));
      if ((stockToLeave >= smoothingSettings.thresholdRoughing) && (verticalStockToLeave >= smoothingSettings.thresholdRoughing)) {
        smoothing.level = smoothingSettings.roughing; // set roughing level
      } else {
        if ((stockToLeave >= smoothingSettings.thresholdFinishing) && (verticalStockToLeave >= smoothingSettings.thresholdFinishing)) {
          smoothing.level = smoothingSettings.semi; // set semi level
        } else {
          smoothing.level = smoothingSettings.finishing; // set finishing level
        }
      }
    } else { // detemine auto smoothing level based on operation tolerance instead of stockToLeave
      smoothing.level = smoothing.tolerance < smoothingSettings.thresholdRoughing ? smoothing.tolerance > smoothingSettings.thresholdFinishing ?
        smoothingSettings.semi : smoothingSettings.finishing : smoothingSettings.roughing;
    }
  }
  if (smoothing.level == -1) { // useSmoothing is disabled
    smoothing.isAllowed = false;
  } else { // do not output smoothing for the following operations
    smoothing.isAllowed = !(currentSection.getTool().type == TOOL_PROBE || currentSection.checkGroup(STRATEGY_DRILLING));
  }
  if (!smoothing.isAllowed) {
    smoothing.level = -1;
    smoothing.tolerance = -1;
  }

  switch (smoothingSettings.differenceCriteria) {
  case "level":
    smoothing.isDifferent = smoothing.level != previousLevel;
    break;
  case "tolerance":
    smoothing.isDifferent = smoothing.tolerance != previousTolerance;
    break;
  case "both":
    smoothing.isDifferent = smoothing.level != previousLevel || smoothing.tolerance != previousTolerance;
    break;
  default:
    error(localize("Unsupported smoothing criteria."));
    return;
  }

  // tool length compensation needs to be canceled when smoothing state/level changes
  if (smoothingSettings.cancelCompensation) {
    smoothing.cancel = !isFirstSection() && smoothing.isDifferent;
  }
  // force smoothing on feedrate change
  smoothing.force = !isFirstSection() && smoothing.isAllowed && feedFormat.areDifferent(getPreviousSection().getMaximumFeedrate(), currentSection.getMaximumFeedrate());
}

function setSmoothing(mode) {
  if (mode == smoothing.isActive && (!mode || !smoothing.isDifferent) && !smoothing.force) {
    return; // return if smoothing is already active or is not different
  }
  if (typeof lengthCompensationActive != "undefined" && smoothingSettings.cancelCompensation) {
    validate(!lengthCompensationActive, "Length compensation is active while trying to update smoothing.");
  }

  if (mode) { // enable smoothing
    writeBlock(gFormat.format(131),
      "F" + feedFormat.format(currentSection.getMaximumFeedrate()),
      "J" + xyzFormat.format(smoothing.level),
      "E" + xyzFormat.format(smoothing.tolerance * (smoothingSettings.useSuperNURBS ? 2 : 1)),
      conditional(smoothingSettings.useSuperNURBS, "D" + xyzFormat.format(smoothing.tolerance)),
      conditional(smoothingSettings.useSuperNURBS, "I" + 3),
      conditional(smoothingSettings.useSuperNURBS, "L" + xyzFormat.format(toPreciseUnit(12, MM))),
      conditional(smoothingSettings.useSuperNURBS, "R" + xyzFormat.format(toPreciseUnit(0.25, MM))),
      conditional(smoothingSettings.useSuperNURBS, "K" + 0)
    );
  } else { // disable smoothing
    writeBlock(gFormat.format(130));
  }
  smoothing.isActive = mode;
  smoothing.force = false;
  smoothing.isDifferent = false;
}
// End of smoothing logic

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
        return "F=PF" + (firstFeedParameter + feedContext.id);
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
    writeBlock("PF" + (firstFeedParameter + feedContext.id) + "=" + feedFormat.format(feedContext.feed), formatComment(feedContext.description));
  }
}

var currentWorkPlaneABC = undefined;

function forceWorkPlane() {
  currentWorkPlaneABC = undefined;
}

function defineWorkPlane(_section, _setWorkPlane) {
  var abc = new Vector(0, 0, 0);
  if (!is3D() || machineConfiguration.isMultiAxisConfiguration()) { // use 5-axis indexing for multi-axis mode
    // set working plane after datum shift

    if (_section.isMultiAxis()) {
      cancelTransformation();
      if (_setWorkPlane) {
        forceWorkPlane();
      }
      if (machineConfiguration.isMultiAxisConfiguration()) {
        abc = _section.getInitialToolAxisABC();
        if (_setWorkPlane) {
          if (!retracted) {
            writeRetract(Z);
          }
          onCommand(COMMAND_UNLOCK_MULTI_AXIS);
          gMotionModal.reset();
          positionABC(abc, true);
        }
      } else {
        if (_setWorkPlane) {
          var d = _section.getGlobalInitialToolAxis();
          // position
          writeBlock(
            gAbsIncModal.format(90),
            gMotionModal.format(0),
            "I" + xyzFormat.format(d.x), "J" + xyzFormat.format(d.y), "K" + xyzFormat.format(d.z)
          );
        }
      }
    } else {
      abc = getWorkPlaneMachineABC(_section.workPlane, _setWorkPlane, true);
      if (_setWorkPlane) {
        setWorkPlane(abc);
      }
    }

  } else { // pure 3D
    var remaining = _section.workPlane;
    if (!isSameDirection(remaining.forward, new Vector(0, 0, 1))) {
      error(localize("Tool orientation is not supported."));
      return abc;
    }
    setRotation(remaining);
  }
  return abc;
}

function cancelWorkPlane(force) {
  if (force) {
    gRotationModal.reset();
  }
  if (useMultiAxisFeatures) {
    fixtureOffset(new Vector(0, 0, 0));
  } else {
    writeBlock(gRotationModal.format(10)); // cancel frame
  }
  forceWorkPlane();
}

function fixtureOffset(abc) {
  writeBlock(
    "CALL OO88",
    "PX=" + xyzFormat.format(0),
    "PY=" + xyzFormat.format(0),
    "PZ=" + xyzFormat.format(0),
    conditional(machineConfiguration.isMachineCoordinate(2), "PC=" + abcFormat.format(abc.z)),
    conditional(machineConfiguration.isMachineCoordinate(1), "PB=" + abcFormat.format(abc.y)),
    conditional(machineConfiguration.isMachineCoordinate(0), "PA=" + abcFormat.format(abc.x)),
    "PH=" + xyzFormat.format(currentWorkOffset),
    "PP=" + xyzFormat.format(fixtureOffsetWCS)
  );
  writeBlock(gFormat.format(15), hFormat.format(fixtureOffsetWCS));
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

  positionABC(abc, !currentSection.isMultiAxis());

  if (useMultiAxisFeatures) {
    if (abc.isNonZero()) {
      fixtureOffset(abc);
    } else {
      currentWorkOffset = undefined;
    }
  }
  if (!currentSection.isMultiAxis()) {
    onCommand(COMMAND_LOCK_MULTI_AXIS);
  }
  currentWorkPlaneABC = abc;
}

var closestABC = false; // choose closest machine angles
var currentMachineABC;

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
    gMotionModal.reset();
    writeBlock(gMotionModal.format(0), a, b, c, getRotaryDirectionCode(abc));
    currentMachineABC = new Vector(abc);
    setCurrentABC(abc); // required for machine simulation
  }
}

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

/**
  Outputs the Rotary axis direction code.
*/
var previousABC = new Vector(0, 0, 0);
function getRotaryDirectionCode(abc) {
  if (masterAxis == -1) {
    return "";
  }
  if (getProperty("useTableDirectionCodes")) {
    var delta = abc.getCoordinate(masterAxis) - previousABC.getCoordinate(masterAxis);
    previousABC.setCoordinate(masterAxis, abc.getCoordinate(masterAxis));
    if (((delta < 0) && (delta > -Math.PI)) || (delta > Math.PI)) {
      return cAxisDirectionModal.format(16);
    } else if (abcFormat.getResultingValue(delta) != 0) {
      return cAxisDirectionModal.format(15);
    }
  } else {
    previousABC.setCoordinate(masterAxis, abc.getCoordinate(masterAxis));
  }
  return "";
}

/**
  Compare a text string to acceptable choices.
  Returns -1 if there is no match.
*/
function parseChoice() {
  for (var i = 1; i < arguments.length; ++i) {
    if (String(arguments[0]).toUpperCase() == String(arguments[i]).toUpperCase()) {
      return i - 1;
    }
  }
  return -1;
}

function printProbeResults() {
  return currentSection.getParameter("printResults", 0) == 1;
}

var probeOutputWorkOffset = 1;

function onParameter(name, value) {
  if (name == "probe-output-work-offset") {
    probeOutputWorkOffset = (value > 0) ? value : 1;
  }
}

function onManualNC(command, value) {
  switch (command) {
  case COMMAND_ACTION:
    var sText1 = String(value);
    var sText2 = new Array();
    sText2 = sText1.split(":");
    if (sText2.length != 2) {
      error(localize("Invalid action command: ") + value);
      return;
    }
    if (sText2[0].toUpperCase() == "SPINDLELOADMONITOR") {
      loadMonitorVal = parseFloat(sText2[1]);
      if (isNaN(loadMonitorVal) || loadMonitorVal < 0) {
        error(localize("Spindle load mointoring requires a valid positive number."));
      }
    }
    break;
  default:
    expandManualNC(command, value);
  }
}

/** Returns true if the spatial vectors are significantly different. */
function areSpatialVectorsDifferent(_vector1, _vector2) {
  return (xyzFormat.getResultingValue(_vector1.x) != xyzFormat.getResultingValue(_vector2.x)) ||
    (xyzFormat.getResultingValue(_vector1.y) != xyzFormat.getResultingValue(_vector2.y)) ||
    (xyzFormat.getResultingValue(_vector1.z) != xyzFormat.getResultingValue(_vector2.z));
}

/** Returns true if the spatial boxes are a pure translation. */
function areSpatialBoxesTranslated(_box1, _box2) {
  return !areSpatialVectorsDifferent(Vector.diff(_box1[1], _box1[0]), Vector.diff(_box2[1], _box2[0])) &&
    !areSpatialVectorsDifferent(Vector.diff(_box2[0], _box1[0]), Vector.diff(_box2[1], _box1[1]));
}

/** Returns true if the spatial boxes are same. */
function areSpatialBoxesSame(_box1, _box2) {
  return !areSpatialVectorsDifferent(_box1[0], _box2[0]) && !areSpatialVectorsDifferent(_box1[1], _box2[1]);
}

function subprogramDefine(_initialPosition, _abc, _retracted, _zIsOutput) {
  // convert patterns into subprograms
  var usePattern = false;
  patternIsActive = false;
  if (currentSection.isPatterned && currentSection.isPatterned() && (getProperty("useSubroutines") == "patterns")) {
    currentPattern = currentSection.getPatternId();
    firstPattern = true;
    for (var i = 0; i < definedPatterns.length; ++i) {
      if ((definedPatterns[i].patternType == SUB_PATTERN) && (currentPattern == definedPatterns[i].patternId)) {
        currentSubprogram = definedPatterns[i].subProgram;
        usePattern = definedPatterns[i].validPattern;
        firstPattern = false;
        break;
      }
    }

    if (firstPattern) {
      // determine if this is a valid pattern for creating a subprogram
      usePattern = subprogramIsValid(currentSection, currentPattern, SUB_PATTERN);
      if (usePattern) {
        currentSubprogram = ++lastSubprogram;
      }
      definedPatterns.push({
        patternType    : SUB_PATTERN,
        patternId      : currentPattern,
        subProgram     : currentSubprogram,
        validPattern   : usePattern,
        initialPosition: _initialPosition,
        finalPosition  : _initialPosition
      });
    }

    if (usePattern) {
      // make sure Z-position is output prior to subprogram call
      if (!_retracted && !_zIsOutput) {
        writeBlock(gMotionModal.format(0), zOutput.format(_initialPosition.z));
      }

      // call subprogram
      writeBlock(callFormat.format(currentSubprogram));
      patternIsActive = true;

      if (firstPattern) {
        subprogramStart(_initialPosition, _abc, incrementalSubprogram);
      } else {
        skipRemainingSection();
        setCurrentPosition(getFramePosition(currentSection.getFinalPosition()));
      }
    }
  }

  // Output cycle operation as subprogram
  if (!usePattern && (getProperty("useSubroutines") == "cycles") && currentSection.doesStrictCycle &&
      (currentSection.getNumberOfCycles() == 1) && currentSection.getNumberOfCyclePoints() >= minimumCyclePoints) {
    var finalPosition = getFramePosition(currentSection.getFinalPosition());
    currentPattern = currentSection.getNumberOfCyclePoints();
    firstPattern = true;
    for (var i = 0; i < definedPatterns.length; ++i) {
      if ((definedPatterns[i].patternType == SUB_CYCLE) && (currentPattern == definedPatterns[i].patternId) &&
          !areSpatialVectorsDifferent(_initialPosition, definedPatterns[i].initialPosition) &&
          !areSpatialVectorsDifferent(finalPosition, definedPatterns[i].finalPosition)) {
        currentSubprogram = definedPatterns[i].subProgram;
        usePattern = definedPatterns[i].validPattern;
        firstPattern = false;
        break;
      }
    }

    if (firstPattern) {
      // determine if this is a valid pattern for creating a subprogram
      usePattern = subprogramIsValid(currentSection, currentPattern, SUB_CYCLE);
      if (usePattern) {
        currentSubprogram = ++lastSubprogram;
      }
      definedPatterns.push({
        patternType    : SUB_CYCLE,
        patternId      : currentPattern,
        subProgram     : currentSubprogram,
        validPattern   : usePattern,
        initialPosition: _initialPosition,
        finalPosition  : finalPosition
      });
    }
    cycleSubprogramIsActive = usePattern;
  }

  // Output each operation as a subprogram
  if (!usePattern && (getProperty("useSubroutines") == "allOperations")) {
    currentSubprogram = ++lastSubprogram;
    writeBlock(callFormat.format(currentSubprogram));
    firstPattern = true;
    subprogramStart(_initialPosition, _abc, false);
  }
}

function subprogramStart(_initialPosition, _abc, _incremental) {
  if (getProperty("useFilesForSubprograms")) {
    var path = FileSystem.getCombinedPath(FileSystem.getFolderPath(getOutputPath()), currentSubprogram + "." + extension);
    redirectToFile(path);
  } else {
    redirectToBuffer();
  }
  var comment = "";
  if (hasParameter("operation-comment")) {
    comment = getParameter("operation-comment");
  }
  writeln(oFormat.format(currentSubprogram) +
    conditional(comment, formatComment(comment))
  );
  saveShowSequenceNumbers = getProperty("showSequenceNumbers");
  setProperty("showSequenceNumbers", false);
  if (_incremental) {
    setIncrementalMode(_initialPosition, _abc);
  }
  gPlaneModal.reset();
  gMotionModal.reset();
}

function subprogramEnd() {
  if (firstPattern) {
    writeBlock("RTS");
    writeln("");
    subprograms += getRedirectionBuffer();
  }
  forceAny();
  firstPattern = false;
  setProperty("showSequenceNumbers", saveShowSequenceNumbers);
  closeRedirection();
}

function subprogramIsValid(_section, _patternId, _patternType) {
  var sectionId = _section.getId();
  var numberOfSections = getNumberOfSections();
  var validSubprogram = _patternType != SUB_CYCLE;

  var masterPosition = new Array();
  masterPosition[0] = getFramePosition(_section.getInitialPosition());
  masterPosition[1] = getFramePosition(_section.getFinalPosition());
  var tempBox = _section.getBoundingBox();
  var masterBox = new Array();
  masterBox[0] = getFramePosition(tempBox[0]);
  masterBox[1] = getFramePosition(tempBox[1]);

  var rotation = getRotation();
  var translation = getTranslation();
  incrementalSubprogram = undefined;

  for (var i = 0; i < numberOfSections; ++i) {
    var section = getSection(i);
    if (section.getId() != sectionId) {
      defineWorkPlane(section, false);
      // check for valid pattern
      if (_patternType == SUB_PATTERN) {
        if (section.getPatternId() == _patternId) {
          var patternPosition = new Array();
          patternPosition[0] = getFramePosition(section.getInitialPosition());
          patternPosition[1] = getFramePosition(section.getFinalPosition());
          tempBox = section.getBoundingBox();
          var patternBox = new Array();
          patternBox[0] = getFramePosition(tempBox[0]);
          patternBox[1] = getFramePosition(tempBox[1]);

          if (areSpatialBoxesSame(masterPosition, patternPosition) && areSpatialBoxesSame(masterBox, patternBox) && !section.isMultiAxis()) {
            incrementalSubprogram = incrementalSubprogram ? incrementalSubprogram : false;
          } else if (!areSpatialBoxesTranslated(masterPosition, patternPosition) || !areSpatialBoxesTranslated(masterBox, patternBox)) {
            validSubprogram = false;
            break;
          } else {
            incrementalSubprogram = true;
          }
        }

      // check for valid cycle operation
      } else if (_patternType == SUB_CYCLE) {
        if ((section.getNumberOfCyclePoints() == _patternId) && (section.getNumberOfCycles() == 1)) {
          var patternInitial = getFramePosition(section.getInitialPosition());
          var patternFinal = getFramePosition(section.getFinalPosition());
          if (!areSpatialVectorsDifferent(patternInitial, masterPosition[0]) && !areSpatialVectorsDifferent(patternFinal, masterPosition[1])) {
            validSubprogram = true;
            break;
          }
        }
      }
    }
  }
  setRotation(rotation);
  setTranslation(translation);
  return (validSubprogram);
}

function setAxisMode(_format, _output, _prefix, _value, _incr) {
  var i = _output.isEnabled();
  if (_output == zOutput) {
    _output = _incr ? createIncrementalVariable({onchange:function() {retracted = false;}, prefix:_prefix}, _format) : createVariable({onchange:function() {retracted = false;}, prefix:_prefix}, _format);
  } else {
    _output = _incr ? createIncrementalVariable({prefix:_prefix}, _format) : createVariable({prefix:_prefix}, _format);
  }
  _output.format(_value);
  _output.format(_value);
  i = i ? _output.enable() : _output.disable();
  return _output;
}

function setIncrementalMode(xyz, abc) {
  xOutput = setAxisMode(xyzFormat, xOutput, "X", xyz.x, true);
  yOutput = setAxisMode(xyzFormat, yOutput, "Y", xyz.y, true);
  zOutput = setAxisMode(xyzFormat, zOutput, "Z", xyz.z, true);
  aOutput = setAxisMode(abcFormat, aOutput, "A", abc.x, true);
  bOutput = setAxisMode(abcFormat, bOutput, "B", abc.y, true);
  cOutput = setAxisMode(abcFormat, cOutput, "C", abc.z, true);
  gAbsIncModal.reset();
  writeBlock(gAbsIncModal.format(91));
  incrementalMode = true;
}

function setAbsoluteMode(xyz, abc) {
  if (incrementalMode) {
    xOutput = setAxisMode(xyzFormat, xOutput, "X", xyz.x, false);
    yOutput = setAxisMode(xyzFormat, yOutput, "Y", xyz.y, false);
    zOutput = setAxisMode(xyzFormat, zOutput, "Z", xyz.z, false);
    aOutput = setAxisMode(abcFormat, aOutput, "A", abc.x, false);
    bOutput = setAxisMode(abcFormat, bOutput, "B", abc.y, false);
    cOutput = setAxisMode(abcFormat, cOutput, "C", abc.z, false);
    gAbsIncModal.reset();
    writeBlock(gAbsIncModal.format(90));
    incrementalMode = false;
  }
}

function onSection() {
  var insertToolCall = isFirstSection() ||
    currentSection.getForceToolChange && currentSection.getForceToolChange() ||
    (tool.number != getPreviousSection().getTool().number);

  retracted = false; // specifies that the tool has been retracted to the safe plane

  var zIsOutput = false; // true if the Z-position has been output, used for patterns

  var newWorkOffset = isFirstSection() ||
    (getPreviousSection().workOffset != currentSection.workOffset); // work offset changes
  var newWorkPlane = isFirstSection() ||
    !isSameDirection(getPreviousSection().getGlobalFinalToolAxis(), currentSection.getGlobalInitialToolAxis()) ||
    (currentSection.isOptimizedForMachine() && getPreviousSection().isOptimizedForMachine() &&
      Vector.diff(getPreviousSection().getFinalToolAxisABC(), currentSection.getInitialToolAxisABC()).length > 1e-4) ||
    (!machineConfiguration.isMultiAxisConfiguration() && currentSection.isMultiAxis()) ||
    (getPreviousSection().isMultiAxis() != currentSection.isMultiAxis()); // force newWorkPlane between indexing and simultaneous operations

  // define smoothing mode
  initializeSmoothing();

  if (insertToolCall || newWorkOffset || newWorkPlane) {
    // stop spindle before retract during tool change
    if (insertToolCall && !isFirstSection()) {
      onCommand(COMMAND_STOP_SPINDLE);
    }
    // retract to safe plane
    writeRetract(Z);
    if (newWorkPlane && !isFirstSection()) {
      setWorkPlane(new Vector(0, 0, 0)); // reset working plane
    }
  }
  // disable smoothing
  if ((insertToolCall && !isFirstSection()) || smoothing.force) {
    setSmoothing(false);
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
      for (line in lines) {
        var comment = lines[line].replace(r1, "").replace(r2, "");
        if (comment) {
          writeComment(comment);
        }
      }
    }
  }

  var spindleChanged = insertToolCall ||
      forceSpindleSpeed ||
      isFirstSection() ||
      (rpmFormat.areDifferent(spindleSpeed, sOutput.getCurrent())) ||
      (tool.clockwise != getPreviousSection().getTool().clockwise);

  if (spindleChanged && prevLoadMonitorVal != 0) {
    writeBlock(mFormat.format(142)); // Turn Spindle Load Monitor Off
    prevLoadMonitorVal = 0;
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
        writeComment(localize("ZMIN") + "=" + xyzFormat.format(zRange.getMinimum()));
      }
    }

    if (getProperty("preloadTool")) {
      if (getProperty("safeToolChange")) {
        forceSequenceNumbers(true);
        writeBlock("IF [ VTLCN EQ " + toolFormat.format(tool.number) + " ] N" + skipNLines(5));
        writeBlock("IF [ VTLNN EQ " + toolFormat.format(tool.number) + " ] N" + skipNLines(3));
        writeBlock("IF [ VTLNN EQ 0 ] N" + skipNLines(2));
        writeBlock(mFormat.format(64));
        writeBlock(mFormat.format(6), "T" + toolFormat.format(tool.number));
      } else {
        if (!isFirstSection()) {
          writeComment("T" + toolFormat.format(tool.number));
          writeBlock(mFormat.format(6));
        } else {
          writeBlock("T" + toolFormat.format(tool.number), mFormat.format(6));
        }
      }
      var nextTool = getNextTool(tool.number);
      if (nextTool) {
        writeBlock("T" + toolFormat.format(nextTool.number));
      } else {
        // preload first tool
        var firstToolNumber = getSection(0).getTool().number;
        if (tool.number != firstToolNumber) {
          writeBlock("T" + toolFormat.format(firstToolNumber));
        } else if (getProperty("safeToolChange")) {
          writeBlock(formatComment("*"));
        }
      }
    } else {
      if (getProperty("safeToolChange")) {
        forceSequenceNumbers(true);
        writeBlock("IF [ VTLCN EQ " + toolFormat.format(tool.number) + " ] N" + skipNLines(2));
        writeBlock(mFormat.format(6), "T" + toolFormat.format(tool.number));
        writeBlock(formatComment("*"));
      } else {
        writeBlock("T" + toolFormat.format(tool.number), mFormat.format(6));
      }
    }
    forceSequenceNumbers(false);
  }

  // Turn on Simplified Load Monitoring
  if ((loadMonitorVal > 0) && spindleChanged && !isProbeOperation()) {
    writeBlock(mFormat.format(143), "VSLNO=1");
    writeBlock("VSLDT[1,", loadMonitorVal + "]");
    prevLoadMonitorVal = loadMonitorVal;
  }

  if (tool.type != TOOL_PROBE && spindleChanged) {
    forceSpindleSpeed = false;

    if (spindleSpeed < 1) {
      error(localize("Spindle speed out of range."));
      return;
    }
    if (spindleSpeed > 65535) {
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
    warningOnce(
      localize("Work offset has not been specified. Using " + formatWords(gFormat.format(15), hFormat.format(1)) + " as WCS."),
      WARNING_WORK_OFFSET
    );
    workOffset = 1;
  }
  if (useMultiAxisFeatures && workOffset == fixtureOffsetWCS) {
    error(subst(localize("Work offset %1 is reserved for the fixture offset macro, please specify a different work offset."), fixtureOffsetWCS));
    return;
  }
  if (workOffset > 0) {
    if (workOffset > 200) {
      error(localize("Work offset out of range."));
    }
    if (workOffset != currentWorkOffset) {
      writeBlock(gFormat.format(15), hFormat.format(workOffset));
      currentWorkOffset = workOffset;
    }
  }

  forceXYZ();
  gAbsIncModal.reset();

  var abc;

  if (machineConfiguration.isMultiAxisConfiguration()) { // use 5-axis indexing for multi-axis mode
    // set working plane after datum shift

    abc = new Vector(0, 0, 0);
    if (currentSection.isMultiAxis()) {
      cancelTransformation();
      forceWorkPlane();
      onCommand(COMMAND_UNLOCK_MULTI_AXIS);
      gMotionModal.reset();
      abc = currentSection.getInitialToolAxisABC();
      if (!retracted && newWorkPlane) {
        writeRetract(Z);
      }
      if (currentSection.getOptimizedTCPMode() == OPTIMIZE_NONE && getProperty("useCAS")) {
        writeBlock(mFormat.format(510), formatComment("DISABLE CAS"));
      }
      positionABC(abc, true);
    } else {
      abc = defineWorkPlane(currentSection, true);
    }
  } else { // pure 3D
    var remaining = currentSection.workPlane;
    if (!isSameDirection(remaining.forward, new Vector(0, 0, 1)) || currentSection.isMultiAxis()) {
      error(localize("Tool orientation is not supported."));
      return;
    }

    setRotation(remaining);
  }

  setProbeAngle(); // output probe angle rotations if required
  // set coolant after we have positioned at Z
  setCoolant(tool.coolant);

  setSmoothing(smoothing.isAllowed);

  gMotionModal.reset();

  var initialPosition = getFramePosition(currentSection.getInitialPosition());
  if (!retracted && !insertToolCall) {
    if (getCurrentPosition().z < initialPosition.z) {
      writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
      zIsOutput = true;
    }
  }

  var lengthOffset = tool.lengthOffset;
  if (lengthOffset > 300) {
    error(localize("Length offset out of range."));
    return;
  }

  writeBlock(gPlaneModal.format(17));

  var isPrepositioned = false;
  if (currentSection.isMultiAxis() && useMultiAxisFeatures) { // use 5-axis indexing for multi-axis mode
    var W;
    if (machineConfiguration.isMultiAxisConfiguration()) {
      W = machineConfiguration.getOrientation(abc);
    } else {
      W = Matrix.getOrientationFromDirection(currentSection.getGlobalInitialToolAxis());
    }
    // position in the 3+2 frame
    var prePosition = W.getTransposed().multiply(initialPosition);
    setWorkPlane(abc);
    writeBlock(gMotionModal.format(0), xOutput.format(prePosition.x), yOutput.format(prePosition.y));
    cancelWorkPlane(true);
    isPrepositioned = true;
  }

  forceAny();
  if (currentSection.getOptimizedTCPMode() == OPTIMIZE_NONE && currentSection.isMultiAxis()) {
    writeBlock(
      gFormat.format(169),
      xOutput.format(initialPosition.x),
      yOutput.format(initialPosition.y),
      zOutput.format(useMultiAxisFeatures ? initialPosition.z : (unit == IN) ? 400 : 9999),
      aOutput.format(abc.x),
      bOutput.format(abc.y),
      cOutput.format(abc.z),
      "H" + lengthOffset,
      getRotaryDirectionCode(abc)
    );
    gMotionModal.reset();
  } else {
    if (!machineConfiguration.isHeadConfiguration()) {
      writeBlock(gMotionModal.format(0), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y));
      writeBlock(gMotionModal.format(0), gFormat.format(56), zOutput.format(initialPosition.z), hFormat.format(lengthOffset));
    } else {
      writeBlock(
        gMotionModal.format(0),
        gFormat.format(56), xOutput.format(initialPosition.x),
        yOutput.format(initialPosition.y),
        zOutput.format(initialPosition.z), hFormat.format(lengthOffset)
      );
    }
  }

  if (insertToolCall || retracted || (!isFirstSection() && getPreviousSection().isMultiAxis())) {
    zIsOutput = true;
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

  if (isProbeOperation()) {
    validate(probeVariables.probeAngleMethod != "G68", "You cannot probe while G11 Rotation is in effect.");
    writeBlock(callFormat.format(9832)); // spin the probe on
    feedOutput.reset();
  }
  abc = defineWorkPlane(currentSection, false);
  // define subprogram
  subprogramDefine(initialPosition, abc, retracted, zIsOutput);

  retracted = false;
}

function onDwell(seconds) {
  seconds = clamp(0.001, seconds, 99999.999);
  // unit is set in the machine
  writeBlock(gFeedModeModal.format(94), gFormat.format(4), "F" + secFormat.format(seconds));
}

function onSpindleSpeed(spindleSpeed) {
  writeBlock(sOutput.format(spindleSpeed));
}

function onCycle() {
  writeBlock(gPlaneModal.format(17), gFeedModeModal.format(94));
  if (isProbeOperation()) {
    xOutput.setPrefix("PX=");
    yOutput.setPrefix("PY=");
    zOutput.setPrefix("PZ=");
    feedOutput.setPrefix("PF=");
  }
}

function getCommonCycle(x, y, z, r) {
  forceXYZ();
  return [xOutput.format(x), yOutput.format(y),
    zOutput.format(z),
    "R" + xyzFormat.format(r)];
}

function setCyclePosition(_position) {
  switch (gPlaneModal.getCurrent()) {
  case 17: // XY
    zOutput.format(_position);
    break;
  case 18: // ZX
    yOutput.format(_position);
    break;
  case 19: // YZ
    xOutput.format(_position);
    break;
  }
}

/** Convert approach to sign. */
function approach(value) {
  validate((value == "positive") || (value == "negative"), "Invalid approach.");
  return (value == "positive") ? 1 : -1;
}

function setProbeAngleMethod() {
  probeVariables.probeAngleMethod = (machineConfiguration.getNumberOfAxes() < 5 || is3D()) ? "G68" : "UNSUPPORTED";
  var axes = [machineConfiguration.getAxisU(), machineConfiguration.getAxisV(), machineConfiguration.getAxisW()];
  for (var i = 0; i < axes.length; ++i) {
    if (axes[i].isEnabled() && isSameDirection((axes[i].getAxis()).getAbsolute(), new Vector(0, 0, 1)) && axes[i].isTable()) {
      probeVariables.probeAngleMethod = "AXIS_ROT";
      break;
    }
  }
  probeVariables.outputRotationCodes = true;
}

/** Output rotation offset based on angular probing cycle. */
function setProbeAngle() {
  if (probeVariables.outputRotationCodes) {
    validate(probeOutputWorkOffset <= 6, "Angular Probing only supports work offsets 1-6.");
    if (probeVariables.probeAngleMethod == "G68" && (Vector.diff(currentSection.getGlobalInitialToolAxis(), new Vector(0, 0, 1)).length > 1e-4)) {
      error(localize("You cannot use multi axis toolpaths while G68 Rotation is in effect."));
    }
    var validateWorkOffset = false;
    switch (probeVariables.probeAngleMethod) {
    case "G68":
      gRotationModal.reset();
      gAbsIncModal.reset();
      writeBlock(
        gPlaneModal.format(17), gAbsIncModal.format(90), gRotationModal.format(11),
        probeVariables.compensationXY, "P=VS84"
      );
      validateWorkOffset = true;
      break;
    case "AXIS_ROT":
      var param = "VZOFC[" + probeOutputWorkOffset + "]";
      writeBlock("VC84=VS84");
      writeBlock(param + " = " + param + " + VC84");
      forceWorkPlane(); // force workplane to rotate ABC in order to apply rotation offsets
      currentWorkOffset = undefined; // force WCS output to make use of updated parameters
      validateWorkOffset = true;
      break;
    default:
      error(localize("Angular Probing is not supported for this machine configuration."));
      return;
    }
    if (validateWorkOffset) {
      for (var i = currentSection.getId(); i < getNumberOfSections(); ++i) {
        if (getSection(i).workOffset != currentSection.workOffset) {
          error(localize("WCS offset cannot change while using angle rotation compensation."));
          return;
        }
      }
    }
    probeVariables.outputRotationCodes = false;
  }
}

function protectedProbeMove(_cycle, x, y, z) {
  var _x = xOutput.format(x);
  var _y = yOutput.format(y);
  var _z = zOutput.format(z);
  if (_z && z >= getCurrentPosition().z) {
    writeBlock(callFormat.format(9810), _z, getFeed(cycle.feedrate)); // protected positioning move
  }
  if (_x || _y) {
    writeBlock(callFormat.format(9810), _x, _y, getFeed(highFeedrate)); // protected positioning move
  }
  if (_z && z < getCurrentPosition().z) {
    writeBlock(callFormat.format(9810), _z, getFeed(cycle.feedrate)); // protected positioning move
  }
}

function onCyclePoint(x, y, z) {
  if (!isSameDirection(getRotation().forward, new Vector(0, 0, 1))) {
    expandCyclePoint(x, y, z);
    return;
  }

  if (isProbeOperation()) {
    if (!useMultiAxisFeatures && !isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1))) {
      if (!allowIndexingWCSProbing && currentSection.strategy == "probe") {
        error(localize("Updating WCS / work offset using probing is only supported by the CNC in the WCS frame."));
        return;
      }
    }
    protectedProbeMove(cycle, x, y, z);
  }

  if (isFirstCyclePoint() || isProbeOperation()) {
    if (!isProbeOperation()) {
      // return to initial Z which is clearance plane and set absolute mode
      repositionToCycleClearance(cycle, x, y, z);
    }
    var g71 = z71Output.format(cycle.clearance);
    if (g71) {
      g71 = formatWords(gFormat.format(71), g71);
    }
    // NCYL

    var F = cycle.feedrate;
    var P = !cycle.dwell ? 0 : clamp(1, cycle.dwell * 1000, 99999999); // in milliseconds

    switch (cycleType) {
    case "drilling":
      if (g71) {
        writeBlock(g71);
      }
      writeBlock(
        gPlaneModal.format(17), gAbsIncModal.format(90), gCycleModal.format(81),
        getCommonCycle(x, y, z, cycle.retract),
        feedOutput.format(F), mFormat.format(53)
      );
      break;
    case "counter-boring":
      if (g71) {
        writeBlock(g71);
      }
      writeBlock(
        gPlaneModal.format(17), gAbsIncModal.format(90), gCycleModal.format(82),
        getCommonCycle(x, y, z, cycle.retract),
        conditional(P > 0, "P" + milliFormat.format(P)),
        feedOutput.format(F), mFormat.format(53)
      );
      break;
    case "chip-breaking":
      if (g71) {
        writeBlock(g71);
      }
      if (cycle.accumulatedDepth < cycle.depth) {
        writeBlock(
          gPlaneModal.format(17), gAbsIncModal.format(90), gCycleModal.format(83),
          getCommonCycle(x, y, z, cycle.retract),
          conditional(P > 0, "P" + milliFormat.format(P)),
          "I" + xyzFormat.format(cycle.incrementalDepth),
          "J" + xyzFormat.format(cycle.accumulatedDepth),
          feedOutput.format(F), mFormat.format(53)
        );
      } else {
        writeBlock(
          gPlaneModal.format(17), gAbsIncModal.format(90), gCycleModal.format(73),
          getCommonCycle(x, y, z, cycle.retract),
          "Q" + xyzFormat.format(cycle.incrementalDepth),
          conditional(P > 0, "P" + milliFormat.format(P)),
          feedOutput.format(F), mFormat.format(53)
        );
      }
      break;
    case "deep-drilling":
      if (g71) {
        writeBlock(g71);
      }
      writeBlock(
        gPlaneModal.format(17), gAbsIncModal.format(90), gCycleModal.format(83),
        getCommonCycle(x, y, z, cycle.retract),
        "Q" + xyzFormat.format(cycle.incrementalDepth),
        conditional(P > 0, "P" + milliFormat.format(P)),
        feedOutput.format(F), mFormat.format(53)
      );
      break;
    case "tapping":
      if (!F) {
        F = tool.getTappingFeedrate();
      }
      if (g71) {
        writeBlock(g71);
      }
      writeBlock(
        gPlaneModal.format(17), gAbsIncModal.format(90), gCycleModal.format((tool.type == TOOL_TAP_LEFT_HAND) ? 74 : (useG284 ? 284 : 84)),
        getCommonCycle(x, y, z, cycle.retract),
        feedOutput.format(F),
        mFormat.format(53)
      );
      break;
    case "left-tapping":
      if (!F) {
        F = tool.getTappingFeedrate();
      }
      if (g71) {
        writeBlock(g71);
      }
      writeBlock(
        gPlaneModal.format(17), gAbsIncModal.format(90), gCycleModal.format(74),
        getCommonCycle(x, y, z, cycle.retract),
        feedOutput.format(F),
        mFormat.format(53)
      );
      break;
    case "right-tapping":
      if (!F) {
        F = tool.getTappingFeedrate();
      }
      if (g71) {
        writeBlock(g71);
      }
      writeBlock(
        gPlaneModal.format(17), gAbsIncModal.format(90), gCycleModal.format(useG284 ? 284 : 84),
        getCommonCycle(x, y, z, cycle.retract),
        feedOutput.format(F),
        mFormat.format(53)
      );
      break;
    case "tapping-with-chip-breaking":
    case "left-tapping-with-chip-breaking":
    case "right-tapping-with-chip-breaking":
      if (cycle.accumulatedDepth < cycle.depth) {
        error(localize("Accumulated pecking depth is not supported for tapping cycles with chip breaking."));
        return;
      }
      if (!F) {
        F = tool.getTappingFeedrate();
      }
      if (g71) {
        writeBlock(g71);
      }
      // K is retract amount
      writeBlock(
        gPlaneModal.format(17), gAbsIncModal.format(90), gCycleModal.format((tool.type == TOOL_TAP_LEFT_HAND ? 273 : 283)),
        gFeedModeModal.format(95), // feed per revolution
        getCommonCycle(x, y, z, cycle.retract),
        conditional(P > 0, "P" + secFormat.format(P / 1000.0)),
        "Q" + xyzFormat.format(cycle.incrementalDepth),
        "F" + pitchFormat.format((gFeedModeModal.getCurrent() == 95) ? tool.getThreadPitch() : F), // for G95 F is pitch, for G94 F is pitch*spindle rpm
        sOutput.format(spindleSpeed),
        "E0", // spindle position
        mFormat.format(53)
      );
      forceFeed();
      break;
    case "fine-boring":
      // TAG: use I/J for shift
      if (g71) {
        writeBlock(g71);
      }
      writeBlock(
        gPlaneModal.format(17), gAbsIncModal.format(90), gCycleModal.format(76),
        getCommonCycle(x, y, z, cycle.retract),
        "Q" + xyzFormat.format(cycle.shift),
        conditional(P > 0, "P" + milliFormat.format(P)),
        feedOutput.format(F), mFormat.format(53)
      );
      break;
    case "back-boring":
      // TAG: use I/J for shift
      if (g71) {
        writeBlock(g71);
      }
      var dx = (gPlaneModal.getCurrent() == 19) ? cycle.backBoreDistance : 0;
      var dy = (gPlaneModal.getCurrent() == 18) ? cycle.backBoreDistance : 0;
      var dz = (gPlaneModal.getCurrent() == 17) ? cycle.backBoreDistance : 0;
      writeBlock(
        gPlaneModal.format(17), gRetractModal.format(98), gAbsIncModal.format(90), gCycleModal.format(87),
        getCommonCycle(x - dx, y - dy, z - dz, cycle.bottom),
        "Q" + xyzFormat.format(cycle.shift),
        conditional(P > 0, "P" + milliFormat.format(P)),
        feedOutput.format(F), mFormat.format(53)
      );
      break;
    case "reaming":
      var FA = cycle.retractFeedrate;
      if (g71) {
        writeBlock(g71);
      }
      writeBlock(
        gPlaneModal.format(17), gAbsIncModal.format(90), gCycleModal.format(85),
        getCommonCycle(x, y, z, cycle.retract),
        conditional(P > 0, "P" + milliFormat.format(P)),
        feedOutput.format(F),
        conditional(FA != F, "FA=" + feedFormat.format(FA)), mFormat.format(53)
      );
      break;
    case "stop-boring":
      if (g71) {
        writeBlock(g71);
      }
      writeBlock(
        gPlaneModal.format(17), gAbsIncModal.format(90), gCycleModal.format(86),
        getCommonCycle(x, y, z, cycle.retract),
        conditional(P > 0, "P" + milliFormat.format(P)),
        feedOutput.format(F), mFormat.format(53)
      );
      if (getProperty("dwellAfterStop") > 0) {
        // make sure spindle reaches full spindle speed
        var seconds = clamp(0.001, getProperty("dwellAfterStop"), 99999.999);
        writeBlock(gFormat.format(4), "F" + secFormat.format(seconds));
      }
      break;
    case "manual-boring":
      expandCyclePoint(x, y, z);
      break;
    case "boring":
      var FA = cycle.retractFeedrate;
      if (g71) {
        writeBlock(g71);
      }
      writeBlock(
        gPlaneModal.format(17), gAbsIncModal.format(90), gCycleModal.format(89),
        getCommonCycle(x, y, z, cycle.retract),
        conditional(P > 0, "P" + milliFormat.format(P)),
        feedOutput.format(F),
        conditional(FA != F, "FA=" + feedFormat.format(FA)), mFormat.format(53)
      );
      break;
    case "probing-x":
      protectedProbeMove(cycle, x, y, z - cycle.depth);
      writeBlock(
        callFormat.format(9811),
        "PX=" + xyzFormat.format(x + approach(cycle.approach1) * (cycle.probeClearance + tool.diameter / 2)),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        getProbingArguments(cycle, true)
      );
      break;
    case "probing-y":
      protectedProbeMove(cycle, x, y, z - cycle.depth);
      writeBlock(
        callFormat.format(9811),
        "PY=" + xyzFormat.format(y + approach(cycle.approach1) * (cycle.probeClearance + tool.diameter / 2)),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        getProbingArguments(cycle, true)
      );
      break;
    case "probing-z":
      protectedProbeMove(cycle, x, y, Math.min(z - cycle.depth + cycle.probeClearance, cycle.retract));
      writeBlock(
        callFormat.format(9811),
        "PZ=" + xyzFormat.format(z - cycle.depth),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        getProbingArguments(cycle, true)
      );
      break;
    case "probing-x-wall":
      protectedProbeMove(cycle, x, y, z);
      writeBlock(
        callFormat.format(9812),
        "PX=" + xyzFormat.format(cycle.width1),
        "PZ=" + xyzFormat.format(z - cycle.depth),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        "PR=" + xyzFormat.format(cycle.probeClearance),
        getProbingArguments(cycle, true)
      );
      break;
    case "probing-y-wall":
      protectedProbeMove(cycle, x, y, z);
      writeBlock(
        callFormat.format(9812),
        "PY=" + xyzFormat.format(cycle.width1),
        "PZ=" + xyzFormat.format(z - cycle.depth),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        "PR=" + xyzFormat.format(cycle.probeClearance),
        getProbingArguments(cycle, true)
      );
      break;
    case "probing-x-channel":
      protectedProbeMove(cycle, x, y, z - cycle.depth);
      writeBlock(
        callFormat.format(9812),
        "PX=" + xyzFormat.format(cycle.width1),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        // not required "R" + xyzFormat.format(cycle.probeClearance),
        getProbingArguments(cycle, true)
      );
      break;
    case "probing-x-channel-with-island":
      protectedProbeMove(cycle, x, y, z);
      writeBlock(
        callFormat.format(9812),
        "PX=" + xyzFormat.format(cycle.width1),
        "PZ=" + xyzFormat.format(z - cycle.depth),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        "PR=" + xyzFormat.format(-cycle.probeClearance),
        getProbingArguments(cycle, true)
      );
      break;
    case "probing-y-channel":
      protectedProbeMove(cycle, x, y, z - cycle.depth);
      writeBlock(
        callFormat.format(9812),
        "PY=" + xyzFormat.format(cycle.width1),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        // not required "R" + xyzFormat.format(cycle.probeClearance),
        getProbingArguments(cycle, true)
      );
      break;
    case "probing-y-channel-with-island":
      protectedProbeMove(cycle, x, y, z);
      writeBlock(
        callFormat.format(9812),
        "PY=" + xyzFormat.format(cycle.width1),
        zOutput.format(z - cycle.depth),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        "PR=" + xyzFormat.format(-cycle.probeClearance),
        getProbingArguments(cycle, true)
      );
      break;
    case "probing-xy-circular-boss":
      protectedProbeMove(cycle, x, y, z);
      writeBlock(
        callFormat.format(9814),
        "PD=" + xyzFormat.format(cycle.width1),
        "PZ=" + xyzFormat.format(z - cycle.depth),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        "PR=" + xyzFormat.format(cycle.probeClearance),
        getProbingArguments(cycle, true)
      );
      break;
    case "probing-xy-circular-partial-boss":
      protectedProbeMove(cycle, x, y, z);
      writeBlock(
        callFormat.format(9823),
        "PA=" + xyzFormat.format(cycle.partialCircleAngleA),
        "PB=" + xyzFormat.format(cycle.partialCircleAngleB),
        "PC=" + xyzFormat.format(cycle.partialCircleAngleC),
        "PD=" + xyzFormat.format(cycle.width1),
        "PZ=" + xyzFormat.format(z - cycle.depth),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        "PR=" + xyzFormat.format(cycle.probeClearance),
        getProbingArguments(cycle, true)
      );
      break;
    case "probing-xy-circular-hole":
      protectedProbeMove(cycle, x, y, z - cycle.depth);
      writeBlock(
        callFormat.format(9814),
        "PD=" + xyzFormat.format(cycle.width1),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        // not required "R" + xyzFormat.format(cycle.probeClearance),
        getProbingArguments(cycle, true)
      );
      break;
    case "probing-xy-circular-partial-hole":
      protectedProbeMove(cycle, x, y, z - cycle.depth);
      writeBlock(
        callFormat.format(9823),
        "PA=" + xyzFormat.format(cycle.partialCircleAngleA),
        "PB=" + xyzFormat.format(cycle.partialCircleAngleB),
        "PC=" + xyzFormat.format(cycle.partialCircleAngleC),
        "PD=" + xyzFormat.format(cycle.width1),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        getProbingArguments(cycle, true)
      );
      break;
    case "probing-xy-circular-hole-with-island":
      protectedProbeMove(cycle, x, y, z);
      writeBlock(
        callFormat.format(9814),
        "PZ=" + xyzFormat.format(z - cycle.depth),
        "PD=" + xyzFormat.format(cycle.width1),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        "PR=" + xyzFormat.format(-cycle.probeClearance),
        getProbingArguments(cycle, true)
      );
      break;
    case "probing-xy-circular-partial-hole-with-island":
      protectedProbeMove(cycle, x, y, z);
      writeBlock(
        callFormat.format(9823),
        "PZ=" + xyzFormat.format(z - cycle.depth),
        "PA=" + xyzFormat.format(cycle.partialCircleAngleA),
        "PB=" + xyzFormat.format(cycle.partialCircleAngleB),
        "PC=" + xyzFormat.format(cycle.partialCircleAngleC),
        "PD=" + xyzFormat.format(cycle.width1),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        "PR=" + xyzFormat.format(-cycle.probeClearance),
        getProbingArguments(cycle, true)
      );
      break;
    case "probing-xy-rectangular-hole":
      protectedProbeMove(cycle, x, y, z - cycle.depth);
      writeBlock(
        callFormat.format(9812),
        "PX=" + xyzFormat.format(cycle.width1),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        // not required "R" + xyzFormat.format(-cycle.probeClearance),
        getProbingArguments(cycle, true)
      );
      writeBlock(
        callFormat.format(9812),
        "PY=" + xyzFormat.format(cycle.width2),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        // not required "R" + xyzFormat.format(-cycle.probeClearance),
        getProbingArguments(cycle, true)
      );
      break;
    case "probing-xy-rectangular-boss":
      protectedProbeMove(cycle, x, y, z);
      writeBlock(
        callFormat.format(9812),
        "PZ=" + xyzFormat.format(z - cycle.depth),
        "PX=" + xyzFormat.format(cycle.width1),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        "PR=" + xyzFormat.format(cycle.probeClearance),
        getProbingArguments(cycle, true)
      );
      writeBlock(
        callFormat.format(9812),
        "PZ=" + xyzFormat.format(z - cycle.depth),
        "PY=" + xyzFormat.format(cycle.width2),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        "PR=" + xyzFormat.format(cycle.probeClearance),
        getProbingArguments(cycle, true)
      );
      break;
    case "probing-xy-rectangular-hole-with-island":
      protectedProbeMove(cycle, x, y, z);
      writeBlock(
        callFormat.format(9812),
        "PZ=" + xyzFormat.format(z - cycle.depth),
        "PX=" + xyzFormat.format(cycle.width1),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        "PR=" + xyzFormat.format(-cycle.probeClearance),
        getProbingArguments(cycle, true)
      );
      writeBlock(
        callFormat.format(9812),
        "PZ=" + xyzFormat.format(z - cycle.depth),
        "PY=" + xyzFormat.format(cycle.width2),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        "PR=" + xyzFormat.format(-cycle.probeClearance),
        getProbingArguments(cycle, true)
      );
      break;
    case "probing-xy-inner-corner":
      var cornerX = x + approach(cycle.approach1) * (cycle.probeClearance + tool.diameter / 2);
      var cornerY = y + approach(cycle.approach2) * (cycle.probeClearance + tool.diameter / 2);
      var cornerI = 0;
      var cornerJ = 0;
      if (cycle.probeSpacing !== undefined) {
        cornerI = cycle.probeSpacing;
        cornerJ = cycle.probeSpacing;
      }
      if ((cornerI != 0) && (cornerJ != 0)) {
        if (currentSection.strategy == "probe") {
          setProbeAngleMethod();
          probeVariables.compensationXY = "X=VS75 Y=VS76";
        }
      }
      protectedProbeMove(cycle, x, y, z - cycle.depth);
      writeBlock(
        callFormat.format(9815), xOutput.format(cornerX), yOutput.format(cornerY),
        conditional(cornerI != 0, "PI=" + xyzFormat.format(cornerI)),
        conditional(cornerJ != 0, "PJ=" + xyzFormat.format(cornerJ)),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        getProbingArguments(cycle, true)
      );
      break;
    case "probing-xy-outer-corner":
      var cornerX = x + approach(cycle.approach1) * (cycle.probeClearance + tool.diameter / 2);
      var cornerY = y + approach(cycle.approach2) * (cycle.probeClearance + tool.diameter / 2);
      var cornerI = 0;
      var cornerJ = 0;
      if (cycle.probeSpacing !== undefined) {
        cornerI = cycle.probeSpacing;
        cornerJ = cycle.probeSpacing;
      }
      if ((cornerI != 0) && (cornerJ != 0)) {
        if (currentSection.strategy == "probe") {
          setProbeAngleMethod();
          probeVariables.compensationXY = "X=VS75 Y=VS76";
        }
      }
      protectedProbeMove(cycle, x, y, z - cycle.depth);
      writeBlock(
        callFormat.format(9816), xOutput.format(cornerX), yOutput.format(cornerY),
        conditional(cornerI != 0, "PI=" + xyzFormat.format(cornerI)),
        conditional(cornerJ != 0, "PJ=" + xyzFormat.format(cornerJ)),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        getProbingArguments(cycle, true)
      );
      break;
    case "probing-x-plane-angle":
      protectedProbeMove(cycle, x, y, z - cycle.depth);
      writeBlock(
        callFormat.format(9843),
        "PX=" + xyzFormat.format(x + approach(cycle.approach1) * (cycle.probeClearance + tool.diameter / 2)),
        "PD=" + xyzFormat.format(cycle.probeSpacing),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        "PA=" + xyzFormat.format(cycle.nominalAngle != undefined ? cycle.nominalAngle : 90),
        getProbingArguments(cycle, false)
      );
      if (currentSection.strategy == "probe") {
        setProbeAngleMethod();
        probeVariables.compensationXY = "X" + xyzFormat.format(0) + " Y" + xyzFormat.format(0);
      }
      break;
    case "probing-y-plane-angle":
      protectedProbeMove(cycle, x, y, z - cycle.depth);
      writeBlock(
        callFormat.format(9843),
        "PY=" + xyzFormat.format(y + approach(cycle.approach1) * (cycle.probeClearance + tool.diameter / 2)),
        "PD=" + xyzFormat.format(cycle.probeSpacing),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        "PA=" + xyzFormat.format(cycle.nominalAngle != undefined ? cycle.nominalAngle : 0),
        getProbingArguments(cycle, false)
      );
      if (currentSection.strategy == "probe") {
        setProbeAngleMethod();
        probeVariables.compensationXY = "X" + xyzFormat.format(0) + " Y" + xyzFormat.format(0);
      }
      break;
    case "probing-xy-pcd-hole":
      protectedProbeMove(cycle, x, y, z);
      writeBlock(
        callFormat.format(9819),
        "PA=" + xyzFormat.format(cycle.pcdStartingAngle),
        "PB=" + xyzFormat.format(cycle.numberOfSubfeatures),
        "PC=" + xyzFormat.format(cycle.widthPCD),
        "PD=" + xyzFormat.format(cycle.widthFeature),
        "PK=" + xyzFormat.format(z - cycle.depth),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        getProbingArguments(cycle, false)
      );
      if (cycle.updateToolWear) {
        error(localize("Action -Update Tool Wear- is not supported with this cycle."));
        return;
      }
      break;
    case "probing-xy-pcd-boss":
      protectedProbeMove(cycle, x, y, z);
      writeBlock(
        callFormat.format(9819),
        "PA=" + xyzFormat.format(cycle.pcdStartingAngle),
        "PB=" + xyzFormat.format(cycle.numberOfSubfeatures),
        "PC=" + xyzFormat.format(cycle.widthPCD),
        "PD=" + xyzFormat.format(cycle.widthFeature),
        "PZ=" + xyzFormat.format(z - cycle.depth),
        "PQ=" + xyzFormat.format(cycle.probeOvertravel),
        "PR=" + xyzFormat.format(cycle.probeClearance),
        getProbingArguments(cycle, false)
      );
      if (cycle.updateToolWear) {
        error(localize("Action -Update Tool Wear- is not supported with this cycle."));
        return;
      }
      break;
    default:
      expandCyclePoint(x, y, z);
    }
    // place cycle operation in subprogram
    if (cycleSubprogramIsActive) {
      if (cycleExpanded || isProbeOperation()) {
        cycleSubprogramIsActive = false;
      } else {
        // call subprogram
        writeBlock(callFormat.format(currentSubprogram));
        subprogramStart(new Vector(x, y, z), new Vector(0, 0, 0), false);
      }
    }
    if (incrementalMode) { // set current position to clearance height
      setCyclePosition(cycle.clearance);
    }
  } else {
    if (cycleExpanded) {
      expandCyclePoint(x, y, z);
    } else {
      if (cycleSubprogramIsActive) {
        if (!xyzFormat.areDifferent(x, xOutput.getCurrent()) &&
        !xyzFormat.areDifferent(y, yOutput.getCurrent()) &&
        !xyzFormat.areDifferent(z, zOutput.getCurrent())) {
          switch (gPlaneModal.getCurrent()) {
          case 17: // XY
            xOutput.reset(); // at least one axis is required
            break;
          case 18: // ZX
            zOutput.reset(); // at least one axis is required
            break;
          case 19: // YZ
            yOutput.reset(); // at least one axis is required
            break;
          }
        }
        if (incrementalMode) { // set current position to retract height
          setCyclePosition(cycle.retract);
        }
        writeBlock(xOutput.format(x), yOutput.format(y), zOutput.format(z));
        if (incrementalMode) { // set current position to clearance height
          setCyclePosition(cycle.clearance);
        }
      } else {
        var _x = xOutput.format(x);
        var _y = yOutput.format(y);
        if (_x || _y) {
          writeBlock(_x, _y);
          // we could add dwell here to make sure spindle reaches full spindle speed if the spindle has been stopped
        }
      }
    }
  }
}

function getProbingArguments(cycle, updateWCS) {
  var outputWCSCode = updateWCS && currentSection.strategy == "probe";
  if (outputWCSCode) {
    validate(probeOutputWorkOffset <= 100, "Work offset is out of range.");
    var nextWorkOffset = hasNextSection() ? getNextSection().workOffset == 0 ? 1 : getNextSection().workOffset : -1;
    if (probeOutputWorkOffset == nextWorkOffset) {
      currentWorkOffset = undefined;
    }
  }
  return [
    (cycle.angleAskewAction == "stop-message" ? "PB=" + xyzFormat.format(cycle.toleranceAngle ? cycle.toleranceAngle : 0) : undefined),
    ((cycle.updateToolWear && cycle.toolWearErrorCorrection < 100) ? "PF=" + xyzFormat.format(cycle.toolWearErrorCorrection ? cycle.toolWearErrorCorrection / 100 : 100) : undefined),
    (cycle.wrongSizeAction == "stop-message" ? "PH=" + xyzFormat.format(cycle.toleranceSize ? cycle.toleranceSize : 0) : undefined),
    (cycle.outOfPositionAction == "stop-message" ? "PM=" + xyzFormat.format(cycle.tolerancePosition ? cycle.tolerancePosition : 0) : undefined),
    ((cycle.updateToolWear && cycleType == "probing-z") ? "PT=" + xyzFormat.format(cycle.toolLengthOffset) : undefined),
    ((cycle.updateToolWear && cycleType !== "probing-z") ? "PT=" + xyzFormat.format(cycle.toolDiameterOffset) : undefined),
    (cycle.updateToolWear ? "PV=" + xyzFormat.format(cycle.toolWearUpdateThreshold ? cycle.toolWearUpdateThreshold : 0) : undefined),
    (cycle.printResults ? "PW=" + xyzFormat.format(1 + cycle.incrementComponent) : undefined), // 1 for advance feature, 2 for reset feature count and advance component number. first reported result in a program should use W2.
    conditional(outputWCSCode, "PS=" + probeWCSFormat.format(probeOutputWorkOffset))
  ];
}

function onCycleEnd() {
  if (isProbeOperation()) {
    zOutput.reset();
    gMotionModal.reset();
    writeBlock(callFormat.format(9810), zOutput.format(cycle.retract)); // protected retract move
    xOutput.setPrefix("X");
    yOutput.setPrefix("Y");
    zOutput.setPrefix("Z");
    feedOutput.setPrefix("F");
  } else {
    if (cycleSubprogramIsActive) {
      subprogramEnd();
      cycleSubprogramIsActive = false;
    }
    if (!cycleExpanded) {
      writeBlock(gFeedModeModal.format(94));
      gMotionModal.reset();
      zOutput.reset();
      writeBlock(gMotionModal.format(0), zOutput.format(getCurrentPosition().z)); // avoid spindle stop
      gCycleModal.reset();
    // writeBlock(gCycleModal.format(80)); // not good since it stops spindle
    }
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
    }
    writeBlock(gMotionModal.format(0), x, y, z);
    forceFeed();
  }
}

function onLinear(_x, _y, _z, feed) {
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var f = getFeed(feed);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      var d = tool.diameterOffset;
      if (d > 300) {
        warning(localize("The diameter offset exceeds the maximum value."));
      }
      writeBlock(gPlaneModal.format(17));
      switch (radiusCompensation) {
      case RADIUS_COMPENSATION_LEFT:
        dOutput.reset();
        writeBlock(gMotionModal.format(1), gFormat.format(41), x, y, z, dOutput.format(d), f);
        break;
      case RADIUS_COMPENSATION_RIGHT:
        dOutput.reset();
        writeBlock(gMotionModal.format(1), gFormat.format(42), x, y, z, dOutput.format(d), f);
        break;
      default:
        writeBlock(gMotionModal.format(1), gFormat.format(40), x, y, z, f);
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
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("This post configuration has not been customized for 5-axis simultaneous toolpath."));
    return;
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation mode cannot be changed at rapid traversal."));
    return;
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var a = aOutput.format(_a);
  var b = bOutput.format(_b);
  var c = cOutput.format(_c);
  var m = getRotaryDirectionCode(new Vector(_a, _b, _c));
  if (x || y || z || a || b || c) {
    writeBlock(gMotionModal.format(0), x, y, z, a, b, c, m);
    forceFeed();
  }
}

function onLinear5D(_x, _y, _z, _a, _b, _c, feed) {
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("This post configuration has not been customized for 5-axis simultaneous toolpath."));
    return;
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for 5-axis move."));
    return;
  }

  forceXYZ();
  forceABC();
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var a = aOutput.format(_a);
  var b = bOutput.format(_b);
  var c = cOutput.format(_c);

  // get feedrate number
  var f = {frn:0, fmode:0};
  if (a || b || c) {
    f = getMultiaxisFeed(_x, _y, _z, _a, _b, _c, feed);
    if (useInverseTimeFeed) {
      f.frn = inverseTimeOutput.format(f.frn);
    } else {
      f.frn = feedOutput.format(f.frn);
    }
  } else {
    f.frn = getFeed(feed);
    f.fmode = 94;
  }

  var m = getRotaryDirectionCode(new Vector(_a, _b, _c));
  if (x || y || z || a || b || c) {
    writeBlock(gFeedModeModal.format(f.fmode), gMotionModal.format(1), x, y, z, a, b, c, f.frn, m);
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      forceFeed(); // force feed on next line
    } else {
      writeBlock(gFeedModeModal.format(f.fmode), gMotionModal.format(1), f.frn);
    }
  }
}

// Start of multi-axis feedrate logic
/***** You can add 'getProperty("useInverseTime'") if desired. *****/
/***** 'previousABC' can be added throughout to maintain previous rotary positions. Required for Mill/Turn machines. *****/
/***** 'headOffset' should be defined when a head rotary axis is defined. *****/
/***** The feedrate mode must be included in motion block output (linear, circular, etc.) for Inverse Time feedrate support. *****/
//var dpmBPW; // ratio of rotary accuracy to linear accuracy for DPM calculations
var dpmBPW = unit == MM ? 1.0 : 0.1; // ratio of rotary accuracy to linear accuracy for DPM calculations
var inverseTimeUnits = 1.0; // 1.0 = minutes, 60.0 = seconds
var maxInverseTime = 99999.9999; // maximum value to output for Inverse Time feeds
var maxDPM = 9999.99; // maximum value to output for DPM feeds
var useInverseTimeFeed = false; // use 1/T feeds
var inverseTimeFormat = createFormat({decimals:4}); // inverse time register format
var inverseTimeOutput = createVariable({prefix:"F", force:true}, inverseTimeFormat);
var previousDPMFeed = 0; // previously output DPM feed
var dpmFeedToler = 0.5; // tolerance to determine when the DPM feed has changed
// var previousABC = new Vector(0, 0, 0); // previous ABC position if maintained in post, don't define if not used
var forceOptimized = undefined; // used to override optimized-for-angles points (XZC-mode)

/** Calculate the multi-axis feedrate number. */
function getMultiaxisFeed(_x, _y, _z, _a, _b, _c, feed) {
  var f = {frn:0, fmode:0};
  if (feed <= 0) {
    error(localize("Feedrate is less than or equal to 0."));
    return f;
  }

  var length = getMoveLength(_x, _y, _z, _a, _b, _c);

  if (useInverseTimeFeed) { // inverse time
    f.frn = getInverseTime(length.tool, feed);
    f.fmode = 93;
    forceFeed();
  } else { // degrees per minute
    f.frn = getFeedDPM(length, feed);
    f.fmode = 94;
  }
  return f;
}

/** Returns point optimization mode. */
function getOptimizedMode() {
  if (forceOptimized != undefined) {
    return forceOptimized;
  }
  return (currentSection.getOptimizedTCPMode() != OPTIMIZE_NONE);
}

/** Calculate the DPM feedrate number. */
function getFeedDPM(_moveLength, _feed) {
  if ((_feed == 0) || (_moveLength.tool < 0.0001) || (toDeg(_moveLength.abcLength) < 0.0005)) {
    previousDPMFeed = 0;
    return _feed;
  }
  var moveTime = _moveLength.tool / _feed;
  if (moveTime == 0) {
    previousDPMFeed = 0;
    return _feed;
  }

  var dpmFeed;
  var tcp = !getOptimizedMode(); // && (forceOptimized == undefined);   // set to false for rotary heads
  //var tcp = false;//!getOptimizedMode();// && (forceOptimized == undefined);   // set to false for rotary heads
  if (tcp) { // TCP mode is supported, output feed as FPM
    dpmFeed = _feed;
  } else if (false) { // standard DPM
    dpmFeed = Math.min(toDeg(_moveLength.abcLength) / moveTime, maxDPM);
    if (Math.abs(dpmFeed - previousDPMFeed) < dpmFeedToler) {
      dpmFeed = previousDPMFeed;
    }
  } else if (true) { // combination FPM/DPM
    var length = Math.sqrt(Math.pow(_moveLength.xyzLength, 2.0) + Math.pow((toDeg(_moveLength.abcLength) * dpmBPW), 2.0));
    dpmFeed = Math.min((length / moveTime), maxDPM);
    if (Math.abs(dpmFeed - previousDPMFeed) < dpmFeedToler) {
      dpmFeed = previousDPMFeed;
    }
  } else { // machine specific calculation
    dpmFeed = _feed;
  }
  previousDPMFeed = dpmFeed;
  return dpmFeed;
}

/** Calculate the Inverse time feedrate number. */
function getInverseTime(_length, _feed) {
  var inverseTime;
  if (_length < 1.e-6) { // tool doesn't move
    if (typeof maxInverseTime === "number") {
      inverseTime = maxInverseTime;
    } else {
      inverseTime = 999999;
    }
  } else {
    inverseTime = _feed / _length / inverseTimeUnits;
    if (typeof maxInverseTime === "number") {
      if (inverseTime > maxInverseTime) {
        inverseTime = maxInverseTime;
      }
    }
  }
  return inverseTime;
}

/** Calculate radius for each rotary axis. */
function getRotaryRadii(startTool, endTool, startABC, endABC) {
  var radii = new Vector(0, 0, 0);
  var startRadius;
  var endRadius;
  var axis = new Array(machineConfiguration.getAxisU(), machineConfiguration.getAxisV(), machineConfiguration.getAxisW());
  for (var i = 0; i < 3; ++i) {
    if (axis[i].isEnabled()) {
      var startRadius = getRotaryRadius(axis[i], startTool, startABC);
      var endRadius = getRotaryRadius(axis[i], endTool, endABC);
      radii.setCoordinate(axis[i].getCoordinate(), Math.max(startRadius, endRadius));
    }
  }
  return radii;
}

/** Calculate the distance of the tool position to the center of a rotary axis. */
function getRotaryRadius(axis, toolPosition, abc) {
  if (!axis.isEnabled()) {
    return 0;
  }

  var direction = axis.getEffectiveAxis();
  var normal = direction.getNormalized();
  // calculate the rotary center based on head/table
  var center;
  var radius;
  if (axis.isHead()) {
    var pivot;
    if (typeof headOffset === "number") {
      pivot = headOffset;
    } else {
      pivot = tool.getBodyLength();
    }
    if (axis.getCoordinate() == machineConfiguration.getAxisU().getCoordinate()) { // rider
      center = Vector.sum(toolPosition, Vector.product(machineConfiguration.getDirection(abc), pivot));
      center = Vector.sum(center, axis.getOffset());
      radius = Vector.diff(toolPosition, center).length;
    } else { // carrier
      var angle = abc.getCoordinate(machineConfiguration.getAxisU().getCoordinate());
      radius = Math.abs(pivot * Math.sin(angle));
      radius += axis.getOffset().length;
    }
  } else {
    center = axis.getOffset();
    var d1 = toolPosition.x - center.x;
    var d2 = toolPosition.y - center.y;
    var d3 = toolPosition.z - center.z;
    var radius = Math.sqrt(
      Math.pow((d1 * normal.y) - (d2 * normal.x), 2.0) +
      Math.pow((d2 * normal.z) - (d3 * normal.y), 2.0) +
      Math.pow((d3 * normal.x) - (d1 * normal.z), 2.0)
    );
  }
  return radius;
}

/** Calculate the linear distance based on the rotation of a rotary axis. */
function getRadialDistance(radius, startABC, endABC) {
  // calculate length of radial move
  var delta = Math.abs(endABC - startABC);
  if (delta > Math.PI) {
    delta = 2 * Math.PI - delta;
  }
  var radialLength = (2 * Math.PI * radius) * (delta / (2 * Math.PI));
  return radialLength;
}

/** Calculate tooltip, XYZ, and rotary move lengths. */
function getMoveLength(_x, _y, _z, _a, _b, _c) {
  // get starting and ending positions
  var moveLength = {};
  var startTool;
  var endTool;
  var startXYZ;
  var endXYZ;
  var startABC;
  if (typeof previousABC !== "undefined") {
    startABC = new Vector(previousABC.x, previousABC.y, previousABC.z);
  } else {
    startABC = getCurrentDirection();
  }
  var endABC = new Vector(_a, _b, _c);

  if (!getOptimizedMode()) { // calculate XYZ from tool tip
    startTool = getCurrentPosition();
    endTool = new Vector(_x, _y, _z);
    startXYZ = startTool;
    endXYZ = endTool;

    // adjust points for tables
    if (!machineConfiguration.getTableABC(startABC).isZero() || !machineConfiguration.getTableABC(endABC).isZero()) {
      startXYZ = machineConfiguration.getOrientation(machineConfiguration.getTableABC(startABC)).getTransposed().multiply(startXYZ);
      endXYZ = machineConfiguration.getOrientation(machineConfiguration.getTableABC(endABC)).getTransposed().multiply(endXYZ);
    }

    // adjust points for heads
    if (machineConfiguration.getAxisU().isEnabled() && machineConfiguration.getAxisU().isHead()) {
      if (typeof getOptimizedHeads === "function") { // use post processor function to adjust heads
        startXYZ = getOptimizedHeads(startXYZ.x, startXYZ.y, startXYZ.z, startABC.x, startABC.y, startABC.z);
        endXYZ = getOptimizedHeads(endXYZ.x, endXYZ.y, endXYZ.z, endABC.x, endABC.y, endABC.z);
      } else { // guess at head adjustments
        var startDisplacement = machineConfiguration.getDirection(startABC);
        startDisplacement.multiply(headOffset);
        var endDisplacement = machineConfiguration.getDirection(endABC);
        endDisplacement.multiply(headOffset);
        startXYZ = Vector.sum(startTool, startDisplacement);
        endXYZ = Vector.sum(endTool, endDisplacement);
      }
    }
  } else { // calculate tool tip from XYZ, heads are always programmed in TCP mode, so not handled here
    startXYZ = getCurrentPosition();
    endXYZ = new Vector(_x, _y, _z);
    startTool = machineConfiguration.getOrientation(machineConfiguration.getTableABC(startABC)).multiply(startXYZ);
    endTool = machineConfiguration.getOrientation(machineConfiguration.getTableABC(endABC)).multiply(endXYZ);
  }

  // calculate axes movements
  moveLength.xyz = Vector.diff(endXYZ, startXYZ).abs;
  moveLength.xyzLength = moveLength.xyz.length;
  moveLength.abc = Vector.diff(endABC, startABC).abs;
  for (var i = 0; i < 3; ++i) {
    if (moveLength.abc.getCoordinate(i) > Math.PI) {
      moveLength.abc.setCoordinate(i, 2 * Math.PI - moveLength.abc.getCoordinate(i));
    }
  }
  moveLength.abcLength = moveLength.abc.length;

  // calculate radii
  moveLength.radius = getRotaryRadii(startTool, endTool, startABC, endABC);

  // calculate the radial portion of the tool tip movement
  var radialLength = Math.sqrt(
    Math.pow(getRadialDistance(moveLength.radius.x, startABC.x, endABC.x), 2.0) +
    Math.pow(getRadialDistance(moveLength.radius.y, startABC.y, endABC.y), 2.0) +
    Math.pow(getRadialDistance(moveLength.radius.z, startABC.z, endABC.z), 2.0)
  );

  // calculate the tool tip move length
  // tool tip distance is the move distance based on a combination of linear and rotary axes movement
  moveLength.tool = moveLength.xyzLength + radialLength;

  // debug
  if (false) {
    writeComment("DEBUG - tool   = " + moveLength.tool);
    writeComment("DEBUG - xyz    = " + moveLength.xyz);
    var temp = Vector.product(moveLength.abc, 180 / Math.PI);
    writeComment("DEBUG - abc    = " + temp);
    writeComment("DEBUG - radius = " + moveLength.radius);
  }
  return moveLength;
}
// End of multi-axis feedrate logic

/** Adjust final point to lie exactly on circle. */
function CircularData(_plane, _center, _end) {
  // use Output variables, since last point could have been adjusted if previous move was circular
  var start = new Vector(xOutput.getCurrent(), yOutput.getCurrent(), zOutput.getCurrent());
  var saveStart = new Vector(start.x, start.y, start.z);
  var center = new Vector(
    xyzFormat.getResultingValue(_center.x),
    xyzFormat.getResultingValue(_center.y),
    xyzFormat.getResultingValue(_center.z)
  );
  var end = new Vector(_end.x, _end.y, _end.z);
  switch (_plane) {
  case PLANE_XY:
    start.setZ(center.z);
    end.setZ(center.z);
    break;
  case PLANE_ZX:
    start.setY(center.y);
    end.setY(center.y);
    break;
  case PLANE_YZ:
    start.setX(center.x);
    end.setX(center.x);
    break;
  default:
    this.center = new Vector(_center.x, _center.y, _center.z);
    this.start = new Vector(start.x, start.y, start.z);
    this.end = new Vector(_end.x, _end.y, _end.z);
    this.offset = Vector.diff(center, start);
    this.radius = this.offset.length;
    break;
  }
  this.start = new Vector(
    xyzFormat.getResultingValue(start.x),
    xyzFormat.getResultingValue(start.y),
    xyzFormat.getResultingValue(start.z)
  );
  var temp = Vector.diff(center, start);
  this.offset = new Vector(
    xyzFormat.getResultingValue(temp.x),
    xyzFormat.getResultingValue(temp.y),
    xyzFormat.getResultingValue(temp.z)
  );
  this.center = Vector.sum(this.start, this.offset);
  this.radius = this.offset.length;

  temp = Vector.diff(end, center).normalized;
  this.end = new Vector(
    xyzFormat.getResultingValue(this.center.x + temp.x * this.radius),
    xyzFormat.getResultingValue(this.center.y + temp.y * this.radius),
    xyzFormat.getResultingValue(this.center.z + temp.z * this.radius)
  );

  switch (_plane) {
  case PLANE_XY:
    this.start.setZ(saveStart.z);
    this.end.setZ(_end.z);
    this.offset.setZ(0);
    break;
  case PLANE_ZX:
    this.start.setY(saveStart.y);
    this.end.setY(_end.y);
    this.offset.setY(0);
    break;
  case PLANE_YZ:
    this.start.setX(saveStart.x);
    this.end.setX(_end.x);
    this.offset.setX(0);
    break;
  }
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
    return;
  }

  var start = getCurrentPosition();

  var circle = new CircularData(getCircularPlane(), new Vector(cx, cy, cz), new Vector(x, y, z));

  if (isFullCircle()) {
    if (isHelical()) {
      linearize(tolerance);
      return;
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gPlaneModal.format(17), gMotionModal.format(clockwise ? 2 : 3), iOutput.format(circle.offset.x, 0), jOutput.format(circle.offset.y, 0), getFeed(feed));
      break;
    case PLANE_ZX:
      writeBlock(gPlaneModal.format(18), gMotionModal.format(clockwise ? 2 : 3), iOutput.format(circle.offset.x, 0), kOutput.format(circle.offset.z, 0), getFeed(feed));
      break;
    case PLANE_YZ:
      writeBlock(gPlaneModal.format(19), gMotionModal.format(clockwise ? 2 : 3), jOutput.format(circle.offset.y, 0), kOutput.format(circle.offset.z, 0), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  } else {
    // helical motion is supported for all 3 planes
    // the feedrate along plane normal is - (helical height/arc length * feedrate)
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(
        gPlaneModal.format(17), gMotionModal.format(clockwise ? 2 : 3),
        xOutput.format(circle.end.x), yOutput.format(circle.end.y), zOutput.format(circle.end.z),
        iOutput.format(circle.offset.x, 0), jOutput.format(circle.offset.y, 0), getFeed(feed));
      break;
    case PLANE_ZX:
      writeBlock(
        gPlaneModal.format(18), gMotionModal.format(clockwise ? 2 : 3),
        xOutput.format(circle.end.x), yOutput.format(circle.end.y), zOutput.format(circle.end.z),
        iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    case PLANE_YZ:
      writeBlock(
        gPlaneModal.format(19), gMotionModal.format(clockwise ? 2 : 3),
        xOutput.format(circle.end.x), yOutput.format(circle.end.y), zOutput.format(circle.end.z),
        jOutput.format(circle.offset.y, 0), kOutput.format(circle.offset.z, 0), getFeed(feed));
      break;
    default:
      linearize(tolerance);
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
  COMMAND_END                     : 2,
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
    if (machineConfiguration.isMultiAxisConfiguration() && (machineConfiguration.getNumberOfAxes() >= 4)) {
      writeBlock(mClampModal.format(10)); // lock 4th-axis
      if (machineConfiguration.getNumberOfAxes() == 5) {
        writeBlock(mClampModal.format(26)); // lock 5th-axis
      }
    }
    return;
  case COMMAND_UNLOCK_MULTI_AXIS:
    if (machineConfiguration.isMultiAxisConfiguration() && (machineConfiguration.getNumberOfAxes() >= 4)) {
      writeBlock(mClampModal.format(11)); // unlock 4th-axis
      if (machineConfiguration.getNumberOfAxes() == 5) {
        writeBlock(mClampModal.format(27)); // unlock 5th-axis
      }
    }
    return;
  case COMMAND_BREAK_CONTROL:
    return;
  case COMMAND_TOOL_MEASURE:
    return;
  }

  var mcode = mapCommand[getCommandStringId(command)];
  if (mcode != undefined) {
    if (mcode == "") {
      return; // ignore
    }
    writeBlock(mFormat.format(mcode));

    if (command == COMMAND_STOP_SPINDLE) {
      if (getProperty("dwellAfterStop") > 0) {
        // make sure spindle reaches full spindle speed
        var seconds = clamp(0.001, getProperty("dwellAfterStop"), 99999.999);
        writeBlock(gFormat.format(4), "F" + secFormat.format(seconds));
      }
    }
  } else {
    onUnsupportedCommand(command);
  }
}

function onSectionEnd() {
  if (!isLastSection() && (getNextSection().getTool().coolant != tool.coolant)) {
    setCoolant(COOLANT_OFF);
  }

  if (true) {
    if (isRedirecting()) {
      if (firstPattern) {
        var finalPosition = getFramePosition(currentSection.getFinalPosition());
        var abc;
        if (currentSection.isMultiAxis() && machineConfiguration.isMultiAxisConfiguration()) {
          abc = currentSection.getFinalToolAxisABC();
        } else {
          abc = currentWorkPlaneABC;
        }
        if (abc == undefined) {
          abc = new Vector(0, 0, 0);
        }
        setAbsoluteMode(finalPosition, abc);
        subprogramEnd();
      }
    }
  }

  if (((getCurrentSectionId() + 1) >= getNumberOfSections()) ||
      (tool.number != getNextSection().getTool().number)) {
    onCommand(COMMAND_BREAK_CONTROL);
  }
  if (currentSection.isMultiAxis()) {
    if (currentSection.getOptimizedTCPMode() == OPTIMIZE_NONE) {
      writeBlock(gFormat.format(170)); // disable TCP
      if (getProperty("useCAS")) {
        writeBlock(mFormat.format(511), formatComment("RE-ENABLE CAS"));
      }
    }
    // the code below gets the machine angles from previous operation. closestABC must also be set to true
    if (currentSection.isOptimizedForMachine()) {
      currentMachineABC = currentSection.getFinalToolAxisABC();
    }
    writeBlock(gFeedModeModal.format(94));
  }

  loadMonitorVal = getProperty("loadMonitorVal");

  if (isProbeOperation()) {
    writeBlock(callFormat.format(9833)); // spin the probe off
    if (probeVariables.probeAngleMethod != "G68") {
      setProbeAngle(); // output probe angle rotations if required
    }
  }
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

  if (gRotationModal.getCurrent() == 11) { // cancel G68 before retracting
    cancelWorkPlane(true);
  }
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
    case "G16":
      gMotionModal.reset();
      writeBlock(gFormat.format(16), hFormat.format(0), gMotionModal.format(0), words);
      break;
    case "G0":
      gMotionModal.reset();
      writeBlock(gAbsIncModal.format(90), gMotionModal.format(0), words);
      break;
    default:
      error(localize("Unsupported safe position method."));
      return;
    }
  }
}

function onClose() {
  if (probeVariables.probeAngleMethod == "G68") {
    cancelWorkPlane();
  }
  writeln("");

  onCommand(COMMAND_STOP_SPINDLE);
  setCoolant(COOLANT_OFF);
  onCommand(COMMAND_UNLOCK_MULTI_AXIS);

  writeRetract(Z);

  gAbsIncModal.reset();

  if (machineConfiguration.isMultiAxisConfiguration()) {
    setWorkPlane(new Vector(0, 0, 0)); // reset working plane
  }

  // writeRetract(X, Y);

  forceXYZ();
  gAbsIncModal.reset();

  if (prevLoadMonitorVal != 0) {
    writeBlock(mFormat.format(142)); // Turn Spindle Load Monitor Off
  }
  if (getProperty("toolLifeMonitor")) {
    writeBlock("TLFOFF"); // Turn Tool Life Monitoring Off
  }

  onCommand(COMMAND_END);

  if (subprograms.length > 0) {
    writeln("");
    write(subprograms);
  }

  if (getProperty("toolLifeMonitor")) {
    saveShowSequenceNumbers = getProperty("showSequenceNumbers");
    setProperty("showSequenceNumbers", false);
    // Macro variables and logic to be used by the controller for tool life monitoring
    writeln("");
    writeComment("################## Tool Check SUB PROGRAM ##################");
    writeln("");
    writeln("OCHCK");
    writeComment("VC200 Tool Number");
    writeComment("VC199 Tool Length");
    writeComment("VC198 Tool Diameter");
    writeBlock("VC195 = 0", formatComment("reset variable"));
    writeln("");
    writeBlock("VC195 = VTPNO[VC200]");
    writeln("");
    writeBlock("VC194 = VC199 + 1", formatComment("upper tool length limit"));
    writeBlock("VC193 = VC199 - 1", formatComment("lower tool Length limit"));
    writeBlock("VC192 = VC198 * 1.05", formatComment("upper tool radius limit"));
    writeBlock("VC191 = VC198 * 0.95", formatComment("lower tool radius limit"));
    writeln("");
    writeln("N1 IF [VTOHT[VC200,10001] LT VC194] N5");
    writeBlock("VUACM[1]='TOOL LONG'");
    writeBlock("VDOUT[992]=1");
    writeln("");
    writeln("N5 IF [VTOHT[VC200,10001] GT VC193] N10");
    writeBlock("VUACM[1]='TOOL SHORT'");
    writeBlock("VDOUT[992]=1");
    writeln("");
    writeln("N10 IF [VTODT[[VC200,10001]] LT VC192] N15");
    writeBlock("VUACM[1]='T DIA LARGE'");
    writeBlock("VDOUT[992]=1");
    writeln("");
    writeln("N15 IF [VTODT[[VC200,10001]] GT VC191] N20");
    writeBlock("VUACM[1]='T DIA SMALL'");
    writeBlock("VDOUT[992]=1");
    writeln("");
    writeln("N20 RTS");
    setProperty("showSequenceNumbers", saveShowSequenceNumbers);
  }
}

function setProperty(property, value) {
  properties[property].current = value;
}
