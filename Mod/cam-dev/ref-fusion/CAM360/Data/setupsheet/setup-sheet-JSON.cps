/**
  Copyright (C) 2012-2016 by Autodesk, Inc.
  All rights reserved.

  JSON setup sheet.

  $Revision: 42020 a20cdb5530b7a5b3e441ecf55e3eebdd06fd6cd5 $
  $Date: 2018-06-18 18:34:01 $

  FORKID {4E9DFE89-DA1C-4531-98C9-7FECF672BD47}
*/

// Disable a few lint rules that don't seem compatible with the post's underlying JS engine
/* eslint-disable prefer-reflect */
/* eslint-disable prefer-arrow-callback */

description = "Setup sheet (JSON)";
vendor = "Autodesk";
vendorUrl = "http://www.autodesk.com";
legal = "Copyright (C) 2012-2016 by Autodesk, Inc.";
certificationLevel = 2;
longDescription =  "Setup sheet data export in JSON (JavaScript Object Notation) format.";
capabilities = CAPABILITY_SETUP_SHEET;
extension = "json";
keywords = "MODEL_IMAGE PREVIEW_IMAGE"
setCodePage("utf-8");

// Allows use of different machines across setups
allowMachineChangeOnSection = true;

// A running container object that will eventually be exported as JSON
let setupSheetObj = {};

// An object to cache all parameters for the current section (operation)
let cachedParams = {};

// A container for miscellaneous items that need to be gathered
// along the way and processed at the end (in onClose)
let runningValues = {};

// map image extensions to mime types
const supportedImageTypes = {
  bmp: "image/bmp",
  gif: "image/gif",
  jpg: "image/jpeg",
  jpeg: "image/jpeg",
  png: "image/png",
  tif: "image/tiff",
  tiff: "image/tiff"
};

// Called first, before any data is processed
// Initialize a few things
function onOpen() {
  setupSheetObj = getInitialSetupObject();
  runningValues = getRunningValuesObject();
}

// Called as each parameter is passed into the post
// Cache them all in an object for later use (mostly, in onSection and friends)
function onParameter(name, value) {
  cachedParams[name] = value;
}

// Called for each CAM operation
// Most processing is handled here
function onSection() {
  // Add the sections for this operation to the container object
  addSummaryObject();
  addToolObject(tool);
  addSetupObject();
  addOperationObject(tool);

  // No need to process anything else in this section.
  // This will stop processing the section and go directly on onSectionEnd.
  skipRemainingSection();
}

// Process "no-tool" operations
function onSectionSpecialCycle() {
  // Get an empty operation properties object (all props with null values)
  // and then update a few select properties useful for "no-tool" operations
  var operationProps = getEmptyOperationProperties();
  operationProps.description = getParamValueOrNull("operation-comment")
  operationProps.strategy = cachedParams["operation-strategy"] ? getStrategyDescription(cachedParams["operation-strategy"]) : null;
  operationProps.wcs = currentSection.workOffset;
  operationProps.tolerance = getParamValueOrNull("operation:tolerance");

  const operation = {
    id: cachedParams["autodeskcam:operation-id"],
    images: [],
    properties: operationProps
  };

  // add the operation to the container
  setupSheetObj.operations.push(operation);
}

// Process "Manual NC" operations
function onManualNC(command, value) {
  var cmdName = getManualNCCommandName(command);
  var description = value ? (cmdName + " = " + String(value)) : cmdName;
  var operation = createManualNCOperation();
  operation.properties.description = description;

  // add the operation to the container
  setupSheetObj.operations.push(operation);
}

// Called at the end of each CAM operation
function onSectionEnd() {
  // Clear out the cached params in preparation for the next operation
  cachedParams = {};
}

// Called after all processing finishes
// Tidy up a few things and store our JSON payload file
function onClose() {
  // Update the properties that had to wait until all data was processed
  updateCalculatedPropertyValues();

  // Write the final container object as JSON
  writeln(JSON.stringify(setupSheetObj, null, 0));
}

// Calculate values in the container object based on other data
function updateCalculatedPropertyValues() {
  setupSheetObj.summary.properties.maxZ = Math.max.apply(null, runningValues.zVals);
  setupSheetObj.summary.properties.minZ = Math.min.apply(null, runningValues.zVals);
  setupSheetObj.summary.properties.maxFeedrate = Math.max.apply(null, runningValues.feedrates);
  setupSheetObj.summary.properties.maxSpindleSpeed = Math.max.apply(null, runningValues.spindleSpeeds);
  setupSheetObj.summary.properties.numSetups = setupSheetObj.setups.length;
  setupSheetObj.summary.properties.numOperations = setupSheetObj.operations.length;
  setupSheetObj.summary.properties.numTools = Object.keys(runningValues.tools).length;
  setupSheetObj.summary.properties.tools = getToolList();
  setupSheetObj.summary.properties.cuttingDistance = runningValues.cuttingDistance;
  setupSheetObj.summary.properties.rapidDistance = runningValues.rapidDistance;
  setupSheetObj.summary.properties.cycleTime = runningValues.cycleTime; // missing rapid time

  // Update the "operationList" property of each setup with an array
  // containing the id's of its child operations. Note, once done, we
  // no longer need (or want) the setup's id property, so remove it.
  setupSheetObj.setups.forEach(function (setup) {
    setup.operationList = runningValues.operationGroups[setup.id];
    delete setup.id;
  });

  // Insert some aggregated tool properties
  insertAggregateToolProperties();

  // Reorder the tool objects in ascending order by tool number
  setupSheetObj.tools.sort(function(t1, t2) {
    return t1.properties.number - t2.properties.number;
  });
}

// Add a summary object to the container, but only if
// this is the first operation of the entire process
function addSummaryObject() {
  if (isFirstSection()) {
    const image = getImageFromTempFolder(modelImagePath);
    const imageArray = image ? [image] : [];
    setupSheetObj.summary.images = imageArray;
    setupSheetObj.summary.properties = getSummaryProperties();
  }
}

