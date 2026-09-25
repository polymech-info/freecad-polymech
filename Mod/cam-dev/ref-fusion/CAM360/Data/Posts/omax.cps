/**
  Copyright (C) 2012-2021 by Autodesk, Inc.
  All rights reserved.

  OMAX waterjet post processor configuration.

  $Revision: 44489 463fd7c2dd9948f82fbd288395b22f549b778dc5 $
  $Date: 2023-05-17 14:08:01 $

  FORKID {A806DFCD-07A4-4506-9AF6-04397CF5BF05}
*/

/*
  ATTENTION:

  1. The initial head position must always match the WCS XY origin
  specified in the CAM Setup.

  2. The initial Z head position must always be zeroed just above the top of the stock.
*/

description = "OMAX Waterjet";
vendor = "OMAX";
vendorUrl = "https://www.omax.com";
legal = "Copyright (C) 2012-2021 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45702;
extension = "omx";
setCodePage("ascii");

longDescription = "Post for OMAX Waterjet. 1) The initial head position must always match the WCS XY origin specified in the CAM Setup. 2) The initial Z head position must always be zeroed just above the top of the stock.";

// unit = IN; // only inch mode is supported
capabilities = CAPABILITY_MILLING | CAPABILITY_JET; // milling will be removed
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(180);
allowHelicalMoves = false;
allowedCircularPlanes = 1 << PLANE_XY; // allow only XY circular motion

properties = {
  etchQuality: {
    title      : "Etch quality",
    description: "Defines the etch quality.",
    type       : "number",
    value      : 6,
    scope      : "post"
  }
};

// use fixed width instead
var xyzFormat = createFormat({decimals:4, trim:false});
var bowFormat = createFormat({decimals:4, trim:false});
var tFormat = createFormat({decimals:4, trim:false});
var integerFormat = createFormat({decimals:0});

// fixed settings
var preamble = true;

var qualFeed = 0; // turn off waterjet
var tas = 0; // unused tilt start
var tae = 0; // unused tilt end
var thickness = 0;

// used for delaying moves
var xTemp = 0;
var yTemp = 0;
var zTemp = 0;
var bowTemp = 0;
var gotMove = false;

// center compensation
var _compensationOffset = 0;

var etchOperation = false; // though-cut unless set to true

var EOB = "R,R,R,R,R,R,[END]";

/**
  Writes the specified block.
*/
function writeBlock() {
  writeWords2("[0], ", arguments, EOB);
}

function convertJSDateToExcelDate(date) {
  var returnDateTime = 25569.0 + ((date.getTime() - (date.getTimezoneOffset() * 60 * 1000)) / (1000 * 60 * 60 * 24));
  return returnDateTime.toString().substr(0, 5);
}

var FIELD = "                    ";

/** Make sure fields are aligned. */
function f(text) {
  var length = text.length;
  if (length > 10) {
    return text;
  }
  return FIELD.substr(0, 10 - length) + text;
}

/** Make sure fields are aligned. */
function fi(text, size) {
  var length = text.length;
  if (length > size) {
    return text;
  }
  return FIELD.substr(0, size - length) + text;
}

