/**
  Copyright (C) 2012-2021 by Autodesk, Inc.
  All rights reserved.

  Excel 2007 setup sheet configuration.

  $Revision: 43194 08c79bb5b30997ccb5fb33ab8e7c8c26981be334 $
  $Date: 2021-02-18 16:25:13 $
  
  FORKID {CDDF7D05-7EFA-49b2-A6C8-D3CAEA690A7E}
*/

description = "Setup Sheet Excel 2007";
vendor = "Autodesk";
vendorUrl = "http://www.autodesk.com";
legal = "Copyright (C) 2012-2021 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45702;

longDescription = "Setup sheet for generating spreadsheet in Excel 2007 format. Only supported on Windows.";

capabilities = CAPABILITY_SETUP_SHEET;
extension = "xlsx";
mimetype = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
keywords = "MODEL_IMAGE";
setCodePage("utf-8");
dependencies = "setup-sheet-excel-2007-template.xlsx";

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

  var now = new Date();
  result["generationTime"] = (now.getTime()/1000.0 - now.getTimezoneOffset()*60)/(24*60*60) + 25569;
  
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
        value = eval.call(global, id); // TAG: not supported
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
/*jsl:ignore*/
  default xml namespace = "http://schemas.openxmlformats.org/spreadsheetml/2006/main";

  var cs = xml..c;
  for (var i = 0; i < cs.length(); ++i) {
    var c = cs[i];
    var v = c.v;
    if (c.@t == "s") { // string
      var text = getString(c.v);
      if (text.charAt(0) == "$") { // variable
        var value = getVariable(variables, text.substr(1));

        switch (typeof(value)) {
        case "boolean":
          delete c.@t;
          c.v = value ? 1 : 0;
          break;
        case "number":
          delete c.@t;
          c.v = value;
          break;
        case "string":
        default:
          if ((value.indexOf("$") < 0) && (text.substr(text.length - 4) == "Time")) {
            delete c.@t;
            c.v = value;
          } else {
            c.@t = "inlineStr";
            delete c.v;
            c.is = <is/>;
            c.is.t = value;
          }
        }
      }
    }
  }
/*jsl:end*/
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

var temporaryFolder;

function onOpen() {
  if (getPlatform() != "WIN32") {
    error(localize("This post is only supported on Windows."));
    return;
  }

  if (!FileSystem.isFolder(FileSystem.getTemporaryFolder())) {
    FileSystem.makeFolder(FileSystem.getTemporaryFolder());
  }
  temporaryFolder = FileSystem.getTemporaryFile("setup-sheet-excel-2007");
  
  FileSystem.removeFolderRecursive(temporaryFolder);

  var templatePath = FileSystem.getCombinedPath(getConfigurationFolder(), "setup-sheet-excel-2007-template.xlsx");

  FileSystem.makeFolder(temporaryFolder);
  ZipFile.unzipTo(templatePath, temporaryFolder);

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
  var epoc = new Date(1900, 0, 1, 0, 0, 0, 0);
  cycleTime = cycleTime + 0.5; // round up
  return cycleTime/(24.0*60*60);
}

/**
  Loads XML from the specified file.
*/
function loadXML(path) {
  var xml = loadText(path, "utf-8");
  xml = xml.replace(/<\?xml (.*?)\?>/, "");
  return new XML(xml);
}

function dumpIds() {
  // only for debugging
  
  for (var k in programInfo) {
    log(k + " = " + programInfo[k]);
  }
  
  for (var i = 0; i < toolInfo.length; ++i) {
    log("TOOL " + i);
    var variables = toolInfo[i];
    for (var k in variables) {
      log(k + " = " + variables[k]);
    }
  }

  for (var i = 0; i < operationInfo.length; ++i) {
    log("OPERATION " + i);
    var variables = operationInfo[i];
    for (var k in variables) {
      log(k + " = " + variables[k]);
    }
  }
}

var sharedStringsPath;
var sharedStrings = [];
var sharedStringsXML;