// Get a cached parameter value or null if the parameter is undefined
function getParamValueOrNull(param) {
  return (cachedParams[param] !== undefined) ? cachedParams[param] : null;
}

// Get a set of operation properties as a JSON object
function getOperationProperties(tool) {
  const isJet = currentSection.getType() === TYPE_JET;
  const isMill = currentSection.getType() === TYPE_MILLING;
  const isTurn = currentSection.getType() === TYPE_TURNING;
  const useCoolant = tool.coolant !== COOLANT_OFF;
  const isProbeOp = isProbeOperation();

  // grab some operation-oriented data from various post methods
  const maxZ = currentSection.getGlobalZRange().getMaximum();
  const minZ = currentSection.getGlobalZRange().getMinimum();
  const feed = currentSection.getMaximumFeedrate();
  let spindleSpeed = currentSection.getMaximumSpindleSpeed();
  const cuttingDistance = currentSection.getCuttingDistance();
  const rapidDistance = currentSection.getRapidDistance();
  const cycleTime = currentSection.getCycleTime();

  let surfaceSpeed = null;
  if (currentSection.getType() === TYPE_TURNING) {
    if (currentSection.getTool().getSpindleMode() === SPINDLE_CONSTANT_SURFACE_SPEED) {
      surfaceSpeed = currentSection.getTool().surfaceSpeed;
      spindleSpeed = null;
    }
  }

  let jetCutType = null;
  let quality = null;
  if (isJet) {
    quality = currentSection.quality;
    switch (currentSection.jetMode) {
      case JET_MODE_THROUGH:
        jetCutType = localize("Through cutting");
        break;
      case JET_MODE_ETCHING:
        jetCutType = localize("Etching");
        break;
      case JET_MODE_VAPORIZE:
        jetCutType = localize("Vaporize");
        break;
    }
  }

  // store these values for future aggregation / processing
  runningValues.zVals.push(maxZ);
  runningValues.zVals.push(minZ);
  runningValues.feedrates.push(feed);
  runningValues.spindleSpeeds.push(spindleSpeed);
  runningValues.cuttingDistance += cuttingDistance;
  runningValues.rapidDistance += rapidDistance;
  runningValues.cycleTime += cycleTime;

  let maxStepDown = null;
  if (cachedParams["operation:maximumStepdown"] !== undefined && cachedParams["operation:maximumStepdown"] > 0) {
    maxStepDown = cachedParams["operation:maximumStepdown"];
  }

  let maxStepOver = null;
  if (cachedParams["operation:maximumStepover"] !== undefined) {
    maxStepOver = cachedParams["operation:maximumStepover"];
  } else if (cachedParams["operation:stepover"] !== undefined) {
      maxStepOver = cachedParams["operation:stepover"];
  }

  //Stock to leave for milling operations
  let radialStockToLeave = cachedParams["operation:stockToLeave"];
  let axialStockToLeave = cachedParams["operation:verticalStockToLeave"];
  let stockToLeave = null;

  if (radialStockToLeave !== undefined && axialStockToLeave !== undefined) {
    if (radialStockToLeave === axialStockToLeave) {
      stockToLeave = radialStockToLeave;
      radialStockToLeave = null;
      axialStockToLeave = null;
    }
  } else if (radialStockToLeave !== undefined) {
    axialStockToLeave = null;
  } else if (axialStockToLeave !== undefined) {
    radialStockToLeave = null;
  } else {
    radialStockToLeave = null;
    axialStockToLeave = null;
  }

  //Finish allowance for turning operations
  let xStockToLeave = cachedParams["operation:xStockToLeave"];
  let zStockToLeave = cachedParams["operation:zStockToLeave"];
  let finishAllowance = null;

  if (xStockToLeave !== undefined && zStockToLeave !== undefined) {
    if (xStockToLeave === zStockToLeave) {
      finishAllowance = xStockToLeave;
      xStockToLeave = null;
      zStockToLeave = null;
    }
  } else if (xStockToLeave !== undefined) {
    zStockToLeave = null;
  } else if (zStockToLeave !== undefined) {
    xStockToLeave = null;
  } else {
    xStockToLeave = null;
    zStockToLeave = null;
  }

  // Note, the properties in this returned object need to be kept in
  // sync with the object returned by getEmptyOperationProperties()
  return {
    coolant: !isProbeOp && (!isJet || useCoolant) ? getCoolantDescription(tool.coolant) : null,
    compensation: null,
    cuttingDistance: isProbeOp ? null : cuttingDistance,
    cuttingType: jetCutType,
    cycleTime: isProbeOp ? null : cycleTime,
    description: getParamValueOrNull("operation-comment"),
    feedratePerRevolution: isProbeOp || currentSection.feedMode != FEED_PER_REVOLUTION ? null : getParamValueOrNull("operation:tool_feedCuttingRel"),
    loadDeviation: getParamValueOrNull("operation:loadDeviation"),
    maxFeedrate: isProbeOp ? null : feed,
    maxSpindleSpeed: (!isTurn && !isMill) || isProbeOp ? null : spindleSpeed,
    maxStepdown: maxStepDown,
    maxStepover: maxStepOver,
    maxZ: is3D() ? maxZ : null,
    minZ: is3D() ? minZ : null,
    notes: getParamValueOrNull("notes"),
    optimalLoad: getParamValueOrNull("operation:optimalLoad"),
    patternGroup: getPatternGroupName(currentSection),
    quality: quality,
    rapidDistance: isProbeOp ? null : rapidDistance,
    safeToolDiameter: null,
    stockToLeave: stockToLeave !== undefined ? stockToLeave : null,
    radialStockToLeave: radialStockToLeave !== undefined ? radialStockToLeave : null,
    axialStockToLeave: axialStockToLeave !== undefined ? axialStockToLeave : null,
    finishAllowance: finishAllowance !== undefined ? finishAllowance : null,
    xStockToLeave: xStockToLeave !== undefined ? xStockToLeave : null,
    zStockToLeave: zStockToLeave !== undefined ? zStockToLeave : null,
    strategy: cachedParams["operation-strategy"] ? getStrategyDescription(cachedParams["operation-strategy"]) : null,
    surfaceSpeed: isProbeOp ? null : surfaceSpeed,
    tolerance: getParamValueOrNull("operation:tolerance"),
    wcs: currentSection.workOffset
  }
}

