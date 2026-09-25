/**
  Copyright (C) 2012-2025 by Autodesk, Inc.
  All rights reserved.

  SCM post processor configuration.

  $Revision: 45368 0d19ee6a7707c0a900d60dabd67224d4924c61f6 $
  $Date: 2025-02-12 05:40:37 $

  FORKID {F4EC72B8-D7E7-45c4-A703-7089F83842E9}
*/

description = "SCM-Prisma 110";
vendor = "SCM";
vendorUrl = "http://www.scmgroup.com";
legal = "Copyright (C) 2012-2025 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45702;

longDescription = "Generic post for SCM-Prisma 110.";

extension = "xxl";
setCodePage("ascii");

capabilities = CAPABILITY_MILLING;
tolerance = spatial(0.002, MM);
minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(180);
allowHelicalMoves = false;
allowedCircularPlanes = undefined; // allow any circular motion

// user-defined properties
properties = {
  machineOrigin: {
    title      : "Machine origin",
    description: "Depending on the type of machine, the point from which the distances are measured (machine origin) may be at the front or rear. For example: the Record and Ergon machines use the Front origin, while the Pratix and Tech machines use the Rear origin.",
    group      : "configuration",
    type       : "enum",
    values     : [
      {title:"Front", id:"front"},
      {title:"Rear", id:"rear"}
    ],
    value: "front",
    scope: "post"
  },
  writeTools: {
    title      : "Write tool list",
    description: "Output a tool list in the header of the code.",
    group      : "formats",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  useRadius: {
    title      : "Radius arcs",
    description: "If yes is selected, arcs are output using radius values rather than IJK.",
    group      : "preferences",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  reverseZaxis: {
    title      : "Invert Z-axis",
    description: "Machines equipped with OSAI invert the Z-axis (Positive Z=towards the work table, negative Z=away from the work table.)",
    group      : "configuration",
    type       : "boolean",
    value      : false,
    scope      : "post"
  }
};

var xyFormat = createFormat({decimals:3});
var zFormat = createFormat({decimals:3});
var abcFormat = createFormat({decimals:3, forceDecimal:true, scale:DEG});
var feedFormat = createFormat({decimals:(unit == MM ? 1 : 2)});
var toolFormat = createFormat({decimals:0});
var taperFormat = createFormat({decimals:1, scale:DEG});
var rpmFormat = createFormat({decimals:0});

var xOutput = createVariable({prefix:"X="}, xyFormat);
var yOutput = createVariable({prefix:"Y="}, xyFormat);
var zOutput = createVariable({prefix:"Z="}, zFormat);

var feedOutput = createVariable({prefix:"V="}, feedFormat);

// circular output
var iOutput = createVariable({prefix:"I=", force:true}, xyFormat);
var jOutput = createVariable({prefix:"J=", force:true}, xyFormat);

/**
  Writes the specified block.
*/
function writeBlock() {
  writeWords(arguments);
}

/**
  Output a comment.
*/
function writeComment(text) {
  if (text) {
    writeln("; " + text);
  }
}

function onOpen() {
  if (getProperty("reverseZaxis") == true) {
    zFormat.setScale(-1);
    zOutput = createVariable({prefix:"Z="}, zFormat);
  }
  if (getProperty("useRadius")) {
    maximumCircularSweep = toRad(90); // avoid potential center calculation errors for CNC
  }
  var workpiece = getWorkpiece();
  writeBlock("H", "DX=" + xyFormat.format(workpiece.upper.x), "DY=" + xyFormat.format(workpiece.upper.y), "DZ=" + xyFormat.format(workpiece.upper.z - workpiece.lower.z), "-A", "*MM", "/DEF");
  writeComment(programName);
  if (programComment != programName) {
    writeComment(programComment);
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
        var comment = "T" + toolFormat.format(tool.number) + "  " +
          "D=" + xyFormat.format(tool.diameter) + " " +
          localize("CR") + "=" + xyFormat.format(tool.cornerRadius);
        if ((tool.taperAngle > 0) && (tool.taperAngle < Math.PI)) {
          comment += " " + localize("TAPER") + "=" + taperFormat.format(tool.taperAngle) + localize("deg");
        }
        if (zRanges[tool.number]) {
          comment += " - " + localize("ZMIN") + "=" + zFormat.format(zRanges[tool.number].getMinimum());
        }
        comment += " - " + getToolTypeName(tool.type);
        writeComment(comment);
      }
    }
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

/** Force output of X, Y, Z, and F on next output. */
function forceAny() {
  forceXYZ();
  feedOutput.reset();
}

function onSection() {
  var abc = currentSection.workPlane.getTurnAndTilt(0, 2);
  writeBlock(
    "XPL",
    "X=" + xyFormat.format(currentSection.workOrigin.x),
    "Y=" + xyFormat.format(currentSection.workOrigin.y),
    "Z=" + zFormat.format(currentSection.workOrigin.z),
    "Q=" + abcFormat.format(abc.z),
    "R=" + abcFormat.format(abc.x)
  );

  forceAny();

  var initialPosition = getFramePosition(currentSection.getInitialPosition());

  writeBlock(
    "XG0",
    xOutput.format(initialPosition.x),
    yOutput.format(initialPosition.y),
    zOutput.format(initialPosition.z),
    "T=" + toolFormat.format(tool.number),
    "S=" + rpmFormat.format(spindleSpeed)
  );
  feedOutput.reset();
}

function onSpindleSpeed(spindleSpeed) {
  writeBlock("S=" + rpmFormat.format(spindleSpeed));
}

function onRadiusCompensation() {
  if (radiusCompensation != RADIUS_COMPENSATION_OFF) {
    error(localize("Radius compensation mode not supported."));
  }
}

function onRapid(_x, _y, _z) {
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  if (x || y || z) {
    writeBlock(
      "XG0", x, y, z,
      "T=" + toolFormat.format(tool.number),
      "S=" + rpmFormat.format(spindleSpeed)
    );
    feedOutput.reset();
  }
}

function onLinear(_x, _y, _z, feed) {
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  if (x || y || z) {
    writeBlock("XL2P", x, y, z, feedOutput.format(feed));
  }
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  if (isHelical() || (getCircularPlane() != PLANE_XY)) {
    var t = tolerance;
    if ((t == 0) && hasParameter("operation:tolerance")) {
      t = getParameter("operation:tolerance");
    }
    linearize(t);
    return;
  }

  xOutput.reset();
  yOutput.reset();
  if (!getProperty("useRadius")) {
    zOutput.reset();
    writeBlock("XA2P", "G=" + (clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx), jOutput.format(cy), feedOutput.format(feed));
  } else {
    var r = getCircularRadius();
    if (toDeg(getCircularSweep()) > (180 + 1e-9)) {
      r = -r; // allow up to <360 deg arcs
    }
    writeBlock("XAR2", xOutput.format(x), yOutput.format(y), "r=" + xyFormat.format(r), "G=" + (clockwise ? 2 : 3), feedOutput.format(feed));
  }
}

function onSectionEnd() {
  writeBlock("XPL", "X=" + xyFormat.format(0), "Y=" + xyFormat.format(0), "Z=" + zFormat.format(0), "Q=" + abcFormat.format(0), "R=" + abcFormat.format(0)); // reset plane
  writeComment("******************************");

  forceAny();
}

function onClose() {
  // home position
  writeBlock("N", "X=" + xyFormat.format(0), "Y=" + xyFormat.format(0), "Z=" + zFormat.format(0), "; " + localize("home"));
}

function setProperty(property, value) {
  properties[property].current = value;
}
