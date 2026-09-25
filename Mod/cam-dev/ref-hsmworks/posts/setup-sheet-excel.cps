/**
  Copyright (C) 2012-2021 by Autodesk, Inc.
  All rights reserved.

  Excel setup sheet configuration.

  $Revision: 43194 08c79bb5b30997ccb5fb33ab8e7c8c26981be334 $
  $Date: 2021-02-18 16:25:13 $
  
  FORKID {F4FA39E1-B6CA-4fbe-A094-8761870B1F78}
*/

description = "Setup Sheet Excel";
vendor = "Autodesk";
vendorUrl = "http://www.autodesk.com";
legal = "Copyright (C) 2012-2021 by Autodesk, Inc.";
certificationLevel = 2;

longDescription = "Setup sheet for generating spreadsheet in Excel format. Consider using the Setup Sheet Excel 2007 post instead which also supports preview picture of the model.";

capabilities = CAPABILITY_SETUP_SHEET;
extension = "xls";
mimetype = "text/xml";
keywords = "MODEL_IMAGE";
setCodePage("utf-8");
dependencies = "setup-sheet-excel-template.xls";

allowMachineChangeOnSection = true;

properties = {
  rapidFeed: {
    title: "Rapid feed",
    description: "Sets the rapid traversal feedrate. Set this to get more accurate cycle times.",
    type: "number",
    value: 5000,
    scope: "post"
  },
  toolChangeTime: {
    title: "Tool change time",
    description: "Sets the tool change time in seconds. Set this to get more accurate cycle times.",
    type: "number",
    value: 15,
    scope: "post"
  },
  listVariables: {
    title: "List variables",
    description: "If enabled, all available variables are outputted to the log.",
    type: "boolean",
    value: false,
    scope: "post"
  }
};

var timeFormat = createFormat({width:2, zeropad:true, decimals:0});

/** Sets variable prefix. */
function prepend(prefix, variables) {
  var result = {};
  var p = prefix + ".";
  for (var k in variables) {
    result[p + k] = variables[k];
  }
  return result;
}

function isProbeOperation(section) {
  return section.hasParameter("operation-strategy") && (section.getParameter("operation-strategy") == "probe");
}

/** Returns the global program information. */
function getProgramInfo() {
  var result = {};
  
  for (var p in properties) {
    result[p] = properties[p];
  }
  
  result["name"] = (programName == undefined) ? "" : programName;
  result["comment"] = (programComment == undefined) ? "" : programComment;

  // 2003-06-11T00:00:00.000
  var now = new Date();
  result["generationTime"] = subst(
    "%1-%2-%3T%4:%5:%6.000",
    now.getFullYear(),
    timeFormat.format(now.getMonth() + 1),
    timeFormat.format(now.getDate()),
    timeFormat.format(now.getHours()),
    timeFormat.format(now.getMinutes()),
    timeFormat.format(now.getSeconds())
  );
  
  result["numberOfSections"] = getNumberOfSections();
  var tools = getToolTable();
  result["numberOfTools"] = tools.getNumberOfTools();

  var maximumFeed = 0;
  var maximumSpindleSpeed = 0;
  var cuttingDistance = 0;
  var rapidDistance = 0;
  var cycleTime = 0;

  var multipleWorkOffsets = false;
  var workOffset;
  var numberOfSections = getNumberOfSections();
  var currentTool;
  for (var i = 0; i < numberOfSections; ++i) {
    var section = getSection(i);

    if (workOffset == undefined) {
      workOffset = section.workOffset;
    } else {
      if (workOffset != section.workOffset) {
        multipleWorkOffsets = true;
      }
    }

    if (!isProbeOperation(section)) {
      maximumFeed = Math.max(maximumFeed, section.getMaximumFeedrate());
      maximumSpindleSpeed = Math.max(maximumSpindleSpeed, section.getMaximumSpindleSpeed());
      cuttingDistance += section.getCuttingDistance();
      rapidDistance += section.getRapidDistance();
      cycleTime += section.getCycleTime();
      if (getProperty("toolChangeTime") > 0) {
        var tool = section.getTool();
        if (currentTool != tool.number) {
          currentTool = tool.number;
          cycleTime += getProperty("toolChangeTime");
        }
      }
    }
  }
  if (getProperty("rapidFeed") > 0) {
    cycleTime += rapidDistance/getProperty("rapidFeed") * 60;
  }

  result["workOffset"] = multipleWorkOffsets ? "" : workOffset;
  result["maximumFeed"] = maximumFeed;
  result["maximumSpindleSpeed"] = maximumSpindleSpeed;
  result["cuttingDistance"] = cuttingDistance;
  result["rapidDistance"] = rapidDistance;
  result["cycleTime"] = formatTime(cycleTime);

  return prepend("program", result);
}