// Get a set of setup properties as a JSON object
function getSetupProperties() {
  return {
    description: getParamValueOrNull("job-description"),
    notes: getParamValueOrNull("job-notes"),
    part: {
      x: cachedParams["part-upper-x"] - cachedParams["part-lower-x"],
      y: cachedParams["part-upper-y"] - cachedParams["part-lower-y"],
      z: cachedParams["part-upper-z"] - cachedParams["part-lower-z"]
    },
    stock: {
      x: cachedParams["stock-upper-x"] - cachedParams["stock-lower-x"],
      y: cachedParams["stock-upper-y"] - cachedParams["stock-lower-y"],
      z: cachedParams["stock-upper-z"] - cachedParams["stock-lower-z"]
    },
    stockLower: {
      x: cachedParams["stock-lower-x"],
      y: cachedParams["stock-lower-y"],
      z: cachedParams["stock-lower-z"]
    },
    stockUpper: {
      x: cachedParams["stock-upper-x"],
      y: cachedParams["stock-upper-y"],
      z: cachedParams["stock-upper-z"]
    },
    wcs: currentSection.workOffset
  }
}

// Get a set of summary properties as a JSON object
function getSummaryProperties() {
  var now = new Date();
  return {
    creationDate: now.toLocaleDateString() + " " + now.toLocaleTimeString(),
    cuttingDistance: getParamValueOrNull("cuttingDistance"),
    cycleTime: getParamValueOrNull("cycleTime"),
    designDocument: getParamValueOrNull("document-path"),
    maxFeedrate: getParamValueOrNull("maxFeedrate"),
    maxSpindleSpeed: getParamValueOrNull("maxSpindleSpeed"),
    maxZ: getParamValueOrNull("maxZ"),
    minZ: getParamValueOrNull("minZ"),
    numOperations: getParamValueOrNull("numOperations"),
    numSetups: getParamValueOrNull("numSetups"),
    numTools: getParamValueOrNull("numTools"),
    productVersion: getParamValueOrNull("generated-by"),
    programComment: programComment,
    rapidDistance: getParamValueOrNull("rapidDistance"),
    tools: null // this is updated later in updateCalculatedPropertyValues()
  }
}

// Get a set of tool properties as a JSON object
function getToolProperties(tool) {
  const isTurning = tool.isTurningTool();
  const isJet = !isTurning && tool.isJetTool();
  const isDrill = !isTurning && tool.isDrill();

  const isTurningGrooving = tool.type === TOOL_TURNING_GROOVING;
  const isTurningGeneral = tool.type === TOOL_TURNING_GENERAL;
  const isTurningBoring = tool.type === TOOL_TURNING_BORING;
  const isTurningThreading = tool.type === TOOL_TURNING_THREADING;

  let edgeLength = null;
  let inscribedCircle = null;

  // If we have values for both edgeLength and inscribedCircleDiameter, use only one
  // or the other based on the current unit system. While this might seem odd, it's
  // apparently the industry standard way of defining the size of a turning insert.
  if ((isTurningGeneral || isTurningBoring) && tool.inscribedCircleDiameter !== undefined
    && tool.edgeLength !== undefined) {
    if (unit === MM && tool.edgeLength > 0) {
      edgeLength = tool.edgeLength;
    } else {
      inscribedCircle = tool.inscribedCircleDiameter;
    }
  }

  return {
    comment: tool.comment ? tool.comment : null,
    compensation: getCompensationDescription(tool),
    cornerRadius: !isTurning && tool.cornerRadius ?  tool.cornerRadius : null,
    crossSection: (isTurningGeneral || isTurningBoring) && tool.crossSection ? tool.crossSection : null,
    diameter: isTurning || isJet ? null : tool.diameter,
    diameterOffset: isJet ? null : isTurning ? tool.compensationOffset : tool.diameterOffset,
    edgeLength: edgeLength,
    flutes: !isTurning && !isJet && tool.numberOfFlutes > 0 ? tool.numberOfFlutes : null,
    holderDescription: tool.holderDescription ? tool.holderDescription : null,
    holderProduct: {
      id: tool.holderProductId ? tool.holderProductId : "",
      link: cachedParams["operation:holder_productLink"] ? cachedParams["operation:holder_productLink"] : ""
    },
    holderType: getHolderTypeName(tool),
    holderVendor: tool.holderVendor ? tool.holderVendor : null,
    inscribedCircle : inscribedCircle,
    insertType: getInsertTypeName(tool),
    jetDiameter: isJet ? tool.jetDiameter : null,
    kerfDiameter: !isJet ? null : tool.jetDiameter,
    length: !isTurning && !isJet ? tool.bodyLength : null,
    lengthOffset: !isJet && !isTurning ? tool.lengthOffset : null,
    manualToolChange: tool.manualToolChange,
    material: tool.material ? getMaterialName(tool.material) : null, // getMaterialName is an api method
    noseRadius: (isTurningGeneral || isTurningGrooving || isTurningBoring) && tool.noseRadius !== undefined && tool.noseRadius > 0 ? tool.noseRadius : null,
    number: tool.getNumber(),
    pitch: isTurningThreading && tool.pitch && tool.pitch > 0 ? tool.pitch : null,
    relief: getReliefAngleDescription(tool),
    taperAngle: !isTurning && !isDrill && tool.taperAngle > 0 && tool.taperAngle < Math.PI ? radToDeg(tool.taperAngle) : null,
    tipAngle: isDrill && tool.taperAngle > 0 && tool.taperAngle < Math.PI ? radToDeg(tool.taperAngle) : null,
    tolerance: (isTurningGeneral || isTurningBoring) && tool.tolerance ? tool.tolerance : null,
    toolDescription: tool.description ? tool.description : null,
    toolProduct: {
      id: tool.productId ? tool.productId : "",
      link: cachedParams["operation:tool_productLink"] ? cachedParams["operation:tool_productLink"] : ""
    },
    toolType: getToolTypeNameLocal(tool),
    toolVendor: tool.vendor ? tool.vendor : null,
    width: isTurningGrooving && tool.grooveWidth ? tool.grooveWidth : null,
  }
}

