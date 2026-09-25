/**
  Copyright (C) 2012-2025 by Autodesk, Inc.
  All rights reserved.

  Siemens SINUMERIK 840D post processor configuration.

  $Revision: 45634 31956ef75f684d71b11e4c257583647373ad2a91 $
  $Date: 2025-10-20 12:18:52 $

  FORKID {75AF44EA-0A42-4803-8DE7-43BF08B352B3}
*/

description = "Siemens SINUMERIK 840D";
// >>>>> INCLUDED FROM ../common/siemens-840d common.cps
if (!description) {
  description = "Siemens SINUMERIK Mill";
}
vendor = "Siemens";
vendorUrl = "http://www.siemens.com";
legal = "Copyright (C) 2012-2025 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45917;

if (!longDescription) {
  longDescription = subst("Generic post for %1. Note that the post will use D1 always for the tool length compensation as this is how most users work.", description);
}
extension = "mpf";
setCodePage("ascii");

capabilities = CAPABILITY_MILLING | CAPABILITY_MACHINE_SIMULATION;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
var useArcTurn = false;
maximumCircularSweep = toRad(useArcTurn ? (999 * 360) : 90); // max revolutions
allowHelicalMoves = true;
allowedCircularPlanes = undefined; // allow any circular motion
highFeedrate = (unit == MM) ? 5000 : 200;
probeMultipleFeatures = true;