/** Returns the tool information in an array. */
function getToolInfo() {
  var result = [];
  var tools = getToolTable();
  for (var i = 0; i < tools.getNumberOfTools(); ++i) {
    var tool = tools.getTool(i);
    
    var first = true;
    var minimumZ = 0;
    var maximumZ = 0;
    var maximumFeed = 0;
    var maximumSpindleSpeed = 0;
    var cuttingDistance = 0;
    var rapidDistance = 0;
    var cycleTime = 0;

    var numberOfSections = getNumberOfSections();
    for (var j = 0; j < numberOfSections; ++j) {
      var section = getSection(j);
      if (section.getTool().number != tool.number) {
        continue;
      }
      
      if (is3D()) {
        var zRange = section.getGlobalZRange();
        if (first) {
          minimumZ = zRange.getMinimum();
          maximumZ = zRange.getMaximum();
        } else {
          minimumZ = Math.min(minimumZ, zRange.getMinimum());
          maximumZ = Math.max(maximumZ, zRange.getMaximum());
        }
      }

      if (!isProbeOperation(section)) {
        maximumFeed = Math.max(maximumFeed, section.getMaximumFeedrate());
        maximumSpindleSpeed = Math.max(maximumSpindleSpeed, section.getMaximumSpindleSpeed());
        cuttingDistance += section.getCuttingDistance();
        rapidDistance += section.getRapidDistance();
        cycleTime += section.getCycleTime();
      }
      first = false;
    }
    if (getProperty("rapidFeed") > 0) {
      cycleTime += rapidDistance/getProperty("rapidFeed") * 60;
    }

    if (!is3D()) {
      minimumZ = "";
      maximumZ = "";
    }
    
    var record = {
      "number": tool.number,
      "diameterOffset": tool.diameterOffset,
      "lengthOffset": tool.lengthOffset,
      "diameter": tool.diameter,
      "cornerRadius": tool.cornerRadius,
      "taperAngle": toDeg(tool.taperAngle),
      "fluteLength": tool.fluteLength,
      "shoulderLength": tool.shoulderLength,
      "bodyLength": tool.bodyLength,
      "numberOfFlutes": tool.numberOfFlutes,
      "type": getToolTypeName(tool.type),
      "maximumFeed": maximumFeed,
      "maximumSpindleSpeed": maximumSpindleSpeed,
      "cuttingDistance": cuttingDistance,
      "rapidDistance": rapidDistance,
      "cycleTime": formatTime(cycleTime),

      "minimumZ": minimumZ,
      "maximumZ": maximumZ,

      "description": tool.description,
      "comment": tool.comment,
      "vendor": tool.vendor,
      "productId": tool.productId,
      "holderDescription": tool.holderDescription,
      "holderComment": tool.holderComment,
      "holderVendor": tool.holderVendor,
      "holderProductId": tool.holderProductId
    };

    result.push(prepend("tool", record));
  }
  return result;
}

var programInfo = {};
var operationInfo = [];
var toolInfo = [];
var global = (function(){return this;}).call();

function getVariable(variables, id) {
  // log("LOOKUP: " + id  + "=" + variables[id]);
  var value = variables[id];
  if (value != undefined) {
    var i = id.indexOf("(");
    if ((i >= 0) && (id.indexOf(")", i + 1) > i)) { // assume function
      try {
        value = eval.call(global, id);
      } catch(e) {
        value = undefined;
      }
    }
  }
  if (value != undefined) {
    return value;
  }
  // warning(subst(localize("The variable '%1' is unknown."), id));
  if (false) {
    variables[id] = "$" + id; // avoid future warnings
    return "$" + id;
  }
  variables[id] = ""; // avoid future warnings
  return "";
}

function replaceVariables(variables, xml) {
/*eslint-disable*/
  var ss = new Namespace("urn:schemas-microsoft-com:office:spreadsheet");
  var datas = xml..ss::Data;
  for (var i = 0; i < datas.length(); ++i) {
    var e = datas[i];
    var t = e.valueOf();
    if (/*(t.length() > 1) &&*/ (t.charAt(0) == "$")) { // variable
      var value = getVariable(variables, t.substr(1));
      switch (typeof(value)) {
      case "boolean":
        e.@ss::Type = "Boolean";
        value = value ? 1 : 0;
        break;
      case "number":
        e.@ss::Type = "Number"; // always using decimal .
        break;
      case "string":
      default:
        if ((value.indexOf("$") < 0) && (t.substr(t.length - 4) == "Time")) {
          e.@ss::Type = "DateTime";
        } else {
          e.@ss::Type = "String";
        }
      }
      datas[i] = value;
    }
  }
/*eslint-enable*/
}