// Convert radians to degrees
function radToDeg(radians)
{
  return radians * (180 / Math.PI);
}

// Checks if the tool is a duplicate in the array runningValues.tools
function isDuplicateTool(tool) {
  for (var i in runningValues.tools) {
    if (runningValues.tools[i].toolId === tool.toolId) {
      return true;
    }
  }
  return false;
}

// Add a tool object to the container if it's a new tool.
function addToolObject(tool) {
  // Add this tool only if it's not already in the cache
  const toolId = parseInt(tool.toolId);
  if (!isDuplicateTool(tool)) {
    // Add the new tool to the cache
    runningValues.tools[toolId] = tool;

    // Create the initial tool object
    const toolObj = {
      id: toolId,
      images: [getToolAsSVGObject(tool)],
      properties: getToolProperties(tool)
    };

    setupSheetObj.tools.push(toolObj);
  }
}

// Add a setup object to the container, but only if the current set of
// cached params has a "job-description" item, which is only available
// with the first operation of each setup.
function addSetupObject() {
  if (cachedParams["job-description"]) {

    // Cache a new object key of this setup's id. The value will be
    // a running array of operation id's that belong to it.
    runningValues.operationGroups[currentSection.getJobId()] = [];

    // Add the id of each setup the current operation belongs to to the global setupIds array
    var operationSetupIds = setupSheetObj.setups.map(function (el) { return el.id; });
    runningValues.setupIds = [].concat(runningValues.setupIds, operationSetupIds);

    // Add this setup to the container if it has not been added before to the global setups array
    if (runningValues.setupIds.indexOf(currentSection.getJobId()) === -1) {
      const image = getImageFromTempFolder(cachedParams["job-image"]);
      const imageArray = image ? [image] : [];
      setupSheetObj.setups.push({
        id: currentSection.getJobId(), // temporary (removed before JSON creation)
        images: imageArray,
        properties: getSetupProperties()
      });
    }
  }
}

// Add an operation object to the container.
// Note that we get it's id from the runningValues, as it will
// have been added by addToolObject.
function addOperationObject(tool) {
  if (currentSection.getForceToolChange && currentSection.getForceToolChange()) {
    addForceToolChange();
  }

  // Add this operation's id to the running collection of id's belonging to the same setup
  runningValues.operationGroups[currentSection.getJobId()].
    push(cachedParams["autodeskcam:operation-id"]);

  const image = getImageFromTempFolder(cachedParams["operation:associatedView"]);
  const imageArray = image ? [image] : [];

  const operation = {
    id: cachedParams["autodeskcam:operation-id"],
    images: imageArray,
    tool: {id: parseInt(tool.toolId)},
    properties: getOperationProperties(tool)
  };

  // update compensation and safe tool diameter parameters if required
  updateOperationCompensationParams(operation, tool);

  // add the operation to the container
  setupSheetObj.operations.push(operation);
}

// Create a Manual NC operation.
// Note: operation id is not exported for Manual NC, hard coded as 0.
function createManualNCOperation() {
  // Get an empty operation properties object (all props with null values)
  // and then update the strategy name
  var operationProps = getEmptyOperationProperties();
  operationProps.strategy = localize("Manual NC");
  const operation = {
    id: 0,
    images: [],
    properties: operationProps
  };

  return operation;
}

// Process Manual NC operation - "Force tool change"
// Special case that does not have function callback, invoked with following section.
function addForceToolChange() {
  var operation = createManualNCOperation();
  operation.properties.description = localize("Force tool change");

  // add the operation to the container
  setupSheetObj.operations.push(operation);
}

// Update compensation and safe tool diameter parameters if required
function updateOperationCompensationParams(operation, tool) {
  const compTypeParam = "operation:compensationType";
  const compRadiusParam = "operation:compensationDeltaRadius";
  const compParam = "operation:compensation";

  const compensationType = cachedParams[compTypeParam] ? cachedParams[compTypeParam] : "computer";
  if (compensationType != "computer") {
    const COMPENSATIONS = { left: localize("left"), right: localize("right"), center: localize("center") };
    const DESCRIPTIONS = { computer: localize("computer"), control: localize("control"), wear: localize("wear"), inverseWear: localize("inverse wear") };
    const compensationDeltaRadius = cachedParams[compRadiusParam] ? cachedParams[compRadiusParam] : 0;
    const compensation = cachedParams[compParam] ? cachedParams[compParam] : localize("center");
    const compensationText = COMPENSATIONS[compensation] ? COMPENSATIONS[compensation] : localize("unspecified");
    const description = DESCRIPTIONS[compensationType] ? DESCRIPTIONS[compensationType] : localize("unspecified");
    operation.properties.compensation = description + " (" + compensationText + ")";
    if (!tool.isTurningTool()) {
      operation.properties.safeToolDiameter = tool.diameter + (2 * compensationDeltaRadius);
    }
  }
}

// Return the unit system used for the values in the JSON output
function getUnitSystem() {
  return unit === MM ? "mm" : "inch";
}