// user-defined properties
properties = {
  preloadTool: {
    title      : "Preload tool",
    description: "Preloads the next tool at a tool change (if any).",
    group      : "preferences",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showSequenceNumbers: {
    title      : "Use sequence numbers",
    description: "'Yes' outputs sequence numbers on each block, 'Only on tool change' outputs sequence numbers on tool change blocks only, and 'No' disables the output of sequence numbers.",
    group      : "formats",
    type       : "enum",
    values     : [
      {title:"Yes", id:"true"},
      {title:"No", id:"false"},
      {title:"Only on tool change", id:"toolChange"}
    ],
    value: "true",
    scope: "post"
  },
  sequenceNumberStart: {
    title      : "Start sequence number",
    description: "The number at which to start the sequence numbers.",
    group      : "formats",
    type       : "integer",
    value      : 10,
    scope      : "post"
  },
  sequenceNumberIncrement: {
    title      : "Sequence number increment",
    description: "The amount by which the sequence number is incremented by in each block.",
    group      : "formats",
    type       : "integer",
    value      : 1,
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
  useTiltedWorkplane: {
    title      : "Use CYCLE800",
    description: "Specifies that the tilted working plane feature (CYCLE800) should be used.",
    group      : "multiAxis",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  useShortestDirection: {
    title      : "Use shortest direction",
    description: "Specifies that the shortest angular direction should be used.",
    group      : "multiAxis",
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
  useIncreasedDecimals: {
    title      : "Use increased decimal output",
    description: "Increases the number of decimals to 5 for MM /6 for IN for the output of linear axes and to 6 for rotary axes.",
    group      : "formats",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  useGrouping: {
    title      : "Group operations",
    description: "Groups toolpath moves together to condense code until expanded at the controller.",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useCIP: {
    title      : "Use CIP",
    description: "Enable to use the CIP command.",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useSmoothing: {
    title      : "Use CYCLE832",
    description: "Enable to use CYCLE832.",
    group      : "preferences",
    type       : "enum",
    values     : [
      {title:"Off", id:"-1"},
      {title:"Automatic", id:"9999"},
      {title:"Level 1", id:"1"},
      {title:"Level 2", id:"2"},
      {title:"Level 3", id:"3"}
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
  cycle800Mode: {
    title      : "CYCLE800 mode",
    description: "Specifies the mode to use for CYCLE800.",
    group      : "multiAxis",
    type       : "enum",
    values     : [
      {id:"39", title:"39 (CAB)"},
      {id:"27", title:"27 (CBA)"},
      {id:"57", title:"57 (ABC)"},
      {id:"45", title:"45 (ACB)"},
      {id:"30", title:"30 (BCA)"},
      {id:"54", title:"54 (BAC)"},
      {id:"192", title:"192 (Rotary angles)"}
    ],
    value: "27",
    scope: "post"
  },
  cycle800SwivelDataRecord: {
    title      : "CYCLE800 Swivel Data Record",
    description: "Specifies the label to use for the Swivel Data Record for CYCLE800.",
    group      : "multiAxis",
    type       : "string",
    value      : "",
    scope      : "post"
  },
  cycle800RetractMethod: {
    title      : "CYCLE800 Retract Method",
    description: "Retract Mode parameter for CYCLE800",
    group      : "multiAxis",
    type       : "enum",
    values     : [
      {id:"0", title:"0 - no retraction"},
      {id:"1", title:"1 - retract in machine Z"},
      {id:"2", title:"2 - retract in machine Z, then XY"}
    ],
    value: "1",
    scope: "post"
  },
  useExtendedCycles: {
    title      : "Extended cycles",
    description: "Specifies whether the extended cycles should be used. Controls before 2011 should set this to false.",
    group      : "preferences",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  useTOFFR: {
    title      : "TOFFR Output",
    description: "Enables outputting TOFFR for Wear and Inverse Wear compensation type.",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  singleLineProbing: {
    title      : "Single line probing",
    description: "If enabled, probing will be output in a single cycle call line.",
    group      : "probing",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  safePositionMethod: {
    title      : "Safe Retracts",
    description: "Select your desired retract option. 'Clearance Height' retracts to the operation clearance height." +
    "'SUPA with HOME variables' will output _XHOME, _YHOME and _ZHOME variables for retracts.",
    group : "homePositions",
    type  : "enum",
    values: [
      {title:"G53", id:"G53"},
      {title:"Clearance Height", id:"clearanceHeight"},
      {title:"SUPA", id:"SUPA"},
      {title:"SUPA with HOME variables", id:"SUPAVariables"}
    ],
    value: "SUPA",
    scope: "post"
  },
  useParkPosition: {
    title      : "Home XY at end",
    description: "Specifies that the machine moves to the home position in XY at the end of the program.",
    group      : "homePositions",
    type       : "boolean",
    value      : false,
    scope      : "post"
  }
};

// wcs definiton
wcsDefinitions = {
  useZeroOffset: false,
  wcs          : [
    {name:"Standard", format:"G", range:[54, 57]},
    {name:"Extended", format:"G", range:[505, 599]}
  ]
};

var gFormat = createFormat({prefix:"G", decimals:0});
var mFormat = createFormat({prefix:"M", decimals:0});
var hFormat = createFormat({prefix:"H", decimals:0});
var dFormat = createFormat({prefix:"D", decimals:0});
var nFormat = createFormat({prefix:"N", decimals:0});

var xyzFormat = createFormat({decimals:(unit == MM ? 3 : 4)});
var abcFormat = createFormat({decimals:3, scale:DEG});
var abcDirectFormat = createFormat({decimals:3, scale:DEG, prefix:"=DC(", suffix:")"});
var abc3Format = createFormat({decimals:6});
var feedFormat = createFormat({decimals:(unit == MM ? 1 : 2)});
var inverseTimeFormat = createFormat({decimals:3, type:FORMAT_REAL});
var toolFormat = createFormat({decimals:0});
var toolProbeFormat = createFormat({decimals:0, minDigitsLeft:3});
var rpmFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:3});
var taperFormat = createFormat({decimals:1, scale:DEG});
var arFormat = createFormat({decimals:3, scale:DEG});
var integerFormat = createFormat({decimals:0});

var motionOutputTolerance = 0.0001;
var xOutput = createOutputVariable({onchange:function() {state.retractedX = false;}, prefix:"X", tolerance:motionOutputTolerance}, xyzFormat);
var yOutput = createOutputVariable({onchange:function() {state.retractedY = false;}, prefix:"Y", tolerance:motionOutputTolerance}, xyzFormat);
var zOutput = createOutputVariable({onchange:function() {state.retractedZ = false;}, prefix:"Z", tolerance:motionOutputTolerance}, xyzFormat);
var toolVectorOutputI = createOutputVariable({prefix:"A3=", control:CONTROL_FORCE}, abc3Format);
var toolVectorOutputJ = createOutputVariable({prefix:"B3=", control:CONTROL_FORCE}, abc3Format);
var toolVectorOutputK = createOutputVariable({prefix:"C3=", control:CONTROL_FORCE}, abc3Format);
var aOutput = createOutputVariable({prefix:"A", tolerance:motionOutputTolerance}, abcFormat);
var bOutput = createOutputVariable({prefix:"B", tolerance:motionOutputTolerance}, abcFormat);
var cOutput = createOutputVariable({prefix:"C", tolerance:motionOutputTolerance}, abcFormat);
var feedOutput = createOutputVariable({prefix:"F"}, feedFormat);
var inverseTimeOutput = createOutputVariable({prefix:"F", control:CONTROL_FORCE}, inverseTimeFormat);
var sOutput = createOutputVariable({prefix:"S", control:CONTROL_FORCE}, rpmFormat);
var dOutput = createOutputVariable({}, dFormat);

// circular output
var iOutput = createOutputVariable({prefix:"I", control:CONTROL_FORCE}, xyzFormat);
var jOutput = createOutputVariable({prefix:"J", control:CONTROL_FORCE}, xyzFormat);
var kOutput = createOutputVariable({prefix:"K", control:CONTROL_FORCE}, xyzFormat);

var gMotionModal = createOutputVariable({control:CONTROL_FORCE}, gFormat); // modal group 1 // G0-G3, ...
var gPlaneModal = createOutputVariable({onchange:function () {gMotionModal.reset();}}, gFormat); // modal group 2 // G17-19
var gAbsIncModal = createOutputVariable({}, gFormat); // modal group 3 // G90-91
var gFeedModeModal = createOutputVariable({}, gFormat); // modal group 5 // G94-95
var gUnitModal = createOutputVariable({}, gFormat); // modal group 6 // G70-71
var fourthAxisClamp = createOutputVariable({}, mFormat);
var fifthAxisClamp = createOutputVariable({}, mFormat);

var settings = {
  coolant: {
    // samples:
    // {id: COOLANT_THROUGH_TOOL, on: 88, off: 89}
    // {id: COOLANT_THROUGH_TOOL, on: [8, 88], off: [9, 89]}
    // {id: COOLANT_THROUGH_TOOL, on: "M88 P3 (myComment)", off: "M89"}
    coolants: [
      {id:COOLANT_FLOOD, on:8},
      {id:COOLANT_MIST},
      {id:COOLANT_THROUGH_TOOL},
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
    roughing              : 3, // roughing level for smoothing in automatic mode
    semi                  : 2, // semi-roughing level for smoothing in automatic mode
    semifinishing         : 2, // semi-finishing level for smoothing in automatic mode
    finishing             : 1, // finishing level for smoothing in automatic mode
    thresholdRoughing     : toPreciseUnit(0.2, MM), // operations with stock/tolerance above that threshold will use roughing level in automatic mode
    thresholdFinishing    : toPreciseUnit(0.05, MM), // operations with stock/tolerance below that threshold will use finishing level in automatic mode
    thresholdSemiFinishing: toPreciseUnit(0.1, MM), // operations with stock/tolerance above finishing and below threshold roughing that threshold will use semi finishing level in automatic mode

    differenceCriteria: "both", // options: "level", "tolerance", "both". Specifies criteria when output smoothing codes
    autoLevelCriteria : "stock", // use "stock" or "tolerance" to determine levels in automatic mode
    cancelCompensation: false // tool length compensation must be canceled prior to changing the smoothing level
  },
  retract: {
    methodXY     : undefined, // special condition, overwrite retract behavior per axis
    methodZ      : undefined, // special condition, overwrite retract behavior per axis
    useZeroValues: ["G28", "G30"], // enter property value id(s) for using "0" value instead of machineConfiguration axes home position values (ie G30 Z0)
    homeXY       : {onIndexing:false, onToolChange:false, onProgramEnd:{axes:[X, Y]}} // Specifies when the machine should be homed in X/Y. Sample: onIndexing:{axes:[X, Y], singleLine:false}
  },
  parametricFeeds: {
    firstFeedParameter    : 1, // specifies the initial parameter number to be used for parametric feedrate output
    feedAssignmentVariable: "_R", // specifies the syntax to define a parameter
    feedOutputVariable    : "F=_R" // specifies the syntax to output the feedrate as parameter
  },
  machineAngles: { // refer to https://cam.autodesk.com/posts/reference/classMachineConfiguration.html#a14bcc7550639c482492b4ad05b1580c8
    controllingAxis: ABC,
    type           : PREFER_PREFERENCE,
    options        : ENABLE_ALL
  },
  workPlaneMethod: {
    useTiltedWorkplane    : true, // specifies that tilted workplanes should be used (ie. G68.2, G254, PLANE SPATIAL, CYCLE800), can be overwritten by property
    eulerConvention       : undefined, // specifies the euler convention (ie EULER_XYZ_R), set to undefined to use machine angles for TWP commands ('undefined' requires machine configuration)
    eulerCalculationMethod: "standard", // ('standard' / 'machine') 'machine' adjusts euler angles to match the machines ABC orientation, machine configuration required
    cancelTiltFirst       : false, // cancel tilted workplane prior to WCS (G54-G59) blocks
    forceMultiAxisIndexing: false, // force multi-axis indexing for 3D programs
    optimizeType          : OPTIMIZE_AXIS // can be set to OPTIMIZE_NONE, OPTIMIZE_BOTH, OPTIMIZE_TABLES, OPTIMIZE_HEADS, OPTIMIZE_AXIS. 'undefined' uses legacy rotations
  },
  subprograms: {
    initialSubprogramNumber: 1, // specifies the initial number to be used for subprograms. 'undefined' uses the main program number
    minimumCyclePoints     : 5, // minimum number of points in cycle operation to consider for subprogram
    format                 : undefined, // the format to use for the subprogam number format
    // objects below also accept strings with "%currentSubprogram" as placeholder. Sample: {files:["%"], embedded:"N" + "%currentSubprogram"}
    files                  : {extension:"spf", prefix:"sub"}, // specifies the subprogram file extension and the prefix to use for the generated file
    startBlock             : {files:"; %_N_" + "_SPF", embedded:"LABEL" + "%currentSubprogram" + ":"}, // specifies the start syntax of a subprogram followed by the subprogram number
    endBlock               : {files:mFormat.format(17), embedded:"LABEL0:"}, // specifies the command to for the end of a subprogram
    callBlock              : {files:"%currentSubprogram" + "; SPF CALL", embedded:"CALL BLOCK LABEL" + "%currentSubprogram" + " TO LABEL0"} // specifies the command for calling a subprogram followed by the subprogram number
  },
  comments: {
    permittedCommentChars: undefined, // letters are not case sensitive, use option 'outputFormat' below. Set to 'undefined' to allow any character
    prefix               : "; ", // specifies the prefix for the comment
    suffix               : "", // specifies the suffix for the comment
    outputFormat         : "ignoreCase", // can be set to "upperCase", "lowerCase" and "ignoreCase". Set to "ignoreCase" to write comments without upper/lower case formatting
    maximumLineLength    : 80 // the maximum number of characters allowed in a line, set to 0 to disable comment output
  },
  probing: {
    allowIndexingWCSProbing: false // specifies that probe WCS with tool orientation is supported
  },
  maximumSequenceNumber       : undefined, // the maximum sequence number (Nxxx), use 'undefined' for unlimited
  outputToolLengthCompensation: false, // specifies if tool length compensation code should be output (G43)
  polarCycleExpandMode        : 0 // 0=EXPAND_NONE: Does not expand any cycles. 1=EXPAND_TCP: Expands drilling cycles, when TCP is on. 2=EXPAND_NON_TCP: Expands drilling cycles, when TCP is off. 3=EXPAND_ALL: Expands all drilling cycles
};

// collected state
var cycleSeparator = ", ";
var toolLengthOffset = 0;

function onOpen() {
  // define and enable machine configuration
  receivedMachineConfiguration = machineConfiguration.isReceived();
  if (typeof defineMachine == "function") {
    defineMachine(); // hardcoded machine configuration
  }
  // define axis formats, should be done prior to activating the machine configuration
  formatOutputVariables();
  activateMachine(); // enable the machine optimizations and settings

  if (receivedMachineConfiguration && machineConfiguration.isMultiAxisConfiguration()) {
    if (machineConfiguration.getMultiAxisFeedrateMode() == FEED_DPM) {
      error(localize("Degrees per minute feedrates are not supported by the controller."));
    }
  }

  var cycle800Config = getCycle800Config(new Vector(0, 0, 0)); // get the Euler method to use for cycle800
  settings.workPlaneMethod.eulerConvention = cycle800Config[0] != 192 ? cycle800Config[2] : undefined;
  if (!machineConfiguration.isMultiAxisConfiguration() && !tcp.isSupportedByMachine) {
    tcp.isSupportedByMachine = true; // default to true when no machine configuration is defined
  }

  writeln("; %_N_" + translateText(String(programName).toUpperCase(), " ", "_") + "_MPF");
  writeComment(programComment);
  writeProgramHeader();

  writeParametricFeedVariables();

  writeSUPAVariables(); // writes SUPA variables if safe position method is SUPAVariables

  if (typeof inspectionWriteVariables == "function") {
    inspectionWriteVariables();
  }

  writeWCS(getSection(0), true);
  // absolute coordinates and feed per min
  writeBlock(gPlaneModal.format(17), gUnitModal.format(unit == MM ? 710 : 700), gAbsIncModal.format(90), gFeedModeModal.format(94));
  writeWorkPiece();
  writeBlock(gFormat.format(64)); // continuous-path mode
  validateCommonParameters();
}

function formatOutputVariables() {
  if (getProperty("useIncreasedDecimals")) {
    xyzFormat.setNumberOfDecimals(unit == MM ? 5 : 6);
    abcFormat.setNumberOfDecimals(6);
    abcDirectFormat.setNumberOfDecimals(6);
    abc3Format.setNumberOfDecimals(8);
    xOutput.setFormat(xyzFormat);
    yOutput.setFormat(xyzFormat);
    zOutput.setFormat(xyzFormat);
    aOutput.setFormat(abcFormat);
    bOutput.setFormat(abcFormat);
    cOutput.setFormat(abcFormat);
    toolVectorOutputI.setFormat(abc3Format);
    toolVectorOutputJ.setFormat(abc3Format);
    toolVectorOutputK.setFormat(abc3Format);
    iOutput.setFormat(xyzFormat);
    jOutput.setFormat(xyzFormat);
    kOutput.setFormat(xyzFormat);
  }

  if (getProperty("useShortestDirection")) {
    var outputFormats = [aOutput, bOutput, cOutput];
    // abcFormat and abcDirectFormat must be compatible except for =DC()
    for (var i = 0; i < outputFormats.length; i++) {
      if (machineConfiguration.isMachineCoordinate(i)) {
        if (machineConfiguration.getAxisByCoordinate(i).isCyclic() || isSameDirection(machineConfiguration.getAxisByCoordinate(i).getAxis(), machineConfiguration.getSpindleAxis())) {
          outputFormats[i].setFormat(abcDirectFormat);
        }
      }
    }
  }
}

function writeParametricFeedVariables() {
  if (getProperty("useParametricFeed")) {
    var firstFeedParameter = settings.parametricFeeds.firstFeedParameter;
    var feedParameterDefinitions = [];
    for (var i = firstFeedParameter; i <= (firstFeedParameter + 10); ++i) {
      feedParameterDefinitions.push(settings.parametricFeeds.feedAssignmentVariable + i);
    }
    writeBlock("DEF REAL", feedParameterDefinitions.join());
  }
}

function writeSUPAVariables() {
  if (getProperty("safePositionMethod") == "SUPAVariables") {
    var method = getProperty("safePositionMethod", "undefined");
    var useZeroValues = (settings.retract.useZeroValues && settings.retract.useZeroValues.indexOf(method) != -1);
    var _xHome = machineConfiguration.hasHomePositionX() && !useZeroValues ? machineConfiguration.getHomePositionX() : toPreciseUnit(0, MM);
    var _yHome = machineConfiguration.hasHomePositionY() && !useZeroValues ? machineConfiguration.getHomePositionY() : toPreciseUnit(0, MM);
    var _zHome = machineConfiguration.getRetractPlane() != 0 && !useZeroValues ? machineConfiguration.getRetractPlane() : toPreciseUnit(0, MM);
    writeBlock("DEF REAL _ZHOME, _XHOME, _YHOME");
    writeBlock("_ZHOME = " + _zHome);
    writeBlock("_XHOME = " + _xHome);
    writeBlock("_YHOME = " + _yHome);
  }
}

function setSmoothing(mode) {
  smoothingSettings = settings.smoothing;
  if (mode == smoothing.isActive && (!mode || !smoothing.isDifferent) && !smoothing.force) {
    return; // return if smoothing is already active or is not different
  }

  if (mode) { // enable smoothing
    if (true) { // set to false when you want to use the alternative version for CYCLE832 output 'CYCLE832(0.01, 1, 1)'
      writeBlock("CYCLE832(" + xyzFormat.format(smoothing.tolerance) + ", 11200" + smoothing.level + ")");
    } else {
      writeBlock("CYCLE832(" + xyzFormat.format(smoothing.tolerance) + ", " + smoothing.level + ", 1)");
    }
  } else { // disable smoothing
    writeBlock("CYCLE832()");
  }
  smoothing.isActive = mode;
  smoothing.force = false;
  smoothing.isDifferent = false;
}

function setTCP(_tcp, force) {
  if (!force) {
    if (!tcp.isSupportedByMachine || state.tcpIsActive == _tcp) {
      return;
    }
  }
  var tcpCode = _tcp ? "TRAORI" : "TRAFOOF";
  state.tcpIsActive = _tcp;

  writeBlock(tcpCode);
  machineSimulation({}); // update machine simulation TCP state
}

function onSection() {
  var forceSectionRestart = optionalSection && !currentSection.isOptional();
  optionalSection = currentSection.isOptional();
  var insertToolCall = isToolChangeNeeded(getProperty("toolAsName") ? "description" : "number") || forceSectionRestart;
  var newWorkOffset = isNewWorkOffset() || forceSectionRestart;
  var newWorkPlane = isNewWorkPlane() || forceSectionRestart || (typeof defineWorkPlane == "function" &&
    Vector.diff(defineWorkPlane(getPreviousSection(), false), defineWorkPlane(currentSection, false)).length > 1e-4);
  initializeSmoothing(); // initialize smoothing mode

  if (insertToolCall || newWorkOffset || newWorkPlane) {
    setCoolant(COOLANT_OFF);
    if (insertToolCall && !isFirstSection() && getPreviousSection().getTool().getType() != TOOL_PROBE) {
      onCommand(COMMAND_STOP_SPINDLE);
    }
    writeRetract(Z); // retract
    if (newWorkPlane && settings.workPlaneMethod.useTiltedWorkplane) {
      cancelWorkPlane(isFirstSection() && !is3D());
    }
  }

  writeln("");
  var comment = formatComment(getParameter("operation-comment", "")).replace(settings.comments.prefix, "");
  writeln(comment ? "MSG (" + "\"" + comment + "\"" + ")" : "");

  if (getProperty("showNotes")) {
    writeSectionNotes();
  }

  // tool change
  writeToolCall(tool, insertToolCall);

  smoothing.force = insertToolCall && (getProperty("useSmoothing") != "-1");
  setSmoothing(smoothing.isAllowed); // writes the required smoothing codes

  if (insertToolCall && tool.type == TOOL_PROBE) {
    writeBlock("SPOS=0");
  }
  startSpindle(tool, insertToolCall);

  // write parametric feedrate table
  if (typeof initializeParametricFeeds == "function") {
    initializeParametricFeeds(insertToolCall);
  }
  // Output modal commands here
  writeBlock(gPlaneModal.format(17), gAbsIncModal.format(90), gFeedModeModal.format(94));

  // wcs
  if (insertToolCall) { // force work offset when changing tool
    currentWorkOffset = undefined;
  }
  writeWCS(currentSection, true);

  forceXYZ();

  var abc = defineWorkPlane(currentSection, !machineConfiguration.isHeadConfiguration());

  if (currentSection.isMultiAxis() && !tcp.isSupportedByOperation) {
    var text = "FGROUP(X, Y, Z";
    if (machineConfiguration.getAxisU().isEnabled()) {
      text += ", " + axisDesignators[machineConfiguration.getAxisU().getCoordinate()];
    }
    if (machineConfiguration.getAxisV().isEnabled()) {
      text += ", " + axisDesignators[machineConfiguration.getAxisV().getCoordinate()];
    }
    writeBlock(text + ")");
  }

  // prepositioning
  var initialPosition = getFramePosition(currentSection.getInitialPosition());
  var isRequired = insertToolCall || state.retractedZ || (!isFirstSection() && getPreviousSection().isMultiAxis());
  writeInitialPositioning(initialPosition, isRequired);

  if (getProperty("useGrouping")) {
    writeBlock("GROUP_BEGIN(0, " + "\"" + comment + "\"" + ", 0, 0)");
  }

  setCoolant(tool.coolant);

  if (insertToolCall) {
    gPlaneModal.reset();
  }
  if (typeof inspectionProcessSectionStart == "function") {
    inspectionProcessSectionStart();
  }

  if (subprogramsAreSupported()) {
    subprogramDefine(initialPosition, abc); // define subprogram
  }
}

function onDwell(seconds) {
  if (seconds > 0) {
    writeBlock(gFormat.format(4), "F" + secFormat.format(seconds));
  }
}

function onSpindleSpeed(spindleSpeed) {
  writeBlock(sOutput.format(spindleSpeed));
}

function onOrientateSpindle(angle) {
  onCommand(COMMAND_STOP_SPINDLE);
  writeBlock("SPOS=" + abcFormat.format(angle));
}

function onCycle() {
  writeBlock(gPlaneModal.format(17));
}

function onCyclePoint(x, y, z) {
  if (isInspectionOperation()) {
    if (typeof inspectionCycleInspect == "function") {
      inspectionCycleInspect(cycle, x, y, z);
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
  if (isProbeOperation()) {
    zOutput.reset();
    gMotionModal.reset();
    writeBlock(gMotionModal.format(1), zOutput.format(cycle.retract), feedOutput.format(cycle.feedrate));
  } else {
    if (subprogramsAreSupported() && subprogramState.cycleSubprogramIsActive) {
      subprogramEnd();
    }
    if (!cycleExpanded && !isInspectionOperation()) {
      writeBlock("MCALL"); // end modal cycle
    }
  }
  writeWCS(currentSection, true);
  if (getProperty("useLiveConnection") && isProbeOperation() && typeof liveConnectionWriteData == "function") {
    liveConnectionWriteData("macroEnd");
  }
  zOutput.reset();
}

function onLinear5D(_x, _y, _z, _a, _b, _c, feed, feedMode) {
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for 5-axis move."));
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
  if (feedMode == FEED_INVERSE_TIME) {
    forceFeed();
  }
  var f = feedMode == FEED_INVERSE_TIME ? inverseTimeOutput.format(feed) : getFeed(feed);
  var fMode = feedMode == FEED_INVERSE_TIME ? 93 : 94;

  // define the rotary radii if non-TCP machine
  if (feedMode == FEED_FPM && !tcp.isSupportedByOperation) {
    setRotaryRadii(getCurrentPosition(), new Vector(_x, _y, _z), getCurrentDirection(), new Vector(_a, _b, _c));
  }

  if (x || y || z || a || b || c) {
    writeBlock(gFeedModeModal.format(fMode), gMotionModal.format(1), x, y, z, a, b, c, f);
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      forceFeed(); // force feed on next line
    } else {
      writeBlock(gFeedModeModal.format(fMode), gMotionModal.format(1), f);
    }
  }
}

var mapCommand = {
  COMMAND_END              : 30,
  COMMAND_STOP_SPINDLE     : 5,
  COMMAND_ORIENTATE_SPINDLE: 19
};

function onCommand(command) {
  switch (command) {
  case COMMAND_COOLANT_OFF:
    setCoolant(COOLANT_OFF);
    return;
  case COMMAND_COOLANT_ON:
    setCoolant(tool.coolant);
    return;
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
  case COMMAND_START_SPINDLE:
    forceSpindleSpeed = false;
    writeBlock(sOutput.format(spindleSpeed), mFormat.format(tool.clockwise ? 3 : 4));
    return;
  case COMMAND_LOAD_TOOL:
    toolLengthOffset = 1; // optional, use tool.lengthOffset instead
    writeToolBlock("T" + (getProperty("toolAsName") ? "=" + "\"" + (tool.description.toUpperCase()) + "\"" : toolFormat.format(tool.number)));
    writeBlock(mFormat.format(6));
    dOutput.reset();
    writeBlock(dOutput.format(toolLengthOffset));
    writeComment(tool.comment);

    var preloadTool = getProperty("toolAsName") ? getNextTool(tool.description != getFirstTool().description, "description") : getNextTool(tool.number != getFirstTool().number);
    if (getProperty("preloadTool") && preloadTool) {
      if (getProperty("toolAsName")) {
        writeBlock("T=" + "\"" + preloadTool.description.toUpperCase() + "\"");
      } else {
        writeBlock("T" + toolFormat.format(preloadTool.number));
      }
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
  if (state.tcpIsActive) {
    setTCP(false);
    forceWorkPlane();
  } else {
    if (currentSection.isMultiAxis()) {
      writeBlock("FGROUP()");
    }
  }
  writeBlock(gFeedModeModal.format(94)); // inverse time feed off
  if (!isLastSection()) {
    if (getNextSection().getTool().coolant != tool.coolant) {
      setCoolant(COOLANT_OFF);
    }
    if (tool.breakControl && isToolChangeNeeded(getNextSection(), getProperty("toolAsName") ? "description" : "number")) {
      onCommand(COMMAND_BREAK_CONTROL);
    }
  }

  if (subprogramsAreSupported()) {
    subprogramEnd();
  }

  if (getProperty("useGrouping")) {
    writeBlock("GROUP_END(0, 0)");
  }
  if (typeof inspectionProcessSectionEnd == "function") {
    inspectionProcessSectionEnd();
  }
  forceAny();
}

function onClose() {
  optionalSection = false;
  writeln("");
  setCoolant(COOLANT_OFF);
  onCommand(COMMAND_STOP_SPINDLE);

  writeRetract(Z);
  setWorkPlane(new Vector(0, 0, 0)); // reset working plane
  cancelWorkPlane(true);

  if (getProperty("useParkPosition")) {
    if (getSetting("retract.homeXY.onProgramEnd", false)) {
      writeRetract(settings.retract.homeXY.onProgramEnd);
    }
  }
  if (typeof inspectionProcessSectionEnd == "function") {
    inspectionProcessSectionEnd();
  }
  writeBlock(mFormat.format(30)); // stop program, spindle stop, coolant off
  if (subprogramsAreSupported()) {
    writeSubprograms();
  }
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
  var comments = String(text).split(EOL);
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
  if (revision < 50198 || skipBlocks) {
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
// >>>>> INCLUDED FROM include_files/workPlaneFunctions_siemens.cpi
var currentWorkPlaneABC = undefined;
function forceWorkPlane() {
  currentWorkPlaneABC = undefined;
}

function cancelWorkPlane(force) {
  if (!settings.workPlaneMethod.forceMultiAxisIndexing && is3D() && !force) {
    return; // ignore
  }
  if (!is3D() && settings.workPlaneMethod.useTiltedWorkplane) {
    if (state.twpIsActive || force) {
      writeBlock("CYCLE800()");
      state.twpIsActive = false;
      machineSimulation({}); // update machine simulation TWP state
      forceWorkPlane();
    }
  }
}

/** Returns the CYCLE800 configuration to use for the selected mode. */
function getCycle800Config(abc) {
  var options = [];
  switch (getProperty("cycle800Mode")) {
  case "39":
    options.push(39, abc, EULER_ZXY_R);
    break;
  case "27":
    options.push(27, abc, EULER_ZYX_R);
    break;
  case "57":
    options.push(57, abc, EULER_XYZ_R);
    break;
  case "45":
    options.push(45, abc, EULER_XZY_R);
    break;
  case "30":
    options.push(30, abc, EULER_YZX_R);
    break;
  case "54":
    options.push(54, abc, EULER_YXZ_R);
    break;
  case "192":
    if (!machineConfiguration.isMultiAxisConfiguration()) {
      error(localize("CYCL800 Mode 192 cannot be used without a multi-axis machine configuration."));
      return options;
    }
    var abcDirect = new Vector(0, 0, 0);
    var axes = new Array(machineConfiguration.getAxisU(), machineConfiguration.getAxisV(), machineConfiguration.getAxisW());
    for (var i = 0; i < machineConfiguration.getNumberOfAxes() - 3; ++i) {
      if (axes[i].isEnabled()) {
        abcDirect.setCoordinate(i, abc.getCoordinate(axes[i].getCoordinate()));
      }
    }
    options.push(192, abcDirect);
    break;
  default:
    error(localize("Unknown CYCLE800 mode selected."));
    return undefined;
  }
  return options;
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
      var cycle800Config = getCycle800Config(abc);
      var DIR = integerFormat.format(-1); // direction
      if (machineConfiguration.isMultiAxisConfiguration()) {
        var machineABC = abc.isNonZero() ? (currentSection.isMultiAxis() ? getCurrentDirection() : getWorkPlaneMachineABC(currentSection, false)) : abc;
        DIR = integerFormat.format(abcFormat.getResultingValue(machineABC.getCoordinate(machineConfiguration.getAxisU().getCoordinate())) >= 0 ? 1 : -1);
        if (settings.workPlaneMethod.useABCPrepositioning || machineABC.isZero()) {
          positionABC(machineABC, false);
        } else {
          setCurrentABC(machineABC);
        }
      }

      var FR = getProperty("cycle800RetractMethod"); // 0 = without moving to safety plane, 1 = move to safety plane only in Z, 2 = move to safety plane Z,X,Y
      var TC = "\"" + getProperty("cycle800SwivelDataRecord") + "\"";
      var ST = integerFormat.format(0);
      var MODE = cycle800Config[0];
      var X0 = integerFormat.format(0);
      var Y0 = integerFormat.format(0);
      var Z0 = integerFormat.format(0);
      var A = abcFormat.format(cycle800Config[1].x);
      var B = abcFormat.format(cycle800Config[1].y);
      var C = abcFormat.format(cycle800Config[1].z);
      var X1 = integerFormat.format(0);
      var Y1 = integerFormat.format(0);
      var Z1 = integerFormat.format(0);
      var FR_I = "";
      var DMODE = integerFormat.format(0); // keep the previous plane active
      writeBlock(
        "CYCLE800(" + [FR, TC, ST, MODE, X0, Y0, Z0, A, B, C, X1, Y1, Z1, DIR +
            (getProperty("useExtendedCycles") ? ("," + [FR_I, DMODE].join(",")) : "")].join(",") + ")"
      );
      state.twpIsActive = abc.isNonZero();
      machineSimulation({a:getCurrentABC().x, b:getCurrentABC().y, c:getCurrentABC().z, coordinates:MACHINE, eulerAngles:abc});
    } else {
      positionABC(abc, true);
    }
    forceABC();
    forceXYZ();

    if (!currentSection.isMultiAxis()) {
      onCommand(COMMAND_LOCK_MULTI_AXIS);
    }
    currentWorkPlaneABC = abc;
  });
}
// <<<<< INCLUDED FROM include_files/workPlaneFunctions_siemens.cpi
// >>>>> INCLUDED FROM include_files/initialPositioning_siemens.cpi
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
  var motionCode = {single:0, multi:0};
  switch (highFeedMapping) {
  case HIGH_FEED_MAP_ANY:
    motionCode = {single:1, multi:1}; // map all rapid traversals to high feed
    break;
  case HIGH_FEED_MAP_MULTI:
    motionCode = {single:0, multi:1}; // map rapid traversal along more than one axis to high feed
    break;
  }
  var feed = (highFeedMapping != HIGH_FEED_NO_MAPPING) ? getFeed(highFeedrate) : "";
  var additionalCodes = [formatWords(codes1), formatWords(codes2)];

  forceModals(gMotionModal);
  writeStartBlocks(isRequired, function() {
    var modalCodes = formatWords(gAbsIncModal.format(90), gPlaneModal.format(17));
    // multi axis prepositioning with TWP
    if (machineConfiguration.isHeadConfiguration()) { // head/head head/table kinematics
      var machineABC = currentSection.isMultiAxis() ? defineWorkPlane(currentSection, false) : getWorkPlaneMachineABC(currentSection, false);
      machineConfiguration.setToolLength(getSetting("workPlaneMethod.compensateToolLength", false) ? getBodyLength(currentSection.getTool()) : 0); // define the tool length for head adjustments
      var mode = currentSection.isOptimizedForMachine() ? TCP_XYZ_OPTIMIZED : TCP_XYZ;
      var globalPosition = getGlobalPosition(currentSection.getInitialPosition());
      var machinePosition = machineConfiguration.getOptimizedPosition(globalPosition, machineABC, mode, OPTIMIZE_BOTH, true);

      cancelWorkPlane();
      positionABC(machineABC);
      var prePosition;
      if (currentSection.isOptimizedForMachine()) {
        prePosition = position;
      } else if (settings.workPlaneMethod.useTiltedWorkplane) {
        prePosition = currentSection.isMultiAxis() ? position : (tcp.isSupportedByMachine ? globalPosition : machinePosition);
      } else {
        prePosition = currentSection.isMultiAxis() ? position : globalPosition;
      }

      if (tcp.isSupportedByMachine) {
        setTCP(true); // force TCP for prepositioning although the operation may not require it
      }

      writeBlock(modalCodes, gMotionModal.format(motionCode.multi),
        xOutput.format(prePosition.x), yOutput.format(prePosition.y), feed, additionalCodes[0]);
      machineSimulation({x:prePosition.x, y:prePosition.y});
      writeBlock(modalCodes, gMotionModal.format(motionCode.multi), zOutput.format(prePosition.z), feed, additionalCodes[1]);
      machineSimulation({z:prePosition.z});

      setTCP(tcp.isSupportedByOperation); // enable/disable TCP depending if it is supported by the operation
      if (!currentSection.isMultiAxis()) {
        var saveCycle800RetractMode = getProperty("cycle800RetractMethod", undefined);
        if (saveCycle800RetractMode != undefined) {
          setProperty("cycle800RetractMethod", "0"); // disable CYCLE800 retract during prepositioning for head kinematics
        }
        var saveRetractedState = [state.retractedX, state.retractedY, state.retractedZ];
        state.retractedX = state.retractedY = state.retractedZ = true; // set retracted states to true to avoid retraction
        defineWorkPlane(currentSection, true);
        [state.retractedX, state.retractedY, state.retractedZ] = saveRetractedState; // restore retracted states
        if (saveCycle800RetractMode != undefined) {
          setProperty("cycle800RetractMethod", saveCycle800RetractMode); // reset CYCLE800 retract mode
        }
      }
    } else {
      if (currentSection.isMultiAxis() && getSetting("workPlaneMethod.prepositionWithTWP", true) && getSetting("workPlaneMethod.useTiltedWorkplane", false) &&
      tcp.isSupportedByOperation && getCurrentDirection().isNonZero()) {
        var W = machineConfiguration.isMultiAxisConfiguration() ? machineConfiguration.getOrientation(getCurrentDirection()) :
          Matrix.getOrientationFromDirection(getCurrentDirection());
        var prePosition = W.getTransposed().multiply(position);
        var angles = settings.workPlaneMethod.eulerConvention != undefined ? W.getEuler2(settings.workPlaneMethod.eulerConvention) : getCurrentDirection();
        setWorkPlane(angles, true);
        writeBlock(modalCodes, gMotionModal.format(motionCode.multi), xOutput.format(prePosition.x), yOutput.format(prePosition.y), feed, additionalCodes[0]);
        machineSimulation({x:prePosition.x, y:prePosition.y});
        cancelWorkPlane();
        writeBlock(additionalCodes[1]); // omit Z-axis output is desired
        forceAny(); // required to output XYZ coordinates in the following line

        if (tcp.isSupportedByOperation) {
          setTCP(true);
        }
      } else {
        if (tcp.isSupportedByOperation) {
          setTCP(true);
        }
        writeBlock(modalCodes, gMotionModal.format(motionCode.multi), xOutput.format(position.x), yOutput.format(position.y), feed, additionalCodes[0]);
        machineSimulation({x:position.x, y:position.y});
        writeBlock(gMotionModal.format(motionCode.single), zOutput.format(position.z), additionalCodes[1]);
        machineSimulation(tcp.isSupportedByOperation ? {x:position.x, y:position.y, z:position.z} : {z:position.z});
      }
    }

    forceModals(gMotionModal);
    if (isRequired) {
      additionalCodes = []; // clear additionalCodes buffer
    }
  });

  if (!isRequired) { // simple positioning
    var modalCodes = formatWords(gAbsIncModal.format(90), gPlaneModal.format(17));
    forceXYZ();
    if (!state.retractedZ && xyzFormat.getResultingValue(getCurrentPosition().z) < xyzFormat.getResultingValue(position.z)) {
      writeBlock(modalCodes, gMotionModal.format(motionCode.single), zOutput.format(position.z), feed);
      machineSimulation({z:position.z});
    }
    writeBlock(modalCodes, gMotionModal.format(motionCode.multi), xOutput.format(position.x), yOutput.format(position.y), feed, additionalCodes);
    machineSimulation({x:position.x, y:position.y});
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
// <<<<< INCLUDED FROM include_files/initialPositioning_siemens.cpi
// >>>>> INCLUDED FROM include_files/positionABC.cpi
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
    gMotionModal.reset();
    writeBlock(gMotionModal.format(0), a, b, c);
    setCurrentABC(abc); // required for machine simulation
    machineSimulation({a:abc.x, b:abc.y, c:abc.z, coordinates:MACHINE});
  }
}
// <<<<< INCLUDED FROM include_files/positionABC.cpi
// >>>>> INCLUDED FROM include_files/writeWCS.cpi
function writeWCS(section, wcsIsRequired) {
  if (section.workOffset != currentWorkOffset) {
    if (getSetting("workPlaneMethod.cancelTiltFirst", false) && wcsIsRequired) {
      cancelWorkPlane();
    }
    if (typeof forceWorkPlane == "function" && wcsIsRequired) {
      forceWorkPlane();
    }
    writeStartBlocks(wcsIsRequired, function () {
      writeBlock(section.wcs);
    });
    currentWorkOffset = section.workOffset;
  }
}
// <<<<< INCLUDED FROM include_files/writeWCS.cpi
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
// >>>>> INCLUDED FROM include_files/writeWorkPiece.cpi
// Calculate stock extents for a cylinder or tube
// Returns a vector with lower limit in x, upper limit in y, and diameter in z
function getStockExtents(workpiece) {
  var extents = new Vector(0, 0, toPreciseUnit(getGlobalParameter("stock-diameter", 0), MM));
  var stockType = getGlobalParameter("stock-type", "");
  if (stockType == "cylinder" || stockType == "tube") {
    if (xyzFormat.getResultingValue(workpiece.upper.x - workpiece.lower.x) != xyzFormat.getResultingValue(extents.z)) {
      extents.setX(workpiece.lower.x);
      extents.setY(workpiece.upper.x);
    } else if (xyzFormat.getResultingValue(workpiece.upper.y - workpiece.lower.y) != xyzFormat.getResultingValue(extents.z)) {
      extents.setX(workpiece.lower.y);
      extents.setY(workpiece.upper.y);
    } else if (xyzFormat.getResultingValue(workpiece.upper.z - workpiece.lower.z) != xyzFormat.getResultingValue(extents.z)) {
      extents.setX(workpiece.lower.z);
      extents.setY(workpiece.upper.z);
    } else { // the cylinder forms a square cube, determine the axis based on the rotary table
      if (machineConfiguration.isMultiAxisConfiguration()) {
        var ix;
        if (machineConfiguration.getAxisV().isEnabled() && machineConfiguration.getAxisV().isTable()) {
          ix = machineConfiguration.getAxisV().getCoordinate();
        } else if (machineConfiguration.getAxisU().isEnabled() && machineConfiguration.getAxisU().isTable()) {
          ix = machineConfiguration.getAxisV().getCoordinate();
        } else { // could not determine cylinder axis
          return undefined;
        }
        extents.setX(workpiece.lower.getCoordinate(ix));
        extents.setY(workpiece.upper.getCoordinate(ix));
      }
    }
  } else {
    return undefined;
  }
  return extents;
}

var axisDesignators = new Array("A", "B", "C");
function writeWorkPiece() {
  if (hasGlobalParameter("stock-type")) {
    var workpiece = getWorkpiece();
    var workpieceType = getGlobalParameter("stock-type");
    var delta = Vector.diff(workpiece.upper, workpiece.lower);
    if (workpieceType != "custom" && delta.isNonZero()) { // stock - workpiece
      // determine table that stock is placed on
      var referencePoint = "\"\"";
      if (machineConfiguration.isMultiAxisConfiguration()) {
        if (machineConfiguration.getAxisV().isEnabled() && machineConfiguration.getAxisV().isTable()) {
          referencePoint = "\"" + axisDesignators[machineConfiguration.getAxisV().getCoordinate()] + "\"";
        } else if (machineConfiguration.getAxisU().isEnabled() && machineConfiguration.getAxisU().isTable()) {
          referencePoint = "\"" + axisDesignators[machineConfiguration.getAxisU().getCoordinate()] + "\"";
        }
      }
      var extents = getStockExtents(workpiece);
      var parameters = []; // array to store WORKPIECE parameters by their index

      parameters[1] = referencePoint;
      switch (workpieceType) {
      case "box":
        parameters[3] = "\"" + "BOX" + "\""; // stock shape
        parameters[4] = 112;
        parameters[5] = xyzFormat.format(workpiece.upper.z);
        parameters[6] = xyzFormat.format(workpiece.lower.z);
        parameters[8] = xyzFormat.format(workpiece.upper.x);
        parameters[9] = xyzFormat.format(workpiece.upper.y);
        parameters[10] = xyzFormat.format(workpiece.lower.x);
        parameters[11] = xyzFormat.format(workpiece.lower.y);
        break;
      case "tube":
      case "cylinder":
        parameters[3] = "\"" + (workpieceType == "tube" ? "PIPE" : "CYLINDER") + "\""; // stock shape
        parameters[4] = workpieceType == "tube" ? 320 : 64;
        if (!extents) {
          break;
        }
        parameters[5] = xyzFormat.format(extents.y);
        parameters[6] = xyzFormat.format(extents.x);
        parameters[8] = xyzFormat.format(extents.z);
        if (workpieceType == "tube") {
          parameters[9] = xyzFormat.format(toPreciseUnit(getGlobalParameter("stock-diameter-inner"), MM));
        }
        break;
      }
      writeBlock("WORKPIECE" + "(" + parameters.join() + ")");
    }
  }
}
// <<<<< INCLUDED FROM include_files/writeWorkPiece.cpi
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
          } else if (!areSpatialBoxesTranslated(masterPosition, patternPosition) || !areSpatialBoxesTranslated(masterBox, patternBox)) {
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

// >>>>> INCLUDED FROM include_files/onRapid_fanuc.cpi
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
// <<<<< INCLUDED FROM include_files/onRapid_fanuc.cpi
// >>>>> INCLUDED FROM include_files/onLinear_siemens.cpi
function onLinear(_x, _y, _z, feed) {
  if (pendingRadiusCompensation >= 0) {
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
      if (getProperty("useTOFFR")) {
        if (getParameter("operation:compensationType") == "wear") {
          writeBlock("TOFFR = -" + tool.diameter / 2);
        } else if (getParameter("operation:compensationType") == "inverseWear") {
          writeBlock("TOFFR = " + tool.diameter / 2);
        }
      }
      writeBlock(gPlaneModal.format(17));
      switch (radiusCompensation) {
      case RADIUS_COMPENSATION_LEFT:
        writeBlock(gMotionModal.format(1), gFormat.format(41), x, y, z, f);
        break;
      case RADIUS_COMPENSATION_RIGHT:
        writeBlock(gMotionModal.format(1), gFormat.format(42), x, y, z, f);
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
// <<<<< INCLUDED FROM include_files/onLinear_siemens.cpi
// >>>>> INCLUDED FROM include_files/onRapid5D_fanuc.cpi
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

  if (x || y || z || a || b || c) {
    writeBlock(gMotionModal.format(0), x, y, z, a, b, c);
    forceFeed();
  }
}
// <<<<< INCLUDED FROM include_files/onRapid5D_fanuc.cpi
// >>>>> INCLUDED FROM include_files/onCircular_siemens.cpi
function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
    return;
  }
  if (getProperty("useSmoothing", -1) != -1) {
    linearize(tolerance);
    return;
  }

  writeBlock(gPlaneModal.format(17));
  var start = getCurrentPosition();
  var revolutions = xyzFormat.getResultingValue(Math.abs(getCircularSweep()) / (2 * Math.PI));
  var turns = useArcTurn ? (revolutions % 1) == 0 ? revolutions - 1 : Math.floor(revolutions) : 0; // full turns

  if (isFullCircle()) {
    if (isHelical()) {
      linearize(tolerance);
      return;
    }
    if (turns > 1) {
      error(localize("Multiple turns are not supported."));
      return;
    }
    // G90/G91 are dont care when we do not used XYZ
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), iOutput.format(cx - start.x), jOutput.format(cy - start.y), getFeed(feed));
      break;
    case PLANE_ZX:
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), iOutput.format(cx - start.x), kOutput.format(cz - start.z), getFeed(feed));
      break;
    case PLANE_YZ:
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), jOutput.format(cy - start.y), kOutput.format(cz - start.z), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  } else if (useArcTurn && !getProperty("useRadius")) { // IJK mode
    switch (getCircularPlane()) {
    case PLANE_XY:
      if (isHelical()) {
        xOutput.reset();
        yOutput.reset();
      }
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x), jOutput.format(cy - start.y), getFeed(feed), turns > 0 ? "TURN=" + turns : "");
      break;
    case PLANE_ZX:
      if (isHelical()) {
        xOutput.reset();
        zOutput.reset();
      }
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x), kOutput.format(cz - start.z), getFeed(feed), turns > 0 ? "TURN=" + turns : "");
      break;
    case PLANE_YZ:
      if (isHelical()) {
        yOutput.reset();
        zOutput.reset();
      }
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), jOutput.format(cy - start.y), kOutput.format(cz - start.z), getFeed(feed), turns > 0 ? "TURN=" + turns : "");
      break;
    default:
      if (turns > 1) {
        error(localize("Multiple turns are not supported."));
        return;
      }
      if (getProperty("useCIP")) { // allow CIP
        var ip = getPositionU(0.5);
        writeBlock(
          "CIP",
          xOutput.format(x),
          yOutput.format(y),
          zOutput.format(z),
          "I1=" + xyzFormat.format(ip.x),
          "J1=" + xyzFormat.format(ip.y),
          "K1=" + xyzFormat.format(ip.z),
          getFeed(feed)
        );
        forceModals(gMotionModal, gPlaneModal);
      } else {
        linearize(tolerance);
      }
    }
  } else { // use radius mode
    if (isHelical()) {
      linearize(tolerance);
      return;
    }
    var r = getCircularRadius();
    if (toDeg(getCircularSweep()) > (180 + 1e-9)) {
      r = -r; // allow up to <360 deg arcs
    }
    forceXYZ();

    // radius mode is only supported on PLANE_XY
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), "CR=" + xyzFormat.format(r), getFeed(feed));
      break;
    case PLANE_ZX:
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), zOutput.format(z), iOutput.format(cx - start.x), kOutput.format(cz - start.z), getFeed(feed));
      break;
    case PLANE_YZ:
      writeBlock(gMotionModal.format(clockwise ? 2 : 3), yOutput.format(y), zOutput.format(z), jOutput.format(cy - start.y), kOutput.format(cz - start.z), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  }
}
// <<<<< INCLUDED FROM include_files/onCircular_siemens.cpi
// >>>>> INCLUDED FROM include_files/rotaryRadii.cpi
var rotaryRadiiTol = toPreciseUnit(2, MM);
var previousRotaryRadii = new Vector(0, 0, 0);

