/**
  Copyright (C) 2012-2025 by Autodesk, Inc.
  All rights reserved.

  OKUMA post processor configuration.

  $Revision: 45609 c67837c91fb96c689e965d0ae2b5289c6a8b646c $
  $Date: 2025-09-16 09:02:54 $

  FORKID {2F9AB8A9-6D4F-4087-81B1-3E14AE260F81}
*/

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                        MANUAL NC COMMANDS
//
// The following ACTION commands are supported by this post.
//
//     spindleLoadMonitor:load        - Changes Spindle Load Monitoring value from default set in property 'Spindle load monitoring value'
//                                      Will be reset to default property value at the end of the section.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

description = "OKUMA";
vendor = "OKUMA";
vendorUrl = "http://www.okuma.com";
legal = "Copyright (C) 2012-2025 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45991;

longDescription = "Milling post for OKUMA. Select 3+2 machining style (CALL OO88, G605) using the 'Tilted work plane method' property.";

extension = "MIN";
setCodePage("ascii");

capabilities = CAPABILITY_MILLING | CAPABILITY_MACHINE_SIMULATION;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(180);
allowHelicalMoves = true;
allowedCircularPlanes = 1 << PLANE_XY; // allow XY plane only

highFeedMapping = HIGH_FEED_NO_MAPPING; // must be set if axes are not synchronized
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
    value      : 1,
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
  dwellAfterStop: {
    title      : "Dwell time after stop",
    description: "Specifies the time in seconds to dwell after a stop.",
    group      : "preferences",
    type       : "number",
    value      : 0,
    scope      : "post"
  },
  separateWordsWithSpace: {
    title      : "Separate words with space",
    description: "Adds spaces between words if 'yes' is selected.",
    group      : "formats",
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
  safePositionMethod: {
    title      : "Safe Retracts",
    description: "Select your desired retract option. 'Clearance Height' retracts to the operation clearance height.",
    group      : "homePositions",
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
    group      : "configuration",
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
    description: "If enabled, M15/M16 are used to specify table rotation direction. This property should only be enabled when the rotary axis moves on a rotary scale (has a defined range).",
    group      : "multiAxis",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  tiltedWorkPlaneMethod: {
    title      : "Tilted work plane method",
    description: "Select the desired tilted work plane method for 3+2 operations. 'None' positions the rotary axes.",
    group      : "multiAxis",
    type       : "enum",
    values     : [
      {title:"Using rotary axes", id:"none"},
      {title:"Fixture offset function - OO88", id:"OO88"},
      {title:"Dynamic fixture offset - G605", id:"G605"}
    ],
    value: "OO88",
    scope: "post"
  },
  fixtureOffsetWCS: {
    title      : "Fixture offset WCS",
    description: "The fixture offset number to use for tilted work planes when 'Tilted work plane method' is enabled.",
    group      : "multiAxis",
    type       : "integer",
    value      : 51,
    range      : [1, 200],
    scope      : "post"
  },
  rotaryOffsetWCS: {
    title      : "Rotary offset WCS",
    description: "The offset number to use for the tilted work plane rotary axes when 'Tilted work plane method' is enabled. This property is only used for Dynamic Fixture Offsets. A value of 0 disables the output of the Roffset code.",
    group      : "multiAxis",
    type       : "integer",
    value      : 0,
    range      : [0, 8],
    scope      : "post"
  },
  toolLifeMonitor: {
    title      : "Enable tool life monitoring",
    description: "Adds subprograms to monitor tool life.",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  loadMonitorVal: {
    title      : "Spindle load monitoring value",
    description: "Set a value here to turn on the spindle load monitoring. The Manual NC Action command 'spindleLoadMonitor' can be used to change it on an operation basis.",
    group      : "preferences",
    type       : "integer",
    value      : 0,
    scope      : "post"
  },
  useG284: {
    title      : "Use G284",
    description: "Use G284 instead of G84 for tapping cycles.",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useSmoothing: {
    title      : "High-Cut mode",
    description: "Select the High-cut contouring mode.",
    group      : "preferences",
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
  useSmoothingNURBS: {
    title      : "Enable superNURBS smoothing",
    description: "Enable to output smoothing blocks using the expanded superNURBS capabilities.",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  safeToolChange: {
    title      : "Enable safe tool change logic",
    description: "Use logic to check if the tool called is staged or already loaded.",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useClampCodes: {
    title      : "Use clamp codes",
    description: "Specifies whether clamp codes for rotary axes should be output.",
    group      : "multiAxis",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useCAS: {
    title      : "Enable Collision Avoidance System",
    description: "Use M-codes to switch off CAS before 5-axis toolpaths.",
    group      : "multiAxis",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useTPOC: {
    title      : "Enable Tool Posture Offset Control",
    description: "Use G445 to enable Tool Posture Offset Control before 5-axis toolpaths.",
    group      : "multiAxis",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  singleResultsFile: {
    title      : "Create single results file",
    description: "Set to false if you want to store the measurement results for each probe / inspection toolpath in a separate file.",
    group      : "probing",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  centerPointOutput: {
    title      : "Output coordinates at center of ball end mill",
    description: "Enable to output the coordinates at the center of a ball end mill during multi-axis moves.",
    group      : "multiAxis",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  offsetCode: {
    title      : "Tool length/diameter offset code",
    description: "Select the output preference for tool length and diameter compensation codes. 'Tool offset' will use the offset numbers associated with the tool.",
    group      : "preferences",
    type       : "enum",
    values     : [
      {title:"Tool offset", id:"toolOffset"},
      {title:"HA", id:"A"},
      {title:"HC", id:"C"}
    ],
    value: "toolOffset",
    scope: "post"
  },
  forceHomeOnIndexing: {
    title      : "Force XY home position on indexing",
    description: "Move XY to their home positions on multi-axis indexing.",
    group      : "homePositions",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useChipConveyor: {
    title      : "Use chip conveyor",
    description: "Enable/disable usage of the chip conveyor.",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "post"
  }
};

// wcs definiton
wcsDefinitions = {
  useZeroOffset: false,
  wcs          : [
    {name:"Standard", format:"G15 H##", range:[1, 200]},
  ]
};

var gFormat = createFormat({prefix:"G", decimals:0, minDigitsLeft:2});
var mFormat = createFormat({prefix:"M", decimals:0, minDigitsLeft:2});
var hFormat = createFormat({prefix:"H", decimals:0, minDigitsLeft:2});
var offsetFormat = createFormat({decimals:0, minDigitsLeft:2});
var oFormat = createFormat({prefix:"O", decimals:0, minDigitsLeft:4});
var probeWCSFormat = createFormat({decimals:0, type:FORMAT_REAL});

var xyzFormat = createFormat({decimals:(unit == MM ? 3 : 4), type:FORMAT_REAL});
var abcFormat = createFormat({decimals:4, type:FORMAT_REAL, scale:DEG});
var feedFormat = createFormat({decimals:(unit == MM ? 2 : 3)});
var inverseTimeFormat = createFormat({decimals:4});
var pitchFormat = createFormat({decimals:(unit == MM ? 3 : 4)});
var toolFormat = createFormat({decimals:0});
var rpmFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:3, type:FORMAT_REAL}); // seconds - range 0.001-99999.999
var milliFormat = createFormat({decimals:0}); // milliseconds // range 1-99999999
var taperFormat = createFormat({decimals:1, scale:DEG});
var integerFormat = createFormat({decimals:0});

var xOutput = createOutputVariable({onchange:function() {state.retractedX = false;}, prefix:"X"}, xyzFormat);
var yOutput = createOutputVariable({onchange:function() {state.retractedY = false;}, prefix:"Y"}, xyzFormat);
var zOutput = createOutputVariable({onchange:function() {state.retractedZ = false;}, prefix:"Z"}, xyzFormat);
var aOutput = createOutputVariable({prefix:"A"}, abcFormat);
var bOutput = createOutputVariable({prefix:"B"}, abcFormat);
var cOutput = createOutputVariable({prefix:"C"}, abcFormat);
var feedOutput = createOutputVariable({prefix:"F"}, feedFormat);
var sOutput = createOutputVariable({prefix:"S", control:CONTROL_FORCE}, rpmFormat);
var inverseTimeOutput = createOutputVariable({prefix:"F", control:CONTROL_FORCE}, inverseTimeFormat);
var loadMonitorOutput = createOutputVariable({prefix:"VSLDT[1, ", suffix:"]", control:CONTROL_FORCE}, integerFormat);

// circular output
var iOutput = createOutputVariable({prefix:"I", control:CONTROL_NONZERO}, xyzFormat);
var jOutput = createOutputVariable({prefix:"J", control:CONTROL_NONZERO}, xyzFormat);
var kOutput = createOutputVariable({prefix:"K", control:CONTROL_NONZERO}, xyzFormat);

// cycle output
var z71Output = createOutputVariable({prefix:"Z", control:CONTROL_FORCE}, xyzFormat);

var gMotionModal = createOutputVariable({}, gFormat); // modal group 1 // G0-G3, ...
var gPlaneModal = createOutputVariable({onchange:function () {gMotionModal.reset();}}, gFormat); // modal group 2 // G17-19
var gAbsIncModal = createOutputVariable({}, gFormat); // modal group 3 // G90-91
var gFeedModeModal = createOutputVariable({}, gFormat); // modal group 5 // G94-95
var gUnitModal = createOutputVariable({}, gFormat); // modal group 6 // G20-21
var gCycleModal = createOutputVariable({}, gFormat); // modal group 9 // G81, ...
var gRetractModal = createOutputVariable({}, gFormat); // modal group 10 // G98-99
var rotaryAxisDirectionModal = createOutputVariable({}, mFormat);
var casModal = createOutputVariable({}, mFormat);
var fourthAxisClamp = createOutputVariable({}, mFormat);
var fifthAxisClamp = createOutputVariable({}, mFormat);
var sixthAxisClamp = createOutputVariable({}, mFormat);

// fixed settings
var fixtureOffsetWCS = 51; // recalculated offset coordinate system number (zero point which is always rewritten in fixture offset function CALL OO88)
var rotaryOffsetWCS = 0; // recalculated offset for rotary axes
// the positions below are used to send the machine to its software limit positions when the 'safePositionMethod' property is set to G0.
var softLimitPositions = {x:(unit == MM ? 9999 : 400), y:(unit == MM ? 9999 : 400), z:(unit == MM ? 9999 : 400)};

// collected state
var loadMonitorVal = 0;

var settings = {
  coolant: {
    // samples:
    // {id: COOLANT_THROUGH_TOOL, on: 88, off: 89}
    // {id: COOLANT_THROUGH_TOOL, on: [8, 88], off: [9, 89]}
    // {id: COOLANT_THROUGH_TOOL, on: "M88 P3 (myComment)", off: "M89"}
    coolants: [
      {id:COOLANT_FLOOD, on:8},
      {id:COOLANT_MIST, on:7},
      {id:COOLANT_THROUGH_TOOL, on:50},
      {id:COOLANT_AIR, on:51},
      {id:COOLANT_AIR_THROUGH_TOOL, on:[12, 339]},
      {id:COOLANT_SUCTION},
      {id:COOLANT_FLOOD_MIST},
      {id:COOLANT_FLOOD_THROUGH_TOOL},
      {id:COOLANT_OFF, off:9}
    ],
    singleLineCoolant: false, // specifies to output multiple coolant codes in one line rather than in separate lines
  },
  smoothing: {
    roughing              : 2, // roughing level for smoothing in automatic mode
    semi                  : 2, // semi-roughing level for smoothing in automatic mode
    semifinishing         : 2, // semi-finishing level for smoothing in automatic mode
    finishing             : 1, // finishing level for smoothing in automatic mode
    thresholdRoughing     : toPreciseUnit(0.01, MM), // operations with stock/tolerance above that threshold will use roughing level in automatic mode
    thresholdFinishing    : toPreciseUnit(0.005, MM), // operations with stock/tolerance below that threshold will use finishing level in automatic mode
    thresholdSemiFinishing: toPreciseUnit(0.01, MM), // operations with stock/tolerance above finishing and below threshold roughing that threshold will use semi finishing level in automatic mode

    differenceCriteria: "both", // options: "level", "tolerance", "both". Specifies criteria when output smoothing codes
    autoLevelCriteria : "stock", // use "stock" or "tolerance" to determine levels in automatic mode
    cancelCompensation: false // tool length compensation must be canceled prior to changing the smoothing level
  },
  retract: {
    cancelRotationOnRetracting: false, // specifies that rotations (G11) needs to be canceled prior to retracting
    methodXY                  : undefined, // special condition, overwrite retract behavior per axis
    methodZ                   : undefined, // special condition, overwrite retract behavior per axis
    useZeroValues             : [], // enter property value id(s) for using "0" value instead of machineConfiguration axes home position values (ie G30 Z0)
    homeXY                    : {onIndexing:false, onToolChange:false, onProgramEnd:false} // Specifies when the machine should be homed in X/Y. Sample: onIndexing:{axes:[X, Y], singleLine:false}
  },
  parametricFeeds: {
    firstFeedParameter    : 1, // specifies the initial parameter number to be used for parametric feedrate output
    feedAssignmentVariable: "PF", // specifies the syntax to define a parameter
    feedOutputVariable    : "F=PF" // specifies the syntax to output the feedrate as parameter
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
    format                 : oFormat, // the format to use for the subprogam number format
    // objects below also accept strings with "%currentSubprogram" as placeholder. Sample: {files:["%"], embedded:"N" + "%currentSubprogram"}
    files                  : {extension:extension, prefix:undefined}, // specifies the subprogram file extension and the prefix to use for the generated file
    startBlock             : {files:[], embedded:[]}, // specifies the start syntax of a subprogram followed by the subprogram number
    endBlock               : {files:["RTS"], embedded:["RTS"]}, // specifies the command to for the end of a subprogram
    callBlock              : {files:["CALL "], embedded:["CALL "]} // specifies the command for calling a subprogram followed by the subprogram number
  },
  comments: {
    permittedCommentChars: " abcdefghijklmnopqrstuvwxyz0123456789.,=_-:+/*#", // letters are not case sensitive, use option 'outputFormat' below. Set to 'undefined' to allow any character
    prefix               : "(", // specifies the prefix for the comment
    suffix               : ")", // specifies the suffix for the comment
    outputFormat         : "ignoreCase", // can be set to "upperCase", "lowerCase" and "ignoreCase". Set to "ignoreCase" to write comments without upper/lower case formatting
    maximumLineLength    : 80 // the maximum number of characters allowed in a line, set to 0 to disable comment output
  },
  probing: {
    macroCall              : "CALL O", // specifies the command to call a macro
    probeAngleMethod       : undefined, // supported options are: OFF, AXIS_ROT, G68 (used for G11). 'undefined' uses automatic selection
    probeAngleVariables    : {x:"#135", y:"#136", z:0, i:0, j:0, k:1, r:"#144", baseParamG54x4:26000, baseParamAxisRot:5200, method:0}, // specifies variables for the angle compensation macros, method 0 = Fanuc, 1 = Haas
    allowIndexingWCSProbing: false // specifies that probe WCS with tool orientation is supported
  },
  maximumSequenceNumber         : 99999999,
  maximumToolDiameterOffset     : 999, // specifies the maximum allowed tool diameter offset number
  allowCancelTCPBeforeRetracting: true, // allows TCP/tool length compensation to be canceled prior retracting. Warning, ensure machine parameters 5006.6(Fanuc)/F114 bit 1(Mazak) are set to prevent axis motion when cancelling compensation.
  polarCycleExpandMode          : 1 // 0=EXPAND_NONE: Does not expand any cycles. 1=EXPAND_TCP: Expands drilling cycles, when TCP is on. 2=EXPAND_NON_TCP: Expands drilling cycles, when TCP is off. 3=EXPAND_ALL: Expands all drilling cycles
};

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

// Start of machine configuration logic
function defineMachine() {
  var useTCP = true;
  var masterAxis;
  if (getProperty("rotaryTableAxis") != "none") {
    if (receivedMachineConfiguration && machineConfiguration.isMultiAxisConfiguration()) {
      error(localize("You can only select either a machine in the CAM setup or use the properties to define your kinematics."));
    }
    var rotary = parseChoice(getProperty("rotaryTableAxis"), "-Z", "-Y", "-X", "NONE", "X", "Y", "Z", "5AXIS");
    if (rotary < 0) {
      error(localize("Valid rotaryTableAxis values are: None, X, Y, Z, -X, -Y, -Z, 5 Axis"));
    }
    rotary -= 3;
    masterAxis = Math.abs(rotary) - 1;
    if (getProperty("rotaryTableAxis") == "5axis") {
      var aAxis = createAxis({coordinate:0, table:true, axis:[1, 0, 0], range:[-120, 90], preference:0, tcp:useTCP});
      var cAxis = createAxis({coordinate:2, table:true, axis:[0, 0, 1], cyclic:true, range:getProperty("useTableDirectionCodes") ? [0, 359.9999] : undefined, preference:0, tcp:useTCP});
      machineConfiguration = new MachineConfiguration(aAxis, cAxis);
    } else if (masterAxis >= 0) {
      // Define Master (carrier) axis
      var rotaryVector = [0, 0, 0];
      rotaryVector[masterAxis] = rotary / Math.abs(rotary);
      useTCP = false; // Single rotary does not use TCP mode
      var aAxis = createAxis({coordinate:0, table:true, axis:rotaryVector, cyclic:true, range:getProperty("useTableDirectionCodes") ? [0, 359.9999] : undefined, preference:0, tcp:useTCP});
      machineConfiguration = new MachineConfiguration(aAxis);
    }
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
    var performRewinds = false; // set to true to enable the retract/reconfigure logic
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
      var useDPMFeeds = true;
      machineConfiguration.setMultiAxisFeedrate(
        useTCP ? FEED_FPM : useDPMFeeds ? FEED_DPM : FEED_INVERSE_TIME,
        useDPMFeeds ? 9999.99 : 99999.99, // maximum output value for inverse time feed rates
        useDPMFeeds ? DPM_COMBINATION : INVERSE_MINUTES, // INVERSE_MINUTES/INVERSE_SECONDS or DPM_COMBINATION/DPM_STANDARD
        0.5, // tolerance to determine when the DPM feed has changed
        (unit == MM) ? 1.0 : 0.1 // ratio of rotary accuracy to linear accuracy for DPM calculations
      );
      setMachineConfiguration(machineConfiguration);
    }
  }
  /* home positions */
  if (getProperty("safePositionMethod") == "G0") {
    // CNC would not fail but move to max position
    machineConfiguration.setHomePositionX(softLimitPositions.x);
    machineConfiguration.setHomePositionY(softLimitPositions.y);
    machineConfiguration.setRetractPlane(softLimitPositions.z);
  }
}
// End of machine configuration logic

function onOpen() {
  circularOutputAccuracy = xyzFormat.getNumberOfDecimals();
  // define and enable machine configuration
  receivedMachineConfiguration = machineConfiguration.isReceived();
  if (typeof defineMachine == "function") {
    defineMachine(); // hardcoded machine configuration
  }
  activateMachine(); // enable the machine optimizations and settings

  if (!getProperty("useClampCodes")) {
    fourthAxisClamp.disable();
    fifthAxisClamp.disable();
    sixthAxisClamp.disable();
  }
  casModal.format(511); // CAS enabled by default

  settings.workPlaneMethod.useTiltedWorkplane = getProperty("tiltedWorkPlaneMethod", "none") != "none";
  settings.retract.homeXY.onIndexing = getProperty("forceHomeOnIndexing") ? {axes:[X, Y]} : false;
  fixtureOffsetWCS = getProperty("fixtureOffsetWCS", fixtureOffsetWCS);
  rotaryOffsetWCS = getProperty("rotaryOffsetWCS", rotaryOffsetWCS);

  saveShowSequenceNumbers = getProperty("showSequenceNumbers");
  loadMonitorVal = getProperty("loadMonitorVal");

  gRotationModal.format(getProperty("tiltedWorkPlaneMethod") == "G605" ? 604 : 10);

  if (!getProperty("separateWordsWithSpace")) {
    setWordSeparator("");
  }

  writeln("O" + getProgramName());
  writeComment(programComment);
  writeProgramHeader();
  writeToolCheckStart();

  if (typeof inspectionWriteVariables == "function") {
    inspectionWriteVariables();
  }

  // absolute coordinates and feed per min
  writeBlock(gFormat.format(40), gCycleModal.format(80), gAbsIncModal.format(90), gFeedModeModal.format(94), gPlaneModal.format(17));
  // writeBlock("VINCH=" + (unit == MM ? 2 : 3));
  writeBlock(gUnitModal.format(unit == MM ? 21 : 20));

  // enable tool life monitoring
  writeBlock(getProperty("toolLifeMonitor") ? "TLFON" : "");
  validateCommonParameters();
}

function setSmoothing(mode) {
  smoothingSettings = settings.smoothing;
  if (mode == smoothing.isActive && (!mode || !smoothing.isDifferent) && !smoothing.force) {
    return; // return if smoothing is already active or is not different
  }
  if (validateLengthCompensation && smoothingSettings.cancelCompensation) {
    validate(!state.lengthCompensationActive, "Length compensation is active while trying to update smoothing.");
  }

  if (mode) { // enable smoothing
    var tolerance = Math.min(smoothing.tolerance * 4, toUnit(0.05, MM));
    var smoothingCodes = !getProperty("useSmoothingNURBS") ? "E" + xyzFormat.format(tolerance) :
      formatWords("E" + xyzFormat.format(tolerance),
        "D" + xyzFormat.format(smoothing.tolerance),
        "I2",
        "L" + xyzFormat.format(toPreciseUnit(19, MM)),
        "R" + xyzFormat.format(toPreciseUnit(0.002, MM)));
    writeBlock(gFormat.format(131),
      "F" + feedFormat.format(currentSection.getMaximumFeedrate()),
      "J" + xyzFormat.format(smoothing.level),
      smoothingCodes
    );
  } else { // disable smoothing
    writeBlock(gFormat.format(130));
  }
  smoothing.isActive = mode;
  smoothing.force = false;
  smoothing.isDifferent = false;
}

function onSection() {
  var forceSectionRestart = optionalSection && !currentSection.isOptional();
  optionalSection = currentSection.isOptional();
  var insertToolCall = isToolChangeNeeded("number") || forceSectionRestart;
  var newWorkOffset = isNewWorkOffset() || forceSectionRestart;
  var newWorkPlane = isNewWorkPlane() || forceSectionRestart || (typeof defineWorkPlane == "function" &&
    Vector.diff(defineWorkPlane(getPreviousSection(), false), defineWorkPlane(currentSection, false)).length > 1e-4);
  initializeSmoothing(); // initialize smoothing mode

  if (insertToolCall || newWorkOffset || newWorkPlane || smoothing.cancel || state.tcpIsActive || currentSection.isMultiAxis()) {
    if (insertToolCall && !isFirstSection()) {
      onCommand(COMMAND_COOLANT_OFF); // turn off coolant before retract during tool change
      onCommand(COMMAND_STOP_SPINDLE); // stop spindle before retract during tool change
    }
    if (!isFirstSection() && (insertToolCall || newWorkPlane)) {
      cancelWorkPlane();
    }
    writeRetract(Z); // retract
    disableLengthCompensation();
    setCAS(true);
    if (isFirstSection()) {
      cancelWorkPlane(machineConfiguration.isMultiAxisConfiguration() && settings.workPlaneMethod.useTiltedWorkplane);
      if (machineConfiguration.isMultiAxisConfiguration()) {
        positionABC(new Vector(0, 0, 0));
      }
      forceABC();
    } else {
      if (insertToolCall || smoothing.cancel) {
        setSmoothing(false);
      }
    }
  }

  writeln("");
  writeComment(getParameter("operation-comment", ""));

  if (getProperty("showNotes") && hasParameter("notes")) {
    writeSectionNotes();
  }

  // Process Pass Through commands
  executeManualNC();

  // tool change
  writeToolCall(tool, insertToolCall);
  startSpindle(tool, insertToolCall);

  // enable simplified spindle load monitoring
  setSpindleLoadMonitor(true, insertToolCall);

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

  if (settings.workPlaneMethod.useTiltedWorkplane && currentWorkOffset == fixtureOffsetWCS) {
    error(subst(localize("Work offset %1 is reserved for the fixture offset macro, please specify a different work offset."), fixtureOffsetWCS));
  }
  if (settings.workPlaneMethod.useTiltedWorkplane && currentWorkOffset == rotaryOffsetWCS) {
    error(subst(localize("Work offset %1 is reserved for the rotary offset macro, please specify a different work offset."), rotaryOffsetWCS));
  }

  forceAny();
  var abc = defineWorkPlane(currentSection, !machineConfiguration.isHeadConfiguration());

  setProbeAngle(); // output probe angle rotations if required

  setCoolant(tool.coolant);

  if (getProperty("useChipConveyor") && isFirstSection()) {
    writeBlock(mFormat.format(279));
  }
  if (tcp.isSupportedByOperation) {
    setCAS(false);
  }

  var initialPosition = getFramePosition(currentSection.getInitialPosition());
  var isRequired = insertToolCall || state.retractedZ || !state.lengthCompensationActive || (!isFirstSection() && getPreviousSection().isMultiAxis());
  writeInitialPositioning(initialPosition, isRequired);

  // enable Tool Posture Offset Control
  if (getProperty("useTPOC") && tcp.isSupportedByOperation) {
    writeBlock(
      gFormat.format(445),
      conditional(machineConfiguration.isMachineCoordinate(0), "A" + abcFormat.format(toRad(0.2))),
      conditional(machineConfiguration.isMachineCoordinate(1), "B" + abcFormat.format(toRad(0.2))),
      conditional(machineConfiguration.isMachineCoordinate(2), "C" + abcFormat.format(toRad(0.2))),
      "P" + abcFormat.format(toRad(0.2)),
      "R" + abcFormat.format(toRad(0.2))
    );
  }

  setSmoothing(smoothing.isAllowed);

  if (isProbeOperation()) {
    validate(probeVariables.probeAngleMethod != "G68", "You cannot probe while G11 Rotation is in effect.");
    writeBlock(settings.probing.macroCall + 9832); // spin the probe on
    inspectionCreateResultsFileHeader();
    feedOutput.reset();
  }
  if (typeof inspectionProcessSectionStart == "function") {
    inspectionProcessSectionStart();
  }

  if (subprogramsAreSupported()) {
    subprogramDefine(initialPosition, abc); // define subprogram
  }
}

/**
 Buffer Manual NC commands for processing later
*/
var bufferPassThrough = true; // enable to output the Pass Through commands until after ending the previous section
var manualNC = [];
function onManualNC(command, value) {
  switch (command) {
  case COMMAND_ACTION:
    var sText1 = String(value);
    var sText2 = new Array();
    sText2 = sText1.split(":");
    if (sText2.length != 2) {
      error(localize("Invalid action command: ") + value);
    }
    if (sText2[0].toUpperCase() == "SPINDLELOADMONITOR") {
      loadMonitorVal = parseFloat(sText2[1]);
      if (isNaN(loadMonitorVal) || loadMonitorVal < 0) {
        error(localize("Spindle load mointoring requires a valid positive number."));
      }
    }
    break;
  case COMMAND_PASS_THROUGH:
    if (command == COMMAND_PASS_THROUGH && bufferPassThrough) {
      manualNC.push({command:command, value:value});
    } else {
      expandManualNC(command, value);
    }
    break;
  default:
    expandManualNC(command, value);
  }
}

/**
 Processes the Manual NC commands
 Pass the desired command to process or leave argument list blank to process all buffered commands
*/
function executeManualNC(command) {
  for (var i = 0; i < manualNC.length; ++i) {
    if (!command || (command == manualNC[i].command)) {
      expandManualNC(manualNC[i].command, manualNC[i].value);
    }
  }
  for (var i = manualNC.length - 1; i >= 0; --i) {
    if (!command || (command == manualNC[i].command)) {
      manualNC.splice(i, 1);
    }
  }
}

var gRotationModal = createOutputVariable({
  onchange: function () {
    if (probeVariables.probeAngleMethod == "G68") {
      probeVariables.outputRotationCodes = true;
    }
  }
}, gFormat);

var currentWorkPlaneABC = undefined;
function forceWorkPlane() {
  currentWorkPlaneABC = undefined;
}

function cancelWCSRotation() {
  if (typeof gRotationModal != "undefined" && gRotationModal.getCurrent() == 11) {
    cancelWorkPlane(true);
  }
}

function cancelWorkPlane(force) {
  if (force) {
    gRotationModal.reset();
  }
  if (settings.workPlaneMethod.useTiltedWorkplane) {
    writeFixtureOffset(new Vector(0, 0, 0), true);
  } else {
    writeBlock(gRotationModal.format(10)); // cancel frame
  }
  state.twpIsActive = false;
  machineSimulation({});
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
    if ((state.lengthCompensationActive || state.tcpIsActive) && typeof disableLengthCompensation == "function") {
      disableLengthCompensation(); // cancel tool lenght compensation / TCP prior to output TWP
    }
    if (settings.workPlaneMethod.useTiltedWorkplane) {
      onCommand(COMMAND_UNLOCK_MULTI_AXIS);
      cancelWorkPlane();
      if (machineConfiguration.isMultiAxisConfiguration()) {
        var machineABC = abc.isNonZero() ? (currentSection.isMultiAxis() ? getCurrentDirection() : getWorkPlaneMachineABC(currentSection, false)) : abc;
        if (settings.workPlaneMethod.useABCPrepositioning || machineABC.isZero()) {
          positionABC(machineABC, false);
        } else {
          setCurrentABC(machineABC);
        }
      }
      if (abc.isNonZero()) {
        writeFixtureOffset(abc);
      } else if (getProperty("tiltedWorkPlaneMethod", "none") != "G605") {
        currentWorkOffset = undefined;
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

function writeFixtureOffset(abc, reset) {
  switch (getProperty("tiltedWorkPlaneMethod", "none")) {
  case "OO88":
    if (!state.twpIsActive && abc.isZero()) {
      return;
    }
    writeBlock(
      "CALL OO88",
      "PX=" + xyzFormat.format(reset ? 0 : currentSection.workOrigin.x),
      "PY=" + xyzFormat.format(reset ? 0 : currentSection.workOrigin.y),
      "PZ=" + xyzFormat.format(reset ? 0 : currentSection.workOrigin.z),
      conditional(machineConfiguration.isMachineCoordinate(2), "PC=" + abcFormat.format(abc.z)),
      conditional(machineConfiguration.isMachineCoordinate(1), "PB=" + abcFormat.format(abc.y)),
      conditional(machineConfiguration.isMachineCoordinate(0), "PA=" + abcFormat.format(abc.x)),
      "PH=" + xyzFormat.format(currentSection.workOffset),
      "PP=" + xyzFormat.format(fixtureOffsetWCS)
    );
    writeBlock(gFormat.format(15), hFormat.format(abc.isZero() ? currentSection.workOffset : fixtureOffsetWCS));
    break;
  case "G605":
    if (abc.isZero()) {
      if (state.twpIsActive) {
        writeBlock(gRotationModal.format(604));
        writeBlock(gFormat.format(15), hFormat.format(currentSection.workOffset));
      }
    } else {
      gRotationModal.reset();
      writeBlock(gRotationModal.format(605), hFormat.format(currentSection.workOffset), "Q" + fixtureOffsetWCS,
        conditional(rotaryOffsetWCS != 0, "R" + rotaryOffsetWCS));
    }
    break;
  }
  state.twpIsActive = abc.isNonZero();
  gMotionModal.reset();
}

function getToolOffsetCode(type) {
  var offset;
  if (getProperty("centerPointOutput") && tool.type == TOOL_MILLING_END_BALL && tcp.isSupportedByOperation) {
    offset = "B";
  } else if (getProperty("offsetCode") == "toolOffset") {
    offset = offsetFormat.format(type == "length" ? tool.lengthOffset : tool.diameterOffset);
  } else {
    offset = getProperty("offsetCode");
  }
  return (type == "length" ? "H" : "D") + offset;
}

function setSpindleLoadMonitor(enable, insertToolCall) {
  if (enable) { // enable spindle load monitoring
    if (insertToolCall || forceSpindleSpeed || isSpindleSpeedDifferent()) {
      if (loadMonitorVal > 0 && tool.type != TOOL_PROBE) {
        writeBlock(mFormat.format(143), "VSLNO=1");
        writeBlock(loadMonitorOutput.format(loadMonitorVal));
      }
    }
  } else { // disable spindle load monitoring
    if (loadMonitorOutput.getCurrent() != 0) {
      writeBlock(mFormat.format(142));
    }
  }
}

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
  var hOffset = getSetting("outputToolLengthOffset", true) ? getToolOffsetCode("length") : "";
  var additionalCodes = [formatWords(codes1), formatWords(codes2)];

  forceModals(gMotionModal);
  writeStartBlocks(isRequired, function() {
    var modalCodes = formatWords(gAbsIncModal.format(90), gPlaneModal.format(17));
    if (typeof disableLengthCompensation == "function") {
      disableLengthCompensation(!isRequired); // cancel tool length compensation prior to enabling it, required when switching G43/G43.4 modes
    }

    if (machineConfiguration.isHeadConfiguration()) { // head/head head/table kinematics
      var machineABC = currentSection.isMultiAxis() ? defineWorkPlane(currentSection, false) : getWorkPlaneMachineABC(currentSection, false);
      machineConfiguration.setToolLength(getSetting("workPlaneMethod.compensateToolLength", false) ? getBodyLength(currentSection.getTool()) : 0); // define the tool length for head adjustments
      var mode = currentSection.isOptimizedForMachine() ? TCP_XYZ_OPTIMIZED : TCP_XYZ;
      var globalPosition = getGlobalPosition(currentSection.getInitialPosition());
      var machinePosition = machineConfiguration.getOptimizedPosition(globalPosition, machineABC, mode, OPTIMIZE_BOTH, true);
      var prePosition = (currentSection.isOptimizedForMachine() || currentSection.isMultiAxis()) ? position :
        (settings.workPlaneMethod.useTiltedWorkplane && !tcp.isSupportedByMachine) ? machinePosition : globalPosition;

      cancelWorkPlane();
      positionABC(machineABC);
      if ((getSetting("workPlaneMethod.useTiltedWorkplane", false) && tcp.isSupportedByMachine && getCurrentDirection().isNonZero()) || tcp.isSupportedByOperation) {
        writeBlock(getOffsetCode(true), hOffset); // force TCP for prepositioning although the operation may not require it
      }
      writeBlock(modalCodes, gMotionModal.format(motionCode.multi), xOutput.format(prePosition.x), yOutput.format(prePosition.y), feed, additionalCodes[0]);
      machineSimulation({x:prePosition.x, y:prePosition.y});
      var lengthComp = state.lengthCompensationActive ? {code:undefined, hOffset:undefined} : {code:getOffsetCode(), hOffset:hOffset};
      writeBlock(modalCodes, gMotionModal.format(motionCode.single), lengthComp.code, zOutput.format(prePosition.z), lengthComp.hOffset, additionalCodes[1]);
      machineSimulation({z:prePosition.z});

      if (!currentSection.isMultiAxis()) {
        if (state.tcpIsActive && !tcp.isSupportedByOperation && typeof disableLengthCompensation == "function") {
          disableLengthCompensation();
        }
        if (getSetting("workPlaneMethod.useTiltedWorkplane", false) && getCurrentDirection().isNonZero()) {
          var saveRetractedState = [state.retractedX, state.retractedY, state.retractedZ];
          state.retractedX = state.retractedY = state.retractedZ = true; // set retracted states to true to avoid retraction
          defineWorkPlane(currentSection, true); // apply workplane for the operation if TWP is supported
          [state.retractedX, state.retractedY, state.retractedZ] = saveRetractedState; // restore retracted states
        }
        if (!state.lengthCompensationActive) {
          writeBlock(modalCodes, gMotionModal.format(motionCode.multi), xOutput.format(position.x), yOutput.format(position.y));
          machineSimulation({x:position.x, y:position.y});
          writeBlock(modalCodes, gMotionModal.format(motionCode.single), getOffsetCode(), zOutput.format(position.z), hOffset);
          machineSimulation({z:position.z});
        }
      }
      forceFeed();
    } else {
      // multi axis prepositioning with TWP
      if (currentSection.isMultiAxis() && getSetting("workPlaneMethod.prepositionWithTWP", true) && getSetting("workPlaneMethod.useTiltedWorkplane", false) &&
        tcp.isSupportedByOperation && getCurrentDirection().isNonZero()) {
        var W = machineConfiguration.isMultiAxisConfiguration() ? machineConfiguration.getOrientation(getCurrentDirection()) :
          Matrix.getOrientationFromDirection(getCurrentDirection());
        var prePosition = W.getTransposed().multiply(position);
        var angles = getCurrentABC();
        setWorkPlane(angles);
        writeBlock(modalCodes, gMotionModal.format(motionCode.multi), xOutput.format(prePosition.x), yOutput.format(prePosition.y), feed, additionalCodes[0]);
        machineSimulation({x:prePosition.x, y:prePosition.y});
        cancelWorkPlane();
        writeBlock(getOffsetCode(), hOffset, additionalCodes[1]); // omit Z-axis output is desired
        forceAny(); // required to output XYZ coordinates in the following line
      } else {
        writeBlock(modalCodes, gMotionModal.format(motionCode.multi), xOutput.format(position.x), yOutput.format(position.y), feed, additionalCodes[0]);
        machineSimulation({x:position.x, y:position.y});
        writeBlock(gMotionModal.format(motionCode.single), getOffsetCode(), zOutput.format(position.z), hOffset, additionalCodes[1]);
        machineSimulation(tcp.isSupportedByOperation ? {x:position.x, y:position.y, z:position.z} : {z:position.z});
      }
    }
    forceModals(gMotionModal);
    if (isRequired) {
      additionalCodes = []; // clear additionalCodes buffer
    }
  });

  validate(!validateLengthCompensation || state.lengthCompensationActive, "Tool length compensation is not active."); // make sure that lenght compensation is enabled
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
  if (machineConfiguration.isMultiAxisConfiguration() && !currentSection.isMultiAxis()) {
    onCommand(COMMAND_LOCK_MULTI_AXIS);
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

function skipNLines(n) {
  setProperty("showSequenceNumbers", "true"); // force sequence numbers to be output
  if (sequenceNumber == undefined) {
    sequenceNumber = getProperty("sequenceNumberStart");
  }
  var sequenceNumberStart = typeof inspectionVariables !== "undefined" ? inspectionVariables.saveSequenceNumbers.start : 0;
  if (sequenceNumberStart > sequenceNumber) {
    error(subst(localize(
      "The sequence number to be output exceeds the maximum sequence number value of '%1'" + EOL +
      "Exceeding the limit will cause the program to fail when using inspection and/or live connection due to the use of the GOTO statements." + EOL +
      "Solutions:" + EOL +
        "- set property '%2' to 'No'" + EOL +
        "- set property '%3' to a lower value" + EOL +
        "- disable property '%4'" + EOL +
        "- modify setting 'maximumSequenceNumber' within your postprocessor to the maximum supported value" + EOL +
        "- split the program into smaller sections."
    ),
    settings.maximumSequenceNumber, properties.showSequenceNumbers.title, properties.sequenceNumberIncrement.title, properties.useLiveConnection.title));
  }
  return ("N" + (n * getProperty("sequenceNumberIncrement") + sequenceNumber));
}

function writeToolCheckStart() {
  var tools = getToolTable();
  if (getProperty("toolLifeMonitor") && tools.getNumberOfTools() > 0) {
    for (var i = 0; i < tools.getNumberOfTools(); ++i) {
      var tool = tools.getTool(i);
      writeComment(subst("T%1 Tool check subprogram call", toolFormat.format(tool.number)));
      writeBlock("VC198=", xyzFormat.format(tool.diameter), formatComment("CAM ToolDiameter"));
      writeBlock("VC199=", xyzFormat.format(tool.bodyLength), formatComment("CAM ToolLength"));
      writeBlock("VC200=", toolFormat.format(tool.number), formatComment("CAM ToolNumber"));
      writeBlock("CALL OCHCK");
    }
  }
}

function writeToolCheckEnd() {
  if (getProperty("toolLifeMonitor")) {
    setProperty("showSequenceNumbers", "false");
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
    writeBlock("IF [VTOHT[VC200,10001] LT VC194]", skipNLines(3));
    writeBlock("VUACM[1]='TOOL LONG'");
    writeBlock("VDOUT[992]=1");
    writeln("");
    writeBlock("IF [VTOHT[VC200,10001] GT VC193]", skipNLines(3));
    writeBlock("VUACM[1]='TOOL SHORT'");
    writeBlock("VDOUT[992]=1");
    writeln("");
    writeBlock("IF [VTODT[[VC200,10001]] LT VC192]", skipNLines(3));
    writeBlock("VUACM[1]='T DIA LARGE'");
    writeBlock("VDOUT[992]=1");
    writeln("");
    writeBlock("IF [VTODT[[VC200,10001]] GT VC191]", skipNLines(3));
    writeBlock("VUACM[1]='T DIA SMALL'");
    writeBlock("VDOUT[992]=1");
    writeln("");
    writeBlock("RTS");
    setProperty("showSequenceNumbers", saveShowSequenceNumbers);
  }
}

function getProgramName() {
  if (programName) {
    if (programName.length > 8) {
      warning(subst(localize("Program name exceeds maximum length of '%1' characters."), 8));
    }
    programName = String(programName).toUpperCase();
    if (!isSafeText(programName, "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")) {
      error(localize("Program name contains invalid character(s)."));
    }
    if (programName[0] == "O") {
      warning(localize("Using reserved program name."));
    }
    return programName;
  } else {
    error(localize("Program name has not been specified."));
  }
  return undefined;
}

/**
  Outputs the Rotary axis direction code.
*/
function getRotaryDirectionCode(abc) {
  if (machineConfiguration.getNumberOfAxes() != 4) {
    return "";
  }
  var axis = machineConfiguration.getAxisU().getCoordinate();
  if (getProperty("useTableDirectionCodes")) {
    var outputs = [aOutput, bOutput, cOutput];
    var delta = outputs[axis].getResultingValue(abc.getCoordinate(axis)) -
      outputs[axis].getResultingValue(getCurrentABC().getCoordinate(axis));
    var pi = outputs[axis].getResultingValue(Math.PI);
    if (((delta < 0) && (delta > -pi)) || (delta > pi)) {
      return rotaryAxisDirectionModal.format(16);
    } else if (abcFormat.getResultingValue(delta) != 0) {
      return rotaryAxisDirectionModal.format(15);
    }
  }
  return "";
}

function setCAS(mode) {
  if (getProperty("useCAS")) {
    var code = casModal.format(mode ? 511 : 510);
    writeBlock(code ? formatWords(code, formatComment(mode ? "ENABLE CAS" : "DISABLE CAS")) : "");
  }
}

var toolLengthCompOutput = createOutputVariable({control : CONTROL_FORCE,
  onchange: function() {
    state.tcpIsActive = toolLengthCompOutput.getCurrent() == 169;
    state.lengthCompensationActive = toolLengthCompOutput.getCurrent() == 56 || state.tcpIsActive;
  }
}, gFormat);

function getOffsetCode(forceTCP) {
  if (!getSetting("outputToolLengthCompensation", true) && toolLengthCompOutput.isEnabled()) {
    state.lengthCompensationActive = true; // always assume that length compensation is active
    toolLengthCompOutput.disable();
  }
  var offsetCode = 56;
  if (tcp.isSupportedByOperation || forceTCP) {
    offsetCode = 169;
  }
  return toolLengthCompOutput.format(offsetCode);
}

function disableLengthCompensation(force) {
  if (state.lengthCompensationActive || force) {
    if (force) {
      toolLengthCompOutput.reset();
    }
    if (!getSetting("allowCancelTCPBeforeRetracting", false)) {
      validate(state.retractedZ, "Cannot cancel tool length compensation if the machine is not fully retracted.");
    }
    writeBlock(toolLengthCompOutput.format(state.tcpIsActive ? 170 : 53)); // G53 is the cancel tool length offset command
  }
}

function onDwell(seconds) {
  var maxValue = 99999.999;
  if (seconds > maxValue) {
    warning(subst(localize("Dwelling time of '%1' exceeds the maximum value of '%2' in operation '%3'"), seconds, maxValue, getParameter("operation-comment", "")));
  }
  seconds = clamp(0.001, seconds, maxValue);
  // unit is set in the machine
  writeBlock(gFormat.format(4), "F" + secFormat.format(seconds));
}

function onSpindleSpeed(spindleSpeed) {
  writeBlock(sOutput.format(spindleSpeed));
}

function onCycle() {
  writeBlock(gPlaneModal.format(17));
  if (isProbeOperation()) {
    xOutput.setPrefix("PX=");
    yOutput.setPrefix("PY=");
    zOutput.setPrefix("PZ=");
    feedOutput.setPrefix("PF=");
  }
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
  if (isProbeOperation()) {
    zOutput.reset();
    gMotionModal.reset();
    writeBlock(settings.probing.macroCall + 9810, zOutput.format(cycle.retract)); // protected retract move
    xOutput.setPrefix("X");
    yOutput.setPrefix("Y");
    zOutput.setPrefix("Z");
    feedOutput.setPrefix("F");
  } else {
    if (subprogramsAreSupported() && subprogramState.cycleSubprogramIsActive) {
      subprogramEnd();
    }
    if (!cycleExpanded) {
      gMotionModal.reset();
      zOutput.reset();
      writeBlock(gMotionModal.format(0), zOutput.format(getCurrentPosition().z)); // avoid spindle stop
      gCycleModal.reset();
    // writeBlock(gCycleModal.format(80)); // not good since it stops spindle
    }
  }
}

function getCommonCycle(x, y, z, r, c) {
  forceXYZ(); // force xyz on first drill hole of any cycle
  if ((currentSection.getPolarMode && currentSection.getPolarMode() != POLAR_MODE_OFF) && currentSection.isMultiAxis()) {
    var polarPosition = getPolarPosition(x, y, z);
    return [xOutput.format(polarPosition.first.x), yOutput.format(polarPosition.first.y), zOutput.format(polarPosition.first.z),
      aOutput.format(polarPosition.second.x), bOutput.format(polarPosition.second.y), cOutput.format(polarPosition.second.z),
      "R" + xyzFormat.format(r)];
  } else {
    if (subprogramsAreSupported() && subprogramState.incrementalMode) {
      zOutput.format(c);
      return [xOutput.format(x), yOutput.format(y),
        "Z" + xyzFormat.format(z - r),
        "R" + xyzFormat.format(r - c)];
    } else {
      return [xOutput.format(x), yOutput.format(y),
        zOutput.format(z),
        "R" + xyzFormat.format(r)];
    }
  }
}

function writeDrillCycle(cycle, x, y, z) {
  if (!isSameDirection(machineConfiguration.getSpindleAxis(), getForwardDirection(currentSection))) {
    expandCyclePoint(x, y, z);
    return;
  }
  if (isFirstCyclePoint()) {
    // return to initial Z which is clearance plane and set absolute mode
    repositionToCycleClearance(cycle, x, y, z);
    writeBlock(gFeedModeModal.format(94));
    var g71 = z71Output.format(cycle.clearance);

    var F = cycle.feedrate;
    var P = !cycle.dwell ? 0 : clamp(1, cycle.dwell * 1000, 99999999); // in milliseconds
    switch (cycleType) {
    case "drilling":
      writeBlock(gFormat.format(71), g71);
      writeBlock(
        gPlaneModal.format(17), gCycleModal.format(81),
        getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
        feedOutput.format(F), mFormat.format(53)
      );
      break;
    case "counter-boring":
      writeBlock(gFormat.format(71), g71);
      writeBlock(
        gPlaneModal.format(17), gCycleModal.format(82),
        getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
        conditional(P > 0, "P" + milliFormat.format(P)),
        feedOutput.format(F), mFormat.format(53)
      );
      break;
    case "chip-breaking":
      writeBlock(gFormat.format(71), g71);
      if (cycle.accumulatedDepth < cycle.depth) {
        writeBlock(
          gPlaneModal.format(17), gCycleModal.format(83),
          getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
          conditional(P > 0, "P" + milliFormat.format(P)),
          "I" + xyzFormat.format(cycle.incrementalDepth),
          "J" + xyzFormat.format(cycle.accumulatedDepth),
          feedOutput.format(F), mFormat.format(53)
        );
      } else {
        writeBlock(
          gPlaneModal.format(17), gCycleModal.format(73),
          getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
          "Q" + xyzFormat.format(cycle.incrementalDepth),
          conditional(P > 0, "P" + milliFormat.format(P)),
          feedOutput.format(F), mFormat.format(53)
        );
      }
      break;
    case "deep-drilling":
      writeBlock(gFormat.format(71), g71);
      writeBlock(
        gPlaneModal.format(17), gCycleModal.format(83),
        getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
        "Q" + xyzFormat.format(cycle.incrementalDepth),
        conditional(P > 0, "P" + milliFormat.format(P)),
        feedOutput.format(F), mFormat.format(53)
      );
      break;
    case "tapping":
      writeBlock(gFormat.format(71), g71);
      if (!F) {
        F = tool.getTappingFeedrate();
      }
      writeBlock(
        gPlaneModal.format(17), gCycleModal.format((tool.type == TOOL_TAP_LEFT_HAND) ? 74 : (getProperty("useG284") ? 284 : 84)),
        getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
        feedOutput.format(F),
        mFormat.format(53)
      );
      break;
    case "left-tapping":
      writeBlock(gFormat.format(71), g71);
      if (!F) {
        F = tool.getTappingFeedrate();
      }
      writeBlock(
        gPlaneModal.format(17), gCycleModal.format(74),
        getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
        feedOutput.format(F),
        mFormat.format(53)
      );
      break;
    case "right-tapping":
      writeBlock(gFormat.format(71), g71);
      if (!F) {
        F = tool.getTappingFeedrate();
      }
      writeBlock(
        gPlaneModal.format(17), gCycleModal.format(getProperty("useG284") ? 284 : 84),
        getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
        feedOutput.format(F),
        mFormat.format(53)
      );
      break;
    case "tapping-with-chip-breaking":
    case "left-tapping-with-chip-breaking":
    case "right-tapping-with-chip-breaking":
      writeBlock(gFormat.format(71), g71);
      if (cycle.accumulatedDepth < cycle.depth) {
        error(localize("Accumulated pecking depth is not supported for tapping cycles with chip breaking."));
      }
      if (!F) {
        F = tool.getTappingFeedrate();
      }
      // K is retract amount
      writeBlock(
        gPlaneModal.format(17), gCycleModal.format((tool.type == TOOL_TAP_LEFT_HAND ? 273 : 283)),
        gFeedModeModal.format(95), // feed per revolution
        getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
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
      writeBlock(gFormat.format(71), g71);
      // TAG: use I/J for shift
      writeBlock(
        gPlaneModal.format(17), gCycleModal.format(76),
        getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
        "Q" + xyzFormat.format(cycle.shift),
        conditional(P > 0, "P" + milliFormat.format(P)),
        feedOutput.format(F), mFormat.format(53)
      );
      break;
    case "back-boring":
      writeBlock(gFormat.format(71), g71);
      // TAG: use I/J for shift
      var dx = (gPlaneModal.getCurrent() == 19) ? cycle.backBoreDistance : 0;
      var dy = (gPlaneModal.getCurrent() == 18) ? cycle.backBoreDistance : 0;
      var dz = (gPlaneModal.getCurrent() == 17) ? cycle.backBoreDistance : 0;
      writeBlock(
        gPlaneModal.format(17), gRetractModal.format(98), gCycleModal.format(87),
        getCommonCycle(x - dx, y - dy, z - dz, cycle.bottom, cycle.clearance),
        "Q" + xyzFormat.format(cycle.shift),
        conditional(P > 0, "P" + milliFormat.format(P)),
        feedOutput.format(F), mFormat.format(53)
      );
      break;
    case "reaming":
      writeBlock(gFormat.format(71), g71);
      var FA = cycle.retractFeedrate;
      writeBlock(
        gPlaneModal.format(17), gCycleModal.format(85),
        getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
        conditional(P > 0, "P" + milliFormat.format(P)),
        feedOutput.format(F),
        conditional(FA != F, "FA=" + feedFormat.format(FA)), mFormat.format(53)
      );
      break;
    case "stop-boring":
      writeBlock(gFormat.format(71), g71);
      writeBlock(
        gPlaneModal.format(17), gCycleModal.format(86),
        getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
        conditional(P > 0, "P" + milliFormat.format(P)),
        feedOutput.format(F), mFormat.format(53)
      );
      if (getProperty("dwellAfterStop") > 0) {
        onDwell(getProperty("dwellAfterStop")); // make sure spindle reaches full spindle speed
      }
      break;
    case "boring":
      writeBlock(gFormat.format(71), g71);
      var FA = cycle.retractFeedrate;
      writeBlock(
        gPlaneModal.format(17), gCycleModal.format(89),
        getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
        conditional(P > 0, "P" + milliFormat.format(P)),
        feedOutput.format(F),
        conditional(FA != F, "FA=" + feedFormat.format(FA)), mFormat.format(53)
      );
      break;
    default:
      expandCyclePoint(x, y, z);
    }
    if (subprogramsAreSupported()) {
      // place cycle operation in subprogram
      handleCycleSubprogram(new Vector(x, y, z), new Vector(0, 0, 0), false);
      if (subprogramState.incrementalMode) { // set current position to clearance height
        setCyclePosition(cycle.clearance);
      }
    }
  } else {
    if (cycleExpanded) {
      expandCyclePoint(x, y, z);
    } else {
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
      if (subprogramsAreSupported() && subprogramState.incrementalMode) { // set current position to retract height
        setCyclePosition(cycle.retract);
      }
      if ((currentSection.getPolarMode && currentSection.getPolarMode() != POLAR_MODE_OFF) && currentSection.isMultiAxis()) {
        var polarPosition = getPolarPosition(x, y, z);
        setCurrentPositionAndDirection(polarPosition);
        writeBlock(xOutput.format(polarPosition.first.x), yOutput.format(polarPosition.first.y), zOutput.format(polarPosition.first.z),
          aOutput.format(polarPosition.second.x), bOutput.format(polarPosition.second.y), cOutput.format(polarPosition.second.z));
      } else {
        writeBlock(xOutput.format(x), yOutput.format(y), zOutput.format(z));
      }
      if (subprogramsAreSupported() && subprogramState.incrementalMode) { // set current position to clearance height
        setCyclePosition(cycle.clearance);
      }
    }
  }
}

/** Convert approach to sign. */
function approach(value) {
  validate((value == "positive") || (value == "negative"), "Invalid approach.");
  return (value == "positive") ? 1 : -1;
}

function protectedProbeMove(_cycle, x, y, z) {
  var _x = xOutput.format(x);
  var _y = yOutput.format(y);
  var _z = zOutput.format(z);
  var macroCall = settings.probing.macroCall;
  if (_z && z >= getCurrentPosition().z) {
    writeBlock(macroCall + 9810, _z, getFeed(cycle.feedrate)); // protected positioning move
  }
  if (_x || _y) {
    writeBlock(macroCall + 9810, _x, _y, getFeed(highFeedrate)); // protected positioning move
  }
  if (_z && z < getCurrentPosition().z) {
    writeBlock(macroCall + 9810, _z, getFeed(cycle.feedrate)); // protected positioning move
  }
}

function writeProbeCycle(cycle, x, y, z) {
  if (isProbeOperation()) {
    if (!settings.workPlaneMethod.useTiltedWorkplane && !isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1))) {
      if (!settings.probing.allowIndexingWCSProbing && currentSection.strategy == "probe") {
        error(localize("Updating WCS / work offset using probing is only supported by the CNC in the WCS frame."));
      }
    }
    if (printProbeResults()) {
      inspectionFileOpen();
      writeProbingToolpathInformation(z - cycle.depth + tool.diameter / 2);
      inspectionWriteCADTransform();
      inspectionWriteWorkplaneTransform();
      if (typeof inspectionWriteVariables == "function") {
        inspectionVariables.pointNumber += 1;
      }
      inspectionFileClose();
    }
    protectedProbeMove(cycle, x, y, z);
  }

  var macroCall = settings.probing.macroCall;
  switch (cycleType) {
  case "probing-x":
    protectedProbeMove(cycle, x, y, z - cycle.depth);
    writeBlock(
      macroCall + 9811,
      "PX=" + xyzFormat.format(x + approach(cycle.approach1) * (cycle.probeClearance + tool.diameter / 2)),
      "PQ=" + xyzFormat.format(cycle.probeOvertravel),
      getProbingArguments(cycle, true)
    );
    break;
  case "probing-y":
    protectedProbeMove(cycle, x, y, z - cycle.depth);
    writeBlock(
      macroCall + 9811,
      "PY=" + xyzFormat.format(y + approach(cycle.approach1) * (cycle.probeClearance + tool.diameter / 2)),
      "PQ=" + xyzFormat.format(cycle.probeOvertravel),
      getProbingArguments(cycle, true)
    );
    break;
  case "probing-z":
    protectedProbeMove(cycle, x, y, Math.min(z - cycle.depth + cycle.probeClearance, cycle.retract));
    writeBlock(
      macroCall + 9811,
      "PZ=" + xyzFormat.format(z - cycle.depth),
      "PQ=" + xyzFormat.format(cycle.probeOvertravel),
      getProbingArguments(cycle, true)
    );
    break;
  case "probing-x-wall":
    protectedProbeMove(cycle, x, y, z);
    writeBlock(
      macroCall + 9812,
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
      macroCall + 9812,
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
      macroCall + 9812,
      "PX=" + xyzFormat.format(cycle.width1),
      "PQ=" + xyzFormat.format(cycle.probeOvertravel),
      // not required "R" + xyzFormat.format(cycle.probeClearance),
      getProbingArguments(cycle, true)
    );
    break;
  case "probing-x-channel-with-island":
    protectedProbeMove(cycle, x, y, z);
    writeBlock(
      macroCall + 9812,
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
      macroCall + 9812,
      "PY=" + xyzFormat.format(cycle.width1),
      "PQ=" + xyzFormat.format(cycle.probeOvertravel),
      // not required "R" + xyzFormat.format(cycle.probeClearance),
      getProbingArguments(cycle, true)
    );
    break;
  case "probing-y-channel-with-island":
    protectedProbeMove(cycle, x, y, z);
    writeBlock(
      macroCall + 9812,
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
      macroCall + 9814,
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
      macroCall + 9823,
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
      macroCall + 9814,
      "PD=" + xyzFormat.format(cycle.width1),
      "PQ=" + xyzFormat.format(cycle.probeOvertravel),
      // not required "R" + xyzFormat.format(cycle.probeClearance),
      getProbingArguments(cycle, true)
    );
    break;
  case "probing-xy-circular-partial-hole":
    protectedProbeMove(cycle, x, y, z - cycle.depth);
    writeBlock(
      macroCall + 9823,
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
      macroCall + 9814,
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
      macroCall + 9823,
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
      macroCall + 9812,
      "PX=" + xyzFormat.format(cycle.width1),
      "PQ=" + xyzFormat.format(cycle.probeOvertravel),
      // not required "R" + xyzFormat.format(-cycle.probeClearance),
      getProbingArguments(cycle, true)
    );
    writeBlock(
      macroCall + 9812,
      "PY=" + xyzFormat.format(cycle.width2),
      "PQ=" + xyzFormat.format(cycle.probeOvertravel),
      // not required "R" + xyzFormat.format(-cycle.probeClearance),
      getProbingArguments(cycle, true)
    );
    break;
  case "probing-xy-rectangular-boss":
    protectedProbeMove(cycle, x, y, z);
    writeBlock(
      macroCall + 9812,
      "PZ=" + xyzFormat.format(z - cycle.depth),
      "PX=" + xyzFormat.format(cycle.width1),
      "PQ=" + xyzFormat.format(cycle.probeOvertravel),
      "PR=" + xyzFormat.format(cycle.probeClearance),
      getProbingArguments(cycle, true)
    );
    writeBlock(
      macroCall + 9812,
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
      macroCall + 9812,
      "PZ=" + xyzFormat.format(z - cycle.depth),
      "PX=" + xyzFormat.format(cycle.width1),
      "PQ=" + xyzFormat.format(cycle.probeOvertravel),
      "PR=" + xyzFormat.format(-cycle.probeClearance),
      getProbingArguments(cycle, true)
    );
    writeBlock(
      macroCall + 9812,
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
      macroCall + 9815, xOutput.format(cornerX), yOutput.format(cornerY),
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
      macroCall + 9816, xOutput.format(cornerX), yOutput.format(cornerY),
      conditional(cornerI != 0, "PI=" + xyzFormat.format(cornerI)),
      conditional(cornerJ != 0, "PJ=" + xyzFormat.format(cornerJ)),
      "PQ=" + xyzFormat.format(cycle.probeOvertravel),
      getProbingArguments(cycle, true)
    );
    break;
  case "probing-x-plane-angle":
    protectedProbeMove(cycle, x, y, z - cycle.depth);
    writeBlock(
      macroCall + 9843,
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
      macroCall + 9843,
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
      macroCall + 9819,
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
    }
    break;
  case "probing-xy-pcd-boss":
    protectedProbeMove(cycle, x, y, z);
    writeBlock(
      macroCall + 9819,
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
    }
    break;
  }
}

function getProbingArguments(cycle, updateWCS) {
  var outputWCSCode = updateWCS && currentSection.strategy == "probe";
  var probeOutputWorkOffset = currentSection.probeWorkOffset;
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

function printProbeResults() {
  return currentSection.getParameter("printResults", 0) == 1;
}

/** Output rotation offset based on angular probing cycle. */
function setProbeAngle() {
  if (probeVariables.outputRotationCodes) {
    var probeOutputWorkOffset = currentSection.probeWorkOffset;
    validate(probeOutputWorkOffset <= 6, "Angular Probing only supports work offsets 1-6.");
    if (probeVariables.probeAngleMethod == "G68" && (Vector.diff(currentSection.getGlobalInitialToolAxis(), new Vector(0, 0, 1)).length > 1e-4)) {
      error(localize("You cannot use multi axis toolpaths while G11 Rotation is in effect."));
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
    }
    if (validateWorkOffset) {
      for (var i = currentSection.getId(); i < getNumberOfSections(); ++i) {
        if (getSection(i).workOffset != currentSection.workOffset) {
          error(localize("WCS offset cannot change while using angle rotation compensation."));
        }
      }
    }
    probeVariables.outputRotationCodes = false;
  }
}

validate(settings.probing, "Setting 'probing' is required but not defined.");
var probeVariables = {
  outputRotationCodes: false, // determines if it is required to output rotation codes
  compensationXY     : undefined,
  probeAngleMethod   : undefined,
  rotaryTableAxis    : -1
};

function onLinear(_x, _y, _z, feed) {
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      writeBlock(gPlaneModal.format(17));
      switch (radiusCompensation) {
      case RADIUS_COMPENSATION_LEFT:
        writeBlock(gMotionModal.format(1), gFormat.format(41), x, y, z, getToolOffsetCode("diameter"), getFeed(feed));
        break;
      case RADIUS_COMPENSATION_RIGHT:
        writeBlock(gMotionModal.format(1), gFormat.format(42), x, y, z, getToolOffsetCode("diameter"), getFeed(feed));
        break;
      default:
        writeBlock(gMotionModal.format(1), gFormat.format(40), x, y, z, getFeed(feed));
      }
    } else {
      writeBlock(gMotionModal.format(1), x, y, z, getFeed(feed));
    }
  }
}

function onRapid5D(_x, _y, _z, _a, _b, _c) {
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("This post configuration has not been customized for 5-axis simultaneous toolpath."));
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation mode cannot be changed at rapid traversal."));
  }
  var xyz = adjustXYZForBallCutter(new Vector(_x, _y, _z), new Vector(_a, _b, _c));
  var x = xOutput.format(xyz.x);
  var y = yOutput.format(xyz.y);
  var z = zOutput.format(xyz.z);
  var a = aOutput.format(_a);
  var b = bOutput.format(_b);
  var c = cOutput.format(_c);
  var m = getRotaryDirectionCode(new Vector(_a, _b, _c));
  if (x || y || z || a || b || c) {
    writeBlock(gMotionModal.format(0), x, y, z, a, b, c, m);
    forceFeed();
  }
}

function adjustXYZForBallCutter(xyz, abc) {
  if (getProperty("centerPointOutput") && tool.type == TOOL_MILLING_END_BALL) {
    var toolAxis = machineConfiguration.getDirection(new Vector(abc));
    toolAxis.multiply(tool.cornerRadius);
    xyz = Vector.sum(xyz, toolAxis);
  }
  return xyz;
}

function onLinear5D(_x, _y, _z, _a, _b, _c, feed, feedMode) {
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("This post configuration has not been customized for 5-axis simultaneous toolpath."));
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for 5-axis move."));
  }
  var xyz = adjustXYZForBallCutter(new Vector(_x, _y, _z), new Vector(_a, _b, _c));
  var x = xOutput.format(xyz.x);
  var y = yOutput.format(xyz.y);
  var z = zOutput.format(xyz.z);
  var a = aOutput.format(_a);
  var b = bOutput.format(_b);
  var c = cOutput.format(_c);

  if (feedMode == FEED_INVERSE_TIME) {
    forceFeed();
  }
  var f = feedMode == FEED_INVERSE_TIME ? inverseTimeOutput.format(feed) : getFeed(feed);
  var fMode = feedMode == FEED_INVERSE_TIME ? 93 : 94;

  var m = getRotaryDirectionCode(new Vector(_a, _b, _c));
  if (x || y || z || a || b || c) {
    writeBlock(gFeedModeModal.format(fMode), gMotionModal.format(1), x, y, z, a, b, c, f, m);
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      forceFeed(); // force feed on next line
    } else {
      writeBlock(gFeedModeModal.format(fMode), gMotionModal.format(1), f);
    }
  }
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
  }
  if (isFullCircle()) {
    if (isHelical()) {
      linearize(tolerance);
      return;
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gPlaneModal.format(17), gMotionModal.format(clockwise ? 2 : 3), iOutput.format(circularOffset.x), jOutput.format(circularOffset.y), getFeed(feed));
      break;
    case PLANE_ZX:
      writeBlock(gPlaneModal.format(18), gMotionModal.format(clockwise ? 2 : 3), iOutput.format(circularOffset.x), kOutput.format(circularOffset.z), getFeed(feed));
      break;
    case PLANE_YZ:
      writeBlock(gPlaneModal.format(19), gMotionModal.format(clockwise ? 2 : 3), jOutput.format(circularOffset.y), kOutput.format(circularOffset.z), getFeed(feed));
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
        xOutput.format(x), yOutput.format(y), zOutput.format(z),
        iOutput.format(circularOffset.x), jOutput.format(circularOffset.y), getFeed(feed));
      break;
    case PLANE_ZX:
      writeBlock(
        gPlaneModal.format(18), gMotionModal.format(clockwise ? 2 : 3),
        xOutput.format(x), yOutput.format(y), zOutput.format(z),
        iOutput.format(circularOffset.x), kOutput.format(circularOffset.z), getFeed(feed));
      break;
    case PLANE_YZ:
      writeBlock(
        gPlaneModal.format(19), gMotionModal.format(clockwise ? 2 : 3),
        xOutput.format(x), yOutput.format(y), zOutput.format(z),
        jOutput.format(circularOffset.y), kOutput.format(circularOffset.z), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  }
}

var mapCommand = {
  COMMAND_END                     : 2,
  COMMAND_SPINDLE_CLOCKWISE       : 3,
  COMMAND_SPINDLE_COUNTERCLOCKWISE: 4,
  COMMAND_ORIENTATE_SPINDLE       : 19
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
  case COMMAND_STOP_SPINDLE:
    writeBlock(mFormat.format(5));
    if (getProperty("dwellAfterStop") > 0) {
      onDwell(getProperty("dwellAfterStop"));
    }
    return;
  case COMMAND_LOAD_TOOL:
    setSpindleLoadMonitor(false); // disable spindle load monitoring
    writeComment(tool.comment);
    var toolCall = "T" + toolFormat.format(tool.number);
    if (getProperty("preloadTool")) {
      if (getProperty("safeToolChange")) {
        writeBlock("IF [ VTLCN EQ", toolFormat.format(tool.number), "]", skipNLines(5));
        writeBlock("IF [ VTLNN EQ", toolFormat.format(tool.number), "]", skipNLines(3));
        writeBlock("IF [ VTLNN EQ 0 ]", skipNLines(2));
        writeBlock(mFormat.format(64));
        writeToolBlock(mFormat.format(6), toolCall);
      } else {
        if (!isFirstSection()) {
          writeComment(toolCall);
          writeToolBlock(mFormat.format(6));
        } else {
          writeToolBlock(toolCall, mFormat.format(6));
        }
      }
      var preloadTool = getNextTool(tool.number != getFirstTool().number);
      if (preloadTool) {
        writeBlock("T" + toolFormat.format(preloadTool.number)); // preload next/first tool
      } else if (getProperty("safeToolChange")) {
        writeBlock(formatComment("*"));
      }
    } else {
      if (getProperty("safeToolChange")) {
        writeBlock("IF [ VTLCN EQ", toolFormat.format(tool.number), "]", skipNLines(2));
        writeToolBlock(mFormat.format(6), toolCall);
        writeBlock(formatComment("*"));
      } else {
        writeToolBlock(toolCall, mFormat.format(6));
      }
    }
    setProperty("showSequenceNumbers", saveShowSequenceNumbers);
    return;
  case COMMAND_LOCK_MULTI_AXIS:
    if (machineConfiguration.isMultiAxisConfiguration()) {
      if (aOutput.isEnabled()) {
        writeBlock(fourthAxisClamp.format(10)); // lock A-axis
      }
      if (bOutput.isEnabled()) {
        writeBlock(fifthAxisClamp.format(20)); // lock B-axis
      }
      if (cOutput.isEnabled()) {
        writeBlock(sixthAxisClamp.format(26)); // lock C-axis
      }
    }
    return;
  case COMMAND_UNLOCK_MULTI_AXIS:
    if (machineConfiguration.isMultiAxisConfiguration()) {
      if (aOutput.isEnabled()) {
        writeBlock(fourthAxisClamp.format(11)); // unlock A-axis
      }
      if (bOutput.isEnabled()) {
        writeBlock(fifthAxisClamp.format(21)); // unlock B-axis
      }
      if (cOutput.isEnabled()) {
        writeBlock(sixthAxisClamp.format(27)); // unlock C-axis
      }
    }
    return;
  case COMMAND_BREAK_CONTROL:
    return;
  case COMMAND_TOOL_MEASURE:
    return;
  case COMMAND_PROBE_ON:
    return;
  case COMMAND_PROBE_OFF:
    return;
  }

  var mcode = mapCommand[getCommandStringId(command)];
  if (mcode != undefined) {
    if (mcode == "") {
      return; // ignore
    }
    writeBlock(mFormat.format(mcode));
  } else {
    onUnsupportedCommand(command);
  }
}

function onSectionEnd() {
  if (subprogramsAreSupported()) {
    subprogramEnd();
  }
  if (currentSection.isMultiAxis()) {
    writeBlock(gFeedModeModal.format(94));
  }

  if (!isLastSection()) {
    if (getNextSection().getTool().coolant != tool.coolant) {
      setCoolant(COOLANT_OFF);
    }
    if (tool.breakControl && isToolChangeNeeded(getNextSection(), getProperty("toolAsName") ? "description" : "number")) {
      onCommand(COMMAND_BREAK_CONTROL);
    }
  }
  if (tcp.isSupportedByOperation) {
    writeBlock(conditional(getProperty("useTPOC"), gFormat.format(444)));
  }
  loadMonitorVal = getProperty("loadMonitorVal");

  if (isProbeOperation()) {
    writeBlock(settings.probing.macroCall + 9833); // spin the probe off
    if (probeVariables.probeAngleMethod != "G68") {
      setProbeAngle(); // output probe angle rotations if required
    }
  }
  forceAny();
  rotaryAxisDirectionModal.reset(); // reset rotary axis direction code for the next operation
}

/** Output block to do safe retract and/or move to home position. */
function writeRetract() {
  var retract = getRetractParameters.apply(this, arguments);
  if (retract && retract.words.length > 0) {
    if (typeof cancelWCSRotation == "function" && getSetting("retract.cancelRotationOnRetracting", false)) { // cancel rotation before retracting
      cancelWCSRotation();
    }
    for (var i in retract.words) {
      var words = retract.singleLine ? retract.words : retract.words[i];
      switch (retract.method) {
      case "G16":
        gMotionModal.reset();
        if (retract.retractAxes[2]) { // substitute Z-position with Z=VPSLZ when G16 retract method is used
          words = "Z=VPSLZ";
        }
        writeBlock(gFormat.format(16), hFormat.format(0), gMotionModal.format(0), words);
        break;
      case "G0":
        gMotionModal.reset();
        writeBlock(gAbsIncModal.format(90), gMotionModal.format(0), words);
        break;
      default:
        error(subst(localize("Unsupported safe position method '%1'"), retract.method));
      }
      var posX = retract.positions.x == softLimitPositions.x ? MAX : retract.positions.x;
      var posY = retract.positions.y == softLimitPositions.y ? MAX : retract.positions.y;
      var posZ = retract.positions.z == softLimitPositions.z ? MAX : retract.positions.z;
      machineSimulation({
        x          : retract.singleLine || words.indexOf("X") != -1 ? posX : undefined,
        y          : retract.singleLine || words.indexOf("Y") != -1 ? posY : undefined,
        z          : retract.singleLine || words.indexOf("Z") != -1 ? posZ : undefined,
        coordinates: MACHINE
      });
      if (retract.singleLine) {
        break;
      }
    }
  }
}

function onClose() {
  optionalSection = false;
  if (isDPRNTopen) {
    inspectionFileOpen();
    inspectionPrintLine("END");
    inspectionFileClose();
    isDPRNTopen = false;
  }
  if (probeVariables.probeAngleMethod == "G68") {
    cancelWorkPlane();
  }
  writeln("");
  onCommand(COMMAND_COOLANT_OFF);
  onCommand(COMMAND_STOP_SPINDLE);

  if (machineConfiguration.isMultiAxisConfiguration()) {
    cancelWorkPlane();
    setWorkPlane(new Vector(0, 0, 0)); // reset working plane
  }
  writeRetract(Z);
  if (getSetting("retract.homeXY.onProgramEnd", false)) {
    writeRetract(settings.retract.homeXY.onProgramEnd);
  }

  setSpindleLoadMonitor(false); // disable spindle load monitoring
  if (getProperty("toolLifeMonitor")) {
    writeBlock("TLFOFF"); // disable tool life monitoring
  }
  if (typeof inspectionProcessSectionEnd == "function") {
    inspectionProcessSectionEnd();
  }
  if (getProperty("useChipConveyor")) {
    writeBlock(mFormat.format(278));
  }
  // Process Manual NC commands
  executeManualNC();
  onCommand(COMMAND_END);

  if (subprogramsAreSupported()) {
    writeSubprograms();
  }
  writeToolCheckEnd();
}

function inspectionPrintLine() {
  var prefix = "'";
  var suffix = "'";

  for (i in arguments) {
    if (String(arguments[i]).charAt(0) == "@") {
      writeln("PUT " + arguments[i].substring(1));
    } else if (arguments[i].length > 12) {
      var split = arguments[i].match(/.{1,12}/g);
      for (j in split) {
        writeln("PUT " + prefix + split[j] + suffix);
      }
    } else {
      writeln("PUT " + prefix + arguments[i] + suffix);
    }
  }
  writeln("WRITE C");
}

var isResultsFileOpen = false;
function inspectionFileOpen() {
  var reniResFile = "REN-RESULTS"; //File name is hardcoded for renishaw output results
  if (!isResultsFileOpen) {
    writeComment("PROBING FILE OPEN");
    // writeComment(subst("IF ALARM PLEASE DELETE THE %1.TXT AND RESTART THE PROGRAM", reniResFile)); //okuma
    writeln("FWRITC MD1:" + reniResFile + ".TXT;A");
    isResultsFileOpen = true;
  }
}

function inspectionFileClose() {
  if (isResultsFileOpen) {
    writeln("CLOSE C");
    isResultsFileOpen = false;
  }
}

var isDPRNTopen = false;
var WARNING_OUTDATED = 0;
var toolpathIdFormat = createFormat({decimals:5, forceDecimal:true});
var patternInstances = new Array();
var initializePatternInstances = true; // initialize patternInstances array the first time inspectionGetToolpathId is called
function inspectionGetToolpathId(section) {
  if (initializePatternInstances) {
    for (var i = 0; i < getNumberOfSections(); ++i) {
      var _section = getSection(i);
      if (_section.getInternalPatternId) {
        var sectionId = _section.getId();
        var patternId = _section.getInternalPatternId();
        var isPatterned = _section.isPatterned && _section.isPatterned();
        var isMirrored = patternId != _section.getPatternId();
        if (isPatterned || isMirrored) {
          var isKnownPatternId = false;
          for (var j = 0; j < patternInstances.length; j++) {
            if (patternId == patternInstances[j].patternId) {
              patternInstances[j].patternIndex++;
              patternInstances[j].sections.push(sectionId);
              isKnownPatternId = true;
              break;
            }
          }
          if (!isKnownPatternId) {
            patternInstances.push({patternId:patternId, patternIndex:1, sections:[sectionId]});
          }
        }
      }
    }
    initializePatternInstances = false;
  }

  var _operationId = section.getParameter("autodeskcam:operation-id", "");
  var key = -1;
  for (k in patternInstances) {
    if (patternInstances[k].patternId == _operationId) {
      key = k;
      break;
    }
  }
  var _patternId = (key > -1) ? patternInstances[key].sections.indexOf(section.getId()) + 1 : 0;
  var _cycleId = cycle && ("cycleID" in cycle) ? cycle.cycleID : section.getParameter("cycleID", 0);
  if (isProbeOperation(section) && _cycleId == 0 && getGlobalParameter("product-id").toLowerCase().indexOf("fusion") > -1) {
    // we expect the cycleID to be non zero always for macro probing toolpaths, Fusion only
    warningOnce(localize("Outdated macro probing operations detected. Please regenerate all macro probing operations."), WARNING_OUTDATED);
  }
  if (_patternId > 99) {
    error(subst(localize("The maximum number of pattern instances is limited to 99" + EOL +
      "You need to split operation '%1' into separate pattern groups."
    ), section.getParameter("operation-comment", "")));
  }
  if (_cycleId > 99) {
    error(subst(localize("The maximum number of probing cycles is limited to 99" + EOL +
      "You need to split operation '%1' to multiple operations with less than 100 cycles in each operation."
    ), section.getParameter("operation-comment", "")));
  }
  return toolpathIdFormat.format(_operationId + (_cycleId * 0.01) + (_patternId * 0.0001) + 0.00001);
}

function inspectionCreateResultsFileHeader() {
  if (isDPRNTopen) {
    if (!getProperty("singleResultsFile")) {
      inspectionPrintLine("END");
      inspectionFileClose();
      isDPRNTopen = false;
    }
  }

  if (isProbeOperation() && !printProbeResults()) {
    return; // if print results is not desired by probe/ probeWCS
  }

  if (!isDPRNTopen) {
    // check for existence of none alphanumeric characters but not spaces
    var resFile;
    if (getProperty("singleResultsFile")) {
      resFile = getParameter("job-description") + "-RESULTS";
    } else {
      resFile = getParameter("operation-comment") + "-RESULTS";
    }
    resFile = resFile.replace(/:/g, "-");
    resFile = resFile.replace(/[^a-zA-Z0-9 -]/g, "");
    resFile = resFile.replace(/\s/g, "-");
    resFile = resFile.toUpperCase();

    inspectionFileOpen();
    inspectionPrintLine("START");
    inspectionPrintLine("RESULTSFILE ", resFile);

    if (hasGlobalParameter("document-id")) {
      inspectionPrintLine("DOCUMENTID " + getGlobalParameter("document-id").toUpperCase());
    }
    if (hasGlobalParameter("model-version")) {
      inspectionPrintLine("MODELVERSION " + getGlobalParameter("model-version").toUpperCase());
    }
  }
  if (isProbeOperation() && printProbeResults()) {
    isDPRNTopen = true;
  }
}

function getPointNumber() {
  if (typeof inspectionWriteVariables == "function") {
    return (inspectionVariables.pointNumber);
  } else {
    return ("@VS62");
  }
}

function inspectionWriteCADTransform() {
  var cadOrigin = currentSection.getModelOrigin();
  var cadWorkPlane = currentSection.getModelPlane().getTransposed();
  var cadEuler = cadWorkPlane.getEuler2(EULER_XYZ_S);
  inspectionPrintLine(
    "G331 N",
    getPointNumber(),
    " A" + abcFormat.format(cadEuler.x),
    " B" + abcFormat.format(cadEuler.y),
    " C" + abcFormat.format(cadEuler.z),
    " X" + xyzFormat.format(-cadOrigin.x),
    " Y" + xyzFormat.format(-cadOrigin.y),
    " Z" + xyzFormat.format(-cadOrigin.z)
  );
}

function inspectionWriteWorkplaneTransform() {
  var orientation = (machineConfiguration.isMultiAxisConfiguration() && getCurrentDirection() != undefined) ? machineConfiguration.getOrientation(getCurrentDirection()) : currentSection.workPlane;
  var abc = orientation.getEuler2(EULER_XYZ_S);
  inspectionPrintLine(
    "G330 N",
    getPointNumber(),
    " A" + abcFormat.format(abc.x),
    " B" + abcFormat.format(abc.y),
    " C" + abcFormat.format(abc.z),
    " X" + xyzFormat.format(0),
    " Y" + xyzFormat.format(0),
    " Z" + xyzFormat.format(0),
    " I0 R0"
  );
}

function writeProbingToolpathInformation(cycleDepth) {
  inspectionPrintLine("TOOLPATHID " + inspectionGetToolpathId(currentSection));
  if (isInspectionOperation()) {
    inspectionPrintLine("TOOLPATH " + getParameter("operation-comment").toUpperCase().replace(/[()]/g, ""));
  } else {
    inspectionPrintLine("CYCLEDEPTH " + xyzFormat.format(cycleDepth));
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
// >>>>> INCLUDED FROM include_files/setProbeAngleMethod.cpi
function setProbeAngleMethod() {
  var axisRotIsSupported = false;
  var axes = [machineConfiguration.getAxisU(), machineConfiguration.getAxisV(), machineConfiguration.getAxisW()];
  for (var i = 0; i < axes.length; ++i) {
    if (axes[i].isEnabled() && isSameDirection((axes[i].getAxis()).getAbsolute(), new Vector(0, 0, 1)) && axes[i].isTable()) {
      axisRotIsSupported = true;
      if (settings.probing.probeAngleVariables.method == 0) { // Fanuc
        validate(i < 2, localize("Rotary table axis is invalid."));
        probeVariables.rotaryTableAxis = i;
      } else { // Haas
        probeVariables.rotaryTableAxis = axes[i].getCoordinate();
      }
      break;
    }
  }
  if (settings.probing.probeAngleMethod == undefined) {
    probeVariables.probeAngleMethod = axisRotIsSupported ? "AXIS_ROT" : getProperty("useG54x4") ? "G54.4" : "G68"; // automatic selection
  } else {
    probeVariables.probeAngleMethod = settings.probing.probeAngleMethod; // use probeAngleMethod from settings
    if (probeVariables.probeAngleMethod == "AXIS_ROT" && !axisRotIsSupported) {
      error(localize("Setting probeAngleMethod 'AXIS_ROT' is not supported on this machine."));
    }
  }
  probeVariables.outputRotationCodes = true;
}
// <<<<< INCLUDED FROM include_files/setProbeAngleMethod.cpi
