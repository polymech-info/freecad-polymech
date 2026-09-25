/**
  Copyright (C) 2012-2021 by Autodesk, Inc.
  All rights reserved.

  Setup sheet configuration.

  $Revision: 43569 147f5cf60e9217cf9c3365dc511a0f631d89bb16 $
  $Date: 2021-10-13 13:53:32 $

  FORKID {BC98C807-412C-4ffc-BD2B-ABB3F0A59DB8}
*/

description = "Setup Sheet (HTML)";
vendor = "Autodesk";
vendorUrl = "http://www.autodesk.com";
legal = "Copyright (C) 2012-2021 by Autodesk, Inc.";
certificationLevel = 2;

longDescription = "Setup sheet for generating an HTML document with the relevant details for the setup, tools, and individual operations. You can print the document directly or alternatively convert it to a PDF file for later reference.";

capabilities = CAPABILITY_SETUP_SHEET;
extension = "html";
mimetype = "text/html";
keywords = "MODEL_IMAGE PREVIEW_IMAGE";
setCodePage("utf-8");
dependencies = "setup-sheet.css";

allowMachineChangeOnSection = true;

properties = {
  embedStylesheet: {
    title      : "Embed stylesheet",
    description: "Embeds the stylesheet in the HTML code.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  useUnitSymbol: {
    title      : "Use unit symbol",
    description: "Specifies that symbols should be used for units (some printers may not support this).",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  showDocumentPath: {
    title      : "Show document path",
    description: "Specifies that the document path should be output.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showModelImage: {
    title      : "Show model image",
    description: "If enabled, a model image will be included in the setup sheet.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showToolImage: {
    title      : "Show tool images",
    description: "If enabled, tool images will be included in the seutp sheet.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showPreviewImage: {
    title      : "Show preview image",
    description: "If enabled, a preview image will be included in the setup sheet.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  previewWidth: {
    title      : "Preview width",
    description: "Specifies the width of the preview image.",
    type       : "string",
    value      : "8cm",
    scope      : "post"
  },
  showPercentages: {
    title      : "Show percentages",
    description: "Specifies that the percentage of the total cycle time should be shown for each operation cycle time.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showFooter: {
    title      : "Show footer",
    description: "Specifies whether a footer should be included in the HTML setup sheet.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showRapidDistance: {
    title      : "Show rapid distance",
    description: "Specifies whether the rapid distance should be output.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  rapidFeed: {
    title      : "Rapid feed",
    description: "Sets the rapid traversal feedrate. Set this to get more accurate cycle times.",
    type       : "number",
    value      : 5000,
    scope      : "post"
  },
  toolChangeTime: {
    title      : "Tool change time",
    description: "Sets the tool change time in seconds. Set this to get more accurate cycle times.",
    type       : "number",
    value      : 15,
    scope      : "post"
  },
  showNotes: {
    title      : "Show notes",
    description: "Writes operation notes as comments in the outputted code.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  forcePreview: {
    title      : "Force preview",
    description: "Enable to force a preview picture for all instances of a pattern.",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  showOperations: {
    title      : "Show operations",
    description: "Enable to output information for each operation.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showTools: {
    title      : "Show tools",
    description: "Enable to see information for each tool.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showTotals: {
    title      : "Show totals",
    description: "Enable to see total information.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  embedImages: {
    title      : "Embed images",
    description: "If enabled, images are embedded into the HTML file.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  }
};

var showToolpath = false;
var useToolNumber = true;

var xyzFormat = createFormat({decimals:(unit == MM ? 3 : 4)});
var feedFormat = createFormat({decimals:(unit == MM ? 3 : 5)});
var toolFormat = createFormat({decimals:0});
var rpmFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:3});
var angleFormat = createFormat({decimals:0, scale:DEG});
var degFormat = createFormat({decimals:0});
var pitchFormat = createFormat({decimals:3});
var spatialFormat = createFormat({decimals:(unit == MM ? 2 : 3)});
var percentageFormat = createFormat({decimals:1, scale:100});
var timeFormat = createFormat({decimals:2});
var taperFormat = angleFormat; // share format

var supportedImageTypes = {
  "bmp" : "image/bmp",
  "gif" : "image/gif",
  "jpg" : "image/jpeg",
  "jpeg": "image/jpeg",
  "png" : "image/png",
  "tif" : "image/tiff",
  "tiff": "image/tiff"
};

// collected state
var zRanges = {};
var totalCycleTime = 0;
var exportedTools = {};
var toolRenderer;

function getUnitSymbolAsString() {
  switch (unit) {
  case MM:
    return getProperty("useUnitSymbol") ? "&#x339c;" : "mm";
  case IN:
    return getProperty("useUnitSymbol") ? "&#x2233;" : "in";
  default:
    error(localize("Unit is not supported."));
    return undefined;
  }
}

function getFeedSymbolAsString() {
  switch (unit) {
  case MM:
    return getProperty("useUnitSymbol") ? "&#x339c;/min" : "mm/min";
  case IN:
    return getProperty("useUnitSymbol")  ? "&#x2233;/min" : "in/min";
    // return getProperty("useUnitSymbol")  ? "&#x2032;/min" : "ft/min";
  default:
    error(localize("Unit is not supported."));
    return undefined;
  }
}

function getFPRSymbolAsString() {
  switch (unit) {
  case MM:
    return getProperty("useUnitSymbol") ? "&#x339c;" : "mm";
  case IN:
    return getProperty("useUnitSymbol")  ? "&#x2233;" : "in";
  default:
    error(localize("Unit is not supported."));
    return undefined;
  }
}

function toString(value) {
  if (typeof value == "string") {
    return "'" + value + "'";
  } else {
    return value;
  }
}

function makeRow(content, classId) {
  if (classId) {
    return "<tr class=\"" + classId + "\">" + content + "</tr>";
  } else {
    return "<tr>" + content + "</tr>";
  }
}

function makeHeading(content, classId) {
  if (classId) {
    return "<th class=\"" + classId + "\">" + content + "</th>";
  } else {
    return "<th>" + content + "</th>";
  }
}

function makeColumn(content, classId) {
  if (classId) {
    return "<td class=\"" + classId + "\">" + content + "</td>";
  } else {
    return "<td>" + content + "</td>";
  }
}

function bold(content, classId) {
  if (classId) {
    return "<b class=\"" + classId + "\">" + content + "</b>";
  } else {
    return "<b>" + content + "</b>";
  }
}

function d(content) {
  return "<div class=\"description\" style=\"display: inline;\">" + content + "</div>";
}

function v(content) {
  return "<div class=\"value\" style=\"display: inline;\">" + content + "</div>";
}

function vWrap(content) {
  return "<div class=\"value\" style=\"display: inline; white-space: normal;\">" + content + "</div>";
}

function p(content, classId) {
  if (classId) {
    return "<p class=\"value\">" + content + "</p>";
  } else {
    return "<p>" + content + "</p>";
  }
}

var cachedParameters = {};
var patternIds = {};
var seenPatternIds = {};

function formatPatternId(id) {
  var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  var result = "";
  while (id >= 0) {
    result += chars.charAt(id % chars.length);
    id -= chars.length;
  }
  return result;
}

/** Loads the given image as a img data snippet. Returns empty string if unsupported. */
function getImageAsImgSrc(path) {
  if ((typeof BinaryFile == "function") && (typeof Base64 == "function")) {
    var extension = path.slice(path.lastIndexOf(".") + 1, path.length).toLowerCase();
    var mimetype = supportedImageTypes[extension];
    if (mimetype) {
      var data = BinaryFile.loadBinary(path);
      return "data:" + mimetype + ";base64," + Base64.btoa(data);
    }
  }
  return "";
}

function onParameter(name, value) {
  cachedParameters[name] = value;
}

function onOpen() {
  cachedParameters = {};

  if ((revision < 41366) || !getProperty("embedImages") && (getPlatform() == "WIN32")) { // use SVG instead of image
    toolRenderer = createToolRenderer();
    if (toolRenderer) {
      toolRenderer.setBackgroundColor(new Color(1, 1, 1));
      toolRenderer.setFluteColor(new Color(40.0 / 255, 40.0 / 255, 40.0 / 255));
      toolRenderer.setShoulderColor(new Color(80.0 / 255, 80.0 / 255, 80.0 / 255));
      toolRenderer.setShaftColor(new Color(80.0 / 255, 80.0 / 255, 80.0 / 255));
      toolRenderer.setHolderColor(new Color(40.0 / 255, 40.0 / 255, 40.0 / 255));
    }
  }

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

  write(
    "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\"\n" +
    "                      \"http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd\">\n"
  );
  write("<html>");
  // header
  var c = "<head>";
  c += "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">";
  if (getProperty("embedStylesheet")) {
    c += "<style type=\"text/css\">" + loadText("setup-sheet.css", "utf-8") + "</style>";
  } else {
    c += "<link rel=\"StyleSheet\" href=\"setup-sheet.css\" type=\"text/css\" media=\"print, screen\">";
  }

  var script = "<script type=\"text/javascript\">" +
"function detectIE() {\n" +
"  var ua = window.navigator.userAgent;\n" +
"  var msie = ua.indexOf('MSIE ');\n" +
"  if (msie > 0) {\n" +
"    // IE 10 or older => return version number\n" +
"    return parseInt(ua.substring(msie + 5, ua.indexOf('.', msie)), 10);\n" +
"  }\n" +
"  var trident = ua.indexOf('Trident/');\n" +
"  if (trident > 0) {\n" +
"    // IE 11 => return version number\n" +
"    var rv = ua.indexOf('rv:');\n" +
"    return parseInt(ua.substring(rv + 3, ua.indexOf('.', rv)), 10);\n" +
"  }\n" +
"  var edge = ua.indexOf('Edge/');\n" +
"  if (edge > 0) {\n" +
"    // Edge (IE 12+) => return version number\n" +
"    return parseInt(ua.substring(edge + 5, ua.indexOf('.', edge)), 10);\n" +
"  }\n" +
"  return false;\n" +
"}\n" +
"\n" +
"function onLoad() {\n" +
"  if (detectIE()) {\n" +
"    var paths = document.getElementsByTagName(\"path\")\n" +
"    for (var i in paths) {\n" +
"      var path = paths[i];\n" +
"      if (path.getAttribute(\"class\") == \"holder\") {\n" +
"        path.setAttribute(\"class\", \"holderIE\"); \n" +
"      } else if (path.getAttribute(\"class\") == \"cutter\") {\n" +
"        path.setAttribute(\"class\", \"cutterIE\"); \n" +
"      }\n" +
"    }\n" +
"  }\n" +
"}\n" +
"</script>";

  c += "<style type=\"text/css\">" + ".preview img {width: " + getProperty("previewWidth") + ";}" + "</style>";
  c += script;
  if (programName) {
    c += "<title>" + localize("Setup Sheet for Program") + " " + programName + "</title>";
  } else {
    c += "<title>" + localize("Setup Sheet") + "</title>";
  }
  c += "</head>";
  write(c);

  write("<body onload=\"onLoad()\">");
  if (programName) {
    write("<h1>" + localize("Setup Sheet for Program") + " " + programName + "</h1>");
  } else {
    write("<h1>" + localize("Setup Sheet") + "</h1>");
  }

  patternIds = {};
  var numberOfSections = getNumberOfSections();
  var j = 0;
  for (var i = 0; i < numberOfSections; ++i) {
    var section = getSection(i);
    if (section.isPatterned()) {
      var id = section.getPatternId();
      if (patternIds[id] == undefined) {
        patternIds[id] = formatPatternId(j);
        ++j;
      }
    }
  }
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

/** Formats WCS to text. */
function formatWCS(id) {
  /*
  if (id == 0) {
    id = 1;
  }
  if (id > 6) {
    return "G54.1P" + (id - 6);
  }
  return "G" + (getAsInt(id) + 53);
  */
  return "#" + id;
}

function isProbeOperation(section) {
  return section.hasParameter("operation-strategy") && (section.getParameter("operation-strategy") == "probe");
}

var svg;

/** Returns the SVG representation for the current toolpath. */
function getToolpathAsSVG() {
  var fragment = "";
  if (!svg) {
    return "";
  }

  var pageWidth = 120;
  var pageHeight = 100;

  var box = currentSection.getGlobalBoundingBox();
  // for turning only for now
  box = {lower:new Vector(box.lower.z, box.lower.x, 0), upper:new Vector(box.upper.z, box.upper.x, 0)};

  var width = box.upper.x - box.lower.x;
  var height = box.upper.y - box.lower.y;
  var dx = toMM(width);
  var dy = toMM(height);
  var dimension = Math.min(width, height);
  var margin = toPreciseUnit(1, MM);
  var backgroundColor = "#f0f0f0";

  fragment += "<svg class=\"toolpathimage\" width=\"" + xyzFormat.format(pageWidth) + "mm\" height=\"" + xyzFormat.format(pageHeight) + "mm\" viewBox=\"" + xyzFormat.format(box.lower.x - margin) + " " + xyzFormat.format(box.lower.y - margin) + " " + xyzFormat.format(width + 2 * margin) + " " + xyzFormat.format(height + 2 * margin) + "\" style=\"background:" + backgroundColor + "\"" + ">";
  /*
  fragment += "<defs>";
  fragment += "<path id=\"c\" stroke=\"#f00\" stroke-width=\"1px\" color=\"blue\"></path>";
  fragment += "<path id=\"l\" stroke=\"#f00\" stroke-width=\"1px\" color=\"green\"></path>";
  fragment += "<path id=\"r\" stroke=\"#f00\" stroke-width=\"1px\" color=\"yellow\"></path>";
  fragment += "<path id=\"ramp\" stroke=\"#f00\" stroke-width=\"1px\" color=\"red\"></path>";
  fragment += "</defs>";
  */
  // invert y axis
  fragment += "<g transform=\"translate(" + xyzFormat.format(0) + ", " + xyzFormat.format(height + 2 * margin) + ")\">";
  fragment += "<g transform=\"scale(1, -1)\">";
  fragment += svg.toString();
  fragment += "</g>";
  fragment += "</g>";
  fragment += "</svg>";
  // add support for tool animation
  return fragment;
}

function onSection() {
  if (showToolpath && (currentSection.getType() == TYPE_TURNING)) {
    // var remaining = currentSection.workPlane;
    var map2XY = new Matrix(new Vector(0, 0, 1), new Vector(1, 0, 0), new Vector(0, -1, 0));
    setRotation(map2XY.getTransposed());
    svg = new StringBuffer();
    // add start position svg.append("<circle cx=\"" + xyzFormat.format(x) + "\" cy=\"" + xyzFormat.format(y) + "\" r=\"" + xyzFormat.format(radius) + "\" stroke=\"" + color + "\" stroke-width=\"" + width + "\"/>");
  } else {
    skipRemainingSection();
  }
}

function writeLine(x, y) {
  if (radiusCompensation != RADIUS_COMPENSATION_OFF) {
    return;
  }

  var color;
  switch (movement) {
  case MOVEMENT_CUTTING:
  case MOVEMENT_REDUCED:
  case MOVEMENT_FINISH_CUTTING:
    color = "blue";
    break;
  case MOVEMENT_RAPID:
  case MOVEMENT_HIGH_FEED:
    color = "yellow";
    break;
  case MOVEMENT_LEAD_IN:
  case MOVEMENT_LEAD_OUT:
  case MOVEMENT_LINK_TRANSITION:
  case MOVEMENT_LINK_DIRECT:
    color = "green";
    break;
  default:
    color = "red";
  }

  var start = getCurrentPosition();
  if ((xyzFormat.format(start.x) == xyzFormat.format(x)) &&
      (xyzFormat.format(start.y) == xyzFormat.format(y))) {
    return; // ignore vertical
  }
  svg.append("<line x1=\"" + xyzFormat.format(start.x) + "\" y1=\"" + xyzFormat.format(start.y) + "\" x2=\"" + xyzFormat.format(x) + "\" y2=\"" + xyzFormat.format(y) + "\" stroke=\"" + color + "\"/>");
}

function onRapid(x, y, z) {
  writeLine(x, y);
}

function onLinear(x, y, z, feed) {
  writeLine(x, y);
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  // linearize(tolerance);
  // return;

  if (radiusCompensation != RADIUS_COMPENSATION_OFF) {
    return;
  }

  var color;
  switch (movement) {
  case MOVEMENT_CUTTING:
  case MOVEMENT_REDUCED:
  case MOVEMENT_FINISH_CUTTING:
    color = "blue";
    break;
  case MOVEMENT_RAPID:
  case MOVEMENT_HIGH_FEED:
    color = "yellow";
    break;
  case MOVEMENT_LEAD_IN:
  case MOVEMENT_LEAD_OUT:
  case MOVEMENT_LINK_TRANSITION:
  case MOVEMENT_LINK_DIRECT:
    color = "green";
    break;
  default:
    color = "red";
  }

  var start = getCurrentPosition();

  var largeArc = (getCircularSweep() > Math.PI) ? 1 : 0;
  var sweepFlag = isClockwise() ? 1 : 0; // turning is flipped
  var dpath = [
    "M", xyzFormat.format(start.x), xyzFormat.format(start.y),
    "A", xyzFormat.format(getCircularRadius()), xyzFormat.format(getCircularRadius()), 0, largeArc, sweepFlag, xyzFormat.format(x), xyzFormat.format(y)
  ].join(" ");
  svg.append("<path d=\"" + dpath + "\" fill=\"none\" stroke=\"" + color + "\"/>");
}

function onCyclePoint(x, y, z) {
  var color = "green";
  var radius = tool.diameter * 0.5;
  svg.append("<circle cx=\"" + xyzFormat.format(x) + "\" cy=\"" + xyzFormat.format(y) + "\" r=\"" + xyzFormat.format(radius) + "\" stroke=\"" + color + "\" stroke-width=\"" + "1px" + "\"/>");
}

function pageWidthFitPath(path) {
  var PAGE_WIDTH = 70;
  if (path.length < PAGE_WIDTH) {
    return path;
  }
  var newPath = "";
  var tempPath = "";
  var flushPath = "";
  var offset = 0;
  var ids = "";
  for (var i = 0; i < path.length; ++i) {
    var cv = path[i];
    if (i > (PAGE_WIDTH + offset)) {
      if (flushPath.length == 0) { // No good place to break
        flushPath = tempPath;
        tempPath = "";
      }
      newPath += flushPath + "<br/>";
      offset += flushPath.length - 1;
      flushPath = "";
    }
    if ((cv == "\\") || (cv == "/") || (cv == " ") || (cv == "_")) {
      flushPath += tempPath + cv;
      tempPath = "";
    } else {
      tempPath += cv;
    }
  }
  newPath += flushPath + tempPath;
  return newPath;
}

/** Returns the given spatial value in MM. */
function toMM(value) {
  return value * ((unit == IN) ? 25.4 : 1);
}

/** Returns the SVG representation of the given tool. */
function getToolAsSVG(tool) {
  var fragment = "";

  var pageWidth = 30;
  var pageHeight = 35;

  var box = tool.getExtent(true);

  var width = box.upper.x - box.lower.x;
  var height = box.upper.y - box.lower.y;
  var dx = toMM(width);
  var dy = toMM(height);
  var dimension = Math.min(width, height);
  var margin = toPreciseUnit(1, MM);
  var backgroundColor = "#ffffff";

  fragment += "<svg class=\"toolimage\" width=\"" + xyzFormat.format(pageWidth) + "mm\" height=\"" + xyzFormat.format(pageHeight) + "mm\" viewBox=\"" + xyzFormat.format(box.lower.x - margin) + " " + xyzFormat.format(box.lower.y - margin) + " " + xyzFormat.format(width + 2 * margin) + " " + xyzFormat.format(height + 2 * margin) + "\" style=\"background:" + backgroundColor + "\"" + ">";

  fragment += "<defs>";
  fragment += "<linearGradient id='holderGrad' x1='0%' y1='0%' x2='100%' y2='0%'>";
  fragment += "<stop offset='0%' style='stop-color:rgb(120,120,120);stop-opacity:1'/>";
  fragment += "<stop offset='50%' style='stop-color:rgb(180,180,180);stop-opacity:0.5'/>";
  fragment += "<stop offset='100%' style='stop-color:rgb(150,150,150);stop-opacity:1'/>";
  fragment += "</linearGradient>";
  if (!tool.isJetTool()) { // we only show cutting head
    fragment += "<linearGradient id='cutterGrad' x1='0%' y1='0%' x2='100%' y2='0%'>";
    fragment += "<stop offset='0%' style='stop-color:rgb(228,175,52);stop-opacity:1'/>";
    fragment += "<stop offset='50%' style='stop-color:rgb(240,240,240);stop-opacity:1'/>";
    fragment += "<stop offset='100%' style='stop-color:rgb(228,175,52);stop-opacity:1'/>";
    fragment += "</linearGradient>";
  }
  fragment += "</defs>";

  if (!tool.isTurningTool()) {
    // invert y axis
    fragment += "<g transform=\"translate(" + xyzFormat.format(0) + ", " + xyzFormat.format(height) + ")\">";
    fragment += "<g transform=\"scale(1, -1)\">";
  }

  var holder = tool.getHolderProfileAsSVGPath();
  if (holder) {
    fragment += "<path class=\"holder\" d=\"" + holder + "\" style=\"fill:url(#holderGrad);vector-effect:non-scaling-stroke;stroke:black;stroke-opacity:0.9\"/>";
  }

  var cutter = !tool.isJetTool() ? tool.getCutterProfileAsSVGPath() : undefined;
  if (cutter) {
    // indicate if insert is on the other side stroke-dasharray=\"3px,3px\"
    fragment += "<path class=\"cutter\" d=\"" + cutter + "\" style=\"fill:url(#cutterGrad);vector-effect:non-scaling-stroke;stroke:black;fill-opacity:1.0;stroke-opacity:0.9\"/>";
  }

  if (false && tool.isTurningTool()) { // mark the compensation point
    var offset = tool.getCompensationDisplacement();
    fragment += "<circle cx=\"" + xyzFormat.format(offset.x) + "\" cy=\"" + xyzFormat.format(offset.y) + "\" r=\"" + "2.5px" + "\" style=\"fill:red;fill-opacity:0.5;vector-effect:non-scaling-stroke\"/>";
  }

  if (!tool.isTurningTool()) {
    fragment += "</g>";
    fragment += "</g>";
  }
  fragment += "</svg>";
  return fragment;
}

var TURNING_RELIEF_ANGLES = [
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

/** Returns the turning ISO tool code. */
function getTurningToolISO(tool) {
  if (!((tool.type == TOOL_TURNING_GENERAL) || (tool.type == TOOL_TURNING_BORING))) {
    return "";
  }

  var reliefAngleCode = "?";
  for (var e in TURNING_RELIEF_ANGLES) {
    if (Math.abs(e.value - tool.reliefAngle) < 1e-3) {
      reliefAngleCode = e.id;
      break;
    }
  }

  var name = "?";
  name += reliefAngleCode;
  return name;
}

var insertDescriptions = [
  localize("User defined"), localize("ISO A 85deg"), localize("ISO B 82deg"), localize("ISO C 80deg"), localize("ISO D 55deg"), localize("ISO E 75deg"), localize("ISO H 120deg"), localize("ISO K 55deg"), localize("ISO L 90deg"), localize("ISO M 86deg"), localize("ISO O 135deg"), localize("ISO P 108deg"), localize("ISO R round"), localize("ISO S square"), localize("ISO T triangle"), localize("ISO V 35deg"), localize("ISO W 80deg"),
  localize("Round"), localize("Radius"), localize("Square"), localize("Chamfer"), localize("40deg"),
  localize("ISO double"), localize("ISO triple"), localize("UTS double"), localize("UTS triple"), localize("ISO double V"), localize("ISO triple V"), localize("UTS double V"), localize("UTS triple V")
];

var holderDescriptions = [
  localize("No holder"), localize("ISO A"), localize("ISO B"), localize("ISO C"), localize("ISO D"), localize("ISO E"), localize("ISO F"), localize("ISO G"), localize("ISO H"), localize("ISO J"), localize("ISO K"), localize("ISO L"), localize("ISO M"), localize("ISO N"), localize("ISO P"), localize("ISO Q"), localize("ISO R"), localize("ISO S"), localize("ISO T"), localize("ISO U"), localize("ISO V"), localize("ISO W"), localize("ISO Y"), localize("Offset"), localize("Straight"),
  localize("External"), localize("Internal"), localize("Face"),
  localize("Straight"), localize("Offset"), localize("Face"),
  localize("Boring bar ISO F"), localize("Boring bar ISO G"), localize("Boring bar ISO J"), localize("Boring bar ISO K"), localize("Boring bar ISO L"), localize("Boring bar ISO P"), localize("Boring bar ISO Q"), localize("Boring bar ISO S"), localize("Boring bar ISO U"), localize("Boring bar ISO W"), localize("Boring bar ISO Y"), localize("Boring bar ISO X")
];

/** Returns a HTML link if text looks like a link. */
function autoLink(link, description) {
  if (!description) {
    description = "";
  }
  if (!link) {
    if ((description.toLowerCase().indexOf("https://") == 0) || (description.toLowerCase().indexOf("http://") == 0)) {
      link = description;
      if (description.length > 16) {
        description = localize("click to visit");
      }
    }
  }
  if (!link) {
    return description;
  }
  if (link.toLowerCase().indexOf("https://") == 0) {
    if (!description) {
      description = link.substr(8);
      if (description.length > 16) {
        description = localize("click to visit");
      }
    }
    return "<a href=\"" + link + "\">" + description + "</a>";
  } else if (link.toLowerCase().indexOf("http://") == 0) {
    if (!description) {
      description = link.substr(7);
      if (description.length > 16) {
        description = localize("click to visit");
      }
    }
    return "<a href=\"" + link + "\">" + description + "</a>";
  } else {
    if (!description) {
      description = link;
      if (description.length > 16) {
        description = localize("click to visit");
      }
    }
    return "<a href=\"http://" + link + "\">" + description + "</a>";
  }
}

function getSectionParameterForTool(tool, id) {
  var numberOfSections = getNumberOfSections();
  for (var i = 0; i < numberOfSections; ++i) {
    var section = getSection(i);
    if (section.getTool().number == tool.number) {
      return section.hasParameter(id) ? section.getParameter(id) : undefined;
    }
  }
  return undefined;
}

/** Returns a HTML table with the common tool information. Note that the table is not closed! */
function presentTool(tool) {
  var c1 = "<table class=\"info\">";

  if (!tool.isJetTool()) {
    c1 += makeRow(
      makeColumn(
        bold(localize("T") + toolFormat.format(tool.number)) + " " +
        localize("D") + toolFormat.format(!tool.isTurningTool() ? tool.diameterOffset : tool.compensationOffset) + " " +
        conditional(!tool.isTurningTool(), localize("L") + toolFormat.format(tool.lengthOffset))
      )
    );
  } else if (tool.isJetTool()) {
    c1 += makeRow(makeColumn("&nbsp;")); // move 1 row down
  }

  if (tool.manualToolChange) {
    c1 += makeRow(makeColumn(d(bold(localize("Manual tool change")))));
  }

  if (tool.isLiveTool && !tool.isTurningTool() && (machineConfiguration.getTurning() || isTurning())) {
    c1 += makeRow(makeColumn(d(localize("Type") + ": ") + v(getToolTypeName(tool.type) + " " + (tool.isLiveTool() ? localize("LIVE") : localize("STATIC")))));
  } else { // dont show for old versions or is non turning
    c1 += makeRow(makeColumn(d(localize("Type") + ": ") + v(getToolTypeName(tool.type))));
  }

  if (!tool.isTurningTool()) {
    c1 += makeRow(makeColumn(d(localize(tool.isJetTool() ? "Kerf Diameter" : "Diameter") + ": ") + v(spatialFormat.format(tool.isJetTool() ? tool.jetDiameter : tool.diameter) + getUnitSymbolAsString())));
    if (tool.cornerRadius) {
      c1 += makeRow(makeColumn(d(localize("Corner Radius") + ": ") + v(spatialFormat.format(tool.cornerRadius) + getUnitSymbolAsString())));
    }
    if ((tool.taperAngle > 0) && (tool.taperAngle < Math.PI)) {
      if (tool.isDrill()) {
        c1 += makeRow(makeColumn(d(localize("Tip Angle") + ": ") + v(taperFormat.format(tool.taperAngle) + "&deg;")));
      } else {
        c1 += makeRow(makeColumn(d(localize("Taper Angle") + ": ") + v(taperFormat.format(tool.taperAngle) + "&deg;")));
      }
    }
    if (!tool.isJetTool()) {
      c1 += makeRow(makeColumn(d(localize("Length") + ": ") + v(spatialFormat.format(tool.bodyLength) + getUnitSymbolAsString())));
      if (tool.numberOfFlutes > 0) {
        c1 += makeRow(makeColumn(d(localize("Flutes") + ": ") + v(tool.numberOfFlutes)));
      }
    }
  } else {
    if (tool.getInsertType() < insertDescriptions.length) {
      c1 += makeRow(makeColumn(d(localize("Insert") + ": ") + v(insertDescriptions[tool.getInsertType()])));
    }
    if (tool.getHolderType() < holderDescriptions.length) {
      var hand = "";
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
      if (!getProperty("showTools")) {
        c1 += makeRow(makeColumn(d(localize("Holder") + ": ") + v(holderDescriptions[tool.getHolderType()] + " " + hand)));
      }
      if (false && tool.clamping) {
        c1 += makeRow(makeColumn(d(localize("Clamping") + ": ") + v(tool.clamping)));
      }
    }

    switch (tool.type) {
    case TOOL_TURNING_GENERAL:
    case TOOL_TURNING_BORING:
      if ((tool.inscribedCircleDiameter !== undefined) && (tool.edgeLength !== undefined)) {
        var edgeLength = tool.edgeLength;
        if ((unit == MM) && (edgeLength > 0)) {
          c1 += makeRow(makeColumn(d(localize("Edge length") + ": ") + v(spatialFormat.format(edgeLength) + getUnitSymbolAsString())));
        } else {
          c1 += makeRow(makeColumn(d(localize("Inscribed circle") + ": ") + v(spatialFormat.format(tool.inscribedCircleDiameter) + getUnitSymbolAsString())));
        }
      }
      if (tool.noseRadius !== undefined) {
        var NOSE_RADII = [
          {idi:"X0", idm:"X0", vi:0.0015, vm:0.04},
          {idi:"00", idm:"01", vi:0.004, vm:0.1},
          {idi:"0.5", idm:"02", vi:0.008, vm:0.2},
          {idi:"01", idm:"04", vi:1.0 / 64, vm:0.4},
          {idi:"02", idm:"08", vi:2.0 / 64, vm:0.8},
          {idi:"03", idm:"12", vi:3.0 / 64, vm:1.2},
          {idi:"04", idm:"16", vi:4.0 / 64, vm:1.6},
          {idi:"05", idm:"20", vi:5.0 / 64, vm:2.0},
          {idi:"06", idm:"24", vi:6.0 / 64, vm:2.4},
          {idi:"07", idm:"28", vi:7.0 / 64, vm:2.8},
          {idi:"08", idm:"32", vi:8.0 / 64, vm:3.2},
          {idi:"00", idm:"M0", vi:0, vm:0} // round
        ];
        var id = "";
        var value = tool.noseRadius;
        /*
        for (var i in NOSE_RADII) {
          var e = NOSE_RADII[i];
          var _value = (unit == MM) ? e.mi : e.vi; // we dont have a tool unit for now
          if (Math.abs(_value - value) < 1e-3) {
            id = (unit == MM) ? e.idm : e.idi;
            value = _value;
            break;
          }
        }
*/
        var text = spatialFormat.format(value) + getUnitSymbolAsString();
        if (id) {
          text = id + " " + text;
        }
        c1 += makeRow(makeColumn(d(localize("Nose radius") + ": ") + v(text)));
      }
      if (tool.crossSection !== undefined) {
        c1 += makeRow(makeColumn(d(localize("Cross section") + ": ") + v(tool.crossSection)));
      }
      if (tool.tolerance !== undefined) {
        c1 += makeRow(makeColumn(d(localize("Tolerance") + ": ") + v(tool.tolerance)));
      }
      if (tool.reliefAngle !== undefined) {
        var id = localize("Custom");
        var value = tool.reliefAngle;
        for (var ir in TURNING_RELIEF_ANGLES) {
          var re2 = TURNING_RELIEF_ANGLES[ir];
          if (Math.abs(re2.value - value) < 1e-3) {
            id = re2.id;
            value = re2.value;
            break;
          }
        }
        c1 += makeRow(makeColumn(d(localize("Relief") + ": ") + v(id + " " + degFormat.format(value) + "deg")));
      }
      break;
    case TOOL_TURNING_THREADING:
      if ((tool.pitch !== undefined) && (tool.pitch > 0)) {
        c1 += makeRow(makeColumn(d(localize("Pitch") + ": ") + v(spatialFormat.format(tool.pitch) + getUnitSymbolAsString())));
      }
      // internal/external info
      break;
    case TOOL_TURNING_GROOVING:
      // show shape also
      if (tool.grooveWidth !== undefined) {
        c1 += makeRow(makeColumn(d(localize("Width") + ": ") + v(spatialFormat.format(tool.grooveWidth) + getUnitSymbolAsString())));
      }
      if ((tool.noseRadius !== undefined) && (tool.noseRadius > 0)) {
        c1 += makeRow(makeColumn(d(localize("Nose radius") + ": ") + v(spatialFormat.format(tool.noseRadius) + getUnitSymbolAsString())));
      }
      break;
    case TOOL_TURNING_CUSTOM:
      break;
    }

    var compensationDescription;
    switch (tool.getCompensationMode()) {
    case TOOL_COMPENSATION_INSERT_CENTER:
      compensationDescription = localize("Insert center");
      break;
    case TOOL_COMPENSATION_TIP:
      compensationDescription = localize("Tip");
      break;
    case TOOL_COMPENSATION_TIP_CENTER:
      compensationDescription = localize("Tip center");
      break;
    case TOOL_COMPENSATION_TIP_TANGENT:
      compensationDescription = localize("Tip tangent");
      break;
    }

    if (compensationDescription) {
      c1 += makeRow(makeColumn(d(localize("Compensation") + ": ") + v(compensationDescription)));
    }
  }

  if (tool.material) {
    c1 += makeRow(makeColumn(d(localize("Material") + ": ") + v(getMaterialName(tool.material))));
  }
  if (tool.description) {
    c1 += makeRow(makeColumn(d(localize("Description") + ": ") + v(tool.description)));
  }
  if (tool.comment) {
    c1 += makeRow(makeColumn(d(localize("Comment") + ": ") + v(tool.comment)));
  }
  if (tool.vendor) {
    c1 += makeRow(makeColumn(d(localize("Vendor") + ": ") + v(tool.vendor)));
  }
  var productLink = getSectionParameterForTool(tool, "operation:tool_productLink");
  if (tool.productId || productLink) {
    c1 += makeRow(makeColumn(d(localize("Product") + ": ") + v(autoLink(productLink, tool.productId))));
  }
  if (!getProperty("showTools") && tool.holderDescription) {
    c1 += makeRow(makeColumn(d(localize("Holder") + ": ") + v(tool.holderDescription)));
  }

  // c1 += "<tr class=\"thin\"><td width=\"6cm\">&nbsp;</td></tr>"; // fixed width
  // c1 += "</table>";
  return c1;
}

function writeTools() {
  writeln("<table class=\"sheet\" cellspacing=\"0\" align=\"center\">");
  var colgroup = "<colgroup span=\"3\"><col width=\"1*\"/><col width=\"1*\"/><col width=\"120\"/></colgroup>";
  write(colgroup);
  write(makeRow("<th colspan=\"4\">" + localize("Tools") + "</th>"));

  var tools = getToolTable();
  if (tools.getNumberOfTools() > 0) {
    var numberOfTools = useToolNumber ? tools.getNumberOfTools() : getNumberOfSections();
    for (var i = 0; i < numberOfTools; ++i) {
      var tool = useToolNumber ? tools.getTool(i) : getSection(i).getTool();

      var c1 = presentTool(tool);
      c1 += "</table>";

      var c2 = "<table class=\"info\">";
      c2 += makeRow(makeColumn("&nbsp;")); // move 1 row down
      if (zRanges[tool.number]) {
        c2 += makeRow(makeColumn(d(localize("Minimum Z") + ": ") + v(spatialFormat.format(zRanges[tool.number].getMinimum()) + getUnitSymbolAsString())));
      }

      var maximumFeed = 0;
      var maximumSpindleSpeed = 0;
      var cuttingDistance = 0;
      var rapidDistance = 0;
      var cycleTime = 0;
      for (var j = 0; j < getNumberOfSections(); ++j) {
        var section = getSection(j);
        if (!isProbeOperation(section)) {
          if (section.getTool().number == tool.number) {
            maximumFeed = Math.max(maximumFeed, section.getMaximumFeedrate());
            if ((section.type == TYPE_MILLING) || (section.type == TYPE_TURNING)) {
              if (maximumSpindleSpeed !== undefined) {
                maximumSpindleSpeed = (section.type == TYPE_MILLING) ?
                  Math.max(maximumSpindleSpeed, section.getMaximumSpindleSpeed()) :
                  Math.max(maximumSpindleSpeed, section.getTool().getMaximumSpindleSpeed());
              } else {
                maximumSpindleSpeed = (section.type == TYPE_MILLING) ?
                  section.getMaximumSpindleSpeed() :
                  section.getTool().getMaximumSpindleSpeed();
              }
            }
            cuttingDistance += section.getCuttingDistance();
            rapidDistance += section.getRapidDistance();
            cycleTime += section.getCycleTime();
          }
        }
      }
      if (getProperty("rapidFeed") > 0) {
        cycleTime += rapidDistance / getProperty("rapidFeed") * 60;
      }

      c2 += makeRow(makeColumn(d(localize("Maximum Feed") + ": ") + v(feedFormat.format(maximumFeed) + getFeedSymbolAsString())));
      if (maximumSpindleSpeed !== undefined) {
        c2 += makeRow(makeColumn(d(localize("Maximum Spindle Speed") + ": ") + v(rpmFormat.format(maximumSpindleSpeed) + localize("rpm"))));
      }
      c2 += makeRow(makeColumn(d(localize("Cutting Distance") + ": ") + v(spatialFormat.format(cuttingDistance) + getUnitSymbolAsString())));
      if (getProperty("showRapidDistance")) {
        c2 += makeRow(makeColumn(d(localize("Rapid Distance") + ": ") + v(spatialFormat.format(rapidDistance) + getUnitSymbolAsString())));
      }
      var additional = "";
      if ((getNumberOfSections() > 1) && getProperty("showPercentages")) {
        if (totalCycleTime > 0) {
          additional = "<div class=\"percentage\">(" + percentageFormat.format(cycleTime / totalCycleTime) + "%)</div>";
        }
      }
      c2 += makeRow(makeColumn(d(localize("Estimated Cycle Time") + ": ") + v(formatCycleTime(cycleTime) + " " + additional)));
      // c2 += "<tr class=\"thin\"><td width=\"6cm\">&nbsp;</td></tr>"; // fixed width
      c2 += "</table>";

      var c3 = "<table class=\"info\">";
      c3 += makeRow(makeColumn("&nbsp;")); // move 1 row down
      if (tool.isTurningTool()) {
        if (tool.getHolderType() < holderDescriptions.length) {
          var hand = "";
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
          c3 += makeRow(makeColumn(d(localize("Holder") + ": ") + v(holderDescriptions[tool.getHolderType()] + " " + hand)));
          if (false && tool.clamping) {
            c3 += makeRow(makeColumn(d(localize("Clamping") + ": ") + v(tool.clamping)));
          }
        }
      } else {
        if (tool.holderDescription) {
          c3 += makeRow(makeColumn(d(localize("Holder") + ": ") + v(tool.holderDescription)));
        }
        if (tool.holderComment) {
          c3 += makeRow(makeColumn(d(localize("Comment") + ": ") + v(tool.holderComment)));
        }
        if (tool.holderVendor) {
          c3 += makeRow(makeColumn(d(localize("Vendor") + ": ") + v(tool.holderVendor)));
        }
        var holderLink = getSectionParameterForTool(tool, "operation:holder_productLink");
        if (tool.holderProductId || holderLink) {
          c3 += makeRow(makeColumn(d(localize("Product") + ": ") + v(autoLink(holderLink, tool.holderProductId))));
        }
      }
      c3 += "</table>";

      var c4 = "";
      if (getProperty("showToolImage")) {
        if (toolRenderer) {
          var id = useToolNumber ? tool.number : (i + 1);
          var path = "tool" + id + ".png";
          var width = 2.5 * 100;
          var height = 2.5 * 133;
          var mimetype = "image/png";
          if (getProperty("embedImages") && (revision >= 41366)) {
            if (!exportedTools[id]) {
              if (toolRenderer.getAsBinary) {
                var data = toolRenderer.getAsBinary(mimetype, tool, width, height);
                exportedTools[id] = data; // do not export twice
              }
            }
          } else {
            try {
              if (!exportedTools[id]) {
                toolRenderer.exportAs(path, mimetype, tool, width, height);
                exportedTools[id] = true; // do not export twice
              }
            } catch (e) {
              // ignore
            }
          }

          if (getProperty("embedImages") && (revision >= 41366)) {
            src = "data:" + mimetype + ";base64," + Base64.btoa(exportedTools[id]);
          } else {
            src = encodeURIComponent(path);
          }
          c4 = "<table class=\"info\" cellspacing=\"0\">" +
            makeRow("<td class=\"image\"><img width=\"100px\" src=\"" + src + "\"/></td>") +
            "</table>";
        } else {
          if (getProperty("embedImages")) {
            c4 = getToolAsSVG(tool);
          }
        }
      }
      writeln("");

      write(
        makeRow(
          "<td valign=\"top\">" + c1 + "</td>" +
          "<td valign=\"top\">" + c2 + "</td>" +
          "<td valign=\"top\">" + c3 + "</td>" +
          "<td class=\"toolimage\" valign=\"center\" align=\"center\">" + c4 + "</td>",
          "info"
        )
      );
      if ((i + 1) < tools.getNumberOfTools()) {
        write("<tr class=\"space\"><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>");
      }
      writeln("");
      writeln("");
    }
  }

  writeln("</table>");
  writeln("");
}

function getCrossSections() {
  var CROSS_SECTIONS = [
    {id:"A", d:localize("Type A"), image:""},
    {id:"B", d:localize("Type B"), image:""},
    {id:"C", d:localize("Type C"), image:""},
    {id:"F", d:localize("Type F"), image:""},
    {id:"G", d:localize("Type G"), image:""},
    {id:"H", d:localize("Type H"), image:""},
    {id:"J", d:localize("Type J"), image:""},
    {id:"M", d:localize("Type M"), image:""},
    {id:"N", d:localize("Type N"), image:""},
    {id:"Q", d:localize("Type Q"), image:""},
    {id:"R", d:localize("Type R"), image:""},
    {id:"T", d:localize("Type T"), image:""},
    {id:"U", d:localize("Type U"), image:""},
    {id:"W", d:localize("Type W"), image:""}
  ];
  return CROSS_SECTIONS;
}

function getTurningTolerance() {
  var TOLERANCES = [
    {id:"A", d:localize("Type A"), image:""},
    {id:"B", d:localize("Type B"), image:""},
    {id:"C", d:localize("Type C"), image:""},
    {id:"F", d:localize("Type F"), image:""},
    {id:"G", d:localize("Type G"), image:""},
    {id:"H", d:localize("Type H"), image:""},
    {id:"J", d:localize("Type J"), image:""},
    {id:"M", d:localize("Type M"), image:""},
    {id:"N", d:localize("Type N"), image:""},
    {id:"Q", d:localize("Type Q"), image:""},
    {id:"R", d:localize("Type R"), image:""},
    {id:"T", d:localize("Type T"), image:""},
    {id:"U", d:localize("Type U"), image:""},
    {id:"W", d:localize("Type W"), image:""}
  ];
  return TOLERANCES;
}

function onSectionEnd() {
  var toolpathSVG = getToolpathAsSVG();
  svg = undefined;

  if (isFirstSection()) {
    var c = "";

    if (programComment) {
      c += makeRow(makeColumn(d(localize("Program Comment") + ": ") + v(programComment)));
    }

    if (hasParameter("job-description")) {
      var description = getParameter("job-description");
      if (description) {
        c += makeRow(makeColumn(d(localize("Job Description") + ": ") + v(description)));
      }
    }

    if (hasParameter("iso9000/document-control")) {
      var id = getParameter("iso9000/document-control");
      if (id) {
        c += makeRow(makeColumn(d(localize("Job ISO-9000 Control") + ": ") + v(id)));
      }
    }

    if (getProperty("showDocumentPath")) {
      if (hasParameter("document-path")) {
        var path = getParameter("document-path");
        if (path) {
          c += makeRow(makeColumn(d(localize("Document Path") + ": ") + v(pageWidthFitPath(path))));
        }
      }

      if (hasParameter("document-version")) {
        var version = getParameter("document-version");
        if (version) {
          c += makeRow(makeColumn(d(localize("Document Version") + ": ") + v(version)));
        }
      }
    }

    if (getProperty("showNotes") && hasParameter("job-notes")) {
      var notes = getParameter("job-notes");
      if (notes) {
        c +=
          "<tr class=\"notes\"><td valign=\"top\">" +
          d(localize("Notes")) + ": <pre>" + getParameter("job-notes") +
          "</pre></td></tr>";
      }
    }

    if (c) {
      write("<table class=\"jobhead\" align=\"center\">" + c + "</table>");
      write("<br>");
      writeln("");
      writeln("");
    }

    var workpiece = getWorkpiece();
    var delta = Vector.diff(workpiece.upper, workpiece.lower);
    if (delta.isNonZero() || modelImagePath && getProperty("showModelImage")) {

      write("<table class=\"job\" cellspacing=\"0\" align=\"center\">");
      write(makeRow("<th colspan=\"2\">" + localize("Setup") + "</th>"));
      write("<tr>");

      var numberOfColumns = 0;
      { // stock - workpiece
        if (delta.isNonZero()) {
          var c = "<table class=\"info\" cellspacing=\"0\">";

          var workOffset = undefined;
          var multipleWCS = false;
          var numberOfSections = getNumberOfSections();
          var workOffsets = [];
          for (var i = 0; i < numberOfSections; ++i) {
            var section = getSection(i);
            if (!workOffsets[section.workOffset]) {
              workOffsets[section.workOffset] = true;
            }
            if (!workOffset) {
              workOffset = section.workOffset;
            }
            if (workOffset != section.workOffset) {
              multipleWCS = true;
            }
          }
          var text = "";
          for (var id in workOffsets) {
            text += " " + formatWCS(id);
          }
          c += makeRow(makeColumn(d(localize("WCS")) + ":" + text));

          if (multipleWCS) {
            c += makeRow(makeColumn(d(localize("Program uses multiple WCS!"))));
          }

          c += makeRow(makeColumn(
            d(localize("Stock")) + ": <br>&nbsp;&nbsp;" + v(localize("DX") + ": " + spatialFormat.format(delta.x) + getUnitSymbolAsString()) + "<br>&nbsp;&nbsp;" + v(localize("DY") + ": " + spatialFormat.format(delta.y) + getUnitSymbolAsString()) + "<br>&nbsp;&nbsp;" + v(localize("DZ") + ": " + spatialFormat.format(delta.z) + getUnitSymbolAsString())
          ));

          if (hasParameter("part-lower-x") && hasParameter("part-lower-y") && hasParameter("part-lower-z") &&
              hasParameter("part-upper-x") && hasParameter("part-upper-y") && hasParameter("part-upper-z")) {
            var lower = new Vector(getParameter("part-lower-x"), getParameter("part-lower-y"), getParameter("part-lower-z"));
            var upper = new Vector(getParameter("part-upper-x"), getParameter("part-upper-y"), getParameter("part-upper-z"));
            var delta = Vector.diff(upper, lower);
            c += makeRow(makeColumn(
              d(localize("Part")) + ": <br>&nbsp;&nbsp;" + v(localize("DX") + ": " + spatialFormat.format(delta.x) + getUnitSymbolAsString() + "<br>&nbsp;&nbsp;" + v(localize("DY") + ": " + spatialFormat.format(delta.y) + getUnitSymbolAsString()) + "<br>&nbsp;&nbsp;" + v(localize("DZ") + ": " + spatialFormat.format(delta.z) + getUnitSymbolAsString()))
            ));
          }

          c += makeRow(makeColumn(
            d(localize("Stock Lower in WCS") + " " + formatWCS(workOffset)) + ": <br>&nbsp;&nbsp;" + v("X: " + spatialFormat.format(workpiece.lower.x) + getUnitSymbolAsString()) + "<br>&nbsp;&nbsp;" + v("Y: " + spatialFormat.format(workpiece.lower.y) + getUnitSymbolAsString()) + "<br>&nbsp;&nbsp;" + v("Z: " + spatialFormat.format(workpiece.lower.z) + getUnitSymbolAsString())
          ));
          c += makeRow(makeColumn(
            d(localize("Stock Upper in WCS") + " " + formatWCS(workOffset)) + ": <br>&nbsp;&nbsp;" + v("X: " + spatialFormat.format(workpiece.upper.x) + getUnitSymbolAsString()) + "<br>&nbsp;&nbsp;" + v("Y: " + spatialFormat.format(workpiece.upper.y) + getUnitSymbolAsString()) + "<br>&nbsp;&nbsp;" + v("Z: " + spatialFormat.format(workpiece.upper.z) + getUnitSymbolAsString())
          ));

          c += "</table>";
          write(makeColumn(c));
          ++numberOfColumns;
        }
      }

      if (modelImagePath && getProperty("showModelImage")) {
        var path = FileSystem.getCombinedPath(FileSystem.getFolderPath(getOutputPath()), modelImagePath);
        var src = "";
        if (!FileSystem.isFile(path)) {
          warning(subst(localize("Model image doesn't exist '%1'."), path));
        } else {
          if (getProperty("embedImages") && (revision >= 41366)) {
            // add support for image from database instead
            src = getImageAsImgSrc(path);
            FileSystem.remove(path);
          } else {
            src = encodeURIComponent(modelImagePath);
          }
        }

        ++numberOfColumns;
        var alignment = (numberOfColumns <= 1) ? "center" : "right";
        write("<td class=\"model\" align=\"" + alignment + "\"><img src=\"" + src + "\"/></td>");
      }

      write("</tr>");
      write("</table>");
      write("<br>");
      writeln("");
      writeln("");
    }

    if (getProperty("showTotals")) {
      writeTotals();
      write("<br>");
      writeln("");
      writeln("");
    }

    if (getProperty("showTools")) {
      writeTools();
      write("<br>");
      writeln("");
      writeln("");
    }
  }

  if (!getProperty("showOperations")) {
    return; // skip
  }

  if (isFirstSection()) {
    writeln("<table class=\"sheet\" cellspacing=\"0\" align=\"center\">");
    var colgroup = "<colgroup span=\"4\"><col width=\"1*\"/><col width=\"1*\"/><col width=\"120\"/></colgroup>";
    write(colgroup);
    write(makeRow("<th colspan=\"5\">" + localize("Operations") + "</th>"));
  }

  var c1 = "<table class=\"info\" cellspacing=\"0\">";

  c1 += makeRow(
    makeColumn(v(localize("Operation") + " " + (currentSection.getId() + 1) + "/" + getNumberOfSections()))
  );

  if (hasParameter("operation-comment")) {
    c1 += makeRow(
      makeColumn(d(localize("Description") + ": ") + v(getParameter("operation-comment")))
    );
  }

  if (hasParameter("operation-strategy")) {
    var strategies = {
      "drill"     : localize("Drilling"),
      "probe"     : localize("Probe"),
      "face"      : localize("Facing"),
      "path3d"    : localize("3D Path"),
      "pocket2d"  : localize("Pocket 2D"),
      "contour2d" : localize("Contour 2D"),
      "adaptive2d": localize("Adaptive 2D"),
      "slot"      : localize("Slot"),
      "circular"  : localize("Circular"),
      "bore"      : localize("Bore"),
      "thread"    : localize("Thread"),
      "jet2d"     : localize("Profile 2D"),

      "contour_new"     : localize("Contour"),
      "contour"         : localize("Contour"),
      "parallel_new"    : localize("Parallel"),
      "parallel"        : localize("Parallel"),
      "pocket_new"      : localize("Pocket"),
      "pocket"          : localize("Pocket"),
      "adaptive"        : localize("Adaptive"),
      "horizontal_new"  : localize("Horizontal"),
      "horizontal"      : localize("Horizontal"),
      "blend"           : localize("Blend"),
      "flow"            : localize("Flow"),
      "morph"           : localize("Morph"),
      "pencil_new"      : localize("Pencil"),
      "pencil"          : localize("Pencil"),
      "project"         : localize("Project"),
      "ramp"            : localize("Ramp"),
      "radial_new"      : localize("Radial"),
      "radial"          : localize("Radial"),
      "scallop_new"     : localize("Scallop"),
      "scallop"         : localize("Scallop"),
      "morphed_spiral"  : localize("Morphed Spiral"),
      "spiral_new"      : localize("Spiral"),
      "spiral"          : localize("Spiral"),
      "swarf5d"         : localize("Multi-Axis Swarf"),
      "multiAxisContour": localize("Multi-Axis Contour"),
      "multiAxisBlend"  : localize("Multi-Axis Blend"),

      "turningRoughing"              : localize("Turning Profile"),
      "turningProfileGroove"         : localize("Turning Profile Groove"),
      "turningPart"                  : localize("Turning Part"),
      "turningFace"                  : localize("Turning Face"),
      "turningGroove"                : localize("Turning Groove"),
      "turningChamfer"               : localize("Turning Chamfer"),
      "turningThread"                : localize("Turning Thread"),
      "turningStockTransfer"         : localize("Turning Stock Transfer"),
      "turningSecondarySpindleGrab"  : localize("Turning Spindle Grab"),
      "turningSecondarySpindlePull"  : localize("Turning Spindle Pull"),
      "turningSecondarySpindleReturn": localize("Turning Spindle Return")
    };

    if (strategies[getParameter("operation-strategy")]) {
      var description = strategies[getParameter("operation-strategy")];
      c1 += makeRow(
        makeColumn(d(localize("Strategy") + ": ") + v(description))
      );
    }
  }

  var newWCS = !isFirstSection() && (currentSection.workOffset != getPreviousSection().workOffset);
  c1 += makeRow(
    makeColumn(d(localize("WCS") + ": ") + v(formatWCS(currentSection.workOffset) + (newWCS ? (" " + bold(localize("NEW!"))) : "")))
  );
  if (currentSection.isPatterned()) {
    var id = patternIds[currentSection.getPatternId()];
    c1 += makeRow(
      makeColumn(d(localize("Pattern Group") + ": ") + v(id))
    );
  }

  var tolerance = cachedParameters["operation:tolerance"];
  var stockToLeave = cachedParameters["operation:stockToLeave"];
  var axialStockToLeave = cachedParameters["operation:verticalStockToLeave"];
  var maximumStepdown = cachedParameters["operation:maximumStepdown"];
  var maximumStepover = cachedParameters["operation:maximumStepover"] ? cachedParameters["operation:maximumStepover"] : cachedParameters["operation:stepover"];
  var optimalLoad = cachedParameters["operation:optimalLoad"];
  var loadDeviation = cachedParameters["operation:loadDeviation"];

  if (tolerance != undefined) {
    c1 += makeRow(makeColumn(d(localize("Tolerance") + ": ") + v(spatialFormat.format(tolerance) + getUnitSymbolAsString())));
  }
  if (stockToLeave != undefined) {
    if ((axialStockToLeave != undefined) && (stockToLeave != axialStockToLeave)) {
      c1 += makeRow(
        makeColumn(
          d(localize("Stock to Leave") + ": ") + v(spatialFormat.format(stockToLeave) + getUnitSymbolAsString()) + "/" + v(spatialFormat.format(axialStockToLeave) + getUnitSymbolAsString())
        )
      );
    } else {
      c1 += makeRow(makeColumn(d(localize("Stock to Leave") + ": ") + v(spatialFormat.format(stockToLeave) + getUnitSymbolAsString())));
    }
  }

  if ((maximumStepdown != undefined) && (maximumStepdown > 0)) {
    c1 += makeRow(makeColumn(d(localize("Maximum stepdown") + ": ") + v(spatialFormat.format(maximumStepdown) + getUnitSymbolAsString())));
  }

  if ((optimalLoad != undefined) && (optimalLoad > 0)) {
    c1 += makeRow(makeColumn(d(localize("Optimal load") + ": ") + v(spatialFormat.format(optimalLoad) + getUnitSymbolAsString())));
    if ((loadDeviation != undefined) && (loadDeviation > 0)) {
      c1 += makeRow(makeColumn(d(localize("Load deviation") + ": ") + v(spatialFormat.format(loadDeviation) + getUnitSymbolAsString())));
    }
  } else if ((maximumStepover != undefined) && (maximumStepover > 0)) {
    c1 += makeRow(makeColumn(d(localize("Maximum stepover") + ": ") + v(spatialFormat.format(maximumStepover) + getUnitSymbolAsString())));
  }

  var compensationType = hasParameter("operation:compensationType") ? getParameter("operation:compensationType") : "computer";
  if (compensationType != "computer") {
    var compensationDeltaRadius = hasParameter("operation:compensationDeltaRadius") ? getParameter("operation:compensationDeltaRadius") : 0;

    var compensation = hasParameter("operation:compensation") ? getParameter("operation:compensation") : "center";
    var COMPENSATIONS = {left:localize("left"), right:localize("right"), center:localize("center")};
    var compensationText = localize("unspecified");
    if (COMPENSATIONS[compensation]) {
      compensationText = COMPENSATIONS[compensation];
    }

    var DESCRIPTIONS = {computer:localize("computer"), control:localize("control"), wear:localize("wear"), inverseWear:localize("inverse wear")};
    var description = localize("unspecified");
    if (DESCRIPTIONS[compensationType]) {
      description = DESCRIPTIONS[compensationType];
    }
    c1 += makeRow(makeColumn(d(localize("Compensation") + ": ") + v(description + " (" + compensationText + ")")));
    c1 += makeRow(makeColumn(d(localize("Safe Tool Diameter") + ": ") + v("< " + spatialFormat.format(tool.diameter + 2 * compensationDeltaRadius) + getUnitSymbolAsString())));
  }
  c1 += "</table>";

  var c2 = "<table class=\"info\" cellspacing=\"0\">";
  c2 += makeRow(makeColumn(v("&nbsp;"))); // move 1 row down

  if (is3D()) {
    var zRange = currentSection.getGlobalZRange();
    c2 += makeRow(makeColumn(d(localize("Maximum Z") + ": ") + v(spatialFormat.format(zRange.getMaximum()) + getUnitSymbolAsString())));
    c2 += makeRow(makeColumn(d(localize("Minimum Z") + ": ") + v(spatialFormat.format(zRange.getMinimum()) + getUnitSymbolAsString())));
  }

  if (!isProbeOperation(currentSection)) {
    var maximumFeed = currentSection.getMaximumFeedrate();
    var maximumSpindleSpeed = currentSection.getMaximumSpindleSpeed();
    var cuttingDistance = currentSection.getCuttingDistance();
    var rapidDistance = currentSection.getRapidDistance();
    var cycleTime = currentSection.getCycleTime();

    if (currentSection.getType() == TYPE_TURNING) {
      if (currentSection.getTool().getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
        c2 += makeRow(makeColumn(d(localize("Surface Speed") + ": ") + v(rpmFormat.format(currentSection.getTool().surfaceSpeed * ((unit == MM) ? 1 / 1000.0 : 1 / 12.0)) + ((unit == MM) ? localize("m/min") : localize("ft/min")))));
      } else {
        c2 += makeRow(makeColumn(d(localize("Maximum Spindle Speed") + ": ") + v(rpmFormat.format(maximumSpindleSpeed) + localize("rpm"))));
      }
      if (currentSection.feedMode == FEED_PER_REVOLUTION) {
        if (hasParameter("operation:tool_feedCuttingRel")) {
          var feed = getParameter("operation:tool_feedCuttingRel");
          c2 += makeRow(makeColumn(d(localize("Feedrate per Rev") + ": ") + v(feedFormat.format(feed) + getFPRSymbolAsString())));
        }
      } else {
        c2 += makeRow(makeColumn(d(localize("Maximum Feedrate") + ": ") + v(feedFormat.format(maximumFeed) + getFeedSymbolAsString())));
      }
    } else if (currentSection.getType() == TYPE_MILLING) {
      c2 += makeRow(makeColumn(d(localize("Maximum Spindle Speed") + ": ") + v(rpmFormat.format(maximumSpindleSpeed) + localize("rpm"))));
      c2 += makeRow(makeColumn(d(localize("Maximum Feedrate") + ": ") + v(feedFormat.format(maximumFeed) + getFeedSymbolAsString())));
    } else if (currentSection.getType() == TYPE_JET) {
      c2 += makeRow(makeColumn(d(localize("Maximum Feedrate") + ": ") + v(feedFormat.format(maximumFeed) + getFeedSymbolAsString())));
    }
    c2 += makeRow(makeColumn(d(localize("Cutting Distance") + ": ") + v(spatialFormat.format(cuttingDistance) + getUnitSymbolAsString())));
    if (getProperty("showRapidDistance")) {
      c2 += makeRow(makeColumn(d(localize("Rapid Distance") + ": ") + v(spatialFormat.format(rapidDistance) + getUnitSymbolAsString())));
    }
    if (getProperty("rapidFeed") > 0) {
      cycleTime += rapidDistance / getProperty("rapidFeed") * 60;
    }
    var additional = "";
    if ((getNumberOfSections() > 1) && getProperty("showPercentages")) {
      if (totalCycleTime > 0) {
        additional = "<div class=\"percentage\">(" + percentageFormat.format(cycleTime / totalCycleTime) + "%)</div>";
      }
    }
    c2 += makeRow(makeColumn(d(localize("Estimated Cycle Time") + ": ") + v(formatCycleTime(cycleTime) + " " + additional)));
    if ((currentSection.getType() != TYPE_JET) || (tool.coolant != COOLANT_OFF)) {
      c2 += makeRow(makeColumn(d(localize("Coolant") + ": ") + v(getCoolantDescription(tool.coolant))));
    }
  }

  c2 += "</table>";

  var c3 = presentTool(currentSection.getTool());
  if (currentSection.getType() == TYPE_JET) {
    switch (currentSection.jetMode) {
    case JET_MODE_THROUGH:
      c3 += makeRow(makeColumn(d(localize("Cutting Type") + ": ") + v(localize("Through cutting"))));
      break;
    case JET_MODE_ETCHING:
      c3 += makeRow(makeColumn(d(localize("Cutting Type") + ": ") + v(localize("Etching"))));
      break;
    case JET_MODE_VAPORIZE:
      c3 += makeRow(makeColumn(d(localize("Cutting Type") + ": ") + v(localize("Vaporize"))));
      break;
    }
    c3 += makeRow(makeColumn(d(localize("Quality") + ": ") + v(currentSection.quality)));
  }
  c3 += "</table>";

  var c4 = "";
  if (getProperty("showToolImage")) {
    if (toolRenderer) {
      var id = useToolNumber ? tool.number : (currentSection.getId() + 1);
      var path = "tool" + id + ".png";
      var width = 2.5 * 100;
      var height = 2.5 * 133;
      var mimetype = "image/png";
      if (getProperty("embedImages") && (revision >= 41366)) {
        if (!exportedTools[id]) {
          if (toolRenderer.getAsBinary) {
            var data = toolRenderer.getAsBinary(mimetype, tool, width, height);
            exportedTools[id] = data; // do not export twice
          }
        }
      } else {
        try {
          if (!exportedTools[id]) {
            toolRenderer.exportAs(path, mimetype, tool, width, height);
            exportedTools[id] = true; // do not export twice
          }
        } catch (e) {
          // ignore
        }
      }

      if (getProperty("embedImages") && (revision >= 41366)) {
        src = "data:" + mimetype + ";base64," + Base64.btoa(exportedTools[id]);
      } else {
        src = encodeURIComponent(path);
      }
      c4 = "<table class=\"info\" cellspacing=\"0\">" +
        makeRow("<td class=\"image\"><img width=\"100px\" src=\"" + src + "\"/></td>") +
        "</table>";

    } else {
      if (getProperty("embedImages")) {
        c4 = getToolAsSVG(tool);
      }
    }
  }

  var c5 = "";
  if (cachedParameters["operation:associatedView"] != undefined) {
    path = FileSystem.getCombinedPath(FileSystem.getFolderPath(getOutputPath()), cachedParameters["operation:associatedView"]);
    src = getImageAsImgSrc(path);
    c5 = "<img src=\"" + src + "\"/>";
  }

  write(
    "<tr class=\"info\">" +
      "<td valign=\"top\">" + c1 + "</td>" +
      "<td valign=\"top\">" + c2 + "</td>" +
      "<td valign=\"top\">" + c3 + "</td>" +
      (c4 ? "<td class=\"toolimage\" align=\"center\">" + c4 + "</td>" : "") +
      (c5 ? "<td align=\"center\">" + c5 + "</td>" : "") +
    "</tr>"
  );

  if (toolpathSVG) {
    write(
      "<tr class=\"info\">" +
      "<td colspan=\"4\" valign=\"top\" align=\"center\">" + toolpathSVG + "</td>" +
      "</tr>"
    );
  }

  if (getProperty("showPreviewImage")) {
    var patternId = currentSection.getPatternId();
    var show = false;
    if (getProperty("forcePreview") || !seenPatternIds[patternId]) {
      show = true;
      seenPatternIds[patternId] = true;
    }
    if (show && currentSection.hasParameter("autodeskcam:preview-name")) {
      var path = currentSection.getParameter("autodeskcam:preview-name");
      var absPath = FileSystem.getCombinedPath(FileSystem.getFolderPath(getOutputPath()), path);
      if (FileSystem.isFile(absPath)) {

        if (getProperty("embedImages") && (revision >= 41366)) {
          src = getImageAsImgSrc(absPath);
          FileSystem.remove(absPath);
        } else {
          src = encodeURIComponent(path);
        }

        var r2 = "<table class=\"info\" cellspacing=\"0\">" +
          makeRow("<td class=\"preview\"><img src=\"" + src + "\"/></td>") +
          "</table>";
        write(
          "<tr class=\"info\">" +
          "<td colspan=\"4\" valign=\"top\" align=\"center\">" + r2 + "</td>" +
          "</tr>"
        );
      }
    }
  }

  if (getProperty("showNotes") && hasParameter("notes")) {
    var notes = getParameter("notes");
    if (notes) {
      write(
        "<tr class=\"notes\"><td valign=\"top\" colspan=\"4\">" +
        d(localize("Notes")) + ": <pre>" + getParameter("notes") +
        "</pre></td></tr>"
      );
    }
  }

  if (!isLastSection()) {
    write("<tr class=\"space\"><td colspan=\"5\">&nbsp;</td></tr>");
  }
  writeln("");
  writeln("");

  cachedParameters = {};
}

function formatCycleTime(cycleTime) {
  cycleTime += 0.5; // round up
  var seconds = cycleTime % 60 | 0;
  var minutes = ((cycleTime - seconds) / 60 | 0) % 60;
  var hours = (cycleTime - minutes * 60 - seconds) / (60 * 60) | 0;
  if (hours > 0) {
    return subst(localize("%1h:%2m:%3s"), hours, minutes, seconds);
  } else if (minutes > 0) {
    return subst(localize("%1m:%2s"), minutes, seconds);
  } else {
    return subst(localize("%1s"), seconds);
  }
}

function writeTotals() {
  var zRange;
  var maximumFeed = 0;
  var maximumSpindleSpeed;
  var cuttingDistance = 0;
  var rapidDistance = 0;
  var cycleTime = 0;

  var numberOfSections = getNumberOfSections();
  var currentTool;
  for (var i = 0; i < numberOfSections; ++i) {
    var section = getSection(i);

    if (is3D()) {
      var _zRange = section.getGlobalZRange();
      if (zRange) {
        zRange.expandToRange(_zRange);
      } else {
        zRange = _zRange;
      }
    }

    if (!isProbeOperation(section)) {
      maximumFeed = Math.max(maximumFeed, section.getMaximumFeedrate());
      if ((section.type == TYPE_MILLING) || (section.type == TYPE_TURNING)) {
        if (maximumSpindleSpeed !== undefined) {
          maximumSpindleSpeed = (section.type == TYPE_MILLING) ?
            Math.max(maximumSpindleSpeed, section.getMaximumSpindleSpeed()) :
            Math.max(maximumSpindleSpeed, section.getTool().getMaximumSpindleSpeed());
        } else {
          maximumSpindleSpeed = (section.type == TYPE_MILLING) ?
            section.getMaximumSpindleSpeed() :
            section.getTool().getMaximumSpindleSpeed();
        }
      }
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
    cycleTime += rapidDistance / getProperty("rapidFeed") * 60;
  }
  totalCycleTime = cycleTime;

  writeln("<table class=\"sheet\" cellspacing=\"0\" align=\"center\">");
  write(makeRow("<th>" + localize("Total") + "</th>"));

  var c1 = "<table class=\"info\" cellspacing=\"0\">";
  var tools = getToolTable();
  c1 += makeRow(makeColumn(d(localize("Number Of Operations") + ": ") + v(getNumberOfSections())));
  var text = "";
  var gotTool = false;
  for (var i = 0; i < tools.getNumberOfTools(); ++i) {
    var tool = tools.getTool(i);
    if (i > 0) {
      text += " ";
    }
    gotTool |= tool.number != 0;
    text += bold(localize("T") + toolFormat.format(tool.number));
  }
  if ((section.type == TYPE_MILLING) || (section.type == TYPE_TURNING) || gotTool) {
    c1 += makeRow(makeColumn(d(localize("Number Of Tools") + ": ") + v(tools.getNumberOfTools())));
    c1 += makeRow(makeColumn(d(localize("Tools") + ": ") + vWrap(text)));
  }
  if (zRange) {
    c1 += makeRow(makeColumn(d(localize("Maximum Z") + ": ") + v(spatialFormat.format(zRange.getMaximum()) + getUnitSymbolAsString())));
    c1 += makeRow(makeColumn(d(localize("Minimum Z") + ": ") + v(spatialFormat.format(zRange.getMinimum()) + getUnitSymbolAsString())));
  }
  c1 += makeRow(makeColumn(d(localize("Maximum Feedrate") + ": ") + v(feedFormat.format(maximumFeed) + getFeedSymbolAsString())));
  if (maximumSpindleSpeed !== undefined) {
    c1 += makeRow(makeColumn(d(localize("Maximum Spindle Speed") + ": ") + v(rpmFormat.format(maximumSpindleSpeed) + localize("rpm"))));
  }
  c1 += makeRow(makeColumn(d(localize("Cutting Distance") + ": ") + v(spatialFormat.format(cuttingDistance) + getUnitSymbolAsString())));
  if (getProperty("showRapidDistance")) {
    c1 += makeRow(makeColumn(d(localize("Rapid Distance") + ": ") + v(spatialFormat.format(rapidDistance) + getUnitSymbolAsString())));
  }
  c1 += makeRow(makeColumn(d(localize("Estimated Cycle Time") + ": ") + v(formatCycleTime(cycleTime))));
  c1 += "</table>";

  write(
    "<tr class=\"info\">" +
    "<td valign=\"top\">" + c1 + "</td>" +
    "</tr>"
  );
  write("</table>");
  writeln("");
  writeln("");
}

function onClose() {
  if (getProperty("showOperations")) {
    writeln("</table>");
  }

  // footer
  if (getProperty("showFooter")) {
    write("<br>");
    write("<div class=\"footer\">");
    var src = findFile("../graphics/logo.png");
    if (getProperty("embedImages") && (revision >= 41366)) {
      var data = getImageAsImgSrc(src);
      if (data) {
        write("<img class=\"logo\" src=\"" + data + "\"/>");
      }
    } else {
      var dest = "logo.png";
      if (FileSystem.isFile(src)) {
        FileSystem.copyFile(src, FileSystem.getCombinedPath(FileSystem.getFolderPath(getOutputPath()), dest));
        write("<img class=\"logo\" src=\"" + dest + "\"/>");
      }
    }
    var now = new Date();
    var product = "Autodesk CAM";
    if (hasGlobalParameter("generated-by")) {
      product = getGlobalParameter("generated-by");
    }
    var productUrl = "http://cam.autodesk.com";
    if (product) {
      if ((product.indexOf("HSMWorks") == 0) || (product.indexOf("HSMXpress") == 0)) {
        productUrl = "http://www.hsmworks.com";
      }
    }
    write(localize("Generated by") + " <a href=\"" + productUrl + "\">" + product + "</a>" + " " + now.toLocaleDateString() + " " + now.toLocaleTimeString());
    write("</div");
  }
  write("</body>");
  write("</html>");
}

function quote(text) {
  var result = "";
  for (var i = 0; i < text.length; ++i) {
    var ch = text.charAt(i);
    switch (ch) {
    case "\\":
    case "\"":
      result += "\\";
    }
    result += ch;
  }
  return "\"" + result + "\"";
}

function onTerminate() {
  // add this to print automatically - you could print to XPS and PDF writer
/*
  var device = "Microsoft XPS Document Writer";
  if (device) {
    executeNoWait("rundll32.exe", "mshtml.dll,PrintHTML " + quote(getOutputPath()) + quote(device), false, "");
  } else {
    executeNoWait("rundll32.exe", "mshtml.dll,PrintHTML " + quote(getOutputPath()), false, "");
  }
*/
}

function setProperty(property, value) {
  properties[property].current = value;
}
