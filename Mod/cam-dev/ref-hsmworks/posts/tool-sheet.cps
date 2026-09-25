/**
  Copyright (C) 2012-2021 by Autodesk, Inc.
  All rights reserved.

  Tool sheet configuration.

  $Revision: 43569 147f5cf60e9217cf9c3365dc511a0f631d89bb16 $
  $Date: 2021-10-13 13:53:32 $

  FORKID {43EC4ED1-A199-41f8-85C1-6FF2C01946F6}
*/

description = "Tool Sheet (HTML)";
vendor = "Autodesk";
vendorUrl = "http://www.autodesk.com";
legal = "Copyright (C) 2012-2021 by Autodesk, Inc.";
certificationLevel = 2;

longDescription = "Setup sheet intended for presenting all tools used in HTML.";

capabilities = CAPABILITY_SETUP_SHEET;
extension = "html";
mimetype = "text/html";
setCodePage("utf-8");
dependencies = "tool-sheet.css";

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
  showToolImage: {
    title      : "Show tool images",
    description: "If enabled, tool images will be included in the seutp sheet.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showPercentages: {
    title      : "Output percentages",
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
    title      : "Output rapid distance",
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
  showNumberOfFlutes: {
    title      : "Output number of flutes",
    description: "Specifies whether the number of flutes should be output.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showToolFluteLength: {
    title      : "Output flute length",
    description: "Specifies whether the flute length should be output.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showToolComment: {
    title      : "Output tool comment",
    description: "Specifies whether to output a tool comment.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showToolDescription: {
    title      : "Output tool description",
    description: "Specifies whether to output the tool description.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showToolVendor: {
    title      : "Output tool vendor",
    description: "Specifies whether to output the tool vendor.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showToolProductId: {
    title      : "Output tool product ID",
    description: "Specifies whether to output the product ID.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  toolAsName: {
    title      : "Output tool as name",
    description: "Specifies whether to output the tool as a name instead of a number.",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  showMinimumZ: {
    title      : "Output minimum Z",
    description: "Specifies whether to output the minimum Z.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showMaximumSpindleSpeed: {
    title      : "Output maximum spindle speed",
    description: "Specifies whether to output the maximum spindle speed.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showCuttingDistance: {
    title      : "Output cutting distance",
    description: "Specifies whether to output the cutting distance.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showEstimatedCycleTime: {
    title      : "Output estimated cycle time",
    description: "Specifies whether to output the estimated cycle time.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showHolderDescription: {
    title      : "Output holder description",
    description: "Specifies whether to output the holder description.",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  showHolderComment: {
    title      : "Output holder comment",
    description: "Specifies whether to output the holder comment.",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  showHolderVendor: {
    title      : "Output holder vendor",
    description: "Specifies whether to output the holder vendor.",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  showHolderProductId: {
    title      : "Output holder product ID",
    description: "Specifies whether the number of flutes should be output.",
    type       : "boolean",
    value      : false,
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

var useToolNumber = true;

var xyzFormat = createFormat({decimals:(unit == MM ? 3 : 4)});
var feedFormat = createFormat({decimals:(unit == MM ? 3 : 5)});
var toolFormat = createFormat({decimals:0});
var rpmFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:3});
var angleFormat = createFormat({decimals:0, scale:DEG});
var pitchFormat = createFormat({decimals:3});

// presentation formats
var spatialFormat = createFormat({decimals:3});
var percentageFormat = createFormat({decimals:1, forceDecimal:true, scale:100});
var timeFormat = createFormat({decimals:2});
var taperFormat = angleFormat; // share format

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

function u(content, classId) {
  if (classId) {
    return "<u class=\"" + classId + "\">" + content + "</u>";
  } else {
    return "<u>" + content + "</u>";
  }
}

function d(content) {
  return "<div class=\"description\">" + content + "</div>";
}

function v(content) {
  return "<div class=\"value\">" + content + "</div>";
}

function p(content, classId) {
  if (classId) {
    return "<p class=\"value\">" + content + "</p>";
  } else {
    return "<p>" + content + "</p>";
  }
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

function onSection() {
  if (getProperty("toolAsName") && !tool.description) {
    if (hasParameter("operation-comment")) {
      error(localize("Tool description is empty in operation " + "\"" + (getParameter("operation-comment").toUpperCase()) + "\""));
    } else {
      error(localize("Tool description is empty."));
    }
    return;
  }
  skipRemainingSection();
}

function isProbeOperation(section) {
  return section.hasParameter("operation-strategy") && (section.getParameter("operation-strategy") == "probe");
}

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

function onClose() {
  var toolRenderer = undefined;
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

  var totalCycleTime = 0;
  for (var i = 0; i < getNumberOfSections(); ++i) {
    var section = getSection(i);
    if (!isProbeOperation(section)) {
      totalCycleTime += section.getCycleTime();
    }
    // excluding tool change time
  }

  write(
    "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\"\n" +
    "                      \"http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd\">\n"
  );
  write("<html>");

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

  // header
  c = "<head>";
  c += "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">";
  if (programName) {
    c += "<title>" + localize("Tool Sheet for Program") + " " + programName + "</title>";
  } else {
    c += "<title>" + localize("Tool Sheet") + "</title>";
  }
  if (getProperty("embedStylesheet")) {
    c += "<style type=\"text/css\">" + loadText("tool-sheet.css", "utf-8") + "</style>";
  } else {
    c += "<link rel=\"StyleSheet\" href=\"tool-sheet.css\" type=\"text/css\" media=\"print, screen\">";
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

  c += script;
  c += "</head>";
  write(c);

  write("<body onload=\"onLoad()\">");
  if (programName) {
    write("<h1>" + localize("Tool Sheet for Program") + " " + programName + "</h1>");
  } else {
    write("<h1>" + localize("Tool Sheet") + "</h1>");
  }

  {
    c = "";

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

    if (hasParameter("document-path") && getProperty("showDocumentPath")) {
      var path = getParameter("document-path");
      if (path) {
        c += makeRow(makeColumn(d(localize("Document Path") + ": ") + v(path)));
      }
    }

    if (c) {
      write("<table class=\"jobhead\" align=\"center\">" + c + "</table>");
      write("<br>");
      writeln("");
      writeln("");
    }
  }

  write("<table class=\"sheet\" cellspacing=\"0\" align=\"center\"");
  var colgroup = "<colgroup span=\"3\"><col width=\"1*\"/><col width=\"1*\"/><col width=\"1*\"/><col width=\"120\"/></colgroup>";
  write(colgroup);
  write(makeRow("<th colspan=\"4\">" + localize("Tools") + "</th>"));

  var tools = getToolTable();
  if (tools.getNumberOfTools() > 0) {
    for (var i = 0; i < tools.getNumberOfTools(); ++i) {
      var tool = tools.getTool(i);

      var c1 = "<table class=\"tool\">";
      c1 += makeRow(makeColumn(bold(localize("Tool"))));
      c1 += makeRow(
        makeColumn(
          bold(localize("T") + (getProperty("toolAsName") ? "="  + "\"" + (tool.description.toUpperCase()) + "\"" : toolFormat.format(tool.number))) + " " +
          localize("D") + toolFormat.format(tool.diameterOffset) + " " +
          localize("L") + toolFormat.format(tool.lengthOffset)
        )
      );
      c1 += makeRow(makeColumn(d(localize("Type") + ": ") + v(getToolTypeName(tool.type))));
      c1 += makeRow(makeColumn(d(localize("Diameter") + ": ") + v(spatialFormat.format(tool.diameter) + getUnitSymbolAsString())));
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
      c1 += makeRow(makeColumn(d(localize("Length") + ": ") + v(spatialFormat.format(tool.bodyLength) + getUnitSymbolAsString())));
      if (getProperty("showToolFluteLength")) {
        c1 += makeRow(makeColumn(d(localize("Flute length") + ": ") + v(spatialFormat.format(tool.fluteLength) + getUnitSymbolAsString())));
      }
      if (getProperty("showNumberOfFlutes") && (tool.numberOfFlutes > 0)) {
        c1 += makeRow(makeColumn(d(localize("Flutes") + ": ") + v(tool.numberOfFlutes)));
      }
      if (tool.material && getProperty("showToolMaterial")) {
        c1 += makeRow(makeColumn(d(localize("Material") + ": ") + v(getMaterialName(tool.material))));
      }
      if (tool.comment && getProperty("showToolComment")) {
        c1 += makeRow(makeColumn(d(localize("Comment") + ": ") + v(tool.comment)));
      }
      if (tool.description && getProperty("showToolDescription")) {
        c1 += makeRow(makeColumn(d(localize("Description") + ": ") + v(tool.description)));
      }
      if (tool.vendor && getProperty("showToolVendor")) {
        c1 += makeRow(makeColumn(d(localize("Vendor") + ": ") + v(tool.vendor)));
      }
      var productLink = getSectionParameterForTool(tool, "operation:tool_productLink");
      if ((tool.productId || productLink) && getProperty("showToolProductId")) {
        c1 += makeRow(makeColumn(d(localize("Product ID") + ": ") + v(autoLink(productLink, tool.productId))));
      }
      //c1 += "<tr class=\"thin\"><td width=\"6cm\">&nbsp;</td></tr>"; // fixed width
      c1 += "</table>";

      var c2 = "<table class=\"tool\">";
      if (getProperty("showMinimumZ") ||
          getProperty("showMaximumFeed") ||
          getProperty("showMaximumSpindleSpeed") ||
          getProperty("showCuttingDistance") ||
          getProperty("showRapidDistance") ||
          getProperty("showEstimatedCycleTime")) {
        c2 += makeRow(makeColumn(bold(localize("Cutting"))));
        c2 += makeRow(makeColumn("&nbsp;")); // move 1 row down
      }
      if (zRanges[tool.number] && getProperty("showMinimumZ")) {
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
            maximumSpindleSpeed = Math.max(maximumSpindleSpeed, section.getMaximumSpindleSpeed());
            cuttingDistance += section.getCuttingDistance();
            rapidDistance += section.getRapidDistance();
            cycleTime += section.getCycleTime();
          }
        }
      }
      if (getProperty("rapidFeed") > 0) {
        cycleTime += rapidDistance / getProperty("rapidFeed") * 60;
      }
      if (getProperty("showMaximumFeed")) {
        c2 += makeRow(makeColumn(d(localize("Maximum Feed") + ": ") + v(feedFormat.format(maximumFeed) + getFeedSymbolAsString())));
      }
      if (getProperty("showMaximumSpindleSpeed")) {
        c2 += makeRow(makeColumn(d(localize("Maximum Spindle Speed") + ": ") + v(rpmFormat.format(maximumSpindleSpeed) + localize("rpm"))));
      }
      if (getProperty("showCuttingDistance")) {
        c2 += makeRow(makeColumn(d(localize("Cutting Distance") + ": ") + v(spatialFormat.format(cuttingDistance) + getUnitSymbolAsString())));
      }
      if (getProperty("showRapidDistance")) {
        c2 += makeRow(makeColumn(d(localize("Rapid Distance") + ": ") + v(spatialFormat.format(rapidDistance) + getUnitSymbolAsString())));
      }
      var additional = "";
      if ((getNumberOfSections() > 1) && getProperty("showPercentages")) {
        if (totalCycleTime > 0) {
          additional = "<div class=\"percentage\">(" + percentageFormat.format(cycleTime / totalCycleTime) + "%)</div>";
        }
      }
      if (getProperty("showEstimatedCycleTime")) {
        c2 += makeRow(makeColumn(d(localize("Estimated Cycle Time") + ": ") + v(formatCycleTime(cycleTime) + " " + additional)));
      }
      //c2 += "<tr class=\"thin\"><td width=\"6cm\">&nbsp;</td></tr>"; // fixed width
      c2 += "</table>";

      var c3 = "<table class=\"tool\">";
      if (getProperty("showHolderDescription") || getProperty("showHolderComment") || getProperty("showHolderVendor") || getProperty("showHolderProductId")) {
        c3 += makeRow(makeColumn(bold(localize("Holder"))));
        c3 += makeRow(makeColumn("&nbsp;")); // move 1 row down
      }
      if (tool.holderDescription && getProperty("showHolderDescription")) {
        c3 += makeRow(makeColumn(d(localize("Description") + ": ") + v(tool.holderDescription)));
      }
      if (tool.holderComment && getProperty("showHolderComment")) {
        c3 += makeRow(makeColumn(d(localize("Comment") + ": ") + v(tool.holderComment)));
      }
      if (tool.holderVendor && getProperty("showHolderVendor")) {
        c3 += makeRow(makeColumn(d(localize("Vendor") + ": ") + v(tool.holderVendor)));
      }
      var holderLink = getSectionParameterForTool(tool, "operation:holder_productLink");
      if ((tool.holderProductId || holderLink) && getProperty("showHolderProductId")) {
        c3 += makeRow(makeColumn(d(localize("Product ID") + ": ") + v(autoLink(holderLink, tool.holderProductId))));
      }
      c3 += "</table>";

      var image = "";
      if (getProperty("showToolImage")) {
        if (toolRenderer) {
          toolRenderer.setBackgroundColor(new Color(1, 1, 1));
          var path = "tool" + tool.number + ".png";
          var width = 100;
          var height = 133;
          toolRenderer.exportAs(path, "image/png", tool, width, height);
          image = "<img src=\"" + encodeURIComponent(path) + "\"/>";
        } else {
          if (getProperty("embedImages")) {
            image = getToolAsSVG(tool);
          }
        }
      }
      writeln("");

      write(
        makeRow(
          "<td valign=\"top\">" + c1 + "</td>" +
          "<td valign=\"top\">" + c2 + "</td>" +
          "<td valign=\"top\">" + c3 + "</td>" +
          "<td class=\"image\" align=\"right\">" + image + "</td>",
          true ? "even" : "odd"
        )
      );
      writeln("");
      writeln("");
    }
  }

  writeln("</table>");
  writeln("");

  write("<br>");
  // write(p(localize("Total number of tools") + ": " + tools.getNumberOfTools()));

  // footer
  if (getProperty("showFooter")) {
    write("<br>");
    write("<div class=\"footer\">");
    var src = findFile("../graphics/logo.png");
    var dest = "logo.png";
    if (FileSystem.isFile(src)) {
      FileSystem.copyFile(src, FileSystem.getCombinedPath(FileSystem.getFolderPath(getOutputPath()), dest));
      write("<img class=\"logo\" src=\"" + dest + "\"/>");
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

function onComment(text) {
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