// Return the title
function getTitle() {
  let title = localize("Setup Sheet");
  if (programName) {
    title = localize("Setup Sheet for Program") + " " + programName;
  }
  return title;
}

// Build a sorted tool list string ("T2 T4 T49") from the cached tools
function getToolList() {
  const tNumArray = [];
  Object.keys(runningValues.tools).forEach(function(key) {
    tNumArray.push(runningValues.tools[key].number);
  });

  return tNumArray.
    sort(function(a, b) {
      return a - b;
    }).
    map(function(t) {return "T" + t;}).
    join(" ");
}

// Return the extension (with no leading dot) of the specified file name
// or an empty string if no extension exists.
function getFileExtension(filename) {
  const a = filename.split(".");
  if (a.length === 1) {return "";} //  normal file, no extension
  if (a[0] === "" && a.length === 2) {return "";} // hidden file, no extension
  return a.pop().toLowerCase();
}

// Return a formatted image object for the specified PNG image file
// The image is stored in base64 format.
function getImageAsBase64PngObject(imageFile) {
  const pngMimeType = "image/png";

  let imgObj;
  if (FileSystem.isFile(imageFile)) {
    if (typeof BinaryFile == "function" && typeof Base64 == "function") {
      const extension = getFileExtension(imageFile);
      if (supportedImageTypes[extension] == pngMimeType) {
        imgObj = {
          mimetype: pngMimeType,
          content: {
            data: "data:" + pngMimeType + ";base64," +
                  Base64.btoa(BinaryFile.loadBinary(imageFile))
          }
        };
      }
    }
  }

  return imgObj;
}

// Generate an SVG polygon element from a set of points
function getSvgPolygonFromPoints(pointsArray, className) {
  let p = [];
  for (let i = 0; i < pointsArray.length; ++i) {
    p.push(pointsArray[i].x + " " + pointsArray[i].y);
  }

  return {
    polygon: {
      className: className,
      points: p.join(',')
    }
  };
}

// Generate an SVG rect element from a set of 4 points
// Note, p0 is lower left corner, moving CCW
function getSvgRectangleFromPoints(pointsArray, className) {
  const x = pointsArray[0].x;
  const y = pointsArray[0].y;
  const width = pointsArray[1].x - pointsArray[0].x;
  const height = pointsArray[2].y - pointsArray[1].y;

  return {
    rect: {
      className: className,
      x: x,
      y: y,
      width: width,
      height: height
    }
  };
}

// Generate tool holder geometry from a number of SVG "rect" and "polygon" elements
function getSvgHolderGeometry(holder) {
  const toler = 0.001;
  let svgElemsAsJson = [];
  let yOffset = 0;

  if (holder && holder.hasSections()) {
    const numSects = holder.getNumberOfSections();
    let radPrev;
    let rad;
    let points = [];

    // Calculate the 4 corner points for the current section from the available
    // length and diameter info. The result could be a rectangle or an isosceles
    // trapezoid (with the top or bottom being the larger dimension)
    //
    //   p4 ------------- p3      p4 --------------- p3
    //   |                 |       \                 /
    //   |                 |   or   \               /
    //   p1 ------+------ p2         p1 ----+---- p2
    //           x0                        x0
    //
    for (let i = 0; i < numSects; ++i) {
      if (i === 0) {
        // For the first section, add the points that form the lower edge
        rad = radPrev = holder.getDiameter(i) / 2;
        points.push({x: -rad, y: 0});
        points.push({x: rad, y: 0});
      } else {
        // Add the next 2 points to form the upper edge of the section
        // (should always be points 3 and 4 in the array)
        yOffset += holder.getLength(i - 1); // track section "stack height" in space
        rad = holder.getDiameter(i) / 2;
        let height = holder.getLength(i) + yOffset;

        points.push({x: rad, y: height});
        points.push({x: -rad, y: height});

        // See if the current section has any height
        let sectionHasHeight = holder.getLength(i) > toler;

        // If the current section has height...
        // Create either an SVG rect or polygon depending on the shape.
        // They're shaded differently, so they need different CSS class names
        if (sectionHasHeight) {
          if (Math.abs(radPrev - rad) < toler ) {
            svgElemsAsJson.push(getSvgRectangleFromPoints(points, "holderRect"));
          } else {
            // If this is the *last* element, shade it like the rects
            let className = i === numSects - 1 ? "holderRect" : "holderTrap";
            svgElemsAsJson.push(getSvgPolygonFromPoints(points, className));
          }
        }

        // Copy point 4 to point 1 and point 3 to point 2 as the lower edge of the next section.
        // (See above line drawings for details...)
        // Truncate the array to the first 2 points. We'll add the last 2 in the next iteration.
        points[0] = points[3];
        points[1] = points[2];
        points.length = 2;

        radPrev = rad;
      }
    }
  }

  return svgElemsAsJson;
}