function loadSharedStrings() {

  var path = FileSystem.getCombinedPath(temporaryFolder, "xl\\_rels\\workbook.xml.rels");
  var Relationships = loadXML(path);

  default xml namespace = "http://schemas.openxmlformats.org/package/2006/relationships";
  
  var rs = Relationships.Relationship;
  for (var i = 0; i < rs.length(); ++i) {
    var r = rs[i];
    if (r.@Type == "http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings") {
      var target = r.@Target;
      var path = FileSystem.getCombinedPath(temporaryFolder, "xl\\" + target.replace(/\//g, "\\"));
      sharedStringsPath = path;

      var sst = loadXML(path);
  
      default xml namespace = "http://schemas.openxmlformats.org/spreadsheetml/2006/main";
  
      var ts = sst.si.t;
      for (var i = 0; i < ts.length(); ++i) {
        var t = ts[i];
        sharedStrings.push(t);
      }

      sharedStringsXML = sst;
      break;
    }
  }
}

function saveSharedStrings() {
  if (!sharedStringsPath) {
    return;
  }
  
  default xml namespace = "http://schemas.openxmlformats.org/spreadsheetml/2006/main";
  
  var ts = sharedStringsXML.si.t;
  for (var i = 0; i < ts.length(); ++i) {
    var t = ts[i];
    if (t.charAt(0) != "$") { // variable
      ts[i] = localize(t);
    }
  }

  try {
    var file = new TextFile(sharedStringsPath, true, "utf-8");
    file.writeln("<?xml version='1.0' encoding='utf-8'?>");
    file.write(sharedStringsXML.toXMLString());
    file.close();
  } catch (e) {
    error(localize("Failed to write shared string."));
  }
}

function getString(index) {
  return sharedStrings[index];
}

function addString(text) {
  sharedStrings.push(text);
  return sharedStrings.length - 1;
}

function updateWorksheet(path) {
  var worksheet = loadXML(path);

  default xml namespace = "http://schemas.openxmlformats.org/spreadsheetml/2006/main";
  var rr = new Namespace("http://schemas.openxmlformats.org/officeDocument/2006/relationships");

  // find operation rows to fill
  var rows = worksheet.sheetData.row;
  for (var i = 0; i < rows.length(); ++i) {
    var row = rows[i];
    var cs = row.c;
    var found = false;
    for (var j = 0; j < cs.length(); ++j) {
      var c = cs[j];
      if (c.@t == "s") { // string
        var text = getString(c.v);
        if (text == "$OPERATION_ROW") {
          found = true;
          break;
        }
      }
    }
    if (found) {
      var r = parseInt(row.@r);

      var rows = worksheet.sheetData.row;
      for (var j = 0; j < rows.length(); ++j) {
        var _row = rows[j];
        var rr = parseInt(_row.@r);
        if (rr> r) {
          _row.@r = rr + (operationInfo.length - 1);
          delete _row.c.@r;
        }
      }

      // insert new rows
      var sheetData = row.parent();
      for (var j = operationInfo.length - 1; j >= 0; --j) {
        var filledRow = row.copy(); // uses a lot of memory
        delete filledRow.c.@r;
        if (!operationInfo[j]) {
          log(localize("Invalid operation information."));
          return;
        }
        replaceVariables(operationInfo[j], filledRow);
        filledRow.@r = r + j;
        worksheet.sheetData.insertChildAfter(row, filledRow);
      }
      delete worksheet.sheetData.row[i]; // remove original row
    }
  }

  // find tool rows to fill
  for (var i = 0; i < rows.length(); ++i) {
    var row = rows[i];
    var cs = row.c;
    var found = false;
    for (var j = 0; j < cs.length(); ++j) {
      var c = cs[j];
      if (c.@t == "s") { // string
        var text = getString(c.v);
        if (text == "$TOOL_ROW") {
          found = true;
          break;
        }
      }
    }
    if (found) {
      var r = parseInt(row.@r);

      var rows = worksheet.sheetData.row;
      for (var j = 0; j < rows.length(); ++j) {
        var _row = rows[j];
        var rr = parseInt(_row.@r);
        if (rr> r) {
          _row.@r = rr + (toolInfo.length - 1);
          delete _row.c.@r;
        }
      }

      // insert new rows
      var sheetData = row.parent();
      for (var j = toolInfo.length - 1; j >= 0; --j) {
        var filledRow = row.copy(); // uses a lot of memory
        delete filledRow.c.@r;
        if (!toolInfo[j]) {
          log(localize("Invalid tool information."));
          return;
        }
        replaceVariables(toolInfo[j], filledRow);
        filledRow.@r = r + j;
        worksheet.sheetData.insertChildAfter(row, filledRow);
      }
      delete worksheet.sheetData.row[i]; // remove original row
    }
  }

  if (!programInfo) {
    log(localize("Invalid program information."));
    return;
  }
  replaceVariables(programInfo, worksheet); // we need to subst correct type

/* we translate shared strings

  var cs = worksheet..c;
  for (var i = 0; i < cs.length(); ++i) {
    var c = cs[i];
    if (c.@t == "s") { // string
      var text = getString(c.v);
      c.@t = "inlineStr";
      delete c.v;
      c.is = <is/>;
      c.is.t = localize(text); // only allowed for strings
    }
  }
*/

  var vs = worksheet..v;
  for (var i = 0; i < vs.length(); ++i) {
    var v = vs[i];
    if (v == "#VALUE!") {
      delete v.parent().v;
    }
  }

  try {
    var file = new TextFile(path, true, "utf-8");
    file.writeln("<?xml version='1.0' encoding='utf-8'?>");
    file.write(worksheet.toXMLString());
    file.close();
  } catch (e) {
    error(localize("Failed to write worksheet."));
  }
}

function updateWorksheets() {
  // see http://msdn.microsoft.com/en-us/library/bb332058%28v=office.12%29.aspx
  
  var path = FileSystem.getCombinedPath(temporaryFolder, "xl\\_rels\\workbook.xml.rels");
  var Relationships = loadXML(path);

  default xml namespace = "http://schemas.openxmlformats.org/package/2006/relationships";
  
  var rs = Relationships.Relationship;
  for (var i = 0; i < rs.length(); ++i) {
    var r = rs[i];
    if (r.@Type == "http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet") {
      var target = r.@Target;
      var path = FileSystem.getCombinedPath(temporaryFolder, "xl\\" + target.replace(/\//g, "\\"));
      if (FileSystem.isFile(path)) {
        updateWorksheet(path);
      }
    }
  }
}

function updateWorkbook() {
  var path = FileSystem.getCombinedPath(temporaryFolder, "xl\\workbook.xml");
  var workbook = loadXML(path);

  default xml namespace = "http://schemas.openxmlformats.org/spreadsheetml/2006/main";
  var sheets = workbook.sheets.sheet;
  for (var i = 0; i < sheets.length(); ++i) {
    var sheet = sheets[i];
    sheet.@name = localize(sheet.@name);
  }
  
  try {
    var file = new TextFile(path, true, "utf-8");
    file.writeln("<?xml version='1.0' encoding='utf-8'?>");
    file.write(workbook.toXMLString());
    file.close();
  } catch (e) {
    error(localize("Failed to write workbook."));
  }
}

function onClose() {
  if (getProperty("listVariables")) {
    dumpIds();
  }

  loadSharedStrings();

  if (false) {
    for (var i = 0; i < sharedStrings.length; ++i) {
      log("sharedStrings[" + i + "]=" + getString(i));
    }
  }
  
  updateWorksheets();
  updateWorkbook();
  saveSharedStrings();
}

function onTerminate() {
  if (!modelImagePath) {
    var extensions = ["jpg", "png"];
    for (var i = 0; i < extensions.length; ++i) {
      var modelImageName = FileSystem.replaceExtension(getOutputPath(), extensions[i]);
      if (FileSystem.isFile(FileSystem.getCombinedPath(FileSystem.getFolderPath(getOutputPath()), modelImageName))) {
        modelImagePath = modelImageName;
        break;
      }
    }
  }

  if (modelImagePath) {

/*
    // find job image
    var path = FileSystem.getCombinedPath(temporaryFolder, "xl\\drawings\\drawing1.xml");
    var wsDr = loadXML(path);
  
    default xml namespace = "http://schemas.openxmlformats.org/drawingml/2006/spreadsheetDrawing";
    var a = new Namespace("http://schemas.openxmlformats.org/drawingml/2006/main");
    var r = new Namespace("http://schemas.openxmlformats.org/package/2006/relationships");
    
    var pics = wsDr..pic;
    for (var i = 0; i < pics.length(); ++i) {
      var pic = pics[i];
      if (pic.nvPicPr.cNvPr.@descr == "Job preview") {
        var blipFill = pic..blipFill;
      }
    }
*/

    var destFolder = FileSystem.getCombinedPath(temporaryFolder, "xl\\media");
    
    var original = FileSystem.getCombinedPath(destFolder, "image1.png");
    FileSystem.remove(original);
    
    // extension must be png or excel fails to load file - still works if file is actually in jpg format
    var imageFilename = "model.png"; // do NOT use non-ASCII characters - and do NOT use spaces
    // var imageFilename = FileSystem.replaceExtension(FileSystem.getFilename(modelImagePath).replace(/ /g, "_"), "png");
    
    var src = FileSystem.getCombinedPath(FileSystem.getFolderPath(getOutputPath()), modelImagePath);
    var dest = FileSystem.getCombinedPath(destFolder, imageFilename);
    try {
      FileSystem.copyFile(src, dest);
    } catch (e) {
      warning(subst(localize("Failed to copy image from '%1' to '%2'."), src, dest));
    }
    
    var path = FileSystem.getCombinedPath(temporaryFolder, "xl\\drawings\\_rels\\drawing1.xml.rels");
    var Relationships = loadXML(path);

    default xml namespace = "http://schemas.openxmlformats.org/package/2006/relationships";
    var rs = Relationships.Relationship;
    for (var i = 0; i < rs.length(); ++i) {
      var r = rs[i];
      if (r.@Type == "http://schemas.openxmlformats.org/officeDocument/2006/relationships/image") {
        if (r.@Target == "../media/image1.png") {
          r.@Target = "../media/" + imageFilename;
        }
      }
    }
    
    try {
      var file = new TextFile(path, true, "utf-8");
      file.writeln("<?xml version='1.0' encoding='utf-8'?>");
      file.write(Relationships.toXMLString());
      file.close();
    } catch (e) {
      error(localize("Failed to write shared string."));
      return;
    }
  }

  ZipFile.zipTo(temporaryFolder, getOutputPath());
  FileSystem.removeFolderRecursive(temporaryFolder);
  
  // executeNoWait("excel", "\"" + getOutputPath() + "\"", false, "");
}

function setProperty(property, value) {
  properties[property].current = value;
}