function setRotaryRadii(startTool, endTool, startABC, endABC) {
  var radii = getRotaryRadii(startTool, endTool, startABC, endABC);
  var axis = new Array(machineConfiguration.getAxisU(), machineConfiguration.getAxisV(), machineConfiguration.getAxisW());
  for (var i = 0; i < 3; ++i) {
    if (axis[i].isEnabled()) {
      var ix = axis[i].getCoordinate();
      if (Math.abs(radii.getCoordinate(ix) - previousRotaryRadii.getCoordinate(ix)) > rotaryRadiiTol) {
        writeBlock("FGREF[" + axisDesignators[ix] + "] = " + xyzFormat.format(radii.getCoordinate(ix)));
        previousRotaryRadii.setCoordinate(ix, radii.getCoordinate(ix));
      }
    }
  }
}

/** Calculate radius for each rotary axis. */
function getRotaryRadii(startTool, endTool, startABC, endABC) {
  var radii = new Vector(0, 0, 0);
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
      pivot = getBodyLength(currentSection.getTool());
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
// <<<<< INCLUDED FROM include_files/rotaryRadii.cpi
// >>>>> INCLUDED FROM include_files/writeRetract_siemens.cpi
function writeRetract() {
  var retract = getRetractParameters.apply(this, arguments);
  if (retract && retract.words.length > 0) {
    for (var i in retract.words) {
      var words = retract.singleLine ? retract.words : retract.words[i];
      switch (retract.method) {
      case "G28":
        forceModals(gMotionModal, gAbsIncModal);
        writeBlock(gFormat.format(28), gAbsIncModal.format(91), words);
        writeBlock(gAbsIncModal.format(90));
        break;
      case "G30":
        forceModals(gMotionModal, gAbsIncModal);
        writeBlock(gFormat.format(30), gAbsIncModal.format(91), words);
        writeBlock(gAbsIncModal.format(90));
        break;
      case "G53":
        forceModals(gMotionModal);
        writeBlock(gAbsIncModal.format(90), gFormat.format(53), gMotionModal.format(0), words, dOutput.format(0));
        writeBlock(dOutput.format(toolLengthOffset));
        break;
      case "SUPA":
      case "SUPAVariables":
        if (retract.method == "SUPAVariables") {
          words = []; // clear words array and add axes variables
          words.push(retract.retractAxes[0] ? "X = _XHOME" : "");
          words.push(retract.retractAxes[1] ? "Y = _YHOME" : "");
          words.push(retract.retractAxes[2] ? "Z = _ZHOME" : "");
        }
        gMotionModal.reset();
        writeBlock(gMotionModal.format(0), "SUPA", words, dOutput.format(0)); // retract
        writeBlock(dOutput.format(toolLengthOffset));
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
// <<<<< INCLUDED FROM include_files/writeRetract_siemens.cpi
// >>>>> INCLUDED FROM include_files/drillCycles_siemens.cpi
function writeDrillCycle(cycle, x, y, z) {
  if (!isSameDirection(machineConfiguration.getSpindleAxis(), getForwardDirection(currentSection))) {
    expandCyclePoint(x, y, z);
    return;
  }

  writeBlock(gFeedModeModal.format(94));
  if (isFirstCyclePoint()) {
    if (!isTappingCycle()) {
      writeBlock(feedOutput.format(cycle.feedrate));
    }

    var RTP;
    var RFP;
    var SDIS;
    var DP;
    var DPR;
    var DTB;
    var SDIR;
    if (tool.type != TOOL_PROBE) {
      RTP = xyzFormat.format(cycle.clearance); // return plane (absolute)
      RFP = xyzFormat.format(cycle.stock); // reference plane (absolute)
      SDIS = xyzFormat.format(cycle.retract - cycle.stock); // safety distance
      DP = xyzFormat.format(cycle.bottom); // depth (absolute)
      DPR = ""; // depth (relative to reference plane)
      DTB = secFormat.format(cycle.dwell);
      SDIR = integerFormat.format(tool.clockwise ? 3 : 4); // direction of rotation: M3:3 and M4:4
    }

    if (cycleType == "chip-breaking" && (cycle.accumulatedDepth < cycle.depth)) {
      expandCyclePoint(x, y, z);
      return;
    }
    if (xyzFormat.getResultingValue(cycle.clearance) > xyzFormat.getResultingValue(getCurrentPosition().z)) {
      writeBlock(gMotionModal.format(0), zOutput.format(cycle.clearance));
    }
    switch (cycleType) {
    case "drilling":
      var _GMODE = integerFormat.format(0);
      var _DMODE = integerFormat.format(0); // keep the programmed plane active
      var _AMODE = integerFormat.format(10); // dwell is programmed in seconds and depth is taken from DP DPR settings
      writeBlock(
        "MCALL CYCLE81(" + [RTP, RFP, SDIS, DP, DPR +
          (getProperty("useExtendedCycles") ? (cycleSeparator + [_GMODE, _DMODE, _AMODE].join(cycleSeparator)) : "")].join(cycleSeparator) + ")"
      );
      break;
    case "counter-boring":
      var _GMODE = integerFormat.format(0);
      var _DMODE = integerFormat.format(0); // keep the programmed plane active
      var _AMODE = integerFormat.format(10); // dwell is programmed in seconds and depth is taken from DP DPR settings
      writeBlock(
        "MCALL CYCLE82(" + [RTP, RFP, SDIS, DP, DPR, DTB +
          (getProperty("useExtendedCycles") ? (cycleSeparator + [_GMODE, _DMODE, _AMODE].join(", ")) : "")].join(cycleSeparator) + ")"
      );
      break;
    case "chip-breaking":
      // add support for accumulated depth
      var FDEP = xyzFormat.format(cycle.stock - cycle.incrementalDepth);
      var FDPR = ""; // relative to reference plane (unsigned)
      var _DAM = xyzFormat.format(cycle.incrementalDepthReduction); // degression (unsigned)
      DTB = "";
      var DTS = secFormat.format(0); // dwell time at start
      var FRF = xyzFormat.format(1); // feedrate factor (unsigned)
      var VARI = integerFormat.format(0); // chip breaking
      var _AXN = ""; // tool axis
      var _MDEP = xyzFormat.format((cycle.incrementalDepthReduction > 0) ? cycle.minimumIncrementalDepth : cycle.incrementalDepth); // minimum drilling depth
      var _VRT = xyzFormat.format(cycle.chipBreakDistance); // retraction distance
      var _DTD = secFormat.format((cycle.dwell != undefined) ? cycle.dwell : 0);
      var _DIS1 = integerFormat.format(0); // limit distance
      var _GMODE = integerFormat.format(0); // drilling with respect to the tip
      var _DMODE = integerFormat.format(0); // keep the programmed plane active
      var _AMODE = integerFormat.format(1001110);
      writeBlock(
        "MCALL CYCLE83(" + [RTP, RFP, SDIS, DP, DPR, FDEP, FDPR, _DAM, DTB, DTS, FRF, VARI, _AXN, _MDEP, _VRT, _DTD, _DIS1 +
            (getProperty("useExtendedCycles") ? (cycleSeparator + [_GMODE, _DMODE, _AMODE].join(cycleSeparator)) : "")].join(cycleSeparator) + ")"
      );
      break;
    case "deep-drilling":
      var FDEP = xyzFormat.format(cycle.stock - cycle.incrementalDepth);
      var FDPR = ""; // relative to reference plane (unsigned)
      var _DAM = xyzFormat.format(cycle.incrementalDepthReduction); // degression (unsigned)
      var DTS = secFormat.format(0); // dwell time at start
      var FRF = xyzFormat.format(1); // feedrate factor (unsigned)
      var VARI = integerFormat.format(1); // full retract
      var _AXN = ""; // tool axis
      var _MDEP = xyzFormat.format((cycle.incrementalDepthReduction > 0) ? cycle.minimumIncrementalDepth : cycle.incrementalDepth); // minimum drilling depth
      var _VRT = xyzFormat.format(cycle.chipBreakDistance ? cycle.chipBreakDistance : 0); // retraction distance
      var _DTD = secFormat.format((cycle.dwell != undefined) ? cycle.dwell : 0);
      var _DIS1 = integerFormat.format(0); // limit distance
      var _GMODE = integerFormat.format(0); // drilling with respect to the tip
      var _DMODE = integerFormat.format(0); // keep the programmed plane active
      var _AMODE = integerFormat.format(1001110);
      writeBlock(
        "MCALL CYCLE83(" + [RTP, RFP, SDIS, DP, DPR, FDEP, FDPR, _DAM, DTB, DTS, FRF, VARI, _AXN, _MDEP, _VRT, _DTD, _DIS1 +
          (getProperty("useExtendedCycles") ? (cycleSeparator + [_GMODE, _DMODE, _AMODE].join(cycleSeparator)) : "")].join(cycleSeparator) + ")"
      );

      break;
    case "tapping":
    case "left-tapping":
    case "right-tapping":
      var SDAC = SDIR; // direction of rotation after end of cycle
      var MPIT = ""; // thread pitch as thread size
      var PIT = xyzFormat.format(tool.threadPitch); // thread pitch
      var POSS = xyzFormat.format(0); // spindle position for oriented spindle stop in cycle (in degrees)
      var SST = rpmFormat.format(spindleSpeed); // speed for tapping
      var SST1 = rpmFormat.format(spindleSpeed); // speed for return
      var _AXN = integerFormat.format(0); // tool axis
      var _PITA = integerFormat.format((unit == MM) ? 1 : 3);
      var _TECHNO = ""; // technology settings
      var _VARI = integerFormat.format(0); // machining type: 0 = tapping full depth, 1 = tapping partial retract, 2 = tapping full retract
      var _DAM = ""; // incremental depth
      var _VRT = ""; // retract distance for chip breaking
      var _PITM = ""; // string for pitch input (not used)
      var _PTAB = ""; // string for thread table (not used)
      var _PTABA = ""; // string for selection from thread table (not used)
      var _GMODE = integerFormat.format(0); // reserved (geometrical mode)
      var _DMODE = integerFormat.format(0); // units and active spindle (0 for tool spindle, 100 for turning spindle)
      var _AMODE = integerFormat.format((tool.type == TOOL_TAP_LEFT_HAND) ? 1002002 : 1001002); // alternate mode
      writeBlock(
        "MCALL CYCLE84(" + [RTP, RFP, SDIS, DP, DPR, DTB, SDAC, MPIT, PIT, POSS, SST, SST1, _AXN, _PITA, _TECHNO, _VARI, _DAM, _VRT, _PITM, _PTAB, _PTABA +
            (getProperty("useExtendedCycles") ? (cycleSeparator + [_GMODE, _DMODE, _AMODE].join(cycleSeparator)) : "")].join(cycleSeparator) + ")"
      );
      break;
    case "tapping-with-chip-breaking":
      if (cycle.accumulatedDepth < cycle.depth) {
        error(localize("Accumulated pecking depth is not supported for canned tapping cycles with chip breaking."));
        return;
      }
      var SDAC = SDIR; // direction of rotation after end of cycle
      var MPIT = ""; // thread pitch as thread size
      var PIT = xyzFormat.format(tool.threadPitch); // thread pitch
      var POSS = xyzFormat.format(0); // spindle position for oriented spindle stop in cycle (in degrees)
      var SST = rpmFormat.format(spindleSpeed); // speed for tapping
      var SST1 = rpmFormat.format(spindleSpeed); // speed for return
      var _AXN = integerFormat.format(0); // tool axis
      var _PITA = integerFormat.format((unit == MM) ? 1 : 3);
      var _TECHNO = ""; // technology settings
      var _VARI = integerFormat.format(1); // machining type: 0 = tapping full depth, 1 = tapping partial retract, 2 = tapping full retract
      var _DAM = xyzFormat.format(cycle.incrementalDepth); // incremental depth
      var _VRT = xyzFormat.format(cycle.chipBreakDistance); // retract distance for chip breaking
      var _PITM = ""; // string for pitch input (not used)
      var _PTAB = ""; // string for thread table (not used)
      var _PTABA = ""; // string for selection from thread table (not used)
      var _GMODE = integerFormat.format(0); // reserved (geometrical mode)
      var _DMODE = integerFormat.format(0); // units and active spindle (0 for tool spindle, 100 for turning spindle)
      var _AMODE = integerFormat.format((tool.type == TOOL_TAP_LEFT_HAND) ? 1002002 : 1001002); // alternate mode

      writeBlock(
        "MCALL CYCLE84(" + [RTP, RFP, SDIS, DP, DPR, DTB, SDAC, MPIT, PIT, POSS, SST, SST1, _AXN, _PITA, _TECHNO, _VARI, _DAM, _VRT, _PITM, _PTAB, _PTABA +
            (getProperty("useExtendedCycles") ? (cycleSeparator + [_GMODE, _DMODE, _AMODE].join(cycleSeparator)) : "")].join(cycleSeparator) + ")"
      );
      break;
    case "reaming":
      var FFR = feedFormat.format(cycle.feedrate);
      var RFF = feedFormat.format(cycle.retractFeedrate);
      var _GMODE = integerFormat.format(0); // reserved
      var _DMODE = integerFormat.format(0); // keep current plane active
      var _AMODE = integerFormat.format(0); // compatibility from DP and DT programming
      writeBlock(
        "MCALL CYCLE85(" + [RTP, RFP, SDIS, DP, DPR, DTB, FFR, RFF +
            (getProperty("useExtendedCycles") ? (cycleSeparator + [_GMODE, _DMODE, _AMODE].join(cycleSeparator)) : "")].join(cycleSeparator) + ")"
      );
      break;
    case "stop-boring":
      if (cycle.dwell > 0) {
        writeBlock(
          "MCALL CYCLE88(" + [RTP, RFP, SDIS, DP, DPR, DTB, SDIR].join(cycleSeparator) + ")"
        );
      } else {
        writeBlock(
          "MCALL CYCLE87(" + [RTP, RFP, SDIS, DP, DPR, SDIR].join(cycleSeparator) + ")"
        );
      }
      break;
    case "fine-boring":
      var RPA = xyzFormat.format(-Math.cos(cycle.shiftOrientation) * cycle.shift); // return path in abscissa of the active plane (enter incrementally with)
      var RPO = xyzFormat.format(-Math.sin(cycle.shiftOrientation) * cycle.shift); // return path in the ordinate of the active plane (enter incrementally sign)
      var RPAP = xyzFormat.format(0); // return plane in the applicate (enter incrementally with sign)
      var POSS = xyzFormat.format(toDeg(cycle.shiftOrientation)); // spindle position for oriented spindle stop in cycle (in degrees)
      var _GMODE = integerFormat.format(0); // lift off
      var _DMODE = integerFormat.format(0); // keep current plane active
      var _AMODE = integerFormat.format(10); // dwell in seconds and keep units abs/inc setting from DP/DPR
      writeBlock(
        "MCALL CYCLE86(" + [RTP, RFP, SDIS, DP, DPR, DTB, SDIR, RPA, RPO, RPAP, POSS +
          (getProperty("useExtendedCycles") ? (cycleSeparator + [_GMODE, _DMODE, _AMODE].join(cycleSeparator)) : "")].join(cycleSeparator) + ")"
      );
      break;
    case "boring":
      // retract feed is ignored
      writeBlock(
        "MCALL CYCLE89(" + [RTP, RFP, SDIS, DP, DPR, DTB].join(cycleSeparator) + ")"
      );
      break;
    default:
      expandCyclePoint(x, y, z);
    }
    if (!cycleExpanded) {
      if (subprogramsAreSupported()) { // place cycle operation in subprogram
        handleCycleSubprogram(new Vector(x, y, z), new Vector(0, 0, 0), false);
        if (subprogramState.incrementalMode) { // set current position to clearance height
          setCyclePosition(cycle.clearance);
        }
      }
      forceXYZ();
      if ((currentSection.getPolarMode && currentSection.getPolarMode() != POLAR_MODE_OFF) && currentSection.isMultiAxis()) {
        var polarPosition = getPolarPosition(x, y, z);
        setCurrentPositionAndDirection(polarPosition);
        writeBlock(xOutput.format(polarPosition.first.x), yOutput.format(polarPosition.first.y), aOutput.format(polarPosition.second.x),
          bOutput.format(polarPosition.second.y), cOutput.format(polarPosition.second.z));
      } else {
        writeBlock(xOutput.format(x), yOutput.format(y));
      }
    }
  } else {
    if (!cycleExpanded) {
      if (subprogramsAreSupported() && subprogramState.incrementalMode) { // set current position to clearance height
        setCyclePosition(cycle.clearance);
      }
      if ((currentSection.getPolarMode && currentSection.getPolarMode() != POLAR_MODE_OFF) && currentSection.isMultiAxis()) {
        var polarPosition = getPolarPosition(x, y, z);
        setCurrentPositionAndDirection(polarPosition);
        writeBlock(xOutput.format(polarPosition.first.x), yOutput.format(polarPosition.first.y),
          aOutput.format(polarPosition.second.x), bOutput.format(polarPosition.second.y), cOutput.format(polarPosition.second.z));
      } else {
        writeBlock(xOutput.format(x), yOutput.format(y));
      }
      if (subprogramsAreSupported() && subprogramState.incrementalMode) { // set current position to clearance height
        setCyclePosition(cycle.clearance);
      }
    } else {
      expandCyclePoint(x, y, z);
    }
  }
}
// <<<<< INCLUDED FROM include_files/drillCycles_siemens.cpi
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
// >>>>> INCLUDED FROM include_files/probeCycles_siemens.cpi
function writeProbeCycle(cycle, x, y, z, P, F) {
  if (isProbeOperation()) {
    var _x = xOutput.format(x);
    var _y = yOutput.format(y);
    var _z = zOutput.format(z);
    if (!settings.workPlaneMethod.useTiltedWorkplane && !isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1))) {
      if (!settings.probing.allowIndexingWCSProbing && currentSection.strategy == "probe") {
        error(localize("Updating WCS / work offset using probing is only supported by the CNC in the WCS frame."));
        return;
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

    if (_z && (z >= getCurrentPosition().z)) {
      writeBlock(gMotionModal.format(1), _z, feedOutput.format(cycle.feedrate));
    }
    if (_x || _y) {
      writeBlock(gMotionModal.format(1), _x, _y, feedOutput.format(cycle.feedrate));
    }
    if (_z && (z < getCurrentPosition().z)) {
      writeBlock(gMotionModal.format(1), _z, feedOutput.format(cycle.feedrate));
    }

    currentWorkOffset = undefined;

    var singleLine = getProperty("singleLineProbing");
    var probingArguments = getProbingArguments(cycle, singleLine);

    var _PRNUM = (!singleLine ? "_PRNUM=" : "") + toolProbeFormat.format(1); // Probingtyp, Probingnumber. 3 digits. 1st = (0=Multiprobe, 1=Monoprobe), 2nd/3rd = 2digit Probing-Tool-Number
    var _VMS = (!singleLine ? "_VMS=" : "") + xyzFormat.format(0); // Feed of probing. 0=150mm/min, >1=300m/min
    var _TSA = (!singleLine ? "_TSA=" : "") + (cycleType.indexOf("angle") != -1 ? xyzFormat.format(0.1) : xyzFormat.format(1)); // tolerance (trust area) //angle tolerance (in the simulation he move to the second point with this angle)
    var _NMSP = (!singleLine ? "_NMSP=" : "") + xyzFormat.format(1); // number of measurements at same spot
    var _ID = probingArguments.isIncrementalDepth ? (!singleLine ? "_ID=" : "") + xyzFormat.format(cycle.depth * -1) : undefined; // incremental depth infeed in Z, direction over sign (only by circular boss, wall resp. rectangle and by hole/channel/circular boss/wall with guard zone)
    var _SETVAL = (!probingArguments.isRectangularFeature ? (!singleLine ? "_SETVAL=" : "") : undefined);
    _SETVAL = (cycle.width1 && !probingArguments.isRectangularFeature ? _SETVAL + xyzFormat.format(cycle.width1) : _SETVAL);
    var _SETV0 = (probingArguments.isRectangularFeature ? (!singleLine ? "_SETV[0]=" : "") + (cycle.width1 ? xyzFormat.format(cycle.width1) : (singleLine ? xyzFormat.format(0) : "")) : undefined); // nominal value in X
    var _SETV1 = (probingArguments.isRectangularFeature ? (!singleLine ? "_SETV[1]=" : "") + (cycle.width2 ? xyzFormat.format(cycle.width2) : "") : undefined); // nominal value in Y
    var _DMODE = 0;
    var _FA = (!singleLine ? "_FA=" : "") + // measuring range (distance to surface), total measuring range=2*_FA in mm
      xyzFormat.format(cycle.probeClearance ? cycle.probeClearance : cycle.probeOvertravel);
    var _RA = (probingArguments.isAngleProbing ? (!singleLine ? "_RA=" : "") + xyzFormat.format(0) : undefined); // correction of angle, 0 dont rotate the table;
    var _STA1 = (probingArguments.isAngleProbing ? (!singleLine ? "_STA1=" : "") + xyzFormat.format(0) : undefined); // angle of the plane
    var _TDIF = probingArguments._TDIF;
    var _TNUM = probingArguments._TNUM;
    var _TMV = probingArguments._TMV;
    var _TUL = probingArguments._TUL;
    var _TLL = probingArguments._TLL;
    var _K = (!singleLine ? "_K=" : "");
    var _KNUM = probingArguments._KNUM;
    if (_KNUM == undefined) {
      _KNUM = (!singleLine ? "_KNUM=" + xyzFormat.format(currentSection.probeWorkOffset) : xyzFormat.format(10000 + currentSection.probeWorkOffset)); // automatically input in active workOffset. e.g. _KNUM=1 (G54)
    }

    if (!getProperty("toolAsName") && tool.number >= 100) {
      error(localize("Tool number is out of range for probing. Tool number must be below 100."));
      return;
    }

    if (cycle.updateToolWear) {
      if (getProperty("toolAsName") && !cycle.toolDescription) {
        if (hasParameter("operation-comment")) {
          error(subst(localize("Tool description is empty in operation \"%1\"."), getParameter("operation-comment").toUpperCase()));
        } else {
          error(localize("Tool description is empty."));
        }
        return;
      }
      if (!probingArguments.isAngleProbing) {
        var array = [100, 51, 34, 26, 21, 17, 15, 13, 12, 9, 0];
        var factor = cycle.toolWearErrorCorrection;

        for (var i = 1; i < array.length; ++i) {
          var range = new Range(array[i - 1], array[i]);
          if (range.isWithin(factor)) {
            _K += (factor <= range.getMaximum()) ? i : i + 1;
            break;
          }
        }
      } else {
        _K = undefined;
      }
    } else {
      _K = undefined;
    }

    writeBlock(
      conditional(probingArguments.isWrongSizeAction, "_CBIT[2]=1 "),
      conditional(cycle.updateToolWear, "_CHBIT[3]=1 "), //0 tool data are written in geometry, wear is deleted; 1 difference is written in tool wear data geometry remain unchanged
      conditional(cycle.printResults, "_CHBIT[10]=1 _CHBIT[11]=1")
    );

    var cycleParameters;
    switch (cycleType) {
    case "probing-x":
    case "probing-y":
      cycleParameters = {cycleNumber:978, _MA:cycleType == "probing-x" ? 1 : 2, _MVAR:0};
      _SETVAL += xyzFormat.format((cycleType == "probing-x" ? x : y) + approach(cycle.approach1) * (cycle.probeClearance + tool.diameter / 2));
      writeBlock(gMotionModal.format(1), zOutput.format(z - cycle.depth), feedOutput.format(cycle.feedrate));
      break;
    case "probing-z":
      cycleParameters = {cycleNumber:978, _MA:3, _MVAR:0};
      _SETVAL += xyzFormat.format(z - cycle.depth);
      writeBlock(gMotionModal.format(1), zOutput.format(z - cycle.depth + cycle.probeClearance));
      break;
    case "probing-x-channel":
      cycleParameters = {cycleNumber:977, _MA:1, _MVAR:3};
      writeBlock(gMotionModal.format(1) + " " + zOutput.format(z - cycle.depth));
      break;
    case "probing-x-channel-with-island":
      cycleParameters = {cycleNumber:977, _MA:1, _MVAR:3};
      break;
    case "probing-y-channel":
      cycleParameters = {cycleNumber:977, _MA:2, _MVAR:3};
      writeBlock(gMotionModal.format(1) + " " + zOutput.format(z - cycle.depth));
      break;
    case "probing-y-channel-with-island":
      cycleParameters = {cycleNumber:977, _MA:2, _MVAR:3};
      break;
      /* not supported currently, need min. 3 points to call this cycle (same as heindenhain)
    case "probing-xy-inner-corner":
      cycleParameters = {cycleNumber: 961, _MVAR: 105};
      break;
    case "probing-xy-outer-corner":
      cycleParameters = {cycleNumber: 961, _MVAR: 106};
      _ID = (!singleLine ? "_ID=" : "") + xyzFormat.format(0);
      break;
      */
    case "probing-x-wall":
    case "probing-y-wall":
      cycleParameters = {cycleNumber:977, _MA:cycleType == "probing-x-wall" ? 1 : 2, _MVAR:4};
      break;
    case "probing-xy-circular-hole":
      cycleParameters = {cycleNumber:977, _MVAR:1};
      writeBlock(gMotionModal.format(1) + " " + zOutput.format(cycle.bottom));
      break;
    case "probing-xy-circular-hole-with-island":
      cycleParameters = {cycleNumber:977, _MVAR:1};
      // writeBlock(conditional(cycleType == "probing-xy-circular-hole", gMotionModal.format(1) + " " + zOutput.format(z - cycle.depth)));
      break;
    case "probing-xy-circular-boss":
      cycleParameters = {cycleNumber:977, _MVAR:2};
      break;
    case "probing-xy-rectangular-hole":
      cycleParameters = {cycleNumber:977, _MVAR:5};
      writeBlock(gMotionModal.format(1) + " " + zOutput.format(z - cycle.depth));
      break;
    case "probing-xy-rectangular-boss":
      cycleParameters = {cycleNumber:977, _MVAR:6};
      break;
    case "probing-xy-rectangular-hole-with-island":
      cycleParameters = {cycleNumber:977, _MVAR:5};
      break;
    case "probing-x-plane-angle":
    case "probing-y-plane-angle":
      cycleParameters = {cycleNumber:998, _MA:cycleType == "probing-x-plane-angle" ? 201 : 102, _MVAR:5};
      _ID = (!singleLine ? "_ID=" : "") + xyzFormat.format(cycle.probeSpacing); // distance between points
      _SETVAL += xyzFormat.format((cycleType == "probing-x-plane-angle" ? x : y) + approach(cycle.approach1) * (cycle.probeClearance + tool.diameter / 2));
      writeBlock(gMotionModal.format(1), zOutput.format(z - cycle.depth));
      writeBlock(gMotionModal.format(1), cycleType == "probing-x-plane-angle" ? yOutput.format(y - cycle.probeSpacing / 2) : xOutput.format(x - cycle.probeSpacing / 2));
      break;
    default:
      cycleNotSupported();
    }

    var multiplier = (probingArguments.probeWCS || probingArguments.isAngleProbing) ? 100 : 0; // 1xx for datum shift correction
    multiplier = (cycleType.indexOf("island") != -1) ? 1000 + multiplier : multiplier; // 1xxx for guardian zone
    var _MVAR = cycleParameters._MVAR != undefined ? (!singleLine ? "_MVAR=" : "") + xyzFormat.format(multiplier + cycleParameters._MVAR) : undefined; // CYCLE TYPE
    var _MA = cycleParameters._MA != undefined ? (!singleLine ? "_MA=" : "") + xyzFormat.format(cycleParameters._MA) : undefined;

    var procParam = [];
    if (!singleLine) {
      writeBlock(_TSA, _PRNUM, _VMS, _NMSP, _FA, _TDIF, _TUL, _TLL, _K, _TMV);
      writeBlock(_MVAR, _SETV0, _SETV1, _SETVAL, _MA, _ID, _RA, _STA1, _TNUM, _KNUM);
      writeBlock("CYCLE" + xyzFormat.format(cycleParameters.cycleNumber));
    } else {
      switch (cycleParameters.cycleNumber) {
      case 977:
        procParam = [_MVAR, _KNUM, "", _PRNUM, _SETVAL, _SETV0, _SETV1,
          _FA, _TSA, _STA1, _ID, "", "", _MA, _NMSP, _TNUM,
          "", "", _TDIF, _TUL, _TLL, _TMV, _K, "", "", _DMODE].join(cycleSeparator);
        break;
      case 998:
        procParam = [_MVAR, _KNUM, _RA, _PRNUM, _SETVAL, _STA1,
          "", _FA, _TSA, _MA, "", _ID, _SETV0, _SETV1,
          "", "", _NMSP, "", _DMODE].join(cycleSeparator);
        break;
      case 978:
        procParam = [_MVAR, _KNUM, "", _PRNUM, _SETVAL,
          _FA, _TSA, _MA, "", _NMSP, _TNUM, "", "", _TDIF,
          _TUL, _TLL, _TMV, _K, "", "", _DMODE].join(cycleSeparator);
        break;
      default:
        cycleNotSupported();
      }
      writeBlock(
        ("CYCLE" + xyzFormat.format(cycleParameters.cycleNumber)) + "(" + (procParam) + cycleSeparator + ")"
      );
    }

    if (probingArguments.isOutOfPositionAction) {
      if (cycleParameters.cycleNumber != 977) {
        writeComment("Out of position action is only supported with CYCLE977.");
      } else {
        var positionUpperTolerance = xyzFormat.format(cycle.tolerancePosition);
        var positionLowerTolerance = xyzFormat.format(cycle.tolerancePosition * -1);
        writeBlock(
          "IF((_OVR[5]>" + positionUpperTolerance + ")" +
          " OR (_OVR[6]>" + positionUpperTolerance + ")" +
          " OR (_OVR[5]<" + positionLowerTolerance + ")" +
          " OR (_OVR[6]<" + positionLowerTolerance + ")" +
          ")"
        );
        writeBlock("SETAL(62990,\"OUT OF POSITION TOLERANCE\")");
        onCommand(COMMAND_STOP);
        writeBlock("ENDIF");
      }
    }

    if (probingArguments.isAngleAskewAction) {
      var angleUpperTolerance = xyzFormat.format(cycle.toleranceAngle);
      var angleLowerTolerance = xyzFormat.format(cycle.toleranceAngle * -1);
      writeBlock(
        "IF((_OVR[16]>" + angleUpperTolerance + ")" +
        " OR (_OVR[16]<" + angleLowerTolerance + ")" +
        ")"
      );
      writeBlock("SETAL(62991,\"OUT OF ANGLE TOLERANCE\")");
      onCommand(COMMAND_STOP);
      writeBlock("ENDIF");
    }
  }
}

/** Convert approach to sign. */
function approach(value) {
  validate((value == "positive") || (value == "negative"), "Invalid approach.");
  return (value == "positive") ? 1 : -1;
}
// <<<<< INCLUDED FROM include_files/probeCycles_siemens.cpi
// >>>>> INCLUDED FROM include_files/getProbingArguments_siemens.cpi
function getProbingArguments(cycle, singleLine) {
  var probeWCS = hasParameter("operation-strategy") && (getParameter("operation-strategy") == "probe");
  var isAngleProbing = cycleType.indexOf("angle") != -1;

  return {
    probeWCS             : probeWCS,
    isAngleProbing       : isAngleProbing,
    isRectangularFeature : cycleType.indexOf("rectangular") != -1,
    isIncrementalDepth   : cycleType.indexOf("island") != -1 || cycleType.indexOf("wall") != -1 || cycleType.indexOf("boss") != -1,
    isAngleAskewAction   : (cycle.angleAskewAction == "stop-message"),
    isWrongSizeAction    : (cycle.wrongSizeAction == "stop-message"),
    isOutOfPositionAction: (cycle.outOfPositionAction == "stop-message"),
    _TUL                 : !isAngleProbing ? (cycle.tolerancePosition ? ((!singleLine ? "_TUL=" : "") + xyzFormat.format(cycle.tolerancePosition)) : undefined) : undefined,
    _TLL                 : !isAngleProbing ? (cycle.tolerancePosition ? ((!singleLine ? "_TLL=" : "") + xyzFormat.format(cycle.tolerancePosition * -1)) : undefined) : undefined,
    _TNUM                : (!isAngleProbing && cycle.updateToolWear) ? (!singleLine ? (getProperty("toolAsName") ? "_TNAME=" : "_TNUM=") : "") + (getProperty("toolAsName") ? "\"" + (cycle.toolDescription.toUpperCase()) + "\"" : toolFormat.format(cycle.toolWearNumber)) : undefined,
    _TDIF                : (!isAngleProbing && cycle.updateToolWear) ? (!singleLine ? "_TDIF=" : "") + xyzFormat.format(cycle.toolWearUpdateThreshold) : undefined,
    _TMV                 : cycle.hasSizeTolerance ? ((!isAngleProbing && cycle.updateToolWear) ? (!singleLine ? "_TMV=" : "") + xyzFormat.format(cycle.toleranceSize) : undefined) : undefined,
    _KNUM                : (!isAngleProbing && cycle.updateToolWear) ? (!singleLine ? "_KNUM=" : "") + xyzFormat.format(cycleType == "probing-z" ? (1000 + (cycle.toolLengthOffset)) : (2000 + (cycle.toolDiameterOffset))) : (isAngleProbing && !probeWCS) ? (!singleLine ? "_KNUM=" : "") + 0 : undefined // 2001 for D1
  };
}
// <<<<< INCLUDED FROM include_files/getProbingArguments_siemens.cpi

// <<<<< INCLUDED FROM ../common/siemens-840d common.cps

settings.supportsToolVectorOutput = true; // specifies if the control does support tool axis vector output for multi axis toolpath