function onOpen() {

  if ((getProperty("etchQuality") != 6) && (getProperty("etchQuality") != 7)) {
    error(localize("Etch quality must be either 6 or 7."));
    return;
  }

  setWordSeparator("");

  switch (unit) {
  case IN:
    // Do nothing, Omax files can only be in IN
    break;
  case MM:
    xyzFormat = createFormat({decimals:4, trim:false, scale:1 / 25.4}); // convert to inches
    // error(localize("Program must be in inches."));
    // return;
    break;
  }

  { // stock - workpiece
    var workpiece = getWorkpiece();
    var delta = Vector.diff(workpiece.upper, workpiece.lower);
    if (delta.isNonZero()) {
      // thickness = (workpiece.upper.z - workpiece.lower.z);
    }
  }

  if (preamble) {
    writeln("// Slash Slash marks (//) represent remarks that are ignored by the computer");
    writeln("// if the slashes are the first characters in the line");
    writeln("// For additional information about .OMX files, consult the OMAX Interactive Reference.");
    writeln("// The line below identifies this file as a .OMX file.  Do not modify it, or the file will not open.");
    writeln("This is an OMAX (.OMX) file.  Do not modify the first " + "\"" + "2" + "\"" + " lines of this file. For information on this file format contact softwareengineering@omax.com or visit http://www.omax.com.");
    writeln("2");
    writeln("// Above is a flag that indicates the kind of data this file contains 2 means tool path data.");
    writeln("// Below is the version of this file format. Do not modify it, unless you are confident you know what you are doing.");
    writeln("2");
    writeln("// Below is the date that this file was first created, in units of days since 1900.");
    var dateNow = new Date();
    writeln(convertJSDateToExcelDate(dateNow));
    writeln("// The following fields are reserved for future use.  Do not delete or modify them.");
    writeln("[Reserved]");
    writeln("[Reserved]");
    writeln("[Reserved]");
    writeln("[Reserved]");
    writeln("[Reserved]");
    writeln("[Reserved]");
    writeln("// Insert any comments here.  These may be displayed in some dialogs to the user,");
    writeln("// Such as the dialog for the parametric shape library.");
    writeln("[COMMENT]");
    var product = "Autodesk CAM";
    if (hasGlobalParameter("generated-by")) {
      product = getGlobalParameter("generated-by");
    }
    writeln("Generated by " + product);
    if (programComment) {
      writeln(programComment);
    }
    writeln("[END]");
    writeln("[VARIABLES]");
    writeln("// Insert variable declarations here if making a parametric file.");
    writeln("// Format is:");
    writeln("// Variable Name, Min Value, Max Value, Default Value, LengthFlag (True or False)");
    writeln("[END]");
    writeln("// Tool path data is below.");
    writeln("// Items marked with R are reserved for future use");
    writeln("// Some features such as Thickness and Tilt may not yet be supported.");
    writeln("// ");
    writeln("//   " + f("X") + "  " + f("Y") + "  " + f("Z") + "  " + f("StartTilt") + "  " + f("EndTilt") + "  " + f("Bow") + "  " + fi("Quality", 8) + "  " + fi("Side", 6) + "  " + fi("Thickness", 10));
  }

  if (getNumberOfSections() > 0) {
    var firstSection = getSection(0);

    var remaining = firstSection.workPlane;
    if (!isSameDirection(remaining.forward, new Vector(0, 0, 1))) {
      error(localize("Tool orientation is not supported."));
      return;
    }
    setRotation(remaining);

    var originZ = firstSection.getGlobalZRange().getMinimum(); // the cutting depth of the first section

    for (var i = 0; i < getNumberOfSections(); ++i) {
      var section = getSection(i);
      var z = section.getGlobalZRange().getMinimum();
      if ((z + 1e-9) < originZ) {
        error(localize("You are trying to machine at multiple depths which is not allowed."));
        return;
      }
    }
  }

  // always output X0 Y0 Z0 as the first move for OMAX - first position is always incremental from current head position
  writeBlock(
    f(xyzFormat.format(0)), ", ", f(xyzFormat.format(0)), ", ", f(xyzFormat.format(0)), ", ",
    f(tFormat.format(tas)), ", ", f(tFormat.format(tae)), ", ", // need to switch format if this is going to be used
    f(bowFormat.format(bowTemp)), ", ",
    fi(integerFormat.format(qualFeed), 8), ", ",
    fi(integerFormat.format(currentCompensationOffset), 6), ", ",
    fi(integerFormat.format(thickness), 10), ", "
  );

  if (getNumberOfSections() > 0) {
    var firstSection = getSection(0);
    var initialPosition = getFramePosition(firstSection.getInitialPosition());

    // move up to initial Z position
    validate(xyzFormat.getResultingValue(initialPosition.z) >= 0, "Toolpath is unexpectedly below Z0."); // just for safety
    writeBlock(
      f(xyzFormat.format(0)), ", ", f(xyzFormat.format(0)), ", ", f(xyzFormat.format(initialPosition.z)), ", ",
      f(tFormat.format(tas)), ", ", f(tFormat.format(tae)), ", ", // need to switch format if this is going to be used
      f(bowFormat.format(bowTemp)), ", ",
      fi(integerFormat.format(qualFeed), 8), ", ",
      fi(integerFormat.format(currentCompensationOffset), 6), ", ",
      fi(integerFormat.format(thickness), 10), ", "
    );
  }
}

function onSection() {
  var remaining = currentSection.workPlane;
  if (!isSameDirection(remaining.forward, new Vector(0, 0, 1))) {
    error(localize("Tool orientation is not supported."));
    return;
  }
  setRotation(remaining);

  etchOperation = false;
  if (currentSection.getType() == TYPE_JET) {

    switch (tool.type) {
    case TOOL_WATER_JET:
      break;
    default:
      error(localize("The CNC does not support the required tool."));
      return;
    }

    switch (currentSection.jetMode) {
    case JET_MODE_THROUGH:
      break;
    case JET_MODE_ETCHING:
      etchOperation = true;
      break;
    case JET_MODE_VAPORIZE:
      error(localize("Vaporize is not supported by the CNC."));
      return;
    default:
      error(localize("Unsupported cutting mode."));
      return;
    }

    // currentSection.quality

  } else if (currentSection.getType() == TYPE_MILLING) {
    warning(localize("Milling toolpath will be used as waterjet through-cutting toolpath."));
  } else {
    error(localize("CNC doesn't support the toolpath."));
    return;
  }
}

