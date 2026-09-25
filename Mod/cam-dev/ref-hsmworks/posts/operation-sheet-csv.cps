/**
  Copyright (C) 2012-2021 by Autodesk, Inc.
  All rights reserved.

  Operation sheet CSV configuration.

  $Revision: 43569 147f5cf60e9217cf9c3365dc511a0f631d89bb16 $
  $Date: 2021-10-13 13:53:32 $

  FORKID {FD67790C-7676-4ee2-B726-87942A6FAB34}
*/

description = "Operation Sheet CSV";
vendor = "Autodesk";
vendorUrl = "http://www.autodesk.com";
legal = "Copyright (C) 2012-2021 by Autodesk, Inc.";
certificationLevel = 2;

longDescription = "Setup sheet for exporting relevant info for each operation to an CSV file which can be imported easily into other applications like a spreadsheet.";

capabilities = CAPABILITY_SETUP_SHEET;
extension = "csv";
mimetype = "plain/csv";
setCodePage("ascii");

allowMachineChangeOnSection = true;

properties = {
  decimal: {
    title      : "Decimal symbol",
    description: "Defines the decimal symbol.",
    type       : "string",
    value      : ".",
    scope      : "post"
  },
  separator: {
    title      : "Separator symbol",
    description: "Defines the field separator.",
    type       : "string",
    value      : ";",
    scope      : "post"
  },
  rapidFeed: {
    title      : "Rapid feed",
    description: "Specifies the rapid traversal feed.",
    type       : "number",
    value      : 5000,
    scope      : "post"
  }
};

var feedFormat = createFormat({decimals:(unit == MM ? 0 : 2)});
var toolFormat = createFormat({decimals:0});
var rpmFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:3});
var angleFormat = createFormat({decimals:0, scale:DEG});
var pitchFormat = createFormat({decimals:3});
var spatialFormat = createFormat({decimals:3});
var taperFormat = angleFormat; // share format

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

function formatCycleTime(cycleTime) {
  cycleTime += 0.5; // round up
  var seconds = cycleTime % 60 | 0;
  var minutes = ((cycleTime - seconds) / 60 | 0) % 60;
  var hours = (cycleTime - minutes * 60 - seconds) / (60 * 60) | 0;
  return subst("%1:%2:%3", hours, minutes, seconds);
}

function isProbeOperation(section) {
  return section.hasParameter("operation-strategy") && (section.getParameter("operation-strategy") == "probe");
}

function getStrategyDescription() {
  if (!hasParameter("operation-strategy")) {
    return "";
  }

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
    "multiAxisBlend"  : localize("Multi-Axis Blend")
  };
  var description = "";
  if (strategies[getParameter("operation-strategy")]) {
    description = strategies[getParameter("operation-strategy")];
  } else {
    description = localize("Unspecified");
  }
  return description;
}

var cachedParameters = {};

function onParameter(name, value) {
  cachedParameters[name] = value;
}

function onOpen() {
  writeln(["OPERATION", "COMMENT", "STRATEGY", "TOLERANCE", "RADIAL STOCK TO LEAVE", "AXIAL STOCK TO LEAVE", "STEPDOWN", "STEPOVER", "TOOL #", "DIAMETER #", "LENGTH #", "TYPE", "COMMENT", "DIAMETER", "CORNER RADIUS", "ANGLE", "BODY LENGTH", "FLUTE #", "MAXIMUM FEED", "MAXIMUM SPINDLE SPEED", "FEED DISTANCE", "RAPID DISTANCE", "CYCLE TIME"].join(getProperty("separator")));
  cachedParameters = {};
}

function onSection() {
  feedFormat.setDecimalSymbol(getProperty("decimal"));
  secFormat.setDecimalSymbol(getProperty("decimal"));
  angleFormat.setDecimalSymbol(getProperty("decimal"));
  pitchFormat.setDecimalSymbol(getProperty("decimal"));
  spatialFormat.setDecimalSymbol(getProperty("decimal"));

  var s = getProperty("separator");

  var tolerance = cachedParameters["operation:tolerance"];
  var stockToLeave = cachedParameters["operation:stockToLeave"];
  var axialStockToLeave = cachedParameters["operation:verticalStockToLeave"];
  var maximumStepdown = cachedParameters["operation:maximumStepdown"];
  var maximumStepover = cachedParameters["operation:maximumStepover"] ? cachedParameters["operation:maximumStepover"] : cachedParameters["operation:stepover"];

  var record = "" + (getCurrentSectionId() + 1);
  if (hasParameter("operation-comment")) {
    var comment = getParameter("operation-comment");
    record += s + quote(comment);
  } else {
    record += s;
  }
  record += s + quote(getStrategyDescription());
  record += s + (tolerance ? spatialFormat.format(tolerance) : "");
  record += s + (stockToLeave ? spatialFormat.format(stockToLeave) : "");
  record += s + (axialStockToLeave ? spatialFormat.format(axialStockToLeave) : "");
  record += s + (maximumStepdown ? spatialFormat.format(maximumStepdown) : "");
  record += s + (maximumStepover ? spatialFormat.format(maximumStepover) : "");

  record += s + "T" + toolFormat.format(tool.number);
  record += s + "D" + toolFormat.format(tool.diameterOffset);
  record += s + "L" + toolFormat.format(tool.lengthOffset);
  record += s + quote(getToolTypeName(tool.type));
  if (tool.comment) {
    record += s + quote(tool.comment);
  } else {
    record += s;
  }
  record += s + spatialFormat.format(tool.diameter);
  if (tool.cornerRadius) {
    record += s + spatialFormat.format(tool.cornerRadius);
  } else {
    record += s;
  }
  if ((tool.taperAngle > 0) && (tool.taperAngle < Math.PI)) {
    record += s + taperFormat.format(tool.taperAngle);
  } else {
    record += s;
  }
  record += s + spatialFormat.format(tool.bodyLength);
  record += s + spatialFormat.format(tool.numberOfFlutes);

  if (!isProbeOperation(currentSection)) {
    var maximumFeed = currentSection.getMaximumFeedrate();
    var maximumSpindleSpeed = currentSection.getMaximumSpindleSpeed();
    var cuttingDistance = currentSection.getCuttingDistance();
    var rapidDistance = currentSection.getRapidDistance();
    var cycleTime = currentSection.getCycleTime();

    if (getProperty("rapidFeed") > 0) {
      cycleTime += rapidDistance / getProperty("rapidFeed") * 60;
    }

    record += s + feedFormat.format(maximumFeed);
    record += s + maximumSpindleSpeed;
    record += s + spatialFormat.format(cuttingDistance);
    record += s + spatialFormat.format(rapidDistance);
    record += s + formatCycleTime(cycleTime);
  }
  writeln(record);

  skipRemainingSection();
}

function onSectionEnd() {
  cachedParameters = {};
}

function setProperty(property, value) {
  properties[property].current = value;
}