function updateWorksheet(worksheet) {
  default xml namespace = "urn:schemas-microsoft-com:office:spreadsheet";
  var ss = new Namespace("urn:schemas-microsoft-com:office:spreadsheet");

  worksheet.@ss::Name = localize(worksheet.@ss::Name); // title

  // find operation rows to fill
  var datas = worksheet..ss::Row.ss::Cell.ss::Data.(function::valueOf() == "$OPERATION_ROW");
  for (var i = 0; i < datas.length(); ++i) {
    var row = datas[i].parent().parent();
    var table = row.parent();
    delete row.ss::Cell.ss::Data.(function::valueOf() == "$OPERATION_ROW")[0];

    for (var j = operationInfo.length - 1; j >= 0; --j) {
      var filledRow = row.copy(); // uses a lot of memory
      replaceVariables(operationInfo[j], filledRow);
      table.insertChildAfter(row, filledRow);
    }

    var offset = getNumberOfSections() - 1;
    var base = row.childIndex();

    var rows = table.ss::Row;
    for (var r = 0; r < rows.length(); ++r) {
      var rr = rows[r];
      var index = parseInt(rr.@ss::Index);
      if ((index >= 0) && (rr.childIndex() > (base + offset))) {
        rr.@ss::Index = index + offset;
      }
    }

    delete table.children()[base];
    table.@ss::ExpandedRowCount = parseInt(table.@ss::ExpandedRowCount) + offset;
  }
 
  // find tool rows to fill
  var datas = worksheet..ss::Row.ss::Cell.ss::Data.(function::valueOf() == "$TOOL_ROW");
  for (var i = 0; i < datas.length(); ++i) {
    var row = datas[i].parent().parent();
    var table = row.parent();
    delete row.ss::Cell.ss::Data.(function::valueOf() == "$TOOL_ROW")[0];

    for (var j = toolInfo.length - 1; j >= 0; --j) {
      var filledRow = row.copy(); // uses a lot of memory
      replaceVariables(toolInfo[j], filledRow);
      table.insertChildAfter(row, filledRow);
    }

    var offset = getNumberOfSections() - 1;
    var base = row.childIndex();

    var rows = table.ss::Row;
    for (var r = 0; r < rows.length(); ++r) {
      var rr = rows[r];
      var index = parseInt(rr.@ss::Index);
      if ((index >= 0) && (rr.childIndex() > (base + offset))) {
        rr.@ss::Index = index + offset;
      }
    }

    delete table.children()[base];
    table.@ss::ExpandedRowCount = parseInt(table.@ss::ExpandedRowCount) + offset;
  }

  replaceVariables(programInfo, worksheet);

  var datas = worksheet..ss::Data.(@ss::Type == "String");
  for (var i = 0; i < datas.length(); ++i) {
    var e = datas[i];
    var texts = e.text();
    for (var j = 0; j < texts.length(); ++j) {
      var t = texts[j];
      texts[j] = localize(t); // only allowed for strings
    }
  }
}

var cachedParameters = {};
var globalParameters = true;

function onParameter(name, value) {
  if (globalParameters) {
    if (name.substr(name.length - 6) == "marker") {
      globalParameters = false;
    } else {
      programInfo[name] = value;
    }
  }
  cachedParameters[name] = value;
}