function onParameter(name, value) {
}

var currentQual = 0;
var currentCompensationOffset = 0; // center compensation

function flushMove() {
  if (gotMove) {
    if ((currentQual == 0) || (qualFeed == 0)) {
      // the alternative would be to skip the moves where the compensation is changed - but this would cause the lead in/out to be different
      currentCompensationOffset = _compensationOffset; // compensation offset may only be changed during quality 0
    }
    currentQual = qualFeed;
    /*
    if (currentCompensationOffset != compensationOffset) {
      writeComment("Compensation mismatch");
    }
    */

    validate(xyzFormat.getResultingValue(zTemp) >= 0, "Toolpath is unexpectedly below Z0."); // just for safety
    writeBlock(
      f(xyzFormat.format(xTemp)), ", ", f(xyzFormat.format(yTemp)), ", ", f(xyzFormat.format(zTemp)), ", ",
      f(tFormat.format(tas)), ", ", f(tFormat.format(tae)), ", ", // need to switch format if this is going to be used
      f(bowFormat.format(bowTemp)), ", ",
      fi(integerFormat.format(qualFeed), 8), ", ",
      fi(integerFormat.format(currentCompensationOffset), 6), ", ",
      fi(integerFormat.format(thickness), 10), ", "
    );
    gotMove = false;
    bowTemp = 0;
  }
}

function onRapid(x, y, z) {
  flushMove();

  xTemp = x;
  yTemp = y;
  zTemp = z;
  bowTemp = 0;
  gotMove = true;
}

function onLinear(x, y, z, feed) {
  flushMove();

  xTemp = x;
  yTemp = y;
  zTemp = z;
  bowTemp = 0;
  gotMove = true;
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  // spirals are not allowed - arcs must be < 360deg
  // fail if radius compensation is changed for circular move
  validate(gotMove, "Move expected before circular move.");
  validate(bowTemp == 0);
  bowTemp = (clockwise ? -1 : 1) * Math.tan(getCircularSweep() / 4); // ATTENTION: setting bow for the pending move!

  flushMove();

  xTemp = x;
  yTemp = y;
  zTemp = z;
  bowTemp = 0;
  gotMove = true;
}

function onMovement(movement) {
  switch (movement) {
  case MOVEMENT_CUTTING:
  case MOVEMENT_FINISH_CUTTING:
    if (etchOperation) {
      qualFeed = getProperty("etchQuality");
    } else {
      switch (currentSection.quality) {
      case 1:
        qualFeed = 5;
        break;
      case 2:
        qualFeed = 4;
        break;
      case 3:
        qualFeed = 2;
        break;
      default:
        qualFeed = 3;
      }
      break;
    }
    break;
  case MOVEMENT_LEAD_IN:
  case MOVEMENT_LEAD_OUT:
    if (etchOperation) {
      qualFeed = getProperty("etchQuality");
    } else {
      qualFeed = 9; // make a user defined setting
    }
    break;
  case MOVEMENT_RAPID:
    qualFeed = 0; // turn off waterjet
    break;
  default:
    if (etchOperation) {
      qualFeed = getProperty("etchQuality");
    } else {
      qualFeed = 0; // turn off waterjet - used for head down moves
    }
  }
}

function onRadiusCompensation() {
  switch (radiusCompensation) {
  case RADIUS_COMPENSATION_LEFT:
    _compensationOffset = 1;
    break;
  case RADIUS_COMPENSATION_RIGHT:
    _compensationOffset = 2;
    break;
  default:
    _compensationOffset = 0; // center compensation
  }
}

function onCycle() {
  error(localize("Canned cycles are not supported."));
}

function onSectionEnd() {
  qualFeed = 0; // turn off waterjet
  _compensationOffset = 0; // center compensation

  if (!gotMove) {
    var p = getCurrentPosition();
    xTemp = p.x;
    yTemp = p.y;
    zTemp = p.z;
    bowTemp = 0;
    gotMove = true;
  }

  validate(gotMove, "Move expected at end of operation to turn off waterjet.");
  flushMove();
}

function onClose() {
}

function setProperty(property, value) {
  properties[property].current = value;
}
