/**
  Copyright (C) 2012-2026 by Autodesk, Inc.
  All rights reserved.

  Heidenhain post processor configuration.

  $Revision: 44210 ffe0eb09a5649b934d239c6145bde9ed20754f4a $
  $Date: 2026-01-20 22:18:16 $

  FORKID {36E63822-3A79-42b9-96EA-6B661FE8D0C8}
*/

description = "Heidenhain";
vendor = "Heidenhain";
vendorUrl = "http://www.heidenhain.com";
legal = "Copyright (C) 2012-2026 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45917;

longDescription = "Generic post for Heidenhain controls like iTNC 530, TNC 620, TNC 640 and TNC 7.";

extension = "h";
if (getCodePage() == 932) { // shift-jis is not supported
  setCodePage("ascii");
} else {
  setCodePage("ansi"); // setCodePage("utf-8");
}

capabilities = CAPABILITY_MILLING | CAPABILITY_MACHINE_SIMULATION;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(5400); // 15 revolutions
allowHelicalMoves = true;
allowedCircularPlanes = undefined; // allow any circular motion
probeMultipleFeatures = true;
highFeedrate = (unit == MM) ? 9999 : 999;

// user-defined properties
properties = {
  writeVersion: {
    title      : "Write version",
    description: "Write the version number in the header of the code.",
    group      : "formats",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  usePlane: {
    title      : "Tilted workplane",
    description: "Specifies the tilted workplane command to use.",
    group      : "multiAxis",
    type       : "enum",
    values     : [
      {id:"none", title:"Use rotary angles"},
      {id:"true", title:"Use Plane Spatial"},
      {id:"false", title:"Use Cycle19"}
    ],
    value: "true",
    scope: "post"
  },
  useFunctionTCPM: {
    title      : "Use function TCPM",
    description: "Specifies whether to use Function TCPM instead of M128/M129.",
    group      : "multiAxis",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  preloadTool: {
    title      : "Preload tool",
    description: "Preloads the next tool at a tool change (if any).",
    group      : "preferences",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  optionalStop: {
    title      : "Optional stop",
    description: "Outputs optional stop code during when necessary in the code.",
    group      : "preferences",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  structureComments: {
    title      : "Structure comments",
    description: "Shows structure comments.",
    group      : "formats",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  safePositionMethod: {
    title      : "Safe Retracts",
    description: "Select your desired retract option. 'Clearance Height' retracts to the operation clearance height.",
    group      : "homePositions",
    type       : "enum",
    values     : [
      {title:"Clearance Height", id:"clearanceHeight"},
      {title:"M91", id:"M91"},
      {title:"M92", id:"M92"}
    ],
    value: "M91",
    scope: "post"
  },
  useM140: {
    title      : "Use M140",
    description: "Specifies to use M140 MB MAX for Z-axis retracts instead of M91/M92 positions.",
    group      : "homePositions",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showNotes: {
    title      : "Show notes",
    description: "Writes operation notes as comments in the outputted code.",
    group      : "formats",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  preferredTilt: {
    title      : "Prefer tilt",
    description: "Specifies which tilt direction is preferred." + EOL +
      "Notice that if the 'Tilted workplane' property is set to 'Use Plane Spatial' and a machine configuration is defined," + EOL +
      "the tilt preference is specified with the machine configuration and the SEQ parameter will be based on the rotary axis angle. This property will be ignored in this case.",
    group : "multiAxis",
    type  : "integer",
    values: [
      {id:-1, title:"Negative"},
      {id:0, title:"Either"},
      {id:1, title:"Positive"}
    ],
    value: -1,
    scope: "post"
  },
  useSmoothing: {
    title      : "Use smoothing",
    description: "Specifies whether CYCL DEF 32 should be used.",
    group      : "preferences",
    type       : "enum",
    values     : [
      {title:"Off", id:"-1"},
      {title:"Automatic", id:"9999"}
    ],
    value: "-1",
    scope: "post"
  },
  toolAsName: {
    title      : "Tool as name",
    description: "If enabled, the tool will be called with the tool description rather than the tool number.",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  outputSpindleSpeedForProbing: {
    title      : "Output spindle speed for probing",
    description: "Specifies whether the spindle speed value is needed at the machine tool for probing operations",
    group      : "probing",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  useParkPosition: {
    title      : "Home XY at end",
    description: "Specifies that the machine moves to the home position in XY at the end of the program.",
    group      : "homePositions",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  showSequenceNumbers: {
    title      : "Use sequence numbers",
    description: "'Yes' outputs sequence numbers on each block, 'No' disables the output of sequence numbers.",
    group      : "formats",
    type       : "enum",
    values     : [
      {title:"Yes", id:"true"},
      {title:"No", id:"false"}
    ],
    value  : "true",
    scope  : "post",
    visible: false
  },
  sequenceNumberStart: {
    title      : "Start sequence number",
    description: "The number at which to start the sequence numbers.",
    group      : "formats",
    type       : "integer",
    value      : 0,
    scope      : "post",
    visible    : false
  },
  sequenceNumberIncrement: {
    title      : "Sequence number increment",
    description: "The amount by which the sequence number is incremented by in each block.",
    group      : "formats",
    type       : "integer",
    value      : 1,
    scope      : "post",
    visible    : false
  }
};

// wcs definiton
wcsDefinitions = {
  useZeroOffset: true
};

var xyzFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceSign:true});
var abcFormat = createFormat({decimals:3, forceSign:true, scale:DEG});
var feedFormat = createFormat({decimals:(unit == MM ? 0 : 2), scale:(unit == MM ? 1 : 10)});
var txyzFormat = createFormat({decimals:(unit == MM ? 7 : 8), forceSign:true});
var rpmFormat = createFormat({decimals:0});
var toolFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:3});
var paFormat = createFormat({decimals:3, forceSign:true, scale:DEG});
var angleFormat = createFormat({decimals:0, scale:DEG});
var pitchFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceSign:true});
var ratioFormat = createFormat({decimals:3});
var mFormat = createFormat({prefix:"M", decimals:0});
var taperFormat = createFormat({decimals:0, scale:DEG});

var xOutput = createOutputVariable({onchange:function() {state.retractedX = false;}, prefix:"X"}, xyzFormat);
var yOutput = createOutputVariable({onchange:function() {state.retractedY = false;}, prefix:"Y"}, xyzFormat);
var zOutput = createOutputVariable({onchange:function() {state.retractedZ = false;}, prefix:"Z"}, xyzFormat);
var toolVectorOutputI = createOutputVariable({prefix:"TX", control:CONTROL_FORCE}, txyzFormat);
var toolVectorOutputJ = createOutputVariable({prefix:"TY", control:CONTROL_FORCE}, txyzFormat);
var toolVectorOutputK = createOutputVariable({prefix:"TZ", control:CONTROL_FORCE}, txyzFormat);
var aOutput = createOutputVariable({prefix:"A"}, abcFormat);
var bOutput = createOutputVariable({prefix:"B"}, abcFormat);
var cOutput = createOutputVariable({prefix:"C"}, abcFormat);
var sOutput = createOutputVariable({prefix:"S", control:CONTROL_FORCE}, rpmFormat);
var feedOutput = createOutputVariable({prefix:"F"}, feedFormat);
var fourthAxisClamp = createOutputVariable({}, mFormat);
var fifthAxisClamp = createOutputVariable({}, mFormat);

var settings = {
  coolant: {
    // samples:
    // {id: COOLANT_THROUGH_TOOL, on: 88, off: 89}
    // {id: COOLANT_THROUGH_TOOL, on: [8, 88], off: [9, 89]}
    // {id: COOLANT_THROUGH_TOOL, on: "M88 P3 (myComment)", off: "M89"}
    coolants: [
      {id:COOLANT_FLOOD, on:8, off:9},
      {id:COOLANT_MIST, on:25, off:9},
      {id:COOLANT_THROUGH_TOOL, on:7, off:9},
      {id:COOLANT_AIR},
      {id:COOLANT_AIR_THROUGH_TOOL},
      {id:COOLANT_SUCTION},
      {id:COOLANT_FLOOD_MIST},
      {id:COOLANT_FLOOD_THROUGH_TOOL},
      {id:COOLANT_OFF, off:9}
    ],
    singleLineCoolant: false, // specifies to output multiple coolant codes in one line rather than in separate lines
  },
  smoothing: {
    roughing              : 1, // roughing level for smoothing in automatic mode
    semi                  : 1, // semi-roughing level for smoothing in automatic mode
    semifinishing         : 0, // semi-finishing level for smoothing in automatic mode
    finishing             : 0, // finishing level for smoothing in automatic mode
    thresholdRoughing     : toPreciseUnit(0.5, MM), // operations with stock/tolerance above that threshold will use roughing level in automatic mode
    thresholdFinishing    : toPreciseUnit(0.05, MM), // operations with stock/tolerance below that threshold will use finishing level in automatic mode
    thresholdSemiFinishing: toPreciseUnit(0.1, MM), // operations with stock/tolerance above finishing and below threshold roughing that threshold will use semi finishing level in automatic mode
    differenceCriteria    : "both", // options: "level", "tolerance", "both". Specifies criteria when output smoothing codes
    autoLevelCriteria     : "tolerance", // use "stock" or "tolerance" to determine levels in automatic mode
    cancelCompensation    : false // tool length compensation must be canceled prior to changing the smoothing level
  },
  retract: {
    cancelRotationOnRetracting: false, // specifies that rotations (G68) need to be canceled prior to retracting
    methodXY                  : undefined, // special condition, overwrite retract behavior per axis
    methodZ                   : undefined, // special condition, overwrite retract behavior per axis
    useZeroValues             : [], // enter property value id(s) for using "0" value instead of machineConfiguration axes home position values (ie G30 Z0)
    homeXY                    : {onIndexing:false, onToolChange:false, onProgramEnd:{axes:[X, Y]}} // Specifies when the machine should be homed in X/Y. Sample: onIndexing:{axes:[X, Y], singleLine:false}
  },
  parametricFeeds: {
    firstFeedParameter    : 50, // specifies the initial parameter number to be used for parametric feedrate output
    feedAssignmentVariable: "FN 0: Q", // specifies the syntax to define a parameter
    feedOutputVariable    : "FQ" // specifies the syntax to output the feedrate as parameter
  },
  machineAngles: { // refer to https://cam.autodesk.com/posts/reference/classMachineConfiguration.html#a14bcc7550639c482492b4ad05b1580c8
    controllingAxis: ABC,
    type           : PREFER_PREFERENCE,
    options        : ENABLE_ALL
  },
  workPlaneMethod: {
    useTiltedWorkplane    : true, // specifies that tilted workplanes should be used (ie. G68.2, G254, PLANE SPATIAL, CYCLE800), can be overwritten by property
    eulerConvention       : EULER_XYZ_S, // specifies the euler convention (ie EULER_XYZ_R), set to undefined to use machine angles for TWP commands ('undefined' requires machine configuration)
    eulerCalculationMethod: "standard", // ('standard' / 'machine') 'machine' adjusts euler angles to match the machines ABC orientation, machine configuration required
    cancelTiltFirst       : false, // cancel tilted workplane prior to WCS (G54-G59) blocks
    forceMultiAxisIndexing: false, // force multi-axis indexing for 3D programs
    prepositionWithTWP    : true, // Use tilted workplane commands for multi axis toolpath prepositioning
    optimizeType          : OPTIMIZE_AXIS // can be set to OPTIMIZE_NONE, OPTIMIZE_BOTH, OPTIMIZE_TABLES, OPTIMIZE_HEADS, OPTIMIZE_AXIS. 'undefined' uses legacy rotations
  },
  subprograms: {
    initialSubprogramNumber: 100, // specifies the initial number to be used for subprograms. 'undefined' uses the main program number
    minimumCyclePoints     : 5, // minimum number of points in cycle operation to consider for subprogram
    files                  : {extension:extension, prefix:undefined}, // specifies the subprogram file extension and the prefix to use for the generated file
    format                 : xyzFormat, // the format to use for the subprogam number format
    startBlock             : {files:"BEGIN PGM " + "%currentSubprogram" + ((unit == MM) ? " MM" : " INCH"), embedded:"LBL " + "%currentSubprogram"}, // specifies the start syntax of a subprogram followed by the subprogram number
    endBlock               : {files:"END PGM " + "%currentSubprogram" + ((unit == MM) ? " MM" : " INCH"), embedded:"LBL 0"}, // specifies the command to for the end of a subprogram
    callBlock              : {files:"CALL PGM " + "%currentSubprogram" + ".H", embedded:"CALL LBL " + "%currentSubprogram"} // specifies the command for calling a subprogram followed by the subprogram number
  },
  comments: {
    permittedCommentChars: undefined, // letters are not case sensitive, use option 'outputFormat' below. Set to 'undefined' to allow any character
    prefix               : ";", // specifies the prefix for the comment
    suffix               : "", // specifies the suffix for the comment
    outputFormat         : "ignoreCase", // can be set to "upperCase", "lowerCase" and "ignoreCase". Set to "ignoreCase" to write comments without upper/lower case formatting
    maximumLineLength    : 80, // the maximum number of characters allowed in a line, set to 0 to disable comment output
    showSequenceNumbers  : true // specifies if comments should be output with sequence numbers
  },
  probing: {
    allowIndexingWCSProbing: false // specifies that probe WCS with tool orientation is supported
  },
  sequenceNumberPrefix        : "", // specifies the prefix to output for the sequence number
  maximumSequenceNumber       : undefined, // the maximum sequence number (Nxxx), use 'undefined' for unlimited
  supportsToolVectorOutput    : true, // specifies if the control does support tool axis vector output for multi axis toolpath
  outputToolLengthCompensation: false,
  polarCycleExpandMode        : 0, // 0=EXPAND_NONE: Does not expand any cycles. 1=EXPAND_TCP: Expands drilling cycles, when TCP is on. 2=EXPAND_NON_TCP: Expands drilling cycles, when TCP is off. 3=EXPAND_ALL: Expands all drilling cycles
  // fixed settings below, do not modify
  supportsInverseTimeFeed     : false // this postprocessor does not support inverse time feedrates
};

// fixed settings
var useCycl247 = true; // use CYCL 247 for work offset
var useCycl7 = false; // use CYCL 7 for work offset
var useCycl205 = false; // use CYCL 205 for universal pecking
var MP7500Bit2 = 1; // -only relevant for CYCLE 19- 0: The tilting axes are NOT positioned with CYCLE19, 1: The tilting axes are positioned with CYCLE19

// collected state
var CYCLE_19 = 1;
var PLANE_SPATIAL = 2;
var twpMethod = undefined;
var radiusCompensationTable = new Table(
  ["R0", "RL", "RR"],
  {initial:RADIUS_COMPENSATION_OFF},
  "Invalid radius compensation"
);

/** Adds a structure comment. */
function writeStructureComment(text) {
  if (getProperty("structureComments")) {
    if (isTextSupported(text)) {
      writeBlock("* -", formatComment(text).replace(settings.comments.prefix, ""));
    }
  } else {
    writeComment(text);
  }
}

/** Writes a separator. */
function writeSeparator() {
  writeComment("-------------------------------------");
}

/** Writes the specified text through the data interface. */
function printData(text) {
  if (isTextSupported(text)) {
    writeBlock("FN 15: PRINT", text);
  }
}

function writeWorkpiece() {
  var workpiece = getWorkpiece();
  var delta = Vector.diff(workpiece.upper, workpiece.lower);
  if (delta.isNonZero()) {
    writeBlock("BLK FORM 0.1 Z X" + xyzFormat.format(workpiece.lower.x), "Y" + xyzFormat.format(workpiece.lower.y), "Z" + xyzFormat.format(workpiece.lower.z));
    writeBlock("BLK FORM 0.2 X" + xyzFormat.format(workpiece.upper.x), "Y" + xyzFormat.format(workpiece.upper.y), "Z" + xyzFormat.format(workpiece.upper.z));
  }
}

function onOpen() {
  // define and enable machine configuration
  receivedMachineConfiguration = machineConfiguration.isReceived();
  if (typeof defineMachine == "function") {
    defineMachine(); // hardcoded machine configuration
  }
  activateMachine(); // enable the machine optimizations and settings

  currentWorkOffset = 0; // default to work offset 0
  settings.workPlaneMethod.useTiltedWorkplane = getProperty("usePlane") != "none";
  twpMethod = getProperty("usePlane") == "true" ? PLANE_SPATIAL : getProperty("usePlane") == "false" ? CYCLE_19 : undefined;
  if (!machineConfiguration.isMultiAxisConfiguration() && !tcp.isSupportedByMachine) {
    tcp.isSupportedByMachine = true; // default to true when no machine configuration is defined
  }
  if (machineConfiguration.isHeadConfiguration() && getProperty("useM140")) {
    setProperty("useM140", false);
    warning(localize("Property 'useM140' is not supported for head kinematics and has been turned off."));
  }

  writeBlock("BEGIN PGM" + (programName ? (SP + programName) : "") + ((unit == MM) ? " MM" : " INCH"));
  writeComment(programComment);
  writeWorkpiece();

  if (twpMethod == CYCLE_19) {
    settings.workPlaneMethod.eulerConvention = undefined; // use machine angles for CYCLE 19, requires a machine configuration

    writeSeparator();
    writeComment("The postprocessor uses the following settings for CYCLE19:");
    writeComment("  Make sure that these settings match the settings on your machine.");
    writeComment("  MP7500 Bit1: " + (settings.workPlaneMethod.eulerConvention == undefined ? 0 + " - Machine angles" : 1 + " - Euler angles"));
    writeComment("  MP7500 Bit2: " + MP7500Bit2 + (MP7500Bit2 == 0 ? " - The tilting axes are NOT positioned with CYCLE19" : " - The tilting axes are positioned with CYCLE19"));

    if (getSetting("workPlaneMethod.prepositionWithTWP", true) && tcp.isSupportedByMachine && !machineConfiguration.isHeadConfiguration()) {
      for (var i = 0; i < getNumberOfSections(); ++i) {
        var section = getSection(i);
        if (section.isMultiAxis()) {
          var msg = "Risk of collision detected." + EOL +
          "  5-axis simultaneous machining has been detected in this program" + EOL +
          "  and the 'Tilted Workplane' property is set to 'use Cycle19'." + EOL +
          "  With CYCLE19, we cannot guarantee that safe prepositioning is possible" + EOL +
          "  without knowing the actual machine settings." + EOL +
          "  For this reason, the postprocessor will use PLANE SPATIAL for prepositioning" + EOL +
          "  5-axis simultaneous toolpaths.";
          warning(localize(msg));
          writeSeparator();
          writeComment("WARNING, " + msg);
          onCommand(COMMAND_STOP);
          break;
        }
      }
    }
    if (MP7500Bit2 == 0 && !machineConfiguration.isMultiAxisConfiguration()) {
      error("Using CYCLE19 requires a machine configuration when 'MP7500Bit2' is set to '0'." + EOL +
        "  Depending on your machine settings, you can either set 'MP7500Bit2' to '1' in the postprocessor" + EOL +
        "  or you must use a machine configuration.");
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

  writeSeparator();
  writeProgramHeader();
  writeSeparator();

  if (typeof inspectionWriteVariables == "function") {
    inspectionWriteVariables();
  }
  if (!is3D()) {
    writeBlock(mFormat.format(126)); // shortest path traverse
  }
  if (getProperty("useM140")) {
    writeBlock("TOOL CALL", getSpindleAxisLetter(machineConfiguration.getSpindleAxis()), formatComment("SET TOOL AXIS FOR M140"));
  }
  onCommand(COMMAND_START_CHIP_TRANSPORT);
  validateCommonParameters();
}

function setSmoothing(mode) {
  smoothingSettings = settings.smoothing;
  if (mode == smoothing.isActive && (!mode || !smoothing.isDifferent) && !smoothing.force && !isFirstSection()) {
    return; // return if smoothing is already active or is not different
  }
  var scaleFactor = 1.3;
  var toleranceFormat = createFormat({decimals:4, forceSign:true, minimum:0.0001}); // smoothing cycle only supports 4 decimals
  if (mode) { // enable smoothing
    writeBlock("CYCL DEF 32.0", localize("TOLERANCE"));
    writeBlock("CYCL DEF 32.1 T" + toleranceFormat.format(smoothing.tolerance * scaleFactor));
    writeBlock("CYCL DEF 32.2 HSC-MODE:" + smoothing.level, conditional(tcp.isSupportedByOperation, "TA0.5")); // HSC mode, finishing = 0, roughing = 1
  } else { // disable smoothing
    writeBlock("CYCL DEF 32.0", localize("TOLERANCE")); // cancel tolerance
    writeBlock("CYCL DEF 32.1");
  }
  smoothing.isActive = mode;
  smoothing.force = false;
  smoothing.isDifferent = false;
}

function onSection() {
  var forceSectionRestart = optionalSection && !currentSection.isOptional();
  optionalSection = currentSection.isOptional();
  var insertToolCall = isToolChangeNeeded(getProperty("toolAsName") ? "description" : "number") || forceSectionRestart;
  var newWorkOffset = isNewWorkOffset() || forceSectionRestart;
  var newWorkPlane = isNewWorkPlane() || forceSectionRestart || (typeof defineWorkPlane == "function" &&
    Vector.diff(defineWorkPlane(getPreviousSection(), false), defineWorkPlane(currentSection, false)).length > 1e-4);
  initializeSmoothing(); // initialize smoothing mode

  if (insertToolCall || newWorkOffset || newWorkPlane || state.tcpIsActive) {
    setTCP(false);
    if (insertToolCall) {
      setCoolant(COOLANT_OFF);
    }
    writeRetract(Z); // retract to safe plane
    if (newWorkPlane) {
      cancelWorkPlane(isFirstSection() && !is3D());
    }
  }

  writeSeparator();
  writeStructureComment(getParameter("operation-comment", ""));
  if (getProperty("showNotes")) {
    writeSectionNotes();
  }

  // tool change
  if (insertToolCall) {
    if (!isFirstSection()) {
      onCommand(COMMAND_STOP_SPINDLE);
    }
    writeToolCall(tool, insertToolCall);
    if (tool.type != TOOL_PROBE) {
      onCommand(tool.clockwise ? COMMAND_SPINDLE_CLOCKWISE : COMMAND_SPINDLE_COUNTERCLOCKWISE);
    }
  } else {
    startSpindle(tool, insertToolCall);
  }

  // write parametric feedrate table
  if (typeof initializeParametricFeeds == "function") {
    initializeParametricFeeds(insertToolCall);
  }

  if (currentSection.workOffset != 0) {
    currentWorkOffset = undefined;
  }
  writeWCS();
  forceXYZ();

  var abc = defineWorkPlane(currentSection, !machineConfiguration.isHeadConfiguration());

  // prepositioning
  var initialPosition = getFramePosition(currentSection.getInitialPosition());
  var isRequired = insertToolCall || state.retractedZ || (!state.tcpIsActive && tcp.isSupportedByOperation) ||
    (machineConfiguration.isHeadConfiguration() && (currentWorkPlaneABC == undefined || (Vector.diff(currentWorkPlaneABC, abc).length > 1e-4))) ||
    (!isFirstSection() && getPreviousSection().isMultiAxis());
  writeInitialPositioning(initialPosition, isRequired);

  setCoolant(tool.coolant); // writes the required coolant codes
  setSmoothing(smoothing.isAllowed); // writes the required smoothing codes

  if (typeof inspectionProcessSectionStart == "function") {
    inspectionProcessSectionStart();
  }
  if (subprogramsAreSupported()) {
    subprogramDefine(initialPosition, abc); // define subprogram
  }
}

function setTCP(_tcp, force) {
  if (!force) {
    if (!tcp.isSupportedByMachine || state.tcpIsActive == _tcp) {
      return;
    }
  }
  var tcpCode = _tcp ? getProperty("useFunctionTCPM") ? "FUNCTION TCPM F TCP AXIS POS PATHCTRL AXIS" : mFormat.format(128) :
    getProperty("useFunctionTCPM") ? "FUNCTION RESET TCPM" : mFormat.format(129);
  state.tcpIsActive = _tcp;

  writeBlock(tcpCode);
  machineSimulation({}); // update machine simulation TCP state
}

function onDwell(seconds) {
  validate(seconds >= 0);
  writeBlock("CYCL DEF 9.0", localize("DWELL TIME"));
  writeBlock("CYCL DEF 9.1 DWELL", secFormat.format(seconds));
}

function onSpindleSpeed(spindleSpeed) {
  writeBlock("TOOL CALL", getSpindleAxisLetter(machineConfiguration.getSpindleAxis()),
    tool.type == TOOL_PROBE ? getProperty("outputSpindleSpeedForProbing") ? sOutput.format(50) : "" : sOutput.format(spindleSpeed)
  );
}

function onCyclePoint(x, y, z) {
  if (isInspectionOperation()) {
    if (typeof inspectionCycleInspect == "function") {
      inspectionCycleInspect(cycle, x, y, z);
      return;
    } else {
      cycleNotSupported();
    }
  } else if (isProbeOperation()) {
    writeProbeCycle(cycle, x, y, z);
  } else {
    writeDrillCycle(cycle, x, y, z);
  }
}

function onCycleEnd() {
  if (subprogramsAreSupported() && subprogramState.cycleSubprogramIsActive) {
    subprogramEnd();
  }
  if (getProperty("useLiveConnection") && isProbeOperation() && typeof liveConnectionWriteData == "function") {
    liveConnectionWriteData("macroEnd");
  }
  zOutput.reset();
  forceFeed();
}

var mapCommand = {
  COMMAND_END                     : 30,
  COMMAND_SPINDLE_CLOCKWISE       : 3,
  COMMAND_SPINDLE_COUNTERCLOCKWISE: 4,
  COMMAND_STOP_SPINDLE            : 5
};

function onCommand(command) {
  switch (command) {
  case COMMAND_STOP:
    writeBlock(mFormat.format(0));
    forceSpindleSpeed = true;
    forceCoolant = true;
    return;
  case COMMAND_OPTIONAL_STOP:
    writeBlock(mFormat.format(1));
    forceSpindleSpeed = true;
    forceCoolant = true;
    return;
  case COMMAND_COOLANT_OFF:
    setCoolant(COOLANT_OFF);
    return;
  case COMMAND_COOLANT_ON:
    setCoolant(tool.coolant);
    return;
  case COMMAND_LOAD_TOOL:
    forceSpindleSpeed = false;
    writeToolBlock(
      "TOOL CALL", getProperty("toolAsName") ? "\"" + (tool.description.toUpperCase()) + "\"" : tool.number,
      getSpindleAxisLetter(machineConfiguration.getSpindleAxis()),
      tool.type == TOOL_PROBE ? getProperty("outputSpindleSpeedForProbing") ? sOutput.format(50) : "" : sOutput.format(spindleSpeed)
    );
    writeComment(tool.comment);
    onCommand(COMMAND_TOOL_MEASURE);

    // preload tool
    var preloadTool = getProperty("toolAsName") ? getNextTool(tool.description != getFirstTool().description, "description") : getNextTool(tool.number != getFirstTool().number);
    if (getProperty("preloadTool") && preloadTool) {
      writeBlock("TOOL DEF", getProperty("toolAsName") ? "\"" + (preloadTool.description.toUpperCase()) + "\"" : preloadTool.number);
    }
    state.retractedZ = false; // force retract in Z after tool change
    writeRetract(Z);
    return;
  case COMMAND_START_SPINDLE:
    var spindleSpeedIsRequired = forceSpindleSpeed || operationNeedsSafeStart || rpmFormat.areDifferent(spindleSpeed, sOutput.getCurrent());
    if (spindleSpeedIsRequired) {
      onSpindleSpeed(spindleSpeed);
      forceSpindleSpeed = false;
    }
    if (tool.type != TOOL_PROBE) {
      onCommand(tool.clockwise ? COMMAND_SPINDLE_CLOCKWISE : COMMAND_SPINDLE_COUNTERCLOCKWISE);
    }
    return;
  case COMMAND_LOCK_MULTI_AXIS:
    if (machineConfiguration.isMultiAxisConfiguration()) {
      // writeBlock(fourthAxisClamp.format(25)); // lock 4th axis
      if (machineConfiguration.getNumberOfAxes() > 4) {
        // writeBlock(fifthAxisClamp.format(35)); // lock 5th axis
      }
    }
    return;
  case COMMAND_UNLOCK_MULTI_AXIS:
    if (machineConfiguration.isMultiAxisConfiguration()) {
      // writeBlock(fourthAxisClamp.format(26)); // unlock 4th axis
      if (machineConfiguration.getNumberOfAxes() > 4) {
        // writeBlock(fifthAxisClamp.format(36)); // unlock 5th axis
      }
    }
    return;
  case COMMAND_START_CHIP_TRANSPORT:
    return;
  case COMMAND_STOP_CHIP_TRANSPORT:
    return;
  case COMMAND_BREAK_CONTROL:
    return;
  case COMMAND_TOOL_MEASURE:
    return;
  case COMMAND_PROBE_ON:
    return;
  case COMMAND_PROBE_OFF:
    return;
  case COMMAND_LIVE_ALIGNMENT:
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
  if (subprogramsAreSupported()) {
    subprogramEnd();
  }
  if (!isLastSection()) {
    if (getNextSection().getTool().coolant != tool.coolant) {
      setCoolant(COOLANT_OFF);
    }
    if (tool.breakControl && isToolChangeNeeded(getNextSection(), getProperty("toolAsName") ? "description" : "number")) {
      onCommand(COMMAND_BREAK_CONTROL);
    }
  }
  writeProbeLog(); // probe log
  if (typeof inspectionProcessSectionEnd == "function") {
    inspectionProcessSectionEnd();
  }
  forceAny();
}

function onClose() {
  optionalSection = false;
  setTCP(false);
  setSmoothing(false);
  setCoolant(COOLANT_OFF);
  if (tool.breakControl) {
    onCommand(COMMAND_BREAK_CONTROL);
  }
  onCommand(COMMAND_STOP_SPINDLE);
  /*
  if (useCycl247) {
    writeBlock(
      "CYCL DEF 247 " + localize("DATUM SETTING") + " ~" + EOL +
      "  Q339=" + 0 + " ; " + localize("DATUM NUMBER")
    );
  } else {
    //writeBlock("CYCL DEF 7.0 " + localize("DATUM SHIFT"));
    //writeBlock("CYCL DEF 7.1 #" + 0);
  }
*/
  writeRetract(Z);
  if (getProperty("useParkPosition") && getSetting("retract.homeXY.onProgramEnd", false)) {
    writeRetract(settings.retract.homeXY.onProgramEnd);
  }
  setWorkPlane(new Vector(0, 0, 0)); // reset working plane
  if (settings.workPlaneMethod.forceMultiAxisIndexing || !is3D() || machineConfiguration.isMultiAxisConfiguration()) {
    writeBlock(mFormat.format(127)); // cancel shortest path traverse
  }
  onCommand(COMMAND_STOP_CHIP_TRANSPORT);
  if (typeof inspectionProcessSectionEnd == "function") {
    inspectionProcessSectionEnd();
  }
  writeBlock(mFormat.format(30)); // stop program, spindle stop, coolant off

  if (subprogramsAreSupported()) {
    writeSubprograms();
  }
  if (typeof inspectionWriteSubrograms == "function") {
    inspectionWriteSubrograms();
  }
  if (outputErrorLabel) {
    writeBlock("LBL \"ERROR_OUT_OF_TOLERANCE\"");
    writeComment(localize("MEASURED POSITION IS OUT OF TOLERANCE."));
    writeBlock("FN 14: ERROR = 1072");
    onCommand(COMMAND_STOP);
    writeBlock("LBL 0");
  }
  writeBlock("END PGM", (programName ? programName : ""), ((unit == MM) ? "MM" : "INCH"));
}

// >>>>> INCLUDED FROM include_files/commonFunctions.cpi
// internal variables, do not change
var receivedMachineConfiguration;
var tcp = {isSupportedByControl:getSetting("supportsTCP", true), isSupportedByMachine:false, isSupportedByOperation:false};
var state = {
  retractedX              : false, // specifies that the machine has been retracted in X
  retractedY              : false, // specifies that the machine has been retracted in Y
  retractedZ              : false, // specifies that the machine has been retracted in Z
  tcpIsActive             : false, // specifies that TCP is currently active
  twpIsActive             : false, // specifies that TWP is currently active
  lengthCompensationActive: !getSetting("outputToolLengthCompensation", true), // specifies that tool length compensation is active
  mainState               : true // specifies the current context of the state (true = main, false = optional)
};
var validateLengthCompensation = getSetting("outputToolLengthCompensation", true); // disable validation when outputToolLengthCompensation is disabled
var multiAxisFeedrate;
var sequenceNumber;
var optionalSection = false;
var currentWorkOffset;
var forceSpindleSpeed = false;
var operationNeedsSafeStart = false; // used to convert blocks to optional for safeStartAllOperations

function activateMachine() {
  // disable unsupported rotary axes output
  if (!machineConfiguration.isMachineCoordinate(0) && (typeof aOutput != "undefined")) {
    aOutput.disable();
  }
  if (!machineConfiguration.isMachineCoordinate(1) && (typeof bOutput != "undefined")) {
    bOutput.disable();
  }
  if (!machineConfiguration.isMachineCoordinate(2) && (typeof cOutput != "undefined")) {
    cOutput.disable();
  }

  // setup usage of useTiltedWorkplane
  settings.workPlaneMethod.useTiltedWorkplane = getProperty("useTiltedWorkplane") != undefined ? getProperty("useTiltedWorkplane") :
    getSetting("workPlaneMethod.useTiltedWorkplane", false);
  settings.workPlaneMethod.useABCPrepositioning = getSetting("workPlaneMethod.useABCPrepositioning", true);

  if (!machineConfiguration.isMultiAxisConfiguration()) {
    return; // don't need to modify any settings for 3-axis machines
  }

  // identify if any of the rotary axes has TCP enabled
  var axes = [machineConfiguration.getAxisU(), machineConfiguration.getAxisV(), machineConfiguration.getAxisW()];
  tcp.isSupportedByMachine = axes.some(function(axis) {return axis.isEnabled() && axis.isTCPEnabled();}); // true if TCP is enabled on any rotary axis
  if (tcp.isSupportedByMachine) {
    bufferRotaryMoves = false; // disable bufferRotaryMoves if TCP is enabled on any rotary axis
  }

  // save multi-axis feedrate settings from machine configuration
  var mode = machineConfiguration.getMultiAxisFeedrateMode();
  var type = mode == FEED_INVERSE_TIME ? machineConfiguration.getMultiAxisFeedrateInverseTimeUnits() :
    (mode == FEED_DPM ? machineConfiguration.getMultiAxisFeedrateDPMType() : DPM_STANDARD);
  multiAxisFeedrate = {
    mode     : mode,
    maximum  : machineConfiguration.getMultiAxisFeedrateMaximum(),
    type     : type,
    tolerance: mode == FEED_DPM ? machineConfiguration.getMultiAxisFeedrateOutputTolerance() : 0,
    bpwRatio : mode == FEED_DPM ? machineConfiguration.getMultiAxisFeedrateBpwRatio() : 1
  };

  // setup of retract/reconfigure  TAG: Only needed until post kernel supports these machine config settings
  if (receivedMachineConfiguration && machineConfiguration.performRewinds()) {
    safeRetractDistance = machineConfiguration.getSafeRetractDistance();
    safePlungeFeed = machineConfiguration.getSafePlungeFeedrate();
    safeRetractFeed = machineConfiguration.getSafeRetractFeedrate();
  }
  if (typeof safeRetractDistance == "number" && getProperty("safeRetractDistance") != undefined && getProperty("safeRetractDistance") != 0) {
    safeRetractDistance = getProperty("safeRetractDistance");
  }

  if (revision >= 50294) {
    activateAutoPolarMode({tolerance:tolerance / 2, optimizeType:OPTIMIZE_AXIS, expandCycles:getSetting("polarCycleExpandMode", EXPAND_ALL)});
  }

  if (machineConfiguration.isHeadConfiguration() && getSetting("workPlaneMethod.compensateToolLength", false)) {
    for (var i = 0; i < getNumberOfSections(); ++i) {
      var section = getSection(i);
      if (section.isMultiAxis()) {
        machineConfiguration.setToolLength(getBodyLength(section.getTool())); // define the tool length for head adjustments
        section.optimizeMachineAnglesByMachine(machineConfiguration, OPTIMIZE_AXIS);
      }
    }
  } else {
    optimizeMachineAngles2(OPTIMIZE_AXIS);
  }
}

function getBodyLength(tool) {
  for (var i = 0; i < getNumberOfSections(); ++i) {
    var section = getSection(i);
    if (tool.number == section.getTool().number) {
      if (section.hasParameter("operation:tool_assemblyGaugeLength")) { // For Fusion
        return section.getParameter("operation:tool_assemblyGaugeLength", tool.bodyLength + tool.holderLength);
      } else { // Legacy products
        return section.getParameter("operation:tool_overallLength", tool.bodyLength + tool.holderLength);
      }
    }
  }
  return tool.bodyLength + tool.holderLength;
}

function getFeed(f) {
  if (getProperty("useG95")) {
    return feedOutput.format(f / spindleSpeed); // use feed value
  }
  if (typeof activeMovements != "undefined" && activeMovements) {
    var feedContext = activeMovements[movement];
    if (feedContext != undefined) {
      if (!feedFormat.areDifferent(feedContext.feed, f)) {
        if (feedContext.id == currentFeedId) {
          return ""; // nothing has changed
        }
        forceFeed();
        currentFeedId = feedContext.id;
        return settings.parametricFeeds.feedOutputVariable + (settings.parametricFeeds.firstFeedParameter + feedContext.id);
      }
    }
    currentFeedId = undefined; // force parametric feed next time
  }
  return feedOutput.format(f); // use feed value
}

function validateCommonParameters() {
  validateToolData();
  for (var i = 0; i < getNumberOfSections(); ++i) {
    var section = getSection(i);
    if (getSection(0).workOffset == 0 && section.workOffset > 0) {
      if (!(typeof wcsDefinitions != "undefined" && wcsDefinitions.useZeroOffset)) {
        error(localize("Using multiple work offsets is not possible if the initial work offset is 0."));
      }
    }
    if (section.isMultiAxis()) {
      if (!section.isOptimizedForMachine() &&
        (!getSetting("workPlaneMethod.useTiltedWorkplane", false) || !getSetting("supportsToolVectorOutput", false))) {
        error(localize("This postprocessor requires a machine configuration for 5-axis simultaneous toolpath."));
      }
      if (machineConfiguration.getMultiAxisFeedrateMode() == FEED_INVERSE_TIME && !getSetting("supportsInverseTimeFeed", true)) {
        error(localize("This postprocessor does not support inverse time feedrates."));
      }
      if (getSetting("supportsToolVectorOutput", false) && !tcp.isSupportedByControl) {
        error(localize("Incompatible postprocessor settings detected." + EOL +
        "Setting 'supportsToolVectorOutput' requires setting 'supportsTCP' to be enabled as well."));
      }
    }
  }
  if (!tcp.isSupportedByControl && tcp.isSupportedByMachine) {
    error(localize("The machine configuration has TCP enabled which is not supported by this postprocessor."));
  }
  if (getProperty("safePositionMethod") == "clearanceHeight") {
    var msg = "-Attention- Property 'Safe Retracts' is set to 'Clearance Height'." + EOL +
      "Ensure the clearance height will clear the part and or fixtures." + EOL +
      "Raise the Z-axis to a safe height before starting the program.";
    warning(msg);
    writeComment(msg);
  }
}

function validateToolData() {
  var _default = 99999;
  var _maximumSpindleRPM = machineConfiguration.getMaximumSpindleSpeed() > 0 ? machineConfiguration.getMaximumSpindleSpeed() :
    settings.maximumSpindleRPM == undefined ? _default : settings.maximumSpindleRPM;
  var _maximumToolNumber = machineConfiguration.isReceived() && machineConfiguration.getNumberOfTools() > 0 ? machineConfiguration.getNumberOfTools() :
    settings.maximumToolNumber == undefined ? _default : settings.maximumToolNumber;
  var _maximumToolLengthOffset = settings.maximumToolLengthOffset == undefined ? _default : settings.maximumToolLengthOffset;
  var _maximumToolDiameterOffset = settings.maximumToolDiameterOffset == undefined ? _default : settings.maximumToolDiameterOffset;

  var header = ["Detected maximum values are out of range.", "Maximum values:"];
  var warnings = {
    toolNumber    : {msg:"Tool number value exceeds the maximum value for tool: " + EOL, max:" Tool number: " + _maximumToolNumber, values:[]},
    lengthOffset  : {msg:"Tool length offset value exceeds the maximum value for tool: " + EOL, max:" Tool length offset: " + _maximumToolLengthOffset, values:[]},
    diameterOffset: {msg:"Tool diameter offset value exceeds the maximum value for tool: " + EOL, max:" Tool diameter offset: " + _maximumToolDiameterOffset, values:[]},
    spindleSpeed  : {msg:"Spindle speed exceeds the maximum value for operation: " + EOL, max:" Spindle speed: " + _maximumSpindleRPM, values:[]}
  };

  var toolIds = [];
  for (var i = 0; i < getNumberOfSections(); ++i) {
    var section = getSection(i);
    if (toolIds.indexOf(section.getTool().getToolId()) === -1) { // loops only through sections which have a different tool ID
      var toolNumber = section.getTool().number;
      var lengthOffset = section.getTool().lengthOffset;
      var diameterOffset = section.getTool().diameterOffset;
      var comment = section.getParameter("operation-comment", "");

      if (toolNumber > _maximumToolNumber && !getProperty("toolAsName")) {
        warnings.toolNumber.values.push(SP + toolNumber + EOL);
      }
      if (lengthOffset > _maximumToolLengthOffset) {
        warnings.lengthOffset.values.push(SP + "Tool " + toolNumber + " (" + comment + "," + " Length offset: " + lengthOffset + ")" + EOL);
      }
      if (diameterOffset > _maximumToolDiameterOffset) {
        warnings.diameterOffset.values.push(SP + "Tool " + toolNumber + " (" + comment + "," + " Diameter offset: " + diameterOffset + ")" + EOL);
      }
      toolIds.push(section.getTool().getToolId());
    }
    // loop through all sections regardless of tool id for idenitfying spindle speeds

    // identify if movement ramp is used in current toolpath, use ramp spindle speed for comparisons
    var ramp = section.getMovements() & ((1 << MOVEMENT_RAMP) | (1 << MOVEMENT_RAMP_ZIG_ZAG) | (1 << MOVEMENT_RAMP_PROFILE) | (1 << MOVEMENT_RAMP_HELIX));
    var _sectionSpindleSpeed = Math.max(section.getTool().spindleRPM, ramp ? section.getTool().rampingSpindleRPM : 0, 0);
    if (_sectionSpindleSpeed > _maximumSpindleRPM) {
      warnings.spindleSpeed.values.push(SP + section.getParameter("operation-comment", "") + " (" + _sectionSpindleSpeed + " RPM" + ")" + EOL);
    }
  }

  // sort lists by tool number
  warnings.toolNumber.values.sort(function(a, b) {return a - b;});
  warnings.lengthOffset.values.sort(function(a, b) {return a.localeCompare(b);});
  warnings.diameterOffset.values.sort(function(a, b) {return a.localeCompare(b);});

  var warningMessages = [];
  for (var key in warnings) {
    if (warnings[key].values != "") {
      header.push(warnings[key].max); // add affected max values to the header
      warningMessages.push(warnings[key].msg + warnings[key].values.join(""));
    }
  }
  if (warningMessages.length != 0) {
    warningMessages.unshift(header.join(EOL) + EOL);
    warning(warningMessages.join(EOL));
  }
}

function forceFeed() {
  currentFeedId = undefined;
  feedOutput.reset();
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

/** Force output of X, Y, Z, A, B, C, and F on next output. */
function forceAny() {
  forceXYZ();
  forceABC();
  forceFeed();
}

/**
  Writes the specified block.
*/
function writeBlock() {
  var text = formatWords(arguments);
  if (!text) {
    return;
  }
  var prefix = getSetting("sequenceNumberPrefix", "N");
  var suffix = getSetting("writeBlockSuffix", "");
  if ((optionalSection || skipBlocks) && !getSetting("supportsOptionalBlocks", true)) {
    error(localize("Optional blocks are not supported by this post."));
  }
  if (getProperty("showSequenceNumbers") == "true") {
    if (sequenceNumber == undefined || sequenceNumber >= settings.maximumSequenceNumber) {
      sequenceNumber = getProperty("sequenceNumberStart");
    }
    if (optionalSection || skipBlocks) {
      writeWords2("/", prefix + sequenceNumber, text + suffix);
    } else {
      writeWords2(prefix + sequenceNumber, text + suffix);
    }
    sequenceNumber += getProperty("sequenceNumberIncrement");
  } else {
    if (optionalSection || skipBlocks) {
      writeWords2("/", text + suffix);
    } else {
      writeWords(text + suffix);
    }
  }
}

validate(settings.comments, "Setting 'comments' is required but not defined.");
function formatComment(text) {
  var prefix = settings.comments.prefix;
  var suffix = settings.comments.suffix;
  var _permittedCommentChars = settings.comments.permittedCommentChars == undefined ? "" : settings.comments.permittedCommentChars;
  switch (settings.comments.outputFormat) {
  case "upperCase":
    text = text.toUpperCase();
    _permittedCommentChars = _permittedCommentChars.toUpperCase();
    break;
  case "lowerCase":
    text = text.toLowerCase();
    _permittedCommentChars = _permittedCommentChars.toLowerCase();
    break;
  case "ignoreCase":
    _permittedCommentChars = _permittedCommentChars.toUpperCase() + _permittedCommentChars.toLowerCase();
    break;
  default:
    error(localize("Unsupported option specified for setting 'comments.outputFormat'."));
  }
  if (_permittedCommentChars != "") {
    text = filterText(String(text), _permittedCommentChars);
  }
  text = String(text).substring(0, settings.comments.maximumLineLength - prefix.length - suffix.length);
  return text != "" ? prefix + text + suffix : "";
}

/**
  Output a comment.
*/
function writeComment(text) {
  if (!text) {
    return;
  }
  var comments = String(text).split(/\r?\n/);
  for (comment in comments) {
    var _comment = formatComment(comments[comment]);
    if (_comment) {
      if (getSetting("comments.showSequenceNumbers", false)) {
        writeBlock(_comment);
      } else {
        writeln(_comment);
      }
    }
  }
}

function onComment(text) {
  writeComment(text);
}

/**
  Writes the specified block - used for tool changes only.
*/
function writeToolBlock() {
  var show = getProperty("showSequenceNumbers");
  setProperty("showSequenceNumbers", (show == "true" || show == "toolChange") ? "true" : "false");
  writeBlock(arguments);
  setProperty("showSequenceNumbers", show);
  machineSimulation({/*x:toPreciseUnit(200, MM), y:toPreciseUnit(200, MM), coordinates:MACHINE,*/ mode:TOOLCHANGE}); // move machineSimulation to a tool change position
}

var skipBlocks = false;
var initialState = JSON.parse(JSON.stringify(state)); // save initial state
var optionalState = JSON.parse(JSON.stringify(state));
var saveCurrentSectionId = undefined;
function writeStartBlocks(isRequired, code) {
  var saveSkipBlocks = skipBlocks;
  var saveMainState = state; // save main state

  if (!isRequired) {
    if (!getProperty("safeStartAllOperations", false)) {
      return; // when safeStartAllOperations is disabled, dont output code and return
    }
    if (saveCurrentSectionId != getCurrentSectionId()) {
      saveCurrentSectionId = getCurrentSectionId();
      forceModals(); // force all modal variables when entering a new section
      optionalState = Object.create(initialState); // reset optionalState to initialState when entering a new section
    }
    skipBlocks = true; // if values are not required, but safeStartAllOperations is enabled - write following blocks as optional
    state = optionalState; // set state to optionalState if skipBlocks is true
    state.mainState = false;
  }
  code(); // writes out the code which is passed to this function as an argument

  state = saveMainState; // restore main state
  skipBlocks = saveSkipBlocks; // restore skipBlocks value
}

var pendingRadiusCompensation = -1;
function onRadiusCompensation() {
  pendingRadiusCompensation = radiusCompensation;
  if (pendingRadiusCompensation >= 0 && !getSetting("supportsRadiusCompensation", true)) {
    error(localize("Radius compensation mode is not supported."));
    return;
  }
}

function onPassThrough(text) {
  var commands = String(text).split(",");
  for (text in commands) {
    writeBlock(commands[text]);
  }
}

function forceModals() {
  if (arguments.length == 0) { // reset all modal variables listed below
    var modals = [
      "gMotionModal",
      "gPlaneModal",
      "gAbsIncModal",
      "gFeedModeModal",
      "feedOutput"
    ];
    if (operationNeedsSafeStart && (typeof currentSection != "undefined" && currentSection.isMultiAxis())) {
      modals.push("fourthAxisClamp", "fifthAxisClamp", "sixthAxisClamp");
    }
    for (var i = 0; i < modals.length; ++i) {
      if (typeof this[modals[i]] != "undefined") {
        this[modals[i]].reset();
      }
    }
  } else {
    for (var i in arguments) {
      arguments[i].reset(); // only reset the modal variable passed to this function
    }
  }
}

/** Helper function to be able to use a default value for settings which do not exist. */
function getSetting(setting, defaultValue) {
  var result = defaultValue;
  var keys = setting.split(".");
  var obj = settings;
  for (var i in keys) {
    if (obj[keys[i]] != undefined) { // setting does exist
      result = obj[keys[i]];
      if (typeof [keys[i]] === "object") {
        obj = obj[keys[i]];
        continue;
      }
    } else { // setting does not exist, use default value
      if (defaultValue != undefined) {
        result = defaultValue;
      } else {
        error("Setting '" + keys[i] + "' has no default value and/or does not exist.");
        return undefined;
      }
    }
  }
  return result;
}

function getForwardDirection(_section) {
  var forward = undefined;
  var _optimizeType = settings.workPlaneMethod && settings.workPlaneMethod.optimizeType;
  if (_section.isMultiAxis()) {
    forward = _section.workPlane.forward;
  } else if (!getSetting("workPlaneMethod.useTiltedWorkplane", false) && machineConfiguration.isMultiAxisConfiguration()) {
    if (_optimizeType == undefined) {
      var saveRotation = getRotation();
      getWorkPlaneMachineABC(_section, true);
      forward = getRotation().forward;
      setRotation(saveRotation); // reset rotation
    } else {
      var abc = getWorkPlaneMachineABC(_section, false);
      var forceAdjustment = settings.workPlaneMethod.optimizeType == OPTIMIZE_TABLES || settings.workPlaneMethod.optimizeType == OPTIMIZE_BOTH;
      forward = machineConfiguration.getOptimizedDirection(_section.workPlane.forward, abc, false, forceAdjustment);
    }
  } else {
    forward = getRotation().forward;
  }
  return forward;
}

function getRetractParameters() {
  var _arguments = typeof arguments[0] === "object" ? arguments[0].axes : arguments;
  var singleLine = arguments[0].singleLine == undefined ? true : arguments[0].singleLine;
  var words = []; // store all retracted axes in an array
  var retractAxes = new Array(false, false, false);
  var method = getProperty("safePositionMethod", "undefined");
  if (method == "clearanceHeight") {
    if (!is3D()) {
      error(localize("Safe retract option 'Clearance Height' is only supported when all operations are along the setup Z-axis."));
    }
    return undefined;
  }
  validate(settings.retract, "Setting 'retract' is required but not defined.");
  validate(_arguments.length != 0, "No axis specified for getRetractParameters().");
  for (i in _arguments) {
    retractAxes[_arguments[i]] = true;
  }
  if ((retractAxes[0] || retractAxes[1]) && !state.retractedZ) { // retract Z first before moving to X/Y home
    error(localize("Retracting in X/Y is not possible without being retracted in Z."));
    return undefined;
  }
  // special conditions
  if (retractAxes[0] || retractAxes[1]) {
    method = getSetting("retract.methodXY", method);
  }
  if (retractAxes[2]) {
    method = getSetting("retract.methodZ", method);
  }
  // define home positions
  var useZeroValues = (settings.retract.useZeroValues && settings.retract.useZeroValues.indexOf(method) != -1);
  var _xHome = machineConfiguration.hasHomePositionX() && !useZeroValues ? machineConfiguration.getHomePositionX() : toPreciseUnit(0, MM);
  var _yHome = machineConfiguration.hasHomePositionY() && !useZeroValues ? machineConfiguration.getHomePositionY() : toPreciseUnit(0, MM);
  var _zHome = machineConfiguration.getRetractPlane() != 0 && !useZeroValues ? machineConfiguration.getRetractPlane() : toPreciseUnit(0, MM);
  for (var i = 0; i < _arguments.length; ++i) {
    switch (_arguments[i]) {
    case X:
      if (!state.retractedX) {
        words.push("X" + xyzFormat.format(_xHome));
        xOutput.reset();
        state.retractedX = true;
      }
      break;
    case Y:
      if (!state.retractedY) {
        words.push("Y" + xyzFormat.format(_yHome));
        yOutput.reset();
        state.retractedY = true;
      }
      break;
    case Z:
      if (!state.retractedZ) {
        words.push("Z" + xyzFormat.format(_zHome));
        zOutput.reset();
        state.retractedZ = true;
      }
      break;
    default:
      error(localize("Unsupported axis specified for getRetractParameters()."));
      return undefined;
    }
  }
  return {
    method     : method,
    retractAxes: retractAxes,
    words      : words,
    positions  : {
      x: retractAxes[0] ? _xHome : undefined,
      y: retractAxes[1] ? _yHome : undefined,
      z: retractAxes[2] ? _zHome : undefined},
    singleLine: singleLine};
}

/** Returns true when subprogram logic does exist into the post. */
function subprogramsAreSupported() {
  return typeof subprogramState != "undefined";
}

// Start of machine simulation connection move support
var debugSimulation = false; // enable to output debug information for connection move support in the NC program
var TCPON = "TCP ON";
var TCPOFF = "TCP OFF";
var TWPON = "TWP ON";
var TWPOFF = "TWP OFF";
var TOOLCHANGE = "TOOL CHANGE";
var RETRACTTOOLAXIS = "RETRACT TOOLAXIS";
var WORK = "WORK CS";
var MACHINE = "MACHINE CS";
var MIN = "MIN";
var MAX = "MAX";
var WARNING_NON_RANGE = [0, 1, 2];
var isTwpOn;
var isTcpOn;
/**
 * Helper function for connection moves in machine simulation.
 * @param {Object} parameters An object containing the desired options for machine simulation.
 * @note Available properties are:
 * @param {Number} x X axis position, alternatively use MIN or MAX to move to the axis limit
 * @param {Number} y Y axis position, alternatively use MIN or MAX to move to the axis limit
 * @param {Number} z Z axis position, alternatively use MIN or MAX to move to the axis limit
 * @param {Number} a A axis position (in radians)
 * @param {Number} b B axis position (in radians)
 * @param {Number} c C axis position (in radians)
 * @param {Number} feed desired feedrate, automatically set to high/current feedrate if not specified
 * @param {String} mode mode TCPON | TCPOFF | TWPON | TWPOFF | TOOLCHANGE | RETRACTTOOLAXIS
 * @param {String} coordinates WORK | MACHINE - if undefined, work coordinates will be used by default
 * @param {Number} eulerAngles the calculated Euler angles for the workplane
 * @example
  machineSimulation({a:abc.x, b:abc.y, c:abc.z, coordinates:MACHINE});
  machineSimulation({x:toPreciseUnit(200, MM), y:toPreciseUnit(200, MM), coordinates:MACHINE, mode:TOOLCHANGE});
*/
function machineSimulation(parameters) {
  if (revision < 50198 || skipBlocks || (getSimulationStreamPath() == "" && !debugSimulation)) {
    return; // return when post kernel revision is lower than 50198 or when skipBlocks is enabled
  }
  getAxisLimit = function(axis, limit) {
    validate(limit == MIN || limit == MAX, subst(localize("Invalid argument \"%1\" passed to the machineSimulation function."), limit));
    var range = axis.getRange();
    if (range.isNonRange()) {
      var axisLetters = ["X", "Y", "Z"];
      var warningMessage = subst(localize("An attempt was made to move the \"%1\" axis to its MIN/MAX limits during machine simulation, but its range is set to \"unlimited\"." + EOL +
        "A limited range must be set for the \"%1\" axis in the machine definition, or these motions will not be shown in machine simulation."), axisLetters[axis.getCoordinate()]);
      warningOnce(warningMessage, WARNING_NON_RANGE[axis.getCoordinate()]);
      return undefined;
    }
    return limit == MIN ? range.minimum : range.maximum;
  };
  var x = (isNaN(parameters.x) && parameters.x) ? getAxisLimit(machineConfiguration.getAxisX(), parameters.x) : parameters.x;
  var y = (isNaN(parameters.y) && parameters.y) ? getAxisLimit(machineConfiguration.getAxisY(), parameters.y) : parameters.y;
  var z = (isNaN(parameters.z) && parameters.z) ? getAxisLimit(machineConfiguration.getAxisZ(), parameters.z) : parameters.z;
  var rotaryAxesErrorMessage = localize("Invalid argument for rotary axes passed to the machineSimulation function. Only numerical values are supported.");
  var a = (isNaN(parameters.a) && parameters.a) ? error(rotaryAxesErrorMessage) : parameters.a;
  var b = (isNaN(parameters.b) && parameters.b) ? error(rotaryAxesErrorMessage) : parameters.b;
  var c = (isNaN(parameters.c) && parameters.c) ? error(rotaryAxesErrorMessage) : parameters.c;
  var coordinates = parameters.coordinates;
  var eulerAngles = parameters.eulerAngles;
  var feed = parameters.feed;
  if (feed === undefined && typeof gMotionModal !== "undefined") {
    feed = gMotionModal.getCurrent() !== 0;
  }
  var mode = parameters.mode;
  var performToolChange = mode == TOOLCHANGE;
  if (mode !== undefined && ![TCPON, TCPOFF, TWPON, TWPOFF, TOOLCHANGE, RETRACTTOOLAXIS].includes(mode)) {
    error(subst("Mode '%1' is not supported.", mode));
  }

  // mode takes precedence over TCP/TWP states
  var enableTCP = isTcpOn;
  var enableTWP = isTwpOn;
  if (mode === TCPON || mode === TCPOFF) {
    enableTCP = mode === TCPON;
  } else if (mode === TWPON || mode === TWPOFF) {
    enableTWP = mode === TWPON;
  } else {
    enableTCP = typeof state !== "undefined" && state.tcpIsActive;
    enableTWP = typeof state !== "undefined" && state.twpIsActive;
  }
  var disableTCP = !enableTCP;
  var disableTWP = !enableTWP;
  if (disableTWP) {
    simulation.setTWPModeOff();
    isTwpOn = false;
  }
  if (disableTCP) {
    simulation.setTCPModeOff();
    isTcpOn = false;
  }
  if (enableTCP) {
    simulation.setTCPModeOn();
    isTcpOn = true;
  }
  if (enableTWP) {
    if (settings.workPlaneMethod.eulerConvention == undefined) {
      simulation.setTWPModeAlignToCurrentPose();
    } else if (eulerAngles) {
      simulation.setTWPModeByEulerAngles(settings.workPlaneMethod.eulerConvention, eulerAngles.x, eulerAngles.y, eulerAngles.z);
    }
    isTwpOn = true;
  }
  if (mode == RETRACTTOOLAXIS) {
    simulation.retractAlongToolAxisToLimit();
  }

  if (debugSimulation) {
    writeln("  DEBUG" + JSON.stringify(parameters));
    writeln("  DEBUG" + JSON.stringify({isTwpOn:isTwpOn, isTcpOn:isTcpOn, feed:feed}));
  }

  if (x !== undefined || y !== undefined || z !== undefined || a !== undefined || b !== undefined || c !== undefined) {
    if (x !== undefined) {simulation.setTargetX(x);}
    if (y !== undefined) {simulation.setTargetY(y);}
    if (z !== undefined) {simulation.setTargetZ(z);}
    if (a !== undefined) {simulation.setTargetA(a);}
    if (b !== undefined) {simulation.setTargetB(b);}
    if (c !== undefined) {simulation.setTargetC(c);}

    if (feed != undefined && feed) {
      simulation.setMotionToLinear();
      simulation.setFeedrate(typeof feed == "number" ? feed : feedOutput.getCurrent() == 0 ? highFeedrate : feedOutput.getCurrent());
    } else {
      simulation.setMotionToRapid();
    }

    if (coordinates != undefined && coordinates == MACHINE) {
      simulation.moveToTargetInMachineCoords();
    } else {
      simulation.moveToTargetInWorkCoords();
    }
  }
  if (performToolChange) {
    simulation.performToolChangeCycle();
    simulation.moveToTargetInMachineCoords();
  }
}
// <<<<< INCLUDED FROM include_files/commonFunctions.cpi
// >>>>> INCLUDED FROM include_files/defineMachine.cpi
function defineMachine() {
  var useTCP = true;
  if (false) { // note: setup your machine here
    var aAxis = createAxis({coordinate:0, table:true, axis:[1, 0, 0], range:[-120, 120], preference:1, tcp:useTCP});
    var cAxis = createAxis({coordinate:2, table:true, axis:[0, 0, 1], range:[-360, 360], preference:0, tcp:useTCP});
    machineConfiguration = new MachineConfiguration(aAxis, cAxis);

    setMachineConfiguration(machineConfiguration);
    if (receivedMachineConfiguration) {
      warning(localize("The provided CAM machine configuration is overwritten by the postprocessor."));
      receivedMachineConfiguration = false; // CAM provided machine configuration is overwritten
    }
  }

  if (!receivedMachineConfiguration) {
    // multiaxis settings
    if (machineConfiguration.isHeadConfiguration()) {
      machineConfiguration.setVirtualTooltip(false); // translate the pivot point to the virtual tool tip for nonTCP rotary heads
    }

    // retract / reconfigure
    var performRewinds = false; // set to true to enable the rewind/reconfigure logic
    if (performRewinds) {
      machineConfiguration.enableMachineRewinds(); // enables the retract/reconfigure logic
      safeRetractDistance = (unit == IN) ? 1 : 25; // additional distance to retract out of stock, can be overridden with a property
      safeRetractFeed = (unit == IN) ? 20 : 500; // retract feed rate
      safePlungeFeed = (unit == IN) ? 10 : 250; // plunge feed rate
      machineConfiguration.setSafeRetractDistance(safeRetractDistance);
      machineConfiguration.setSafeRetractFeedrate(safeRetractFeed);
      machineConfiguration.setSafePlungeFeedrate(safePlungeFeed);
      var stockExpansion = new Vector(toPreciseUnit(0.1, IN), toPreciseUnit(0.1, IN), toPreciseUnit(0.1, IN)); // expand stock XYZ values
      machineConfiguration.setRewindStockExpansion(stockExpansion);
    }

    // multi-axis feedrates
    if (machineConfiguration.isMultiAxisConfiguration()) {
      machineConfiguration.setMultiAxisFeedrate(
        useTCP ? FEED_FPM : getProperty("useDPMFeeds") ? FEED_DPM : FEED_INVERSE_TIME,
        9999.99, // maximum output value for inverse time feed rates
        getProperty("useDPMFeeds") ? DPM_COMBINATION : INVERSE_MINUTES, // INVERSE_MINUTES/INVERSE_SECONDS or DPM_COMBINATION/DPM_STANDARD
        0.5, // tolerance to determine when the DPM feed has changed
        1.0 // ratio of rotary accuracy to linear accuracy for DPM calculations
      );
      setMachineConfiguration(machineConfiguration);
    }

    /* home positions */
    // machineConfiguration.setHomePositionX(toPreciseUnit(0, IN));
    // machineConfiguration.setHomePositionY(toPreciseUnit(0, IN));
    // machineConfiguration.setRetractPlane(toPreciseUnit(0, IN));
  }
}
// <<<<< INCLUDED FROM include_files/defineMachine.cpi
// >>>>> INCLUDED FROM include_files/defineWorkPlane.cpi
validate(settings.workPlaneMethod, "Setting 'workPlaneMethod' is required but not defined.");
function defineWorkPlane(_section, _setWorkPlane) {
  var abc = new Vector(0, 0, 0);
  if (settings.workPlaneMethod.forceMultiAxisIndexing || !is3D() || machineConfiguration.isMultiAxisConfiguration()) {
    if (isPolarModeActive()) {
      abc = getCurrentDirection();
    } else if (_section.isMultiAxis()) {
      forceWorkPlane();
      cancelTransformation();
      abc = _section.isOptimizedForMachine() ? _section.getInitialToolAxisABC() : _section.getGlobalInitialToolAxis();
    } else if (settings.workPlaneMethod.useTiltedWorkplane && settings.workPlaneMethod.eulerConvention != undefined) {
      if (settings.workPlaneMethod.eulerCalculationMethod == "machine" && machineConfiguration.isMultiAxisConfiguration()) {
        abc = machineConfiguration.getOrientation(getWorkPlaneMachineABC(_section, true)).getEuler2(settings.workPlaneMethod.eulerConvention);
      } else {
        abc = _section.workPlane.getEuler2(settings.workPlaneMethod.eulerConvention);
      }
    } else {
      abc = getWorkPlaneMachineABC(_section, true);
    }

    if (_setWorkPlane) {
      if (_section.isMultiAxis() || isPolarModeActive()) { // 4-5x simultaneous operations
        cancelWorkPlane();
        if (_section.isOptimizedForMachine()) {
          positionABC(abc, true);
        } else {
          setCurrentDirection(abc);
        }
      } else { // 3x and/or 3+2x operations
        setWorkPlane(abc);
      }
    }
  } else {
    var remaining = _section.workPlane;
    if (!isSameDirection(remaining.forward, new Vector(0, 0, 1))) {
      error(localize("Tool orientation is not supported."));
      return abc;
    }
    setRotation(remaining);
  }
  tcp.isSupportedByOperation = isTCPSupportedByOperation(_section);
  return abc;
}

function isTCPSupportedByOperation(_section) {
  var _tcp = _section.getOptimizedTCPMode() == OPTIMIZE_NONE;
  if (!_section.isMultiAxis() && (settings.workPlaneMethod.useTiltedWorkplane ||
    (machineConfiguration.isMultiAxisConfiguration() && settings.workPlaneMethod.optimizeType != undefined ?
      getWorkPlaneMachineABC(_section, false).isZero() : isSameDirection(machineConfiguration.getSpindleAxis(), getForwardDirection(_section))) ||
    settings.workPlaneMethod.optimizeType == OPTIMIZE_HEADS ||
    settings.workPlaneMethod.optimizeType == OPTIMIZE_TABLES ||
    settings.workPlaneMethod.optimizeType == OPTIMIZE_BOTH)) {
    _tcp = false;
  }
  return _tcp;
}
// <<<<< INCLUDED FROM include_files/defineWorkPlane.cpi
// >>>>> INCLUDED FROM include_files/getWorkPlaneMachineABC.cpi
validate(settings.machineAngles, "Setting 'machineAngles' is required but not defined.");
function getWorkPlaneMachineABC(_section, rotate) {
  var currentABC = isFirstSection() ? new Vector(0, 0, 0) : getCurrentABC();
  var abc = _section.getABCByPreference(machineConfiguration, _section.workPlane, currentABC, settings.machineAngles.controllingAxis, settings.machineAngles.type, settings.machineAngles.options);
  if (!isSameDirection(machineConfiguration.getDirection(abc), _section.workPlane.forward)) {
    error(localize("Orientation not supported."));
  }
  if (rotate) {
    if (settings.workPlaneMethod.optimizeType == undefined || settings.workPlaneMethod.useTiltedWorkplane) { // legacy
      var useTCP = false;
      var R = machineConfiguration.getRemainingOrientation(abc, _section.workPlane);
      setRotation(useTCP ? _section.workPlane : R);
    } else {
      if (!_section.isOptimizedForMachine()) {
        machineConfiguration.setToolLength(getSetting("workPlaneMethod.compensateToolLength", false) ? getBodyLength(_section.getTool()) : 0); // define the tool length for head adjustments
        _section.optimize3DPositionsByMachine(machineConfiguration, abc, settings.workPlaneMethod.optimizeType);
      }
    }
  }
  return abc;
}
// <<<<< INCLUDED FROM include_files/getWorkPlaneMachineABC.cpi
// >>>>> INCLUDED FROM include_files/writeToolCall.cpi
function writeToolCall(tool, insertToolCall) {
  if (!isFirstSection()) {
    writeStartBlocks(!getProperty("safeStartAllOperations") && insertToolCall, function () {
      writeRetract(Z); // write optional Z retract before tool change if safeStartAllOperations is enabled
    });
  }
  writeStartBlocks(insertToolCall, function () {
    writeRetract(Z);
    if (getSetting("retract.homeXY.onToolChange", false)) {
      writeRetract(settings.retract.homeXY.onToolChange);
    }
    if (!isFirstSection() && insertToolCall) {
      if (typeof forceWorkPlane == "function") {
        forceWorkPlane();
      }
      onCommand(COMMAND_COOLANT_OFF); // turn off coolant on tool change
      if (typeof disableLengthCompensation == "function") {
        disableLengthCompensation(false);
      }
    }

    if (tool.manualToolChange) {
      onCommand(COMMAND_STOP);
      writeComment("MANUAL TOOL CHANGE TO T" + toolFormat.format(tool.number));
    } else {
      if (!isFirstSection() && getProperty("optionalStop") && insertToolCall) {
        onCommand(COMMAND_OPTIONAL_STOP);
      }
      onCommand(COMMAND_LOAD_TOOL);
    }
  });
  if (typeof forceModals == "function" && (insertToolCall || getProperty("safeStartAllOperations"))) {
    forceModals();
  }
}
// <<<<< INCLUDED FROM include_files/writeToolCall.cpi
// >>>>> INCLUDED FROM include_files/startSpindle.cpi
function startSpindle(tool, insertToolCall) {
  if (tool.type != TOOL_PROBE) {
    var spindleSpeedIsRequired = insertToolCall || forceSpindleSpeed || isFirstSection() ||
      rpmFormat.areDifferent(spindleSpeed, sOutput.getCurrent()) ||
      (tool.clockwise != getPreviousSection().getTool().clockwise);

    writeStartBlocks(spindleSpeedIsRequired, function () {
      if (spindleSpeedIsRequired || operationNeedsSafeStart) {
        onCommand(COMMAND_START_SPINDLE);
      }
    });
  }
}
// <<<<< INCLUDED FROM include_files/startSpindle.cpi
// >>>>> INCLUDED FROM include_files/parametricFeeds.cpi
properties.useParametricFeed = {
  title      : "Parametric feed",
  description: "Specifies that the feedrates should be output using parameters.",
  group      : "preferences",
  type       : "boolean",
  value      : false,
  scope      : "post"
};
var activeMovements;
var currentFeedId;
validate(settings.parametricFeeds, "Setting 'parametricFeeds' is required but not defined.");
function initializeParametricFeeds(insertToolCall) {
  if (getProperty("useParametricFeed") && getParameter("operation-strategy") != "drill" && !currentSection.hasAnyCycle()) {
    if (!insertToolCall && activeMovements && (getCurrentSectionId() > 0) &&
      ((getPreviousSection().getPatternId() == currentSection.getPatternId()) && (currentSection.getPatternId() != 0))) {
      return; // use the current feeds
    }
  } else {
    activeMovements = undefined;
    return;
  }

  activeMovements = new Array();
  var movements = currentSection.getMovements();

  var id = 0;
  var activeFeeds = new Array();
  if (hasParameter("operation:tool_feedCutting")) {
    if (movements & ((1 << MOVEMENT_CUTTING) | (1 << MOVEMENT_LINK_TRANSITION) | (1 << MOVEMENT_EXTENDED))) {
      var feedContext = new FeedContext(id, localize("Cutting"), getParameter("operation:tool_feedCutting"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_CUTTING] = feedContext;
      if (!hasParameter("operation:tool_feedTransition")) {
        activeMovements[MOVEMENT_LINK_TRANSITION] = feedContext;
      }
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
  if (hasParameter("operation:tool_feedTransition")) {
    if (movements & (1 << MOVEMENT_LINK_TRANSITION)) {
      var feedContext = new FeedContext(id, localize("Transition"), getParameter("operation:tool_feedTransition"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LINK_TRANSITION] = feedContext;
    }
    ++id;
  }

  for (var i = 0; i < activeFeeds.length; ++i) {
    var feedContext = activeFeeds[i];
    var feedDescription = typeof formatComment == "function" ? formatComment(feedContext.description) : feedContext.description;
    writeBlock(settings.parametricFeeds.feedAssignmentVariable + (settings.parametricFeeds.firstFeedParameter + feedContext.id) + "=" + feedFormat.format(feedContext.feed) + SP + feedDescription);
  }
}

function FeedContext(id, description, feed) {
  this.id = id;
  this.description = description;
  this.feed = feed;
}
// <<<<< INCLUDED FROM include_files/parametricFeeds.cpi
// >>>>> INCLUDED FROM include_files/coolant.cpi
var currentCoolantMode = COOLANT_OFF;
var coolantOff = undefined;
var isOptionalCoolant = false;
var forceCoolant = false;

function setCoolant(coolant) {
  var coolantCodes = getCoolantCodes(coolant);
  if (Array.isArray(coolantCodes)) {
    writeStartBlocks(!isOptionalCoolant, function () {
      if (settings.coolant.singleLineCoolant) {
        writeBlock(coolantCodes.join(getWordSeparator()));
      } else {
        for (var c in coolantCodes) {
          writeBlock(coolantCodes[c]);
        }
      }
    });
    return undefined;
  }
  return coolantCodes;
}

function getCoolantCodes(coolant, format) {
  if (!getProperty("useCoolant", true)) {
    return undefined; // coolant output is disabled by property if it exists
  }
  isOptionalCoolant = false;
  if (typeof operationNeedsSafeStart == "undefined") {
    operationNeedsSafeStart = false;
  }
  var multipleCoolantBlocks = new Array(); // create a formatted array to be passed into the outputted line
  var coolants = settings.coolant.coolants;
  if (!coolants) {
    error(localize("Coolants have not been defined."));
  }
  if (tool.type && tool.type == TOOL_PROBE) { // avoid coolant output for probing
    coolant = COOLANT_OFF;
  }
  if (coolant == currentCoolantMode) {
    if (operationNeedsSafeStart && coolant != COOLANT_OFF) {
      isOptionalCoolant = true;
    } else if (!forceCoolant || coolant == COOLANT_OFF) {
      return undefined; // coolant is already active
    }
  }
  if ((coolant != COOLANT_OFF) && (currentCoolantMode != COOLANT_OFF) && (coolantOff != undefined) && !forceCoolant && !isOptionalCoolant) {
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
    if (format == undefined || format) {
      return multipleCoolantBlocks; // return the single formatted coolant value
    } else {
      return m; // return unformatted coolant value
    }
  }
  return undefined;
}
// <<<<< INCLUDED FROM include_files/coolant.cpi
// >>>>> INCLUDED FROM include_files/smoothing.cpi
// collected state below, do not edit
validate(settings.smoothing, "Setting 'smoothing' is required but not defined.");
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
  var smoothingSettings = settings.smoothing;
  var previousLevel = smoothing.level;
  var previousTolerance = xyzFormat.getResultingValue(smoothing.tolerance);

  // format threshold parameters
  var thresholdRoughing = xyzFormat.getResultingValue(smoothingSettings.thresholdRoughing);
  var thresholdSemiFinishing = xyzFormat.getResultingValue(smoothingSettings.thresholdSemiFinishing);
  var thresholdFinishing = xyzFormat.getResultingValue(smoothingSettings.thresholdFinishing);

  // determine new smoothing levels and tolerances
  smoothing.level = parseInt(getProperty("useSmoothing"), 10);
  smoothing.level = isNaN(smoothing.level) ? -1 : smoothing.level;
  smoothing.tolerance = xyzFormat.getResultingValue(Math.max(getParameter("operation:tolerance", thresholdFinishing), 0));

  if (smoothing.level == 9999) {
    if (smoothingSettings.autoLevelCriteria == "stock") { // determine auto smoothing level based on stockToLeave
      var stockToLeave = xyzFormat.getResultingValue(getParameter("operation:stockToLeave", getParameter("operation:verticalStockToLeave", 0)));
      var verticalStockToLeave = xyzFormat.getResultingValue(getParameter("operation:verticalStockToLeave", stockToLeave));
      if (((stockToLeave >= thresholdRoughing) && (verticalStockToLeave >= thresholdRoughing)) || getParameter("operation:strategy", "") == "face") {
        smoothing.level = smoothingSettings.roughing; // set roughing level
      } else {
        if (((stockToLeave >= thresholdSemiFinishing) && (stockToLeave < thresholdRoughing)) &&
          ((verticalStockToLeave >= thresholdSemiFinishing) && (verticalStockToLeave < thresholdRoughing))) {
          smoothing.level = smoothingSettings.semi; // set semi level
        } else if (((stockToLeave >= thresholdFinishing) && (stockToLeave < thresholdSemiFinishing)) &&
          ((verticalStockToLeave >= thresholdFinishing) && (verticalStockToLeave < thresholdSemiFinishing))) {
          smoothing.level = smoothingSettings.semifinishing; // set semi-finishing level
        } else {
          smoothing.level = smoothingSettings.finishing; // set finishing level
        }
      }
    } else { // detemine auto smoothing level based on operation tolerance instead of stockToLeave
      if (smoothing.tolerance >= thresholdRoughing || getParameter("operation:strategy", "") == "face") {
        smoothing.level = smoothingSettings.roughing; // set roughing level
      } else {
        if (((smoothing.tolerance >= thresholdSemiFinishing) && (smoothing.tolerance < thresholdRoughing))) {
          smoothing.level = smoothingSettings.semi; // set semi level
        } else if (((smoothing.tolerance >= thresholdFinishing) && (smoothing.tolerance < thresholdSemiFinishing))) {
          smoothing.level = smoothingSettings.semifinishing; // set semi-finishing level
        } else {
          smoothing.level = smoothingSettings.finishing; // set finishing level
        }
      }
    }
  }

  if (smoothing.level == -1) { // useSmoothing is disabled
    smoothing.isAllowed = false;
  } else { // do not output smoothing for the following operations
    smoothing.isAllowed = !(currentSection.getTool().type == TOOL_PROBE || isDrillingCycle());
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
}
// <<<<< INCLUDED FROM include_files/smoothing.cpi
// >>>>> INCLUDED FROM include_files/writeProgramHeader.cpi
properties.writeMachine = {
  title      : "Write machine",
  description: "Output the machine settings in the header of the program.",
  group      : "formats",
  type       : "boolean",
  value      : true,
  scope      : "post"
};
properties.writeTools = {
  title      : "Write tool list",
  description: "Output a tool list in the header of the program.",
  group      : "formats",
  type       : "boolean",
  value      : true,
  scope      : "post"
};
function writeProgramHeader() {
  // dump machine configuration
  var vendor = machineConfiguration.getVendor();
  var model = machineConfiguration.getModel();
  var mDescription = machineConfiguration.getDescription();
  if (getProperty("writeMachine") && (vendor || model || mDescription)) {
    writeComment(localize("Machine"));
    if (vendor) {
      writeComment("  " + localize("vendor") + ": " + vendor);
    }
    if (model) {
      writeComment("  " + localize("model") + ": " + model);
    }
    if (mDescription) {
      writeComment("  " + localize("description") + ": " + mDescription);
    }
  }

  // dump tool information
  if (getProperty("writeTools")) {
    if (false) { // set to true to use the post kernel version of the tool list
      writeToolTable(TOOL_NUMBER_COL);
    } else {
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
          var comment = (getProperty("toolAsName") ? "\"" + tool.description.toUpperCase() + "\"" : "T" + toolFormat.format(tool.number)) + " " +
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
  }
}
// <<<<< INCLUDED FROM include_files/writeProgramHeader.cpi
var incPrefix = ["IX", "IY", "IZ", "IA", "IB", "IC"];
var absPrefix = ["X", "Y", "Z", "A", "B", "C"];
// >>>>> INCLUDED FROM include_files/subprograms.cpi
properties.useSubroutines = {
  title      : "Use subroutines",
  description: "Select your desired subroutine option. 'All Operations' creates subroutines per each operation, 'Cycles' creates subroutines for cycle operations on same holes, and 'Patterns' creates subroutines for patterned operations.",
  group      : "preferences",
  type       : "enum",
  values     : [
    {title:"No", id:"none"},
    {title:"All Operations", id:"allOperations"},
    {title:"All Operations & Patterns", id:"allPatterns"},
    {title:"Cycles", id:"cycles"},
    {title:"Operations, Patterns, Cycles", id:"all"},
    {title:"Patterns", id:"patterns"}
  ],
  value: "none",
  scope: "post"
};
properties.useFilesForSubprograms = {
  title      : "Use files for subroutines",
  description: "If enabled, subroutines will be saved as individual files.",
  group      : "preferences",
  type       : "boolean",
  value      : false,
  scope      : "post"
};

var NONE = 0x0000;
var PATTERNS = 0x0001;
var CYCLES = 0x0010;
var ALLOPERATIONS = 0x0100;
var subroutineBitmasks = {
  none         : NONE,
  patterns     : PATTERNS,
  cycles       : CYCLES,
  allOperations: ALLOPERATIONS,
  allPatterns  : PATTERNS + ALLOPERATIONS,
  all          : PATTERNS + CYCLES + ALLOPERATIONS
};

var SUB_UNKNOWN = 0;
var SUB_PATTERN = 1;
var SUB_CYCLE = 2;

// collected state below, do not edit
validate(settings.subprograms, "Setting 'subprograms' is required but not defined.");
var subprogramState = {
  subprograms            : [],          // Redirection buffer
  newSubprogram          : false,       // Indicate if the current subprogram is new to definedSubprograms
  currentSubprogram      : 0,           // The current subprogram number
  lastSubprogram         : undefined,   // The last subprogram number
  definedSubprograms     : new Array(), // A collection of pattern and cycle subprograms
  saveShowSequenceNumbers: "",          // Used to store pre-condition of "showSequenceNumbers"
  cycleSubprogramIsActive: false,       // Indicate if it's handling a cycle subprogram
  patternIsActive        : false,       // Indicate if it's handling a pattern subprogram
  incrementalSubprogram  : false,       // Indicate if the current subprogram needs to go incremental mode
  incrementalMode        : false,       // Indicate if incremental mode is on
  mainProgramNumber      : undefined    // The main program number
};

function subprogramResolveSetting(_setting, _val, _comment) {
  if (typeof _setting == "string") {
    return formatWords(_setting.toString().replace("%currentSubprogram", subprogramState.currentSubprogram), (_comment ? formatComment(_comment) : ""));
  } else {
    return formatWords(_setting + (_val ? settings.subprograms.format.format(_val) : ""), (_comment ? formatComment(_comment) : ""));
  }
}

/**
 * Start to redirect buffer to subprogram.
 * @param {Vector} initialPosition Initial position
 * @param {Vector} abc Machine axis angles
 * @param {boolean} incremental If the subprogram needs to go incremental mode
 */
function subprogramStart(initialPosition, abc, incremental) {
  var comment = getParameter("operation-comment", "");
  var startBlock;
  if (getProperty("useFilesForSubprograms")) {
    var _fileName = subprogramState.currentSubprogram;
    var subprogramExtension = extension;
    if (settings.subprograms.files) {
      if (settings.subprograms.files.prefix != undefined) {
        _fileName = subprogramResolveSetting(settings.subprograms.files.prefix, subprogramState.currentSubprogram);
      }
      if (settings.subprograms.files.extension) {
        subprogramExtension = settings.subprograms.files.extension;
      }
    }
    var path = FileSystem.getCombinedPath(FileSystem.getFolderPath(getOutputPath()), _fileName + "." + subprogramExtension);
    redirectToFile(path);
    startBlock = subprogramResolveSetting(settings.subprograms.startBlock.files, subprogramState.currentSubprogram, comment);
  } else {
    redirectToBuffer();
    startBlock = subprogramResolveSetting(settings.subprograms.startBlock.embedded, subprogramState.currentSubprogram, comment);
  }
  writeln(startBlock);

  subprogramState.saveShowSequenceNumbers = getProperty("showSequenceNumbers", undefined);
  if (subprogramState.saveShowSequenceNumbers != undefined) {
    setProperty("showSequenceNumbers", "false");
  }
  if (incremental) {
    setAbsIncMode(true, initialPosition, abc);
  }
  if (typeof gPlaneModal != "undefined" && typeof gMotionModal != "undefined") {
    forceModals(gPlaneModal, gMotionModal);
  }
}

/** Output the command for calling a subprogram by its subprogram number. */
function subprogramCall() {
  var callBlock;
  if (getProperty("useFilesForSubprograms")) {
    callBlock = subprogramResolveSetting(settings.subprograms.callBlock.files, subprogramState.currentSubprogram);
  } else {
    callBlock = subprogramResolveSetting(settings.subprograms.callBlock.embedded, subprogramState.currentSubprogram);
  }
  writeBlock(callBlock); // call subprogram
}

/** End of subprogram and close redirection. */
function subprogramEnd() {
  if (isRedirecting()) {
    if (subprogramState.newSubprogram) {
      var finalPosition = getFramePosition(currentSection.getFinalPosition());
      var abc;
      if (currentSection.isMultiAxis() && machineConfiguration.isMultiAxisConfiguration()) {
        abc = currentSection.getFinalToolAxisABC();
      } else {
        abc = getCurrentDirection();
      }
      setAbsIncMode(false, finalPosition, abc);

      if (getProperty("useFilesForSubprograms")) {
        var endBlockFiles = subprogramResolveSetting(settings.subprograms.endBlock.files);
        writeln(endBlockFiles);
      } else {
        var endBlockEmbedded = subprogramResolveSetting(settings.subprograms.endBlock.embedded);
        writeln(endBlockEmbedded);
        writeln("");
        subprogramState.subprograms += getRedirectionBuffer();
      }
    }
    forceAny();
    subprogramState.newSubprogram = false;
    subprogramState.cycleSubprogramIsActive = false;
    if (subprogramState.saveShowSequenceNumbers != undefined) {
      setProperty("showSequenceNumbers", subprogramState.saveShowSequenceNumbers);
    }
    closeRedirection();
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

/**
 * Search defined pattern subprogram by the given id.
 * @param {number} subprogramId Subprogram Id
 * @returns {Object} Returns defined subprogram if found, otherwise returns undefined
 */
function getDefinedPatternSubprogram(subprogramId) {
  for (var i = 0; i < subprogramState.definedSubprograms.length; ++i) {
    if ((SUB_PATTERN == subprogramState.definedSubprograms[i].type) && (subprogramId == subprogramState.definedSubprograms[i].id)) {
      return subprogramState.definedSubprograms[i];
    }
  }
  return undefined;
}

/**
 * Search defined cycle subprogram pattern by the given id, initialPosition, finalPosition.
 * @param {number} subprogramId Subprogram Id
 * @param {Vector} initialPosition Initial position of the cycle
 * @param {Vector} finalPosition Final position of the cycle
 * @returns {Object} Returns defined subprogram if found, otherwise returns undefined
 */
function getDefinedCycleSubprogram(subprogramId, initialPosition, finalPosition) {
  for (var i = 0; i < subprogramState.definedSubprograms.length; ++i) {
    if ((SUB_CYCLE == subprogramState.definedSubprograms[i].type) && (subprogramId == subprogramState.definedSubprograms[i].id) &&
        !areSpatialVectorsDifferent(initialPosition, subprogramState.definedSubprograms[i].initialPosition) &&
        !areSpatialVectorsDifferent(finalPosition, subprogramState.definedSubprograms[i].finalPosition)) {
      return subprogramState.definedSubprograms[i];
    }
  }
  return undefined;
}

/**
 * Creates and returns new defined subprogram
 * @param {Section} section The section to create subprogram
 * @param {number} subprogramId Subprogram Id
 * @param {number} subprogramType Subprogram type, can be SUB_UNKNOWN, SUB_PATTERN or SUB_CYCLE
 * @param {Vector} initialPosition Initial position
 * @param {Vector} finalPosition Final position
 * @returns {Object} Returns new defined subprogram
 */
function defineNewSubprogram(section, subprogramId, subprogramType, initialPosition, finalPosition) {
  // determine if this is valid for creating a subprogram
  isValid = subprogramIsValid(section, subprogramId, subprogramType);
  var subprogram = isValid ? subprogram = ++subprogramState.lastSubprogram : undefined;
  subprogramState.definedSubprograms.push({
    type           : subprogramType,
    id             : subprogramId,
    subProgram     : subprogram,
    isValid        : isValid,
    initialPosition: initialPosition,
    finalPosition  : finalPosition
  });
  return subprogramState.definedSubprograms[subprogramState.definedSubprograms.length - 1];
}

/** Returns true if the given section is a pattern **/
function isPatternOperation(section) {
  return section.isPatterned && section.isPatterned();
}

/** Returns true if the given section is a cycle operation **/
function isCycleOperation(section, minimumCyclePoints) {
  return section.doesStrictCycle &&
  (section.getNumberOfCycles() == 1) && (section.getNumberOfCyclePoints() >= minimumCyclePoints);
}

/** Returns true if the subroutine bit flag is enabled **/
function isSubProgramEnabledFor(subroutine) {
  return subroutineBitmasks[getProperty("useSubroutines")] & subroutine;
}

/**
 * Define subprogram based on the property "useSubroutines"
 * @param {Vector} _initialPosition Initial position
 * @param {Vector} _abc Machine axis angles
 */
function subprogramDefine(_initialPosition, _abc) {
  if (isSubProgramEnabledFor(NONE)) {
    // Return early
    return;
  }

  if (subprogramState.lastSubprogram == undefined) { // initialize first subprogram number
    if (settings.subprograms.initialSubprogramNumber == undefined) {
      try {
        subprogramState.lastSubprogram = getAsInt(programName);
        subprogramState.mainProgramNumber = subprogramState.lastSubprogram; // mainProgramNumber must be a number
      } catch (e) {
        error(localize("Program name must be a number when using subprograms."));
        return;
      }
    } else {
      subprogramState.lastSubprogram = settings.subprograms.initialSubprogramNumber - 1;
      // if programName is a string set mainProgramNumber to undefined, if programName is a number set mainProgramNumber to programName
      subprogramState.mainProgramNumber = (!isNaN(programName) && !isNaN(parseInt(programName, 10))) ? getAsInt(programName) : undefined;
    }
  }

  // convert patterns into subprograms
  subprogramState.patternIsActive = false;
  if (isSubProgramEnabledFor(PATTERNS) && isPatternOperation(currentSection)) {
    var subprogramId = currentSection.getPatternId();
    var subprogramType = SUB_PATTERN;
    var subprogramDefinition = getDefinedPatternSubprogram(subprogramId);

    subprogramState.newSubprogram = !subprogramDefinition;
    if (subprogramState.newSubprogram) {
      subprogramDefinition = defineNewSubprogram(currentSection, subprogramId, subprogramType, _initialPosition, _initialPosition);
    }

    subprogramState.currentSubprogram = subprogramDefinition.subProgram;
    if (subprogramDefinition.isValid) {
      // make sure Z-position is output prior to subprogram call
      var z = zOutput.format(_initialPosition.z);
      if (!state.retractedZ && z) {
        validate(!validateLengthCompensation || state.lengthCompensationActive, "Tool length compensation is not active."); // make sure that length compensation is enabled
        var block = "";
        if (typeof gAbsIncModal != "undefined") {
          block += gAbsIncModal.format(90);
        }
        if (typeof gPlaneModal != "undefined") {
          block += gPlaneModal.format(17);
        }
        writeBlock(block);
        zOutput.reset();
        invokeOnRapid(xOutput.getCurrent(), yOutput.getCurrent(), _initialPosition.z);
      }

      // call subprogram
      subprogramCall();
      subprogramState.patternIsActive = true;

      if (subprogramState.newSubprogram) {
        subprogramStart(_initialPosition, _abc, subprogramState.incrementalSubprogram);
      } else {
        skipRemainingSection();
        setCurrentPosition(getFramePosition(currentSection.getFinalPosition()));
      }
    }
  }

  // Patterns are not used, check other cases
  if (!subprogramState.patternIsActive) {
    // Output cycle operation as subprogram
    if (isSubProgramEnabledFor(CYCLES) && isCycleOperation(currentSection, settings.subprograms.minimumCyclePoints)) {
      var finalPosition = getFramePosition(currentSection.getFinalPosition());
      var subprogramId = currentSection.getNumberOfCyclePoints();
      var subprogramType = SUB_CYCLE;
      var subprogramDefinition = getDefinedCycleSubprogram(subprogramId, _initialPosition, finalPosition);
      subprogramState.newSubprogram = !subprogramDefinition;
      if (subprogramState.newSubprogram) {
        subprogramDefinition = defineNewSubprogram(currentSection, subprogramId, subprogramType, _initialPosition, finalPosition);
      }
      subprogramState.currentSubprogram = subprogramDefinition.subProgram;
      subprogramState.cycleSubprogramIsActive = subprogramDefinition.isValid;
    }

    // Neither patterns and cycles are used, check other operations
    if (!subprogramState.cycleSubprogramIsActive && isSubProgramEnabledFor(ALLOPERATIONS)) {
      // Output all operations as subprograms
      subprogramState.currentSubprogram = ++subprogramState.lastSubprogram;
      if (subprogramState.mainProgramNumber != undefined && (subprogramState.currentSubprogram == subprogramState.mainProgramNumber)) {
        subprogramState.currentSubprogram = ++subprogramState.lastSubprogram; // avoid using main program number for current subprogram
      }
      subprogramCall();
      subprogramState.newSubprogram = true;
      subprogramStart(_initialPosition, _abc, false);
    }
  }
}

/**
 * Determine if this is valid for creating a subprogram
 * @param {Section} section The section to create subprogram
 * @param {number} subprogramId Subprogram Id
 * @param {number} subprogramType Subprogram type, can be SUB_UNKNOWN, SUB_PATTERN or SUB_CYCLE
 * @returns {boolean} If this is valid for creating a subprogram
 */
function subprogramIsValid(_section, subprogramId, subprogramType) {
  var sectionId = _section.getId();
  var numberOfSections = getNumberOfSections();
  var validSubprogram = subprogramType != SUB_CYCLE;

  var masterPosition = new Array();
  masterPosition[0] = getFramePosition(_section.getInitialPosition());
  masterPosition[1] = getFramePosition(_section.getFinalPosition());
  var tempBox = _section.getBoundingBox();
  var masterBox = new Array();
  masterBox[0] = getFramePosition(tempBox[0]);
  masterBox[1] = getFramePosition(tempBox[1]);

  var rotation = getRotation();
  var translation = getTranslation();
  subprogramState.incrementalSubprogram = undefined;

  for (var i = 0; i < numberOfSections; ++i) {
    var section = getSection(i);
    if (section.getId() != sectionId) {
      defineWorkPlane(section, false);

      // check for valid pattern
      if (subprogramType == SUB_PATTERN) {
        if (section.getPatternId() == subprogramId) {
          var patternPosition = new Array();
          patternPosition[0] = getFramePosition(section.getInitialPosition());
          patternPosition[1] = getFramePosition(section.getFinalPosition());
          tempBox = section.getBoundingBox();
          var patternBox = new Array();
          patternBox[0] = getFramePosition(tempBox[0]);
          patternBox[1] = getFramePosition(tempBox[1]);

          if (areSpatialBoxesSame(masterPosition, patternPosition) && areSpatialBoxesSame(masterBox, patternBox) && !section.isMultiAxis()) {
            subprogramState.incrementalSubprogram = subprogramState.incrementalSubprogram ? subprogramState.incrementalSubprogram : false;
          } else if (!areSpatialBoxesTranslated(masterPosition, patternPosition) || !areSpatialBoxesTranslated(masterBox, patternBox) || section.isMultiAxis() || isTCPSupportedByOperation(section)) {
            validSubprogram = false;
            break;
          } else {
            subprogramState.incrementalSubprogram = true;
          }
        }

      // check for valid cycle operation
      } else if (subprogramType == SUB_CYCLE) {
        if ((section.getNumberOfCyclePoints() == subprogramId) && (section.getNumberOfCycles() == 1)) {
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

/**
 * Sets xyz and abc output formats to incremental or absolute type
 * @param {boolean} incremental true: Sets incremental mode, false: Sets absolute mode
 * @param {Vector} xyz Linear axis values for formating
 * @param {Vector} abc Rotary axis values for formating
*/
function setAbsIncMode(incremental, xyz, abc) {
  var outputFormats = [xOutput, yOutput, zOutput, aOutput, bOutput, cOutput];
  for (var i = 0; i < outputFormats.length; ++i) {
    outputFormats[i].setType(incremental ? TYPE_INCREMENTAL : TYPE_ABSOLUTE);
    if (typeof incPrefix != "undefined" && typeof absPrefix != "undefined") {
      outputFormats[i].setPrefix(incremental ? incPrefix[i] : absPrefix[i]);
    }
    if (i <= 2) { // xyz
      outputFormats[i].setCurrent(xyz.getCoordinate(i));
    } else { // abc
      outputFormats[i].setCurrent(abc.getCoordinate(i - 3));
    }
  }
  subprogramState.incrementalMode = incremental;
  if (typeof gAbsIncModal != "undefined") {
    if (incremental) {
      forceModals(gAbsIncModal);
    }
    writeBlock(gAbsIncModal.format(incremental ? 91 : 90));
  }
}

function setCyclePosition(_position) {
  var _spindleAxis;
  if (typeof gPlaneModal != "undefined") {
    _spindleAxis = gPlaneModal.getCurrent() == 17 ? Z : (gPlaneModal.getCurrent() == 18 ? Y : X);
  } else {
    var _spindleDirection = machineConfiguration.getSpindleAxis().getAbsolute();
    _spindleAxis = isSameDirection(_spindleDirection, new Vector(0, 0, 1)) ? Z : isSameDirection(_spindleDirection, new Vector(0, 1, 0)) ? Y : X;
  }
  switch (_spindleAxis) {
  case Z:
    zOutput.format(_position);
    break;
  case Y:
    yOutput.format(_position);
    break;
  case X:
    xOutput.format(_position);
    break;
  }
}

/**
 * Place cycle operation in subprogram
 * @param {Vector} initialPosition Initial position
 * @param {Vector} abc Machine axis angles
 * @param {boolean} incremental If the subprogram needs to go incremental mode
 */
function handleCycleSubprogram(initialPosition, abc, incremental) {
  subprogramState.cycleSubprogramIsActive &= !(cycleExpanded || isProbeOperation());
  if (subprogramState.cycleSubprogramIsActive) {
    // call subprogram
    subprogramCall();
    subprogramStart(initialPosition, abc, incremental);
  }
}

function writeSubprograms() {
  if (subprogramState.subprograms.length > 0) {
    writeln("");
    write(subprogramState.subprograms);
  }
}
// <<<<< INCLUDED FROM include_files/subprograms.cpi

// >>>>> INCLUDED FROM include_files/onRapid_heidenhain.cpi
function onRapid(_x, _y, _z) {
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      error(localize("Radius compensation mode cannot be changed at rapid traversal."));
      return;
    }
    writeBlock("L", x, y, z, radiusCompensationTable.lookup(radiusCompensation), "FMAX");
    forceFeed();
  }
}
// <<<<< INCLUDED FROM include_files/onRapid_heidenhain.cpi
// >>>>> INCLUDED FROM include_files/onLinear_heidenhain.cpi
function onLinear(_x, _y, _z, feed) {
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var f = getFeed(feed);
  if (x || y || z) {
    pendingRadiusCompensation = -1;
    writeBlock("L", x, y, z, radiusCompensationTable.lookup(radiusCompensation), f);
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      forceFeed(); // force feed on next line
    } else {
      pendingRadiusCompensation = -1;
      writeBlock("L", radiusCompensationTable.lookup(radiusCompensation), f);
    }
  }
}
// <<<<< INCLUDED FROM include_files/onLinear_heidenhain.cpi
// >>>>> INCLUDED FROM include_files/onRapid5D_heidenhain.cpi
function onRapid5D(_x, _y, _z, _a, _b, _c) {
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation mode cannot be changed at rapid traversal."));
    return;
  }
  if (!currentSection.isOptimizedForMachine()) {
    forceXYZ();
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var a = currentSection.isOptimizedForMachine() ? aOutput.format(_a) : toolVectorOutputI.format(_a);
  var b = currentSection.isOptimizedForMachine() ? bOutput.format(_b) : toolVectorOutputJ.format(_b);
  var c = currentSection.isOptimizedForMachine() ? cOutput.format(_c) : toolVectorOutputK.format(_c);
  var motionMode = currentSection.isOptimizedForMachine() ? "L" : "LN";

  if (x || y || z || a || b || c) {
    writeBlock(motionMode, x, y, z, a, b, c, radiusCompensationTable.lookup(radiusCompensation), "FMAX");
    forceFeed();
  }
}
// <<<<< INCLUDED FROM include_files/onRapid5D_heidenhain.cpi
// >>>>> INCLUDED FROM include_files/onLinear5D_heidenhain.cpi
function onLinear5D(_x, _y, _z, _a, _b, _c, feed, feedMode) {
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for 5-axis move."));
    return;
  }
  if (!currentSection.isOptimizedForMachine()) {
    forceXYZ();
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var a = currentSection.isOptimizedForMachine() ? aOutput.format(_a) : toolVectorOutputI.format(_a);
  var b = currentSection.isOptimizedForMachine() ? bOutput.format(_b) : toolVectorOutputJ.format(_b);
  var c = currentSection.isOptimizedForMachine() ? cOutput.format(_c) : toolVectorOutputK.format(_c);
  var motionMode = currentSection.isOptimizedForMachine() ? "L" : "LN";
  var f = getFeed(feed);

  if (x || y || z || a || b || c) {
    writeBlock(motionMode, x, y, z, a, b, c, radiusCompensationTable.lookup(radiusCompensation), f);
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      forceFeed(); // force feed on next line
    } else {
      pendingRadiusCompensation = -1;
      writeBlock(motionMode, radiusCompensationTable.lookup(radiusCompensation), f);
    }
  }
}
// <<<<< INCLUDED FROM include_files/onLinear5D_heidenhain.cpi
// >>>>> INCLUDED FROM include_files/onCircular_heidenhain.cpi
function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
    return;
  }
  var start = getCurrentPosition();
  var motionCode = "CC";
  var sweep = (clockwise ? -1 : 1) * Math.abs(getCircularSweep());
  var dir = clockwise ? "DR-" : "DR+";
  var plane = getCircularPlane();

  if (plane == -1) {
    linearize(tolerance); // linearize if circular plane is not XY, ZX, or YZ
    return;
  }
  if (isHelical()) {
    if (plane != PLANE_XY) {
      linearize(tolerance);
      return;
    }
  }
  if (subprogramState.incrementalMode) {
    switch (plane) {
    case PLANE_XY:
      writeBlock(motionCode, "IX" + xyzFormat.format(cx - start.x), "IY" + xyzFormat.format(cy - start.y));
      break;
    case PLANE_ZX:
      writeBlock(motionCode, "IX" + xyzFormat.format(cx - start.x), "IZ" + xyzFormat.format(cz - start.z));
      break;
    case PLANE_YZ:
      writeBlock(motionCode, "IY" + xyzFormat.format(cy - start.y), "IZ" + xyzFormat.format(cz - start.z));
      break;
    }
  } else {
    switch (plane) {
    case PLANE_XY:
      writeBlock(motionCode, "X" + xyzFormat.format(cx), "Y" + xyzFormat.format(cy));
      break;
    case PLANE_ZX:
      writeBlock(motionCode, "X" + xyzFormat.format(cx), "Z" + xyzFormat.format(cz));
      break;
    case PLANE_YZ:
      writeBlock(motionCode, "Y" + xyzFormat.format(cy), "Z" + xyzFormat.format(cz));
      break;
    }
  }

  if (false && !isHelical() && (Math.abs(getCircularSweep()) <= 2 * Math.PI * 0.9)) { // use IPA to avoid radius compensation errors
    motionCode = "C";
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(motionCode, xOutput.format(x), yOutput.format(y), dir, radiusCompensationTable.lookup(radiusCompensation), getFeed(feed));
      break;
    case PLANE_ZX:
      writeBlock(motionCode, xOutput.format(x), zOutput.format(z), dir, radiusCompensationTable.lookup(radiusCompensation), getFeed(feed));
      break;
    case PLANE_YZ:
      writeBlock(motionCode, yOutput.format(y), zOutput.format(z), dir, radiusCompensationTable.lookup(radiusCompensation), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
    return;
  }

  if (isHelical()) {
    if (getCircularPlane() == PLANE_XY) {
      writeBlock("CP IPA" + paFormat.format(sweep), zOutput.format(z), dir, getFeed(feed));
      forceModals(xOutput, yOutput);
    }
  } else {
    // IPA must have same sign as DR
    writeBlock("CP IPA" + paFormat.format(sweep), dir, getFeed(feed));
    switch (getCircularPlane()) {
    case PLANE_XY:
      forceModals(xOutput, yOutput);
      break;
    case PLANE_ZX:
      forceModals(xOutput, zOutput);
      break;
    case PLANE_YZ:
      forceModals(yOutput, zOutput);
      break;
    default:
      forceXYZ();
    }
  }
  if (subprogramState.incrementalMode) {
    xOutput.format(x);
    yOutput.format(y);
    zOutput.format(z);
  }
}

// <<<<< INCLUDED FROM include_files/onCircular_heidenhain.cpi
// >>>>> INCLUDED FROM include_files/workPlaneFunctions_heidenhain.cpi
function getSEQ() {
  var preference = getProperty("preferredTilt");
  if (machineConfiguration.isMultiAxisConfiguration()) {
    var axis = new Array(machineConfiguration.getAxisU(), machineConfiguration.getAxisV(), machineConfiguration.getAxisW());
    for (var i = 0; i < axis.length; ++i) {
      if (axis[i].isEnabled() && !isSameDirection(axis[i].getAxis(), machineConfiguration.getSpindleAxis())) {
        // SEQ must be set based on calculated machine angles so that the machines tilt direction does match with the rotary axis values and machine simulation
        preference = abcFormat.getResultingValue(getCurrentABC().getCoordinate(axis[i].getCoordinate())) < 0 ? -1 : 1;
        break;
      }
    }
  }
  var SEQ = "";
  switch (preference) {
  case -1:
    SEQ = "SEQ-";
    break;
  case 0:
  case 1:
    SEQ = "SEQ+";
    break;
  default:
    error(localize("Invalid tilt preference."));
  }
  return SEQ;
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

function getTableRot() {
  if (machineConfiguration.isMultiAxisConfiguration() && (machineConfiguration.getAxisU().isTable() || machineConfiguration.getAxisV().isTable())) {
    return "TABLE ROT"; // force physical C-axis rotation
  }
  return "";
}

var currentWorkPlaneABC = undefined;
function forceWorkPlane() {
  currentWorkPlaneABC = undefined;
}

function setWorkPlane(abc) {
  if (!settings.workPlaneMethod.forceMultiAxisIndexing && is3D() && !machineConfiguration.isMultiAxisConfiguration()) {
    return; // ignore
  }
  var workplaneIsRequired = (currentWorkPlaneABC == undefined) ||
    abcFormat.areDifferent(abc.x, currentWorkPlaneABC.x) ||
    abcFormat.areDifferent(abc.y, currentWorkPlaneABC.y) ||
    abcFormat.areDifferent(abc.z, currentWorkPlaneABC.z);

  writeStartBlocks(workplaneIsRequired, function () {
    writeRetract(Z);
    if (getSetting("retract.homeXY.onIndexing", false)) {
      writeRetract(settings.retract.homeXY.onIndexing);
    }
    if (settings.workPlaneMethod.useTiltedWorkplane) {
      onCommand(COMMAND_UNLOCK_MULTI_AXIS);
      if (machineConfiguration.isMultiAxisConfiguration()) {
        var machineABC = abc.isNonZero() ? (currentSection.isMultiAxis() ? getCurrentDirection() : getWorkPlaneMachineABC(currentSection, false)) : abc;
        if ((settings.workPlaneMethod.useABCPrepositioning || machineABC.isZero())) {
          positionABC(machineABC, false);
        } else {
          setCurrentABC(machineABC);
        }
      }

      if (twpMethod == PLANE_SPATIAL) {
        var turn = !currentSection.isOptimizedForMachine() || !Vector.areDifferent(getCurrentToolAxis(), machineConfiguration.getSpindleAxis());
        var TURN_STAY = turn ? "TURN FMAX" : "STAY"; // alternatively slow down with F9999
        var sim = {a:turn ? getCurrentABC().x : undefined, b:turn ? getCurrentABC().y : undefined, c:turn ? getCurrentABC().z : undefined};
        if (abc.isNonZero()) {
          writeBlock("PLANE SPATIAL SPA" + abcFormat.format(abc.x), "SPB" + abcFormat.format(abc.y), "SPC" + abcFormat.format(abc.z),
            TURN_STAY, (turn ? formatWords(getSEQ(), getTableRot()) : ""));
        } else {
          writeBlock("PLANE RESET " + TURN_STAY);
        }
        state.twpIsActive = abc.isNonZero();
        machineSimulation({a:sim.a, b:sim.b, c:sim.c, coordinates:MACHINE, eulerAngles:abc.isNonZero() ? abc : undefined});
      } else if (twpMethod == CYCLE_19) {
        feedOutput.reset();
        var feed = MP7500Bit2 == 1 ? feedOutput.format(9999) : "";
        writeBlock("CYCL DEF 19.0 " + localize("WORKING PLANE"));
        if (settings.workPlaneMethod.eulerConvention == undefined) {
          writeBlock("CYCL DEF 19.1",
            conditional(machineConfiguration.isMachineCoordinate(0), "A" + abcFormat.format(abc.x % (Math.PI * 2))),
            conditional(machineConfiguration.isMachineCoordinate(1), "B" + abcFormat.format(abc.y % (Math.PI * 2))),
            conditional(machineConfiguration.isMachineCoordinate(2), "C" + abcFormat.format(abc.z % (Math.PI * 2))),
            feed);
        } else {
          writeBlock("CYCL DEF 19.1 A" + abcFormat.format(abc.x), "B" + abcFormat.format(abc.y), "C" + abcFormat.format(abc.z), feed);
        }

        if (machineConfiguration.isMultiAxisConfiguration()) { // when MP7500Bit2 is set to 1, the code below is optional
          writeBlock("L",
            conditional(machineConfiguration.isMachineCoordinate(0), "A+Q120"),
            conditional(machineConfiguration.isMachineCoordinate(1), "B+Q121"),
            conditional(machineConfiguration.isMachineCoordinate(2), "C+Q122"),
            "R0 FMAX");
        }
        state.twpIsActive = abc.isNonZero();
        machineSimulation({a:getCurrentABC().x, b:getCurrentABC().y, c:getCurrentABC().z, coordinates:MACHINE, eulerAngles:settings.workPlaneMethod.eulerConvention != undefined ? abc : undefined});
      }
    } else {
      positionABC(abc, true);
    }
    if (!currentSection.isMultiAxis()) {
      onCommand(COMMAND_LOCK_MULTI_AXIS);
    }
    currentWorkPlaneABC = abc;
  });
}

function cancelWorkPlane(force) {
  if (!settings.workPlaneMethod.forceMultiAxisIndexing && is3D() && !force) {
    return; // ignore
  }
  if (state.twpIsActive || force) {
    if (twpMethod == PLANE_SPATIAL) {
      writeBlock("PLANE RESET STAY");
    } else if (twpMethod == CYCLE_19) {
      if (MP7500Bit2 == 1) { // when CYCLE19 is set to position the rotaries we must retract before CYCLE19
        writeRetract(Z);
        if (getSetting("retract.homeXY.onIndexing", false)) {
          writeRetract(settings.retract.homeXY.onIndexing);
        }
      }
      feedOutput.reset();
      var feed = MP7500Bit2 == 1 ? feedOutput.format(9999) : "";
      writeBlock("CYCL DEF 19.0 " + localize("WORKING PLANE"));
      if (settings.workPlaneMethod.eulerConvention == undefined) {
        writeBlock("CYCL DEF 19.1",
          conditional(machineConfiguration.isMachineCoordinate(0), "A" + abcFormat.format(0)),
          conditional(machineConfiguration.isMachineCoordinate(1), "B" + abcFormat.format(0)),
          conditional(machineConfiguration.isMachineCoordinate(2), "C" + abcFormat.format(0)),
          feed, formatComment("RESET")
        );
      } else {
        writeBlock("CYCL DEF 19.1 A" + abcFormat.format(0), "B" + abcFormat.format(0), "C" + abcFormat.format(0), feed, formatComment("RESET"));
      }
    } else {
      // specify code here in case getProperty("usePlane") = "none" if needed
    }
    state.twpIsActive = false;
    machineSimulation({}); // update machine simulation TWP state
    forceWorkPlane();
  }
}
// <<<<< INCLUDED FROM include_files/workPlaneFunctions_heidenhain.cpi
// >>>>> INCLUDED FROM include_files/writeRetract_heidenhain.cpi
function writeRetract() {
  var retract = getRetractParameters.apply(this, arguments);
  if (retract && retract.words.length > 0) {
    setTCP(false); // TCP must be canceled prior to retracting
    if (retract.retractAxes[2] && getProperty("useM140", false)) {
      validate((arguments.length <= 1), "Z-axis retracts must be specified separately when property 'useM140' is enabled.");
      writeBlock("L", mFormat.format(140), "MB MAX");
      machineSimulation({mode:RETRACTTOOLAXIS});
      return;
    }
    for (var i in retract.words) {
      var words = retract.singleLine ? retract.words : retract.words[i];
      switch (retract.method) {
      case "M91":
      case "M92":
        writeBlock("L", words, "R0 FMAX", mFormat.format(retract.method == "M92" ? 92 : 91));
        break;
      default:
        if (typeof writeRetractCustom == "function") {
          writeRetractCustom(retract);
          return;
        } else {
          error(subst(localize("Unsupported safe position method '%1'"), retract.method));
        }
      }
      machineSimulation({
        x          : retract.singleLine || words.indexOf("X") != -1 ? retract.positions.x : undefined,
        y          : retract.singleLine || words.indexOf("Y") != -1 ? retract.positions.y : undefined,
        z          : retract.singleLine || words.indexOf("Z") != -1 ? retract.positions.z : undefined,
        coordinates: MACHINE
      });
      if (retract.singleLine) {
        break;
      }
    }
  }
}
// <<<<< INCLUDED FROM include_files/writeRetract_heidenhain.cpi
// >>>>> INCLUDED FROM include_files/positionABC_heidenhain.cpi
function positionABC(abc, force) {
  if (!machineConfiguration.isMultiAxisConfiguration()) {
    error("Function 'positionABC' can only be used with multi-axis machine configurations.");
  }
  if (typeof unwindABC == "function") {
    unwindABC(abc);
  }
  if (force) {
    forceABC();
  }
  var a = aOutput.format(abc.x);
  var b = bOutput.format(abc.y);
  var c = cOutput.format(abc.z);
  if (a || b || c) {
    writeRetract(Z);
    if (getSetting("retract.homeXY.onIndexing", false)) {
      writeRetract(settings.retract.homeXY.onIndexing);
    }
    onCommand(COMMAND_UNLOCK_MULTI_AXIS);
    writeBlock("L", a, b, c, "R0 FMAX", mFormat.format(94));
    setCurrentABC(abc); // required for machine simulation
    machineSimulation({a:abc.x, b:abc.y, c:abc.z, coordinates:MACHINE});
  }
}
// <<<<< INCLUDED FROM include_files/positionABC_heidenhain.cpi
// >>>>> INCLUDED FROM include_files/writeWCS_heidenhain.cpi
var workOffsetLabels = {};
var nextLabel = 1;
function writeWCS() {
  if (currentSection.workOffset != currentWorkOffset) {
    if (currentSection.workOffset <= 9999) {
      if (useCycl247) {
        var workOffsetLabel = workOffsetLabels[currentSection.workOffset];
        if (workOffsetLabel) {
          writeBlock("CALL LBL", workOffsetLabel, ";DATUM");
        } else {
          workOffsetLabels[currentSection.workOffset] = nextLabel;
          writeBlock("LBL", nextLabel++);
          writeBlock(
            "CYCL DEF 247", localize("DATUM SETTING"), "~" + EOL,
            " Q339=" + currentSection.workOffset, ";", localize("DATUM NUMBER")
          );
          writeBlock("LBL 0");
        }
      }
      if (useCycl7) {
        writeBlock("CYCL DEF 7.0", localize("DATUM SHIFT"));
        writeBlock("CYCL DEF 7.1 #" + currentSection.workOffset);
      }
    } else {
      error(localize("Work offset out of range."));
    }
    currentWorkOffset = currentSection.workOffset;
  }
}
// <<<<< INCLUDED FROM include_files/writeWCS_heidenhain.cpi
// >>>>> INCLUDED FROM include_files/initialPositioning_heidenhain.cpi
/**
 * Writes the initial positioning procedure for a section to get to the start position of the toolpath.
 * @param {Vector} position The initial position to move to
 * @param {boolean} isRequired true: Output full positioning, false: Output full positioning in optional state or output simple positioning only
 * @param {String} codes1 Allows to add additional code to the first positioning line
 * @param {String} codes2 Allows to add additional code to the second positioning line (if applicable)
 * @example
  var myVar1 = formatWords("T" + tool.number, currentSection.wcs);
  var myVar2 = getCoolantCodes(tool.coolant);
  writeInitialPositioning(initialPosition, isRequired, myVar1, myVar2);
*/
function writeInitialPositioning(position, isRequired, codes1, codes2) {
  var feed = (highFeedMapping != HIGH_FEED_NO_MAPPING) ? formatWords("R0", getFeed(highFeedrate)) : "";
  var feedCode = {single:"R0 FMAX", multi:"R0 FMAX"};
  switch (highFeedMapping) {
  case HIGH_FEED_MAP_ANY:
    feedCode = {single:feed, multi:feed}; // map all rapid traversals to high feed
    break;
  case HIGH_FEED_MAP_MULTI:
    feedCode = {single:feedCode.single, multi:feed}; // map rapid traversal along more than one axis to high feed
    break;
  }
  var additionalCodes = [formatWords(codes1), formatWords(codes2)];
  var simPosition = position;

  writeStartBlocks(isRequired, function() {
    setTCP(false);
    if (machineConfiguration.isHeadConfiguration()) { // head/head head/table kinematics
      var machineABC = currentSection.isMultiAxis() ? defineWorkPlane(currentSection, false) : getWorkPlaneMachineABC(currentSection, false);
      machineConfiguration.setToolLength(getSetting("workPlaneMethod.compensateToolLength", false) ? getBodyLength(currentSection.getTool()) : 0); // define the tool length for head adjustments
      var mode = currentSection.isOptimizedForMachine() ? TCP_XYZ_OPTIMIZED : TCP_XYZ;
      var globalPosition = getGlobalPosition(currentSection.getInitialPosition());
      var machinePosition = machineConfiguration.getOptimizedPosition(globalPosition, machineABC, mode, OPTIMIZE_BOTH, true);

      cancelWorkPlane();
      positionABC(machineABC);
      var datumShiftPosition;
      if (currentSection.isOptimizedForMachine()) {
        datumShiftPosition = position;
      } else if (settings.workPlaneMethod.useTiltedWorkplane) {
        datumShiftPosition = currentSection.isMultiAxis() ? position : (tcp.isSupportedByMachine ? globalPosition : machinePosition);
      } else {
        datumShiftPosition = currentSection.isMultiAxis() ? position : globalPosition;
      }
      simPosition = datumShiftPosition; // use the datum shift position for simulation
      setDatumShift(datumShiftPosition);
      if (tcp.isSupportedByMachine) {
        setTCP(true); // force TCP for prepositioning although the operation may not require it
      }
      writeBlock("L", xOutput.format(0), yOutput.format(0), feedCode.multi, additionalCodes[0]);
      machineSimulation({x:simPosition.x, y:simPosition.y});
      writeBlock("L", zOutput.format(0), feedCode.single, additionalCodes[1]);
      machineSimulation({z:simPosition.z});
      setDatumShift(new Vector(0, 0, 0));
      setTCP(tcp.isSupportedByOperation); // enable/disable TCP depending if it is supported by the operation

      if (!currentSection.isMultiAxis()) {
        var saveRetractedState = [state.retractedX, state.retractedY, state.retractedZ];
        state.retractedX = state.retractedY = state.retractedZ = true; // set retracted states to true to avoid retraction
        defineWorkPlane(currentSection, true);
        [state.retractedX, state.retractedY, state.retractedZ] = saveRetractedState; // restore retracted states
      }
    } else { // table/table kinematics
      // multi axis prepositioning with TWP
      if (currentSection.isMultiAxis() && getSetting("workPlaneMethod.prepositionWithTWP", true) && getSetting("workPlaneMethod.useTiltedWorkplane", false) &&
        tcp.isSupportedByOperation && getCurrentDirection().isNonZero()) {
        var saveWorkplaneSettings = {twpMethod:twpMethod, eulerConvention:settings.workPlaneMethod.eulerConvention};
        if (twpMethod == CYCLE_19) {
          writeComment("TWP temporarily set to PLANE SPATIAL for safe prepositioning");
          twpMethod = PLANE_SPATIAL; // set TWP method to PLANE_SPATIAL for safe prepositioning for multi axis operations
          settings.workPlaneMethod.eulerConvention = EULER_XYZ_S;
        }
        var W = machineConfiguration.isMultiAxisConfiguration() ? machineConfiguration.getOrientation(getCurrentDirection()) :
          Matrix.getOrientationFromDirection(getCurrentDirection());
        var angles = W.getEuler2(settings.workPlaneMethod.eulerConvention);
        simPosition = W.getTransposed().multiply(position); // use the rotated position for simulation

        setDatumShift(position);
        setWorkPlane(angles);
        writeBlock("L", xOutput.format(0), yOutput.format(0), feedCode.multi, additionalCodes[0]);
        machineSimulation({x:simPosition.x, y:simPosition.y});
        writeBlock("L", zOutput.format(0), feedCode.single, additionalCodes[1]);
        machineSimulation({z:simPosition.z});
        setDatumShift(new Vector(0, 0, 0));
        cancelWorkPlane(); // cancel TWP for multi axis operations
        setTCP(tcp.isSupportedByOperation);
        forceXYZ();

        twpMethod = saveWorkplaneSettings.twpMethod; // restore TWP method
        settings.workPlaneMethod.eulerConvention = saveWorkplaneSettings.eulerConvention; // restore euler convention
      } else {
        setTCP(tcp.isSupportedByOperation);
        writeBlock("L", xOutput.format(position.x), yOutput.format(position.y), feedCode.multi, additionalCodes[0]);
        machineSimulation({x:simPosition.x, y:simPosition.y});
        writeBlock("L", zOutput.format(position.z), feedCode.single, additionalCodes[1]);
        machineSimulation(tcp.isSupportedByOperation ? {x:simPosition.x, y:simPosition.y, z:simPosition.z} : {z:simPosition.z});
      }
    }
    if (isRequired) {
      additionalCodes = []; // clear additionalCodes buffer
    }
  });

  if (!isRequired) { // simple positioning
    forceXYZ();
    if (!state.retractedZ && xyzFormat.getResultingValue(getCurrentPosition().z) < xyzFormat.getResultingValue(position.z)) {
      writeBlock("L", zOutput.format(position.z), feedCode.single);
      machineSimulation({z:simPosition.z});
    }
    radiusCompensationTable.reset();
    writeBlock("L", xOutput.format(position.x), yOutput.format(position.y), feedCode.multi, additionalCodes);
    machineSimulation({x:simPosition.x, y:simPosition.y});
  }
  if (!state.tcpIsActive && isTCPSupportedByOperation(currentSection)) {
    error(localize("Internal error, TCP is required but was not output by the postprocessor."));
  }
}

Matrix.getOrientationFromDirection = function (ijk) {
  var forward = ijk;
  var unitZ = new Vector(0, 0, 1);
  var W;
  if (Math.abs(Vector.dot(forward, unitZ)) < 0.5) {
    var imX = Vector.cross(forward, unitZ).getNormalized();
    W = new Matrix(imX, Vector.cross(forward, imX), forward);
  } else {
    var imX = Vector.cross(new Vector(0, 1, 0), forward).getNormalized();
    W = new Matrix(imX, Vector.cross(forward, imX), forward);
  }
  return W;
};

function setDatumShift(position) {
  writeBlock("CYCL DEF 7.0 " + localize("DATUM SHIFT"));
  writeBlock("CYCL DEF 7.1 X" + xyzFormat.format(position.x));
  writeBlock("CYCL DEF 7.2 Y" + xyzFormat.format(position.y));
  writeBlock("CYCL DEF 7.3 Z" + xyzFormat.format(position.z));
  forceXYZ();
}
// <<<<< INCLUDED FROM include_files/initialPositioning_heidenhain.cpi
// >>>>> INCLUDED FROM include_files/rewind.cpi
function onMoveToSafeRetractPosition() {
  if (!getSetting("allowCancelTCPBeforeRetracting", false)) {
    writeRetract(Z);
  }
  if (state.tcpIsActive) { // cancel TCP so that tool doesn't follow rotaries
    if (typeof setTCP == "function") {
      setTCP(false);
    } else {
      disableLengthCompensation(false);
    }
  }
  writeRetract(Z);
  if (getSetting("retract.homeXY.onIndexing", false)) {
    writeRetract(settings.retract.homeXY.onIndexing);
  }
}

/** Rotate axes to new position above reentry position */
function onRotateAxes(_x, _y, _z, _a, _b, _c) {
  // position rotary axes
  xOutput.disable();
  yOutput.disable();
  zOutput.disable();
  if (typeof unwindABC == "function") {
    unwindABC(new Vector(_a, _b, _c), false);
  }
  onRapid5D(_x, _y, _z, _a, _b, _c);
  setCurrentABC(new Vector(_a, _b, _c));
  machineSimulation({a:_a, b:_b, c:_c, coordinates:MACHINE});
  xOutput.enable();
  yOutput.enable();
  zOutput.enable();
  forceXYZ();
}

/** Return from safe position after indexing rotaries. */
function onReturnFromSafeRetractPosition(_x, _y, _z) {
  if (!machineConfiguration.isHeadConfiguration()) {
    writeInitialPositioning(new Vector(_x, _y, _z), true);
    if (highFeedMapping != HIGH_FEED_NO_MAPPING) {
      onLinear5D(_x, _y, _z, getCurrentDirection().x, getCurrentDirection().y, getCurrentDirection().z, highFeedrate);
    } else {
      onRapid5D(_x, _y, _z, getCurrentDirection().x, getCurrentDirection().y, getCurrentDirection().z);
    }
    machineSimulation({x:_x, y:_y, z:_z, a:getCurrentDirection().x, b:getCurrentDirection().y, c:getCurrentDirection().z});
  } else {
    if (tcp.isSupportedByOperation) {
      if (typeof setTCP == "function") {
        setTCP(true);
      } else {
        writeBlock(getOffsetCode(), hFormat.format(tool.lengthOffset));
      }
    }
    forceXYZ();
    xOutput.reset();
    yOutput.reset();
    zOutput.disable();
    if (highFeedMapping != HIGH_FEED_NO_MAPPING) {
      onLinear(_x, _y, _z, highFeedrate);
    } else {
      onRapid(_x, _y, _z);
    }
    machineSimulation({x:_x, y:_y});
    zOutput.enable();
    invokeOnRapid(_x, _y, _z);
  }
}
// <<<<< INCLUDED FROM include_files/rewind.cpi
// >>>>> INCLUDED FROM include_files/drillCycles_heidenhain.cpi
var EOL_ = " ~" + EOL + "  ";
var expandCurrentCycle = false;
function writeDrillCycle(cycle, x, y, z) {
  if (!isSameDirection(machineConfiguration.getSpindleAxis(), getForwardDirection(currentSection))) {
    expandCyclePoint(x, y, z);
    return;
  }
  if (isFirstCyclePoint()) {
    expandCurrentCycle = false; // reset

    if (cycle.clearance != undefined) {
      if (xyzFormat.getResultingValue(getCurrentPosition().z) < xyzFormat.getResultingValue(cycle.clearance)) {
        writeBlock("L", zOutput.format(cycle.clearance), radiusCompensationTable.lookup(radiusCompensation), "FMAX");
        setCurrentPositionZ(cycle.clearance);
      }
    }
    var Q200 = formatQword("Q200", xyzFormat.format(cycle.retract - cycle.stock), "SET-UP CLEARANCE");
    var Q201 = formatQword("Q201", xyzFormat.format(-cycle.depth), "DEPTH");
    var Q202 = formatQword("Q202", xyzFormat.format(cycle.depth), "INFEED DEPTH");
    var Q203 = formatQword("Q203", xyzFormat.format(cycle.stock), "SURFACE COORDINATE");
    var Q204 = formatQword("Q204", xyzFormat.format(cycle.clearance - cycle.stock), "2ND SET-UP CLEARANCE");
    var Q205 = formatQword("Q205", xyzFormat.format(cycle.minimumIncrementalDepth), "MIN. PLUNGING DEPTH");
    var Q206 = formatQword("Q206", feedFormat.format(cycle.feedrate), "FEED RATE FOR PLUNGING");
    var Q207 = formatQword("Q207", feedFormat.format(cycle.feedrate), "FEED RATE FOR MILLING");
    var Q208 = formatQword("Q208", "MAX", "RETRACTION FEED RATE");
    var Q210 = formatQword("Q210", secFormat.format(0), "DWELL AT TOP");
    var Q211 = formatQword("Q211", secFormat.format(cycle.dwell), "DWELL AT BOTTOM");
    var Q212 = formatQword("Q212", xyzFormat.format(cycle.incrementalDepthReduction), "DECREMENT");

    switch (cycleType) {
    case "drilling":// G81 style
    case "counter-boring":
      writeBlock(["CYCL DEF 200 " + localize("DRILLING"), Q200, Q201, Q206, Q202, Q210, Q203, Q204, Q211].join(EOL_));
      break;
    case "chip-breaking":
      Q202 = formatQword("Q202", xyzFormat.format(cycle.incrementalDepth), "INFEED DEPTH");
      var Q213 = formatQword("Q213", cycle.plungesPerRetract, "BREAKS");
      var Q256 = formatQword("Q256", xyzFormat.format((cycle.chipBreakDistance != undefined) ? cycle.chipBreakDistance : machineParameters.chipBreakingDistance), "DIST. FOR CHIP BRKNG");

      writeBlock(["CYCL DEF 203 " + localize("UNIVERSAL DRILLING"), Q200, Q201, Q206, Q202, Q210, Q203, Q204, Q212, Q213, Q205, Q211, Q208, Q256].join(EOL_));
      break;
    case "deep-drilling":
      Q202 = formatQword("Q202", xyzFormat.format(cycle.incrementalDepth), "INFEED DEPTH");
      var Q258 = formatQword("Q258", xyzFormat.format(0.5), "UPPER ADV. STOP DIST.");
      var Q259 = formatQword("Q259", xyzFormat.format(1), "LOWER ADV. STOP DIST.");
      var Q257 = formatQword("Q257", xyzFormat.format(5), "DEPTH FOR CHIP BRKNG");
      var Q256 = formatQword("Q256", xyzFormat.format((cycle.chipBreakDistance != undefined) ? cycle.chipBreakDistance : machineParameters.chipBreakingDistance), "DIST. FOR CHIP BRKNG");
      var Q379 = formatQword("Q379", "0", "STARTING POINT");

      if (useCycl205) {
        writeBlock(["CYCL DEF 205 " + localize("UNIVERSAL PECKING"), Q200, Q201, Q206, Q202, Q203, Q204, Q212, Q205, Q258, Q259, Q257, Q256, Q211, Q379].join(EOL_));
      } else {
        writeBlock(["CYCL DEF 200 " + localize("DRILLING"), Q200, Q201, Q206, Q202, Q210, Q203, Q204, Q211].join(EOL_));
      }
      break;
    case "gun-drilling":
      var coolantCode = getCoolantCode(tool.coolant);
      var Q379 = formatQword("Q379", xyzFormat.format(cycle.startingDepth), "STARTING POINT");
      var Q253 = formatQword("Q253", feedFormat.format(cycle.positioningFeedrate), "F PRE-POSITIONING");
      Q208 = formatQword("Q208", feedFormat.format(cycle.retractFeedrate), "RETRACT FEED RATE");
      var Q426 = formatQword("Q426", cycle.stopSpindle ? 5 : (tool.clockwise ? 3 : 4), "DIR. OF SPINDLE ROT.");
      var Q427 = formatQword("Q427", rpmFormat.format(cycle.positioningSpindleSpeed ? cycle.positioningSpindleSpeed : tool.spindleRPM), "ENTRY EXIT SPEED");
      var Q428 = formatQword("Q428", rpmFormat.format(tool.spindleRPM), "DRILLING SPEED");
      var Q429 = formatQword("Q429", coolantCode ? coolantCode[1] : 0, "COOLANT ON");
      var Q430 = formatQword("Q430", coolantCode ? coolantCode[0] : 0, "COOLANT OFF");
      var Q435 = formatQword("Q435", xyzFormat.format(cycle.dwellDepth ? (cycle.depth + cycle.dwellDepth) : 0), "DWELL DEPTH");

      writeBlock(["CYCL DEF 241 " + localize("SINGLE-FLUTED DEEP-HOLE DRILLING"), Q200, Q201, Q206, Q211,
        Q203, Q204, Q379, Q253, Q208, Q426, Q427, Q428, Q429, Q430, Q435].join(EOL_));
      break;
    case "tapping":
    case "left-tapping":
    case "right-tapping":
      var Q239 = formatQword("Q239", pitchFormat.format((tool.type == TOOL_TAP_LEFT_HAND ? -1 : 1) * tool.threadPitch), "THREAD PITCH");

      writeBlock(["CYCL DEF 207 " + localize("RIGID TAPPING NEW"), Q200, Q201, Q239, Q203, Q204].join(EOL_));
      break;
    case "tapping-with-chip-breaking":
    case "left-tapping-with-chip-breaking":
    case "right-tapping-with-chip-breaking":
      var Q239 = formatQword("Q239", pitchFormat.format((tool.type == TOOL_TAP_LEFT_HAND ? -1 : 1) * tool.threadPitch), "THREAD PITCH");
      var Q257 = formatQword("Q257", xyzFormat.format(cycle.incrementalDepth), "DEPTH FOR CHIP BRKNG");
      var Q256 = formatQword("Q256", xyzFormat.format((cycle.chipBreakDistance != undefined) ? cycle.chipBreakDistance : machineParameters.chipBreakingDistance), "DIST. FOR CHIP BRKNG");
      var Q336 = formatQword("Q336", angleFormat.format(0), "ANGLE OF SPINDLE");

      writeBlock(["CYCL DEF 209 " + localize("TAPPING W/ CHIP BRKG"), Q200, Q201, Q239, Q203, Q204, Q257, Q256, Q336].join(EOL_));
      break;
    case "reaming":
      Q208 = formatQword("Q208", feedFormat.format(cycle.retractFeedrate), "RETRACTION FEED RATE");

      writeBlock(["CYCL DEF 201 " + localize("REAMING"), Q200, Q201, Q206, Q211, Q208, Q203, Q204].join(EOL_));
      break;
    case "stop-boring":
    case "fine-boring":
      var Q214 = formatQword("Q214", cycleType == "stop-boring" ? 0 : getDisengagementDirection(cycle.shiftDirection), "DISENGAGING DIRECTION");
      var Q336 = formatQword("Q336", angleFormat.format(cycle.compensatedShiftOrientation), "ANGLE OF SPINDLE");

      writeBlock(["CYCL DEF 202 " + localize("BORING"), Q200, Q201, Q206, Q211, Q208, Q203, Q204, Q214, Q336].join(EOL_));
      break;
    case "back-boring":
      var Q249 = formatQword("Q249", xyzFormat.format(cycle.backBoreDistance), "DEPTH REDUCTION");
      var Q250 = formatQword("Q250", xyzFormat.format(cycle.depth), "MATERIAL THICKNESS");
      var Q251 = formatQword("Q251", xyzFormat.format(cycle.shift), "OFF-CENTER DISTANCE");
      var Q252 = formatQword("Q252", xyzFormat.format(0), "TOOL EDGE HEIGHT");
      var Q253 = formatQword("Q253", "MAX", "F PRE-POSITIONING");
      var Q254 = formatQword("Q254", feedFormat.format(cycle.feedrate), "F COUNTERBORING");
      var Q255 = formatQword("Q255", secFormat.format(cycle.dwell), "DWELL AT BOTTOM");
      var Q214 = formatQword("Q214", getDisengagementDirection(cycle.shiftDirection), "DISENGAGING DIRECTION");
      var Q336 = formatQword("Q336", angleFormat.format(cycle.compensatedShiftOrientation), "ANGLE OF SPINDLE");

      writeBlock(["CYCL DEF 204 " + localize("BACK BORING"), Q200, Q249, Q250, Q251, Q252, Q253, Q254, Q255, Q203, Q204, Q214, Q336].join(EOL_));
      break;
    case "boring":
      var Q214 = formatQword("Q214", 0, "DISENGAGING DIRECTION");
      var Q336 = formatQword("Q336", angleFormat.format(cycle.compensatedShiftOrientation), "ANGLE OF SPINDLE");
      Q208 = formatQword("Q208", feedFormat.format(cycle.retractFeedrate), "RETRACTION FEED RATE");

      writeBlock(["CYCL DEF 202 " + localize("BORING"), Q200, Q201, Q206, Q211, Q208, Q203, Q204, Q214, Q336].join(EOL_));
      break;
    case "bore-milling":
      var Q334 = formatQword("Q334", pitchFormat.format(cycle.pitch), "PITCH");
      var Q335 = formatQword("Q335", xyzFormat.format(cycle.diameter), "NOMINAL DIAMETER");
      var Q342 = formatQword("Q342", xyzFormat.format(tool.diameter), "ROUGHING DIAMETER");

      if ((cycle.numberOfSteps != undefined && cycle.numberOfSteps > 1) ||
        (cycle.repeatPass != undefined && cycle.repeatPass > 0)) {
        expandCurrentCycle = true;
      } else {
        writeBlock(["CYCL DEF 208 " + localize("BORE MILLING"), Q200, Q201, Q206, Q334, Q203, Q204, Q335, Q342].join(EOL_));
      }
      break;
    case "thread-milling":
      if (cycle.numberOfSteps != undefined && cycle.numberOfSteps > 1) {
        expandCurrentCycle = true;
      } else {
        var Q335 = formatQword("Q335", xyzFormat.format(cycle.diameter), "NOMINAL DIAMETER");
        Q201 = formatQword("Q201", xyzFormat.format(-cycle.depth), "THREAD DEPTH");
        Q206 = formatQword("Q206", feedFormat.format(cycle.plungeFeedrate), "FEED RATE FOR PLUNGING");
        var Q239 = formatQword("Q239", pitchFormat.format(cycle.pitch), "PITCH");
        var Q355 = formatQword("Q355", xyzFormat.format(1), "THREADS PER STEP"); // defalut to 1
        var Q253 = formatQword("Q253", feedFormat.format(cycle.feedrate), "F PRE-POSITIONING");
        var Q351 = formatQword("Q351", xyzFormat.format(cycle.direction == "climb" ? 1 : -1), "CLIMB OR UP-CUT");

        writeBlock(["CYCL DEF 262 " + localize("THREAD MILLING"), Q335, Q239, Q201, Q355, Q253, Q351, Q200, Q203, Q204, Q207].join(EOL_));
        if (cycle.repeatPass != undefined && cycle.repeatPass > 0) {
          writeBlock("L", xOutput.format(x), yOutput.format(y), "FMAX", mFormat.format(99));
          writeBlock(["CYCL DEF 262 " + localize("THREAD MILLING"), Q335, Q239, Q201, Q355, Q253, Q351, Q200, Q203, Q204, Q207].join(EOL_));
        }
      }
      break;
    case "circular-pocket-milling":
      if (tool.taperAngle > 0) {
        error(localize("Circular pocket milling is not supported for taper tools."));
      }
      if (cycle.repeatPass != undefined && cycle.repeatPass > 0) {
        expandCurrentCycle = true;
      } else {
        Q202 = formatQword("Q202", xyzFormat.format(cycle.incrementalDepth), "INFEED DEPTH");
        Q206 = formatQword("Q206", feedFormat.format(cycle.plungeFeedrate), "FEED RATE FOR PLUNGING");
        var Q215 = formatQword("Q215", "1", "MACHINE OPERATION");
        var Q223 = formatQword("Q223", xyzFormat.format(cycle.diameter), "CIRCLE DIAMETER");
        var Q368 = formatQword("Q368", xyzFormat.format(0), "FINISHING ALLOWANCE FOR SIDE");
        var Q351 = formatQword("Q351", xyzFormat.format(cycle.direction == "climb" ? 1 : -1), "CLIMB OR UP-CUT");
        var Q369 = formatQword("Q369", xyzFormat.format(0), "FINISHING ALLOWANCE FOR FLOOR");
        var Q338 = formatQword("Q338", "0", "INFEED FOR FINISHING");
        var Q370 = formatQword("Q370", ratioFormat.format(cycle.stepover / (tool.diameter / 2)), "TOOL PATH OVERLAP");
        var Q366 = formatQword("Q366", "0", "PLUNGING");
        var Q385 = formatQword("Q385", feedFormat.format(cycle.feedrate), "FEED RATE FOR FINISHING");

        writeBlock(["CYCL DEF 252 " + localize("CIRCULAR POCKET"), Q215, Q223, Q368, Q207, Q351, Q201, Q202, Q369, Q206, Q338, Q200, Q203, Q204, Q370, Q366, Q385].join(EOL_));
      }
      break;
    default:
      expandCurrentCycle = true;
    }
    if (subprogramsAreSupported()) {
      // place cycle operation in subprogram
      handleCycleSubprogram(new Vector(x, y, z), new Vector(0, 0, 0), false);
      if (subprogramState.incrementalMode) { // set current position to clearance height
        setCyclePosition(cycle.clearance);
      }
    }
  }
  if (cycleExpanded || expandCurrentCycle) {
    if (expandCurrentCycle) {
      if (isTappingCycle()) {
        error(localize("Tapping cycle cannot be expanded."));
      }
      expandCyclePoint(x, y, z);
      return;
    } else {
      cycleNotSupported();
    }
  } else {
    if (subprogramsAreSupported() && subprogramState.incrementalMode) { // set current position to retract height
      setCyclePosition(cycle.retract);
    }
    if (isPolarModeActive() || ((currentSection.getPolarMode && currentSection.getPolarMode() != POLAR_MODE_OFF) && currentSection.isMultiAxis())) {
      var polarPosition = getPolarPosition(x, y, z);
      setCurrentPositionAndDirection(polarPosition);
      writeBlock("L", xOutput.format(polarPosition.first.x), yOutput.format(polarPosition.first.y),
        aOutput.format(polarPosition.second.x), bOutput.format(polarPosition.second.y), cOutput.format(polarPosition.second.z), "FMAX", mFormat.format(99));
    } else {
      writeBlock("L", xOutput.format(x), yOutput.format(y), "FMAX", mFormat.format(99));
    }
    if (subprogramsAreSupported() && subprogramState.incrementalMode) { // set current position to clearance height
      setCyclePosition(cycle.clearance);
    }
  }
}

function formatQword(qword, value, comment) {
  return formatWords(qword + "=" + value, formatComment(localize(comment)));
}

/** Used for gun drilling. */
function getCoolantCode(coolant) {
  forceCoolant = true;
  return [getCoolantCodes(COOLANT_OFF, false), getCoolantCodes(coolant, false)];
}

/** Returns the best discrete disengagement direction for the specified direction. */
function getDisengagementDirection(direction) {
  var quadrant = getQuadrant(direction + 45 * Math.PI / 180);
  var disengagementDirection = {0:3, 1:4, 2:1, 3:2}[quadrant];
  if (!disengagementDirection) {
    error(localize("Invalid disengagement direction."));
  }
  return disengagementDirection;
}
// <<<<< INCLUDED FROM include_files/drillCycles_heidenhain.cpi
// >>>>> INCLUDED FROM include_files/probeCycles_heidenhain.cpi
var outputErrorLabel = false;
function writeProbeCycle(cycle, x, y, z) {
  var probeGeometry = hasParameter("operation-strategy") && (getParameter("operation-strategy") == "probe_geometry");
  var probeOutputWorkOffset = getParameter("probe-output-work-offset", currentSection.probeWorkOffset);
  if (!isSameDirection(machineConfiguration.getSpindleAxis(), getForwardDirection(currentSection))) {
    if (!settings.probing.allowIndexingWCSProbing && currentSection.strategy == "probe") {
      error(localize("Updating WCS / work offset using probing is only supported by the CNC in the WCS frame."));
    }
  }
  var isMirrored = currentSection.getInternalPatternId && currentSection.getInternalPatternId() != currentSection.getPatternId();
  validate(!isMirrored, "Mirror pattern is not supported for Probing toolpaths.");
  if (currentSection.isPatterned && currentSection.isPatterned()) {
    // probe cycles that cannot be used with patterns
    var unsupportedCycleTypes = ["probing-x", "probing-y", "probing-xy-inner-corner", "probing-xy-outer-corner", "probing-x-plane-angle", "probing-y-plane-angle"];
    if (unsupportedCycleTypes.indexOf(cycleType) > -1 && (!Matrix.diff(new Matrix(), currentSection.workPlane).isZero())) {
      error(subst("Rotary type patterns are not supported for the Probing cycle type '%1'.", cycleType));
    }
  }

  var Q330 = formatQword("Q330", "+0", "TOOL");
  if (cycle.updateToolWear == 1) {
    if (getProperty("toolAsName")) {
      if (cycle.toolDescription.toUpperCase() == "") {
        warning(localize("The description of the tool to be updated is empty. It will not be updated."));
      } else {
        Q330 = formatQword("QS330", "\"" + (cycle.toolDescription.toUpperCase()) + "\"", "TOOL NAME");
      }
    } else {
      Q330 = formatQword("Q330", xyzFormat.format(cycle.toolWearNumber), "TOOL NUMBER");
    }
  }

  var tolerancePosition = cycle.hasPositionalTolerance ? cycle.tolerancePosition : 0;
  var probeClearance = cycle.probeClearance ? cycle.probeClearance : 0;
  var stopOnError = cycle.wrongSizeAction && cycle.wrongSizeAction == "stop-message" || cycle.outOfPositionAction && cycle.outOfPositionAction == "stop-message";
  var approachSign = cycle.approach1 ? approach(cycle.approach1) : 0;
  var probeToleranceSize = cycle.hasSizeTolerance ? cycle.toleranceSize : 0;
  var surfaceCoordinateX = x + approachSign * (probeClearance + tool.diameter / 2);
  var surfaceCoordinateY = y + approachSign * (probeClearance + tool.diameter / 2);
  if (probeOutputWorkOffset != 0 && !probeGeometry) {
    currentWorkOffset = undefined; // force WCS output to load the correct datum after the probe WCS cycle
  }
  var QLvalue = undefined;

  var Q260 = formatQword("Q260", xyzFormat.format(cycle.stock + (tool.diameter / 2)), "CLEARANCE HEIGHT");
  var Q261 = formatQword("Q261", xyzFormat.format((z + tool.diameter / 2) - cycle.depth), "MEASURING HEIGHT");
  var Q263 = formatQword("Q263", xyzFormat.format(x), "1ST POINT 1ST AXIS");
  var Q264 = formatQword("Q264", xyzFormat.format(y), "1ST POINT 2ND AXIS");
  var Q267 = formatQword("Q267", xyzFormat.format((approachSign)), "TRAVERSE DIRECTION");
  var Q272 = formatQword("Q272", xyzFormat.format(1), "MEASURING AXIS");
  var Q273 = formatQword("Q273", xyzFormat.format(x), "CENTER IN 1ST AXIS");
  var Q274 = formatQword("Q274", xyzFormat.format(y), "CENTER IN 2ND AXIS");
  var Q279 = cycle.hasPositionalTolerance ? formatQword("Q279", xyzFormat.format(tolerancePosition), "TOLERANCE 1ST CENTER") : "";
  var Q280 = cycle.hasPositionalTolerance ? formatQword("Q280", xyzFormat.format(tolerancePosition), "TOLERANCE 2ND CENTER") : "";
  var Q281 = formatQword("Q281", xyzFormat.format(cycle.printResults), "MEASURING LOG");
  var Q288 = formatQword("Q288", xyzFormat.format(surfaceCoordinateX + probeToleranceSize), "MAXIMUM DIMENSION");
  var Q289 = formatQword("Q289", xyzFormat.format(surfaceCoordinateX - probeToleranceSize), "MINIMUM DIMENSION");
  var Q301 = formatQword("Q301", xyzFormat.format(1), "MOVE TO CLEARANCE");
  var Q303 = formatQword("Q303", xyzFormat.format(1), "MEAS. VALUE TRANSFER");
  var Q305 = formatQword("Q305", xyzFormat.format(probeOutputWorkOffset), "NUMBER IN TABLE");
  var Q307 = formatQword("Q307", xyzFormat.format(0), "PRESET ROTATION ANG.");
  var Q309 = formatQword("Q309", xyzFormat.format(stopOnError ? 1 : 0), "PGM-STOP IF ERROR");
  var Q310 = formatQword("Q310", xyzFormat.format(0), "OFFS. 2ND MEASUREMNT");
  var Q311 = formatQword("Q311", xyzFormat.format(cycle.width1 ? cycle.width1 : 0), "NOMINAL LENGTH");
  var Q320 = formatQword("Q320", xyzFormat.format(probeClearance), "SET-UP CLEARANCE");
  var Q321 = formatQword("Q321", xyzFormat.format(x), "CENTER IN 1ST AXIS");
  var Q322 = formatQword("Q322", xyzFormat.format(y), "CENTER IN 2ND AXIS");
  var Q328 = formatQword("Q328", xyzFormat.format(x), "STARTNG PNT 1ST AXIS");
  var Q329 = formatQword("Q329", xyzFormat.format(y), "STARTNG PNT 2ND AXIS");
  var Q331 = formatQword("Q331", xyzFormat.format(x), "DATUM");
  var Q332 = formatQword("Q332", xyzFormat.format(y), "DATUM");
  var Q333 = formatQword("Q333", xyzFormat.format(0), "DATUM");
  var Q365 = formatQword("Q365", xyzFormat.format(1), "TYPE OF TRAVERSE");
  var Q380 = formatQword("Q380", xyzFormat.format(0), "REFERENCE ANGLE");
  var Q381 = formatQword("Q381", xyzFormat.format(0), "PROBE IN TS AXIS");
  var Q382 = formatQword("Q382", xyzFormat.format(0), "1ST CO. FOR TS AXIS");
  var Q383 = formatQword("Q383", xyzFormat.format(0), "2ND CO. FOR TS AXIS");
  var Q384 = formatQword("Q384", xyzFormat.format(0), "3RD CO. FOR TS AXIS");
  var Q405 = formatQword("Q405", xyzFormat.format(x), "DATUM");
  var Q423 = formatQword("Q423", xyzFormat.format(4), "NO. OF MEAS. POINTS");

  switch (cycleType) {
  case "probing-x":
    Q333 = formatQword("Q333", xyzFormat.format(surfaceCoordinateX), "DATUM");
    Q263 = formatQword("Q263", xyzFormat.format(surfaceCoordinateX), "1ST POINT 1ST AXIS");
    if (probeGeometry) {
      writeBlock([("TCH PROBE 427 " + localize("MEASURE COORDINATE")), Q263, Q264, Q261, Q320, Q272, Q267, Q260, Q281, Q288, Q289, Q309, Q330].join(EOL_));
      logFileName = (cycle.printResults > 0) ? "TCHPR427.TXT" : undefined;
    } else {
      writeBlock([("TCH PROBE 419 " + localize("DATUM IN ONE AXIS")), Q263, Q264, Q261, Q320, Q260, Q272, Q267, Q305, Q333, Q303].join(EOL_));
    }
    break;
  case "probing-y":
    Q264 = formatQword("Q264", xyzFormat.format(surfaceCoordinateY), "1ST POINT 2ND AXIS");
    Q272 = formatQword("Q272", xyzFormat.format(2), "MEASURING AXIS");
    Q288 = formatQword("Q288", xyzFormat.format(surfaceCoordinateY + probeToleranceSize), "MAXIMUM DIMENSION");
    Q289 = formatQword("Q289", xyzFormat.format(surfaceCoordinateY - probeToleranceSize), "MINIMUM DIMENSION");
    Q333 = formatQword("Q333", xyzFormat.format(surfaceCoordinateY), "DATUM");

    if (probeGeometry) {
      writeBlock([("TCH PROBE 427 " + localize("MEASURE COORDINATE")), Q263, Q264, Q261, Q320, Q272, Q267, Q260, Q281, Q288, Q289, Q309, Q330].join(EOL_));
      logFileName = (cycle.printResults > 0) ? "TCHPR427.TXT" : undefined;
    } else {
      writeBlock([("TCH PROBE 419 " + localize("DATUM IN ONE AXIS")), Q263, Q264, Q261, Q320, Q260, Q272, Q267, Q305, Q333, Q303].join(EOL_));
    }
    break;
  case "probing-z":
    Q272 = formatQword("Q272", xyzFormat.format(3), "MEASURING AXIS");
    Q288 = formatQword("Q288", xyzFormat.format((z + tool.diameter / 2) - cycle.depth + probeToleranceSize), "MAXIMUM DIMENSION");
    Q289 = formatQword("Q289", xyzFormat.format((z + tool.diameter / 2) - cycle.depth - probeToleranceSize), "MINIMUM DIMENSION");
    var Q294 = formatQword("Q294", xyzFormat.format(z - cycle.depth), "1ST POINT 3RD AXIS");
    Q333 = formatQword("Q333", xyzFormat.format(z - cycle.depth), "DATUM");

    if (probeGeometry) {
      writeBlock([("TCH PROBE 427 " + localize("MEASURE COORDINATE")), Q263, Q264, Q261, Q320, Q272, Q267, Q260, Q281, Q288, Q289, Q309, Q330].join(EOL_));
      logFileName = (cycle.printResults > 0) ? "TCHPR427.TXT" : undefined;
    } else {
      writeBlock([("TCH PROBE 417 " + localize("DATUM IN TS AXIS")), Q263, Q264, Q294, Q320, Q260, Q305, Q333, Q303].join(EOL_));
    }
    break;
  case "probing-x-channel":
  case "probing-x-channel-with-island":
  case "probing-y-channel":
  case "probing-y-channel-with-island":
    Q288 = formatQword("Q288", xyzFormat.format(cycle.width1 + probeToleranceSize), "MAXIMUM DIMENSION");
    Q289 = formatQword("Q289", xyzFormat.format(cycle.width1 - probeToleranceSize), "MINIMUM DIMENSION");
    Q301 = formatQword("Q301", xyzFormat.format(cycleType == "probing-x-channel" ? 0 : 1), "MOVE TO CLEARANCE");
    QLvalue = x;
    if (cycleType == "probing-y-channel" || cycleType == "probing-y-channel-with-island") {
      Q272 = formatQword("Q272", xyzFormat.format(2), "MEASURING AXIS");
      Q405 = formatQword("Q405", xyzFormat.format(y), "DATUM");
      Q301 = formatQword("Q301", xyzFormat.format(cycleType == "probing-y-channel" ? 0 : 1), "MOVE TO CLEARANCE");
      QLvalue = y;
    }

    if (probeGeometry) {
      writeBlock([("TCH PROBE 425 " + localize("MEASURE INSIDE WIDTH")), Q328, Q329, Q310, Q272, Q261, Q260, Q311, Q288, Q289, Q281, Q309, Q330].join(EOL_));
      logFileName = (cycle.printResults > 0) ? "TCHPR425.TXT" : undefined;
    } else {
      Q311 = formatQword("Q311", xyzFormat.format(cycle.width1), "SLOT WIDTH");
      writeBlock([("TCH PROBE 408 " + localize("SLOT CENTER REF PT")), Q321, Q322, Q311, Q272, Q261, Q320, Q260, Q301, Q305, Q405, Q303, Q381, Q382, Q383, Q384, Q333].join(EOL_));
    }
    break;
  case "probing-x-wall":
    var Q266 = formatQword("Q266", xyzFormat.format(y), "2ND POINT 2ND AXIS");
    Q288 = formatQword("Q288", xyzFormat.format(cycle.width1 + probeToleranceSize), "MAXIMUM DIMENSION");
    Q289 = formatQword("Q289", xyzFormat.format(cycle.width1 - probeToleranceSize), "MINIMUM DIMENSION");

    if (probeGeometry) {
      var firstPoint = x + (cycle.width1 / 2);
      var secondPoint = x - (cycle.width1 / 2);
      Q263 = formatQword("Q263", xyzFormat.format(Math.max(firstPoint, secondPoint)), "1ST POINT 1ST AXIS");
      var Q265 = formatQword("Q265", xyzFormat.format(Math.min(firstPoint, secondPoint)), "2ND POINT 1ST AXIS");

      writeBlock([("TCH PROBE 426 " + localize("MEASURE RIDGE WIDTH")), Q263, Q264, Q265, Q266, Q272, Q261, Q320, Q260, Q311, Q288, Q289, Q281, Q309, Q330].join(EOL_));
      logFileName = (cycle.printResults > 0) ? "TCHPR426.TXT" : undefined;
      QLvalue = x;
    } else {
      Q311 = formatQword("Q311", xyzFormat.format(cycle.width1), "RIDGE WIDTH");
      writeBlock([("TCH PROBE 409 " + localize("RIDGE CENTER REF PT")), Q321, Q322, Q311, Q272, Q261, Q320, Q260, Q305, Q405, Q303, Q381, Q382, Q383, Q384, Q333].join(EOL_));
    }
    break;
  case "probing-y-wall":
    var Q265 = formatQword("Q265", xyzFormat.format(x), "2ND POINT 1ST AXIS");
    Q272 = formatQword("Q272", xyzFormat.format(2), "MEASURING AXIS");
    Q288 = formatQword("Q288", xyzFormat.format(cycle.width1 + probeToleranceSize), "MAXIMUM DIMENSION");
    Q289 = formatQword("Q289", xyzFormat.format(cycle.width1 - probeToleranceSize), "MINIMUM DIMENSION");
    Q405 = formatQword("Q405", xyzFormat.format(y), "DATUM");
    QLvalue = y;

    if (probeGeometry) {
      var firstPoint = y + (cycle.width1 / 2);
      var secondPoint = y - (cycle.width1 / 2);
      Q264 = formatQword("Q264", xyzFormat.format(Math.max(firstPoint, secondPoint)), "1ST POINT 2ND AXIS");
      var Q266 = formatQword("Q266", xyzFormat.format(Math.min(firstPoint, secondPoint)), "2ND POINT 2ND AXIS");

      writeBlock([("TCH PROBE 426 " + localize("MEASURE RIDGE WIDTH")), Q263, Q264, Q265, Q266, Q272, Q261, Q320, Q260, Q311, Q288, Q289, Q281, Q309, Q330].join(EOL_));
      logFileName = (cycle.printResults > 0) ? "TCHPR426.TXT" : undefined;
    } else {
      Q311 = formatQword("Q311", xyzFormat.format(cycle.width1), "RIDGE WIDTH");
      writeBlock([("TCH PROBE 409 " + localize("RIDGE CENTER REF PT")), Q321, Q322, Q311, Q272, Q261, Q320, Q260, Q305, Q405, Q303, Q381, Q382, Q383, Q384, Q333].join(EOL_));
    }
    break;
    /*
    case "probing-xy-inner-corner":
      // Heidenhain needs 2 points per surface for inner and outer corner probing
      var spacing = cycle.probeSpacing ? cycle.probeSpacing : tool.diameter * 0.2;
      writeBlock("TCH PROBE 415 " + localize("DATUM INSIDE CORNER") + " ~" + EOL
        + "  Q263=" + xyzFormat.format(x + approachSign * (probeClearance + tool.diameter/2)) + " ;" + localize("1ST POINT 1ST AXIS") + " ~" + EOL
        + "  Q264=" + xyzFormat.format(y + approach(cycle.approach2) * (probeClearance + tool.diameter/2)) + " ;" + localize("1ST POINT 2ND AXIS") + " ~" + EOL
        + "  Q326=" + xyzFormat.format(spacing) + " ;" + localize("SPACING IN 1ST AXIS") + " ~" + EOL
        + "  Q327=" + xyzFormat.format(spacing) + " ;" + localize("SPACING IN 2ND AXIS") + " ~" + EOL
      );
      break;
*/
  case "probing-xy-circular-hole":
  case "probing-xy-circular-hole-with-island":
    var Q262 = formatQword("Q262", xyzFormat.format(cycle.width1), "NOMINAL DIAMETER");
    var Q325 = formatQword("Q325", xyzFormat.format(0), "STARTING ANGLE");
    var Q247 = formatQword("Q247", xyzFormat.format(90), "STEPPING ANGLE");
    Q301 = formatQword("Q301", xyzFormat.format(cycleType == "probing-xy-circular-hole" ? 0 : 1), "MOVE TO CLEARANCE");
    var Q275 = formatQword("Q275", xyzFormat.format(cycle.width1 + probeToleranceSize), "MAXIMUM DIMENSION");
    var Q276 = formatQword("Q276", xyzFormat.format(cycle.width1 - probeToleranceSize), "MINIMUM DIMENSION");

    if (probeGeometry) {
      writeBlock([("TCH PROBE 421 " + localize("MEASURE HOLE")), Q273, Q274, Q262, Q325, Q247, Q261, Q320, Q260, Q301, Q275, Q276, Q279, Q280, Q281, Q309, Q330].join(EOL_));
      logFileName = (cycle.printResults > 0) ? "TCHPR421.TXT" : undefined;
    } else {
      Q262 = formatQword("Q262", xyzFormat.format(cycle.width1), "NOMINAL DIAMETER");
      writeBlock([("TCH PROBE 412 " + localize("DATUM INSIDE CIRCLE")), Q321, Q322, Q262, Q325, Q247, Q261, Q320, Q260, Q301, Q305, Q331, Q332, Q303, Q381, Q382, Q383, Q384, Q333, Q423, Q365].join(EOL_));
    }
    break;
  case "probing-xy-rectangular-hole":
  case "probing-xy-rectangular-hole-with-island":
    var Q282 = formatQword("Q282", xyzFormat.format(cycle.width1), "1ST SIDE LENGTH");
    var Q283 = formatQword("Q283", xyzFormat.format(cycle.width2), "2ND SIDE LENGTH");
    Q301 = formatQword("Q301", xyzFormat.format(cycleType == "probing-xy-rectangular-hole" ? 0 : 1), "MOVE TO CLEARANCE");
    var Q284 = formatQword("Q284", xyzFormat.format(cycle.width1 + probeToleranceSize), "MAX. LIMIT 1ST SIDE");
    var Q285 = formatQword("Q285", xyzFormat.format(cycle.width1 - probeToleranceSize), "MIN. LIMIT 1ST SIDE");
    var Q286 = formatQword("Q286", xyzFormat.format(cycle.width2 + probeToleranceSize), "MAX. LIMIT 2ND SIDE");
    var Q287 = formatQword("Q287", xyzFormat.format(cycle.width2 - probeToleranceSize), "MIN. LIMIT 2ND SIDE");

    if (probeGeometry) {
      writeBlock([("TCH PROBE 423 " + localize("MEAS. RECTAN. INSIDE")), Q273, Q274, Q282, Q283, Q261, Q320, Q260, Q301, Q284, Q285, Q286, Q287, Q279, Q280, Q281, Q309, Q330].join(EOL_));
      logFileName = (cycle.printResults > 0) ? "TCHPR423.TXT" : undefined;
    } else {
      var Q323 = formatQword("Q323", xyzFormat.format(cycle.width1), "FIRST SIDE LENGTH");
      var Q324 = formatQword("Q324", xyzFormat.format(cycle.width2), "2ND SIDE LENGTH");
      writeBlock([("TCH PROBE 410 " + localize("DATUM INSIDE RECTAN.")), Q321, Q322, Q323, Q324, Q261, Q320, Q260, Q301, Q305, Q331, Q332, Q303, Q381, Q382, Q383, Q384, Q333].join(EOL_));
    }
    break;
  case "probing-xy-circular-boss":
    var Q262 = formatQword("Q262", xyzFormat.format(cycle.width1), "NOMINAL DIAMETER");
    var Q325 = formatQword("Q325", xyzFormat.format(0), "STARTING ANGLE");
    var Q247 = formatQword("Q247", xyzFormat.format(90), "STEPPING ANGLE");
    var Q277 = formatQword("Q277", xyzFormat.format(cycle.width1 + probeToleranceSize), "MAXIMUM DIMENSION");
    var Q278 = formatQword("Q278", xyzFormat.format(cycle.width1 - probeToleranceSize), "MINIMUM DIMENSION");

    if (probeGeometry) {
      writeBlock([("TCH PROBE 422 " + localize("MEAS. CIRCLE OUTSIDE")), Q273, Q274, Q262, Q325, Q247, Q261, Q320, Q260, Q301, Q277, Q278, Q279, Q280, Q281, Q309, Q330].join(EOL_));
      logFileName = (cycle.printResults > 0) ? "TCHPR422.TXT" : undefined;
    } else {
      writeBlock([("TCH PROBE 413 " + localize("DATUM OUTSIDE CIRCLE")), Q321, Q322, Q262, Q325, Q247, Q261, Q320, Q260, Q301, Q305, Q331, Q332, Q303, Q381, Q382, Q383, Q384, Q333, Q423, Q365].join(EOL_));
    }
    break;
  case "probing-xy-rectangular-boss":
    var Q282 = formatQword("Q282", xyzFormat.format(cycle.width1), "1ST SIDE LENGTH");
    var Q283 = formatQword("Q283", xyzFormat.format(cycle.width2), "2ND SIDE LENGTH");
    var Q284 = formatQword("Q284", xyzFormat.format(cycle.width1 + probeToleranceSize), "MAX. LIMIT 1ST SIDE");
    var Q285 = formatQword("Q285", xyzFormat.format(cycle.width1 - probeToleranceSize), "MIN. LIMIT 1ST SIDE");
    var Q286 = formatQword("Q286", xyzFormat.format(cycle.width2 + probeToleranceSize), "MAX. LIMIT 2ND SIDE");
    var Q287 = formatQword("Q287", xyzFormat.format(cycle.width2 - probeToleranceSize), "MIN. LIMIT 2ND SIDE");

    if (probeGeometry) {
      writeBlock([("TCH PROBE 424 " + localize("MEAS. RECTAN. OUTS.")), Q273, Q274, Q282, Q283, Q261, Q320, Q260, Q301, Q284, Q285, Q286, Q287, Q279, Q280, Q281, Q309, Q330].join(EOL_));
      logFileName = (cycle.printResults > 0) ? "TCHPR424.TXT" : undefined;
    } else {
      var Q323 = formatQword("Q323", xyzFormat.format(cycle.width1), "FIRST SIDE LENGTH");
      var Q324 = formatQword("Q324", xyzFormat.format(cycle.width2), "2ND SIDE LENGTH");
      writeBlock([("TCH PROBE 411 " + localize("DATUM OUTS. RECTAN.")), Q321, Q322, Q323, Q324, Q261, Q320, Q260, Q301, Q305, Q331, Q332, Q303, Q381, Q382, Q383, Q384, Q333].join(EOL_));
    }
    break;
  case "probing-x-plane-angle":
    Q263 = formatQword("Q263", xyzFormat.format(surfaceCoordinateX), "1ST POINT 1ST AXIS");
    Q264 = formatQword("Q264", xyzFormat.format(y + (cycle.probeSpacing / 2)), "1ST POINT 2ND AXIS");
    Q265 = formatQword("Q265", xyzFormat.format(surfaceCoordinateX), "2ND POINT 1ST AXIS");
    Q266 = formatQword("Q266", xyzFormat.format(y - (cycle.probeSpacing / 2)), "2ND POINT 2ND AXIS");
    var Q312 = getCompensationAxis() > 0 ? formatQword("Q312", xyzFormat.format(getCompensationAxis()), "COMPENSATION AXIS") : "";
    var Q337 = formatQword("Q337", xyzFormat.format(1), "SET TO ZERO");

    if (probeGeometry) {
      writeBlock([("TCH PROBE 420 " + localize("MEASURE ANGLE")), Q263, Q264, Q265, Q266, Q272, Q267, Q261, Q320, Q260, Q301, Q281].join(EOL_));
      logFileName = (cycle.printResults > 0) ? "TCHPR420.TXT" : undefined;
    } else {
      if (getCompensationAxis() < 0) {
        writeBlock([("TCH PROBE 400 " + localize("BASIC ROTATION")), Q263, Q264, Q265, Q266, Q272, Q267, Q261, Q320, Q260, Q301, Q307, Q305].join(EOL_));
      } else {
        writeBlock([("TCH PROBE 403 " + localize("ROT IN ROTARY AXIS")), Q263, Q264, Q265, Q266, Q272, Q267, Q261, Q320, Q260, Q301, Q312, Q337, Q305, Q303, Q380].join(EOL_));
      }
    }
    break;
  case "probing-y-plane-angle":
    Q263 = formatQword("Q263", xyzFormat.format(x - (cycle.probeSpacing / 2)), "1ST POINT 1ST AXIS");
    Q264 = formatQword("Q264", xyzFormat.format(surfaceCoordinateY), "1ST POINT 2ND AXIS");
    Q265 = formatQword("Q265", xyzFormat.format(x + (cycle.probeSpacing / 2)), "2ND POINT 1ST AXIS");
    Q266 = formatQword("Q266", xyzFormat.format(surfaceCoordinateY), "2ND POINT 2ND AXIS");
    Q272 = formatQword("Q272", xyzFormat.format(2), "MEASURING AXIS");
    var Q312 = getCompensationAxis() > 0 ? formatQword("Q312", xyzFormat.format(getCompensationAxis()), "COMPENSATION AXIS") : "";
    var Q337 = formatQword("Q337", xyzFormat.format(1), "SET TO ZERO");

    if (probeGeometry) {
      writeBlock([("TCH PROBE 420 " + localize("MEASURE ANGLE")), Q263, Q264, Q265, Q266, Q272, Q267, Q261, Q320, Q260, Q301, Q281].join(EOL_));
      logFileName = (cycle.printResults > 0) ? "TCHPR420.TXT" : undefined;
    } else {
      if (getCompensationAxis() < 0) {
        writeBlock([("TCH PROBE 400 " + localize("BASIC ROTATION")), Q263, Q264, Q265, Q266, Q272, Q267, Q261, Q320, Q260, Q301, Q307, Q305].join(EOL_));
      } else {
        writeBlock([("TCH PROBE 403 " + localize("ROT IN ROTARY AXIS")), Q263, Q264, Q265, Q266, Q272, Q267, Q261, Q320, Q260, Q301, Q312, Q337, Q305, Q303, Q380].join(EOL_));
      }
    }
    break;
  default:
    cycleNotSupported();
  }
  if (probeGeometry && QLvalue != undefined && (cycle.outOfPositionAction && cycle.outOfPositionAction == "stop-message")) {
    writeBlock("FN 1: QL1 =", xyzFormat.format(QLvalue), "+", xyzFormat.format(tolerancePosition), formatComment("UPPER POSITION"));
    writeBlock("FN 2: QL2 =", xyzFormat.format(QLvalue), "-", xyzFormat.format(tolerancePosition), formatComment("LOWER POSITION"));
    writeBlock("FN 11: IF Q157 GT QL1 GOTO LBL \"ERROR_OUT_OF_TOLERANCE\"");
    writeBlock("FN 12: IF Q157 LT QL2 GOTO LBL \"ERROR_OUT_OF_TOLERANCE\"");
    outputErrorLabel = true;
  }
}

function getCompensationAxis() {
  var axes = [machineConfiguration.getAxisU(), machineConfiguration.getAxisV(), machineConfiguration.getAxisW()];
  for (var i = 0; i < axes.length; ++i) {
    if (axes[i].isEnabled() && isSameDirection((axes[i].getAxis()).getAbsolute(), machineConfiguration.getSpindleAxis()) && axes[i].isTable()) {
      return (axes[i].getCoordinate() + 4);
    }
  }
  return -1;
}

/** Convert approach to sign. */
function approach(value) {
  validate((value == "positive") || (value == "negative"), "Invalid approach.");
  return (value == "positive") ? 1 : -1;
}

var logfilePath = "";
var logFileName;
function writeProbeLog() {
  if (isProbeOperation()) {
    currentWorkOffset = undefined; // force WCS output
    writeWCS();
    if (logFileName != undefined) {
      var comment = getParameter("operation-comment", "").replace(/[\s()]/g, "_");
      var maximumFileNameLength = 25;
      if (comment.length > maximumFileNameLength) {
        var suffix = "_" + String(currentSection.getId());
        comment = String(comment).substring(0, maximumFileNameLength - suffix.length) + suffix;
      }

      writeBlock("FUNCTION FILECOPY", "\"" + logfilePath + logFileName + "\" TO " + "\"" + logfilePath + comment + "\"");
      writeBlock("FUNCTION FILEDELETE", "\"" + logfilePath + logFileName + "\"");
      logFileName = undefined;
    }
  }
}
// <<<<< INCLUDED FROM include_files/probeCycles_heidenhain.cpi