function onOpen() {
  programInfo = getProgramInfo();

  programInfo["program.jobDescription"] = hasGlobalParameter("job-description") ? getGlobalParameter("job-description") : "";
  programInfo["program.partPath"] = hasGlobalParameter("document-path") ? getGlobalParameter("document-path") : "";
  programInfo["program.partName"] = FileSystem.getFilename(programInfo["program.partPath"]);
  programInfo["program.user"] = hasGlobalParameter("username") ? getGlobalParameter("username") : "";
  
  var workpiece = getWorkpiece();
  var delta = Vector.diff(workpiece.upper, workpiece.lower);
  programInfo["program.stockLowerX"] = workpiece.lower.x;
  programInfo["program.stockLowerY"] = workpiece.lower.y;
  programInfo["program.stockLowerZ"] = workpiece.lower.z;
  programInfo["program.stockUpperX"] = workpiece.upper.x;
  programInfo["program.stockUpperY"] = workpiece.upper.y;
  programInfo["program.stockUpperZ"] = workpiece.upper.z;
  programInfo["program.stockDX"] = delta.x;
  programInfo["program.stockDY"] = delta.y;
  programInfo["program.stockDZ"] = delta.z;

  var partLowerX = hasGlobalParameter("part-lower-x") ? getGlobalParameter("part-lower-x") : 0;
  var partLowerY = hasGlobalParameter("part-lower-y") ? getGlobalParameter("part-lower-y") : 0;
  var partLowerZ = hasGlobalParameter("part-lower-z") ? getGlobalParameter("part-lower-z") : 0;
  var partUpperX = hasGlobalParameter("part-upper-x") ? getGlobalParameter("part-upper-x") : 0;
  var partUpperY = hasGlobalParameter("part-upper-y") ? getGlobalParameter("part-upper-y") : 0;
  var partUpperZ = hasGlobalParameter("part-upper-z") ? getGlobalParameter("part-upper-z") : 0;

  programInfo["program.partLowerX"] = partLowerX;
  programInfo["program.partLowerY"] = partLowerY;
  programInfo["program.partLowerZ"] = partLowerZ;
  programInfo["program.partUpperX"] = partUpperX;
  programInfo["program.partUpperY"] = partUpperY;
  programInfo["program.partUpperZ"] = partUpperZ;
  programInfo["program.partDX"] = partUpperX - partLowerX;
  programInfo["program.partDY"] = partUpperY - partLowerY;
  programInfo["program.partDZ"] = partUpperZ - partLowerZ;
  
  toolInfo = getToolInfo();
  
  cachedParameters = {};
}

function onSection() {
  skipRemainingSection();
}

function getStrategy() {
  if (hasParameter("operation-strategy")) {
    var strategies = {
      drill: localize("Drilling"),
      face: localize("Facing"),
      path3d: localize("3D Path"),
      pocket2d: localize("Pocket 2D"),
      contour2d: localize("Contour 2D"),
      adaptive2d: localize("Adaptive 2D"),
      slot: localize("Slot"),
      circular: localize("Circular"),
      bore: localize("Bore"),
      thread: localize("Thread"),
      probe: localize("Probe"),
      
      contour_new: localize("Contour"),
      contour: localize("Contour"),
      parallel_new: localize("Parallel"),
      parallel: localize("Parallel"),
      pocket_new: localize("Pocket"),
      pocket: localize("Pocket"),
      adaptive: localize("Adaptive"),
      horizontal_new: localize("Horizontal"),
      horizontal: localize("Horizontal"),
      flow: localize("Flow"),
      morph: localize("Morph"),
      pencil_new: localize("Pencil"),
      pencil: localize("Pencil"),
      project: localize("Project"),
      ramp: localize("Ramp"),
      radial_new: localize("Radial"),
      radial: localize("Radial"),
      scallop_new: localize("Scallop"),
      scallop: localize("Scallop"),
      morphed_spiral: localize("Morphed Spiral"),
      spiral_new: localize("Spiral"),
      spiral: localize("Spiral"),
      swarf5d: localize("Multi-Axis Swarf"),
      multiAxisContour: localize("Multi-Axis Contour")
    };
    if (strategies[getParameter("operation-strategy")]) {
      return strategies[getParameter("operation-strategy")];
    }
  }
  return "";
}