// Return an object containing the data required to render a tool
// and its holder as SVG
function getToolAsSVGObject(tool) {
  let svgElemsAsJson = [];
  let bounds = {};
  let transform;

  if (!tool.isTurningTool()) {
    holder = tool.holder;

    // Build a transform that (during rendering) will place the center of
    // this tool's bounding box at 0,0 and will flip the data in Y to draw
    // the tool "right side up"
    transform = 'scale(1,-1) translate(0,' + -((tool.holderLength - tool.bodyLength) / 2) + ')';

    // Get the holder geometry as SVG data
    svgElemsAsJson = getSvgHolderGeometry(holder);

    // Add the tool profile as an SVG path
    let toolPath = tool.getCutterProfileAsSVGPath();
    svgElemsAsJson.push({
      path: {
        className: "tool",
        transform: 'translate(0,' + -tool.bodyLength + ')',
        d: toolPath
      }
    });

    let bbox = tool.getExtent(true);
    let width = bbox.upper.x - bbox.lower.x;
    let  height = bbox.upper.y - bbox.lower.y;
    bounds = {
      minX: bbox.lower.x,
      minY: -(height/2),
      width: width,
      height: height
    }
  } else {
    let bbox = tool.getExtent(true);
    let width = bbox.upper.x - bbox.lower.x;
    let height = bbox.upper.y - bbox.lower.y;
    bounds = {
      minX: -width/2,
      minY: -height/2,
      width: width,
      height: height
    }
    let xTrans = -((width / 2) + bbox.lower.x);
    let yTrans = -((height / 2) + bbox.lower.y);
    transform = 'translate(' + xTrans + ' ' + yTrans + ')';
    svgElemsAsJson.push({
      path: {
        className: "holderRect",
        d: tool.getHolderProfileAsSVGPath()
      }
    });
    svgElemsAsJson.push({
      path: {
        className: "tool",
        d: tool.getCutterProfileAsSVGPath()
      }
    });
  }

  return {
    // the mime type of SVG data
    mimetype: "image/svg+xml",
    // content specific to the SVG image type
    content: {
      // bounds of all SVG path data (useful in SVG viewbox object)
      bounds: bounds,
      transform: transform,
      // all SVG path data associated with this tool
      geometry: svgElemsAsJson
    }
  };
}

// Return an object used for tracking intermediate values
function getRunningValuesObject() {
  return {
    tools: {},
    operationGroups: {},
    patternGroups: {},
    zVals: [],
    feedrates: [],
    spindleSpeeds: [],
    cuttingDistance: 0,
    rapidDistance: 0,
    cycleTime: 0,
  };
}

// Convert a specified integer value to a base26 number-string containing only
// the chars A-Z
// (0 = A, 25 = Z, 26 = AA, 52 = BA, ... )
function getBase26String(n) {
  const base = 26;
  if (n < base) {
    return String.fromCharCode(65 + n); // 65 is the ASCII code for 'A'
  } else {
    return getBase26String((n / base) - 1) + String.fromCharCode(65 + (n % base));
  }
}

// Return a string rep of a turning tool's (numeric) compensation mode.
// Returns null if the tool is not a turning tool.
function getCompensationDescription(tool) {
  var desc = null;
  if (tool.isTurningTool()) {
    switch (tool.getCompensationMode()) {
    case TOOL_COMPENSATION_INSERT_CENTER:
      desc = localize("Insert center");
      break;
    case TOOL_COMPENSATION_TIP:
      desc = localize("Tip");
      break;
    case TOOL_COMPENSATION_TIP_CENTER:
      desc = localize("Tip center");
      break;
    case TOOL_COMPENSATION_TIP_TANGENT:
      desc = localize("Tip tangent");
      break;
    }
  }
  return desc;
}

// Return a string rep of a turning tool's (numeric) "relief angle" property.
// Returns "Custom <ang>deg" if the angle is non-standard and null if the tool
// is not a turning tool.
function getReliefAngleDescription(tool) {
  let desc = null;
  if (tool.isTurningTool() && tool.reliefAngle !== undefined) {

    var turningReliefAngles = [
      {id:"N", value:0},
      {id:"A", value:3},
      {id:"B", value:5},
      {id:"C", value:7},
      {id:"P", value:11},
      {id:"D", value:15},
      {id:"E", value:20},
      {id:"F", value:25},
      {id:"G", value:30}
    ];

    let id = localize("Custom");
    let value = tool.reliefAngle;

    // const does not work here, but we'll get a linter complaint unless we disable the rule
    // eslint-disable-next-line prefer-const
    for (let item in turningReliefAngles) {
      const thisItem = turningReliefAngles[item];
      if (Math.abs(thisItem.value - value) < 1e-3) {
        id = thisItem.id;
        value = thisItem.value;
        break;
      }
    }
    desc = id + " " + value + "deg";
  }
  return desc;
}

// Return a Manual NC command display name for a specified Manual NC command or the
// command name itself if a display name is not available.
function getManualNCCommandName(command) {
  var cmdStringId = getCommandStringId(command);
  const manaulNCCmdNames = {
    "COMMAND_COMMENT": localize("Comment"),
    "COMMAND_STOP": localize("Stop"),
    "COMMAND_OPTIONAL_STOP": localize("Optional Stop"),
    "COMMAND_DWELL": localize("Dwell"),
    "COMMAND_BREAK_CONTROL": localize("Tool break control"),
    "COMMAND_TOOL_MEASURE": localize("Measure tool"),
    "COMMAND_START_CHIP_TRANSPORT": localize("Start chip transport"),
    "COMMAND_STOP_CHIP_TRANSPORT": localize("Stop chip transport"),
    "COMMAND_OPEN_DOOR": localize("Open door"),
    "COMMAND_CLOSE_DOOR": localize("Close door"),
    "COMMAND_CALIBRATE": localize("Calibrate"),
    "COMMAND_VERIFY": localize("Verify"),
    "COMMAND_CLEAN": localize("Clean"),
    "COMMAND_ACTION": localize("Action"),
    "COMMAND_PRINT_MESSAGE": localize("Print message"),
    "COMMAND_DISPLAY_MESSAGE": localize("Display message"),
    "COMMAND_ALARM": localize("Alarm"),
    "COMMAND_ALERT": localize("Alert"),
    "COMMAND_PASS_THROUGH": localize("Pass through"),
    "COMMAND_CALL_PROGRAM": localize("Call program")
  };

  return manaulNCCmdNames[cmdStringId] ? manaulNCCmdNames[cmdStringId] : cmdStringId;
}

// Return a strategy description for a specified strategy name or the
// strategy name itself if a description is not available.
function getStrategyDescription(strategyName) {
  var strategies = {
    "drill": localize("Drilling"),
    "probe": localize("Probe WCS"),
    "probe_geometry": localize("Probe Geometry"),
    "inspectSurface": localize("Inspect"),
    "rotary_finishing": localize("Rotary"),
    "steep_and_shallow": localize("Steep and Shallow"),
    "face": localize("Facing"),
    "path3d": localize("3D Path"),
    "pocket2d": localize("Pocket 2D"),
    "contour2d": localize("Contour 2D"),
    "adaptive2d": localize("Adaptive 2D"),
    "slot": localize("Slot"),
    "circular": localize("Circular"),
    "bore": localize("Bore"),
    "thread": localize("Thread"),
    "jet2d": localize("Profile 2D"),
    "contour_new": localize("Contour"),
    "contour": localize("Contour"),
    "parallel_new": localize("Parallel"),
    "parallel": localize("Parallel"),
    "pocket_new": localize("Pocket"),
    "pocket": localize("Pocket"),
    "adaptive": localize("Adaptive"),
    "horizontal_new": localize("Horizontal"),
    "horizontal": localize("Horizontal"),
    "blend": localize("Blend"),
    "flow": localize("Flow"),
    "morph": localize("Morph"),
    "pencil_new": localize("Pencil"),
    "pencil": localize("Pencil"),
    "project": localize("Project"),
    "ramp": localize("Ramp"),
    "radial_new": localize("Radial"),
    "radial": localize("Radial"),
    "scallop_new": localize("Scallop"),
    "scallop": localize("Scallop"),
    "morphed_spiral": localize("Morphed Spiral"),
    "spiral_new": localize("Spiral"),
    "spiral": localize("Spiral"),
    "swarf5d": localize("Multi-Axis Swarf"),
    "multiAxisContour": localize("Multi-Axis Contour"),
    "multiAxisBlend": localize("Multi-Axis Blend"),
    "turningRoughing": localize("Turning Roughing"),
    "turningProfileRoughing": localize("Turning Profile Roughing"),
    "turningProfileFinishing": localize("Turning Profile Finishing"),
    "turningProfileGroove": localize("Turning Profile Groove"),
    "turningPart": localize("Turning Part"),
    "turningFace": localize("Turning Face"),
    "turningGroove": localize("Turning Single Groove"),
    "turningChamfer": localize("Turning Chamfer"),
    "turningThread": localize("Turning Thread"),
    "turningStockTransfer": localize("Turning Stock Transfer"),
    "turningSecondarySpindleGrab": localize("Subspindle Grab"),
    "turningSecondarySpindlePull": localize("Bar Pull"),
    "turningSecondarySpindleReturn": localize("Subspindle Return")
  };

  return strategies[strategyName] ? strategies[strategyName] : strategyName;
}

// If the specified operation is a pattern, return a string representing its
// pattern group name. The first pattern group is named "A" and the value
// increments as a base26 string (A, B, ..., Z, AA, AB, ... ZZ, AAA, AAB,
// ..., ZZZ, ...) for each  new patterned operation. Patterened operations
// with the same operationID will have matching pattern group names.
// Return null for operations that are not patterns.
function getPatternGroupName(section) {
  let name = null;
  if (section.isPatterned()) {
    const id = section.getPatternId();
    if (!runningValues.patternGroups[id]) {
      runningValues.patternGroups[id] =
        getBase26String(Object.keys(runningValues.patternGroups).length);
    }
    name = runningValues.patternGroups[id];
  }
  return name;
}

// Return the basic shell of the setup object we're building.
// This ensures the object contains the necessary sections by default.
function getInitialSetupObject() {
  return {
    version: 1,
    unitSystem: getUnitSystem(),
    title: getTitle(),
    summary: {
      images: [],
      properties: {}
    },
    tools: [],
    setups: [],
    operations: []
  };
}

// Return a string rep of a turning tool's (numeric) "holder type" property.
// Returns null if the type isn't found or the tool is not a turning tool.
function getHolderTypeName(tool) {
  let desc = null;
  if (tool.isTurningTool()) {
    var holderDesc = [
      localize("No holder"), localize("ISO A"), localize("ISO B"),
      localize("ISO C"), localize("ISO D"), localize("ISO E"),
      localize("ISO F"), localize("ISO G"), localize("ISO H"),
      localize("ISO J"), localize("ISO K"), localize("ISO L"),
      localize("ISO M"), localize("ISO N"), localize("ISO P"),
      localize("ISO Q"), localize("ISO R"), localize("ISO S"),
      localize("ISO T"), localize("ISO U"), localize("ISO V"),
      localize("ISO W"), localize("ISO Y"), localize("Offset"),
      localize("Straight"), localize("External"), localize("Internal"),
      localize("Face"), localize("Straight"), localize("Offset"),
      localize("Face"), localize("Boring bar ISO F"), localize("Boring bar ISO G"),
      localize("Boring bar ISO J"), localize("Boring bar ISO K"),
      localize("Boring bar ISO L"), localize("Boring bar ISO P"),
      localize("Boring bar ISO Q"), localize("Boring bar ISO S"),
      localize("Boring bar ISO U"), localize("Boring bar ISO W"),
      localize("Boring bar ISO Y"), localize("Boring bar ISO X")
    ];

    const holderIndex = tool.getHolderType();
    if (holderIndex < holderDesc.length) {
      desc = holderDesc[holderIndex];

      let hand = "";
      switch (tool.hand) {
      case "L":
        hand = localize("Left");
        break;
      case "R":
        hand = localize("Right");
        break;
      case "N":
        hand = localize("Neutral");
        break;
      }

      if (hand !== "") {desc += " " + hand;}
    }
  }

  return desc;
}