/**
  Returns the specified coolant as a string.
*/
function getCoolantName(coolant) {
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

function onSectionEnd() {
  var operationParameters = {};
  
  operationParameters["id"] = currentSection.getId() + 1;
  operationParameters["description"] = hasParameter("operation-comment") ? getParameter("operation-comment") : "";
  operationParameters["strategy"] = getStrategy();
  operationParameters["workOffset"] = currentSection.workOffset;

  var tolerance = cachedParameters["operation:tolerance"];
  var stockToLeave = cachedParameters["operation:stockToLeave"];
  var axialStockToLeave = cachedParameters["operation:verticalStockToLeave"];
  var maximumStepdown = cachedParameters["operation:maximumStepdown"];
  var maximumStepover = cachedParameters["operation:maximumStepover"] ? cachedParameters["operation:maximumStepover"] : cachedParameters["operation:stepover"];

  operationParameters["tolerance"] = tolerance;
  operationParameters["stockToLeave"] = stockToLeave;
  operationParameters["axialStockToLeave"] = axialStockToLeave;
  operationParameters["maximumStepdown"] = maximumStepdown;
  operationParameters["maximumStepover"] = maximumStepover;

  if (!isProbeOperation(currentSection)) {
    var cycleTime = currentSection.getCycleTime();

    if (is3D()) {
      var zRange = currentSection.getGlobalZRange();
      operationParameters["minimumZ"] = zRange.getMinimum();
      operationParameters["maximumZ"] = zRange.getMaximum();
    } else {
      operationParameters["minimumZ"] = "";
      operationParameters["maximumZ"] = "";
    }

    operationParameters["maximumFeed"] = currentSection.getMaximumFeedrate();
    operationParameters["maximumSpindleSpeed"] = currentSection.getMaximumSpindleSpeed();
    operationParameters["cuttingDistance"] = currentSection.getCuttingDistance();
    operationParameters["rapidDistance"] = currentSection.getRapidDistance();
    if (getProperty("rapidFeed") > 0) {
      cycleTime += currentSection.getRapidDistance()/getProperty("rapidFeed") * 60;
    }
    operationParameters["cycleTime"] = formatTime(cycleTime);
  }

  var tool = currentSection.getTool();
  operationParameters["tool.number"] = tool.number;
  operationParameters["tool.diameterOffset"] = tool.diameterOffset;
  operationParameters["tool.lengthOffset"] = tool.lengthOffset;
  operationParameters["tool.diameter"] = tool.diameter;
  operationParameters["tool.cornerRadius"] = tool.cornerRadius;
  operationParameters["tool.taperAngle"] = toDeg(tool.taperAngle);
  operationParameters["tool.fluteLength"] = tool.fluteLength;
  operationParameters["tool.shoulderLength"] = tool.shoulderLength;
  operationParameters["tool.bodyLength"] = tool.bodyLength;
  operationParameters["tool.numberOfFlutes"] = tool.numberOfFlutes;
  operationParameters["tool.type"] = getToolTypeName(tool.type);
  operationParameters["tool.spindleSpeed"] = tool.spindleSpeed;
  operationParameters["tool.coolant"] = getCoolantName(tool.coolant);
  operationParameters["tool.description"] = tool.description;
  operationParameters["tool.comment"] = tool.comment;
  operationParameters["tool.vendor"] = tool.vendor;
  operationParameters["tool.productId"] = tool.productId;
  operationParameters["tool.holderDescription"] = tool.holderDescription;
  operationParameters["tool.holderComment"] = tool.holderComment;
  operationParameters["tool.holderVendor"] = tool.holderVendor;
  operationParameters["tool.holderProductId"] = tool.holderProductId;

  operationInfo.push(prepend("operation", operationParameters));

  cachedParameters = {};
}

function formatTime(cycleTime) {
  cycleTime = cycleTime + 0.5; // round up
  var d = new Date(1899, 11, 31, 0, 0, cycleTime, 0);
  return subst(
    "%1-%2-%3T%4:%5:%6.000",
    d.getFullYear(),
    timeFormat.format(d.getMonth() + 1),
    timeFormat.format(d.getDate()),
    timeFormat.format(d.getHours()),
    timeFormat.format(d.getMinutes()),
    timeFormat.format(d.getSeconds())
  );
}

function dumpIds() {
  for (var k in programInfo) {
    log(k + " = " + programInfo[k]);
  }
  
  if (toolInfo.length > 0) {
    var variables = toolInfo[0];
    for (var k in variables) {
      log(k + " = " + variables[k]);
    }
  }

  if (operationInfo.length > 0) {
    var variables = operationInfo[0];
    for (var k in variables) {
      log(k + " = " + variables[k]);
    }
  }
}

function onClose() {
  if (getProperty("listVariables")) {
    dumpIds();
  }
  
  var xml = loadText("setup-sheet-excel-template.xls", "utf-8");
  var xml = xml.replace(/<\?xml (.*?)\?>/, "");
  var d = new XML(xml);
  
  default xml namespace = "urn:schemas-microsoft-com:office:spreadsheet";
  var ss = new Namespace("urn:schemas-microsoft-com:office:spreadsheet");
  
  var worksheets = d.ss::Worksheet;
  for (var w in worksheets) {
    updateWorksheet(worksheets[w]);
  }

  writeln("<?xml version='1.0' encoding='utf-8'?>");
  write(d.toXMLString());
}

function onTerminate() {
  //openUrl(getOutputPath());
  executeNoWait("excel", "\"" + getOutputPath() + "\"", false, "");
}

function setProperty(property, value) {
  properties[property].current = value;
}