// Return a string rep of a turning tool's (numeric) "insert type" property.
// Returns null if the type isn't found or the tool is not a turning tool.
function getInsertTypeName(tool) {
  let desc = null;
  if (tool.isTurningTool()) {
    var insertDesc = [
      localize("User defined"), localize("ISO A 85deg"), localize("ISO B 82deg"),
      localize("ISO C 80deg"), localize("ISO D 55deg"), localize("ISO E 75deg"),
      localize("ISO H 120deg"), localize("ISO K 55deg"), localize("ISO L 90deg"),
      localize("ISO M 86deg"), localize("ISO O 135deg"), localize("ISO P 108deg"),
      localize("ISO R round"), localize("ISO S square"), localize("ISO T triangle"),
      localize("ISO V 35deg"), localize("ISO W 80deg"), localize("Round"),
      localize("Radius"), localize("Square"), localize("Chamfer"), localize("40deg"),
      localize("ISO double"), localize("ISO triple"), localize("UTS double"),
      localize("UTS triple"), localize("ISO double V"), localize("ISO triple V"),
      localize("UTS double V"), localize("UTS triple V")
    ];

    const insertIndex = tool.getInsertType();
    if (insertIndex < insertDesc.length) {
      desc = insertDesc[insertIndex];
    }
  }

  return desc;
}

// Returns the tool type name for a specified tool. The returned value may also
// contain an additional "LIVE" or "STATIC" suffix string, added based on logic
// from the original HTML setup post.
function getToolTypeNameLocal(tool) {
  let toolType = getToolTypeName(tool.type); // Note, this is a post-engine method
  if (tool.isLiveTool && !tool.isTurningTool() && (machineConfiguration.getTurning() || isTurning())) {
    toolType += " " + (tool.isLiveTool() ? localize("LIVE") : localize("STATIC"));
  }
  return toolType;
}

// Returns a base64 image object from the specified PNG file.
// The file is assumed to be in folder where the post places temporary images.
// If the file isn't found, or is not a PNG, an empty object is returned.
function getImageFromTempFolder(file) {
  let imageObj;
  if (file) {
    const path = FileSystem.getCombinedPath(FileSystem.getFolderPath(getOutputPath()), file);
    imageObj = getImageAsBase64PngObject(path);
  }
  return imageObj;
}

function isProbeOperation() {
  return cachedParams["operation-strategy"] && cachedParams["operation-strategy"] === "probe";
}

/**
  Returns the specified coolant as a string.
*/
function getCoolantDescription(coolant) {
  switch (coolant) {
  case COOLANT_OFF:
    return localize("Off");
  case COOLANT_FLOOD:
    return localize("Flood");
  case COOLANT_MIST:
    return localize("Mist");
  case COOLANT_THROUGH_TOOL:
    return localize("Through tool");
  case COOLANT_AIR:
    return localize("Air");
  case COOLANT_AIR_THROUGH_TOOL:
    return localize("Air through tool");
  case COOLANT_SUCTION:
    return localize("Suction");
  case COOLANT_FLOOD_MIST:
    return localize("Flood and mist");
  case COOLANT_FLOOD_THROUGH_TOOL:
    return localize("Flood and through tool");
  default:
    return localize("Unknown");
  }
}

// Get an *empty* operation properties object (*all* properties, but *null* values)
// Note, this property set needs to be kept in sync wtih the property set that's
// being returned from getOperationProperties
function getEmptyOperationProperties() {
  return {
    coolant: null,
    compensation: null,
    cuttingDistance: null,
    cuttingType: null,
    cycleTime: null,
    description: null,
    feedratePerRevolution: null,
    loadDeviation: null,
    maxFeedrate: null,
    maxSpindleSpeed: null,
    maxStepdown: null,
    maxStepover: null,
    maxZ: null,
    minZ: null,
    notes: null,
    optimalLoad: null,
    patternGroup: null,
    quality: null,
    rapidDistance: null,
    safeToolDiameter: null,
    stockToLeave: null,
    radialStockToLeave: null,
    axialStockToLeave: null,
    finishAllowance: null,
    xStockToLeave: null,
    zStockToLeave: null,
    strategy: null,
    surfaceSpeed: null,
    tolerance: null,
    wcs: null
  }
}

// Utility function to write all cached parameters and their values
// to the output file.
function dumpCachedParams() {
  // const does not work here, but we'll get a linter complaint unless we disable the rule
  // eslint-disable-next-line prefer-const
  for (let prop in cachedParams) {
    writeln(prop + ": " + cachedParams[prop]);
  }
  writeln("------------");
}

function insertAggregateToolProperties() {
  // Iterate through each tool in our JSON object
  setupSheetObj.tools.forEach(function (tool) {

    // Build an array of all operations (from the JSON object) that use the current tool
    // (matched by the tool's id)
    const matchingOperations = setupSheetObj.operations.filter(function(operation) {
      return operation.tool && operation.tool.id === parseInt(tool.id);
    });

    // Create some initial values for the properties we want to insert
    let cuttingDistance = 0;
    let rapidDistance = 0;
    let cycleTime = 0;
    let maxFeedrate = Number.NEGATIVE_INFINITY;
    let maxSpindleSpeed = Number.NEGATIVE_INFINITY;
    let minZ = Number.POSITIVE_INFINITY;

    // Spin through the matching operations and aggregate the values accordingly
    matchingOperations.forEach(function (operation) {
      cuttingDistance += operation.properties.cuttingDistance;
      rapidDistance += operation.properties.rapidDistance;
      cycleTime += operation.properties.cycleTime;
      maxFeedrate = Math.max(maxFeedrate, operation.properties.maxFeedrate);
      maxSpindleSpeed = Math.max(maxSpindleSpeed, operation.properties.maxSpindleSpeed);
      minZ = Math.min(minZ, operation.properties.minZ);
    });

    // Finally, insert the target properties for this tool
    tool.properties.cuttingDistance = cuttingDistance;
    tool.properties.rapidDistance = rapidDistance;
    tool.properties.cycleTime = cycleTime;
    tool.properties.maxFeedrate = maxFeedrate;
    tool.properties.maxSpindleSpeed = maxSpindleSpeed;
    tool.properties.minZ = minZ;
  });
}
