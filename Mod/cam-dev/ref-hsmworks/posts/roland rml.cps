/**
  Copyright (C) 2012-2021 by Autodesk, Inc.
  All rights reserved.

  Roland post processor configuration.

  $Revision: 43569 147f5cf60e9217cf9c3365dc511a0f631d89bb16 $
  $Date: 2021-10-13 13:53:32 $

  FORKID {C1E71A5D-CAD6-45ba-B223-FE41348C147E}
*/

description = "Roland RML";
vendor = "Roland DG";
vendorUrl = "http://www.rolanddg.com";
legal = "Copyright (C) 2012-2021 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45702;

longDescription = "Generic post for Roland RML. By default the post will output code for MDX-15 and MDX-20. Other MDX’s work if you select the correct machine model and options using the 'Machine type' property.";

extension = "prn";
programNameIsInteger = true;
setCodePage("ascii");

capabilities = CAPABILITY_MILLING;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(180);
allowHelicalMoves = true;
allowedCircularPlanes = undefined; // allow any circular motion

// user-defined properties
properties = {
  machineType: {
    title      : "Machine type",
    description: "Sets the machine type.",
    type       : "enum",
    values     : [
      {id:"mdx-15/20", title:"MDX-15/20"},
      {id:"mdx-40", title:"MDX-40"},
      {id:"mdx-50", title:"MDX-50"},
      {id:"mdx-540", title:"MDX-540"}
    ],
    value: "mdx-15/20",
    scope: "post"
  },
  useToolChanger: {
    title      : "Use tool changer",
    description: "Specifies that a tool changer is available.",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  spindleSpeedInRPM: {
    title      : "Spindle speed in RPM",
    description: "If enabled, the spindle speed is outputted with the RPM format rather than the RC spindle speed codes.",
    type       : "boolean",
    value      : false,
    scope      : "post"
  }
};

var mFormat = createFormat({decimals:0});

var xyzFormat; // set in onOpen
var feedFormat = createFormat({decimals:(unit == MM ? 1 : 1), forceDecimal:true, trim:false, scale:1.0 / 60});
var toolFormat = createFormat({decimals:0});
var rpmFormat = createFormat({decimals:0});
var milliFormat = createFormat({decimals:0}); // milliseconds

var xOutput; // set in onOpen
var yOutput; // set in onOpen
var zOutput; // set in onOpen
var feedOutput = createVariable({}, feedFormat);
var sOutput = createVariable({force:true}, rpmFormat);

// collected state
var rapidFeed;
var sMin;
var sMax;

/**
  Writes the specified block.
*/
function writeBlock() {
  writeln(formatWords(arguments) + ";");
}

/**
  Returns the machine type.
*/
function getMachineType() {
  return String(getProperty("machineType")).toLowerCase();
}

function onOpen() {

  setWordSeparator("");

  writeBlock(";;" + (getMachineType() == "mdx-15/20" ? "^IN" : "^DF"));

  switch (getMachineType()) {
  case "mdx-15/20":
    rapidFeed = 15.0 * 60;
    step = 0.025;
    sMin = 6500;
    sMax = 6500;
    break;
  case "mdx-40":
    rapidFeed = 50.0 * 60;
    step = 0.01;
    sMin = 4500;
    sMax = 15000;
    break;
  case "mdx-50":
    rapidFeed = 60.0 * 60;
    step = 0.01;
    sMin = 4500;
    sMax = 15000;
    break;
  case "mdx-540":
    rapidFeed = 125.0 * 60;
    step = 0.01;
    sMin = 3000;
    sMax = 12000;
    break;
  default:
    error(localize("No machine type is selected. You have to define a machine type using the properties."));
    return;
  }

  xyzFormat = createFormat({decimals:(unit == MM ? 0 : 0), scale:1.0 / step});
  xOutput = createVariable({force:true}, xyzFormat);
  yOutput = createVariable({force:true}, xyzFormat);
  zOutput = createVariable({force:true}, xyzFormat);

  writeBlock(getMachineType() == "mdx-15/20" ? "!MC1" : "!MC0;V" + feedOutput.format(rapidFeed));
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

function onParameter(name, value) {
}

function goHome() {
  feedOutput.reset(); // force V

  switch (String(getProperty("machineType")).toLowerCase()) {
  case "mdx-15/20":
    writeBlock("^PR");
    writeBlock("V" + feedOutput.format(rapidFeed));
    writeBlock("Z0,0,162.6"); // retract
    writeBlock("^PA");
    break;
  case "mdx-40":
    writeBlock("^PR");
    writeBlock("V" + feedOutput.format(rapidFeed));
    writeBlock("Z0,0,10500"); // retract
    writeBlock("^PA");
    break;
  case "mdx-50":
    writeBlock("^PR");
    writeBlock("V" + feedOutput.format(rapidFeed));
    writeBlock("Z0,0,13500"); // retract
    writeBlock("^PA");
    break;
  case "mdx-540":
    writeBlock("^PR");
    writeBlock("V" + feedOutput.format(rapidFeed));
    writeBlock("Z0,0,15500"); // retract
    writeBlock("^PA");
    break;
  }
  zOutput.reset();
}

function getSpindleSpeed() {
  var rpm = spindleSpeed;
  var speedCode = 0;
  var sDiff = sMax - sMin;

  var checkrpm = sMin;
  var middle = sMin;
  while (checkrpm < rpm) { // find the closest speedCode
    speedCode += 1;
    var nextSpindleSpeed = ((sDiff / 15) * speedCode) + sMin;
    middle = (nextSpindleSpeed - checkrpm) / 2;
    checkrpm += (nextSpindleSpeed - checkrpm);
  }
  if ((rpm + middle) < checkrpm) { // find the middle of spindle speed range
    speedCode -= 1;
  }
  return speedCode;
}

function getOperationComment() {
  var operationComment = hasParameter("operation-comment") && getParameter("operation-comment");
  return operationComment;
}

function onSection() {
  var insertToolCall = isFirstSection() ||
    currentSection.getForceToolChange && currentSection.getForceToolChange() ||
    (tool.number != getPreviousSection().getTool().number);

  var retracted = false; // specifies that the tool has been retracted to the safe plane
  var newWorkOffset = isFirstSection() ||
    (getPreviousSection().workOffset != currentSection.workOffset); // work offset changes
  var newWorkPlane = isFirstSection() ||
    !isSameDirection(getPreviousSection().getGlobalFinalToolAxis(), currentSection.getGlobalInitialToolAxis());
  if (insertToolCall || newWorkOffset || newWorkPlane) {
    // retract to safe plane
    retracted = true;
    goHome(); //retract
  }

  if (insertToolCall) {
    if (!isFirstSection() && getProperty("optionalStop")) {
      onCommand(COMMAND_OPTIONAL_STOP);
    }

    if (tool.number > 6) {
      warning(localize("Tool number exceeds maximum value."));
    }

    if (getProperty("useToolChanger")) {
      writeBlock("J" + toolFormat.format(tool.number));
    } else {
      if (!isFirstSection()) {
        error(localize("Tool change is not supported without ATC. Please only post operations using the same tool."));
        return;
      }
    }
  }

  if (insertToolCall ||
      isFirstSection() ||
      (rpmFormat.areDifferent(spindleSpeed, sOutput.getCurrent())) ||
      (tool.clockwise != getPreviousSection().getTool().clockwise)) {
    if (spindleSpeed < sMin) {
      error(
        subst(localize("Spindle speed exceeds the minimum value for operation \"%1\"."), getOperationComment()) + " " +
        subst(localize("The spindle speed has to be between %1 and %2 RPM."), rpmFormat.format(sMin), rpmFormat.format(sMax))
      );
      return;
    }
    if (spindleSpeed > sMax) {
      error(
        subst(localize("Spindle speed exceeds the maximum value for operation \"%1\"."), getOperationComment()) + " " +
        subst(localize("The spindle speed has to be between %1 and %2 RPM."), rpmFormat.format(sMin), rpmFormat.format(sMax))
      );
      return;
    }
    writeBlock(
      "!RC",
      (getProperty("spindleSpeedInRPM") ? sOutput.format(spindleSpeed) : getSpindleSpeed()) + ";",
      "!MC1" // spindle on (M03))
    );
  }

  // wcs
  var workOffset = currentSection.workOffset;
  if (workOffset > 0) {
    // error(localize("Work offset out of range."));
    // return;
  }

  forceAny();

  var initialPosition = getFramePosition(currentSection.getInitialPosition());
  if (!retracted && !insertToolCall) {
    if (getCurrentPosition().z < initialPosition.z) {
      goHome();
      feedOutput.reset();
    }
  }

  if (insertToolCall) {
    writeBlock(
      "Z",
      xOutput.format(initialPosition.x), ",",
      yOutput.format(initialPosition.y), ",",
      zOutput.format(initialPosition.z)
    );
  }
}

function onSpindleSpeed(spindleSpeed) {
  writeBlock(
    "!RC",
    (getProperty("spindleSpeedInRPM") ? sOutput.format(spindleSpeed) : getSpindleSpeed()) + ";",
    "!MC1" // spindle on (M03))
  );
}

function onDwell(seconds) {
  if (seconds > 32767 / 1000.0) {
    warning(localize("Dwelling time is out of range."));
  }
  milliseconds = clamp(1, seconds * 1000, 32767);
  writeBlock("W", milliFormat.format(milliseconds));
}

function onRapid(_x, _y, _z) {
  if (radiusCompensation > 0) {
    error(localize("Radius compensation is not supported."));
    return;
  }

  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  if (x || y || z) {
    var f = feedOutput.format(rapidFeed);
    if (f) {
      writeBlock("V" + f); // rapid feed (like G0)
    }
    writeBlock("Z", x + ",", y + ",", z);
    feedOutput.reset();
  }
}

function onLinear(_x, _y, _z, feed) {
  if (radiusCompensation > 0) {
    error(localize("Radius compensation is not supported."));
    return;
  }

  var f = feedOutput.format(feed);
  if (f) {
    writeBlock("V" + f);
  }

  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  if (x || y || z) {
    writeBlock("Z", x + ",", y + ",", z);
  }
}

function onCircular() {
  linearize(tolerance); // note: could use operation tolerance
}

function onCommand(command) {
  onUnsupportedCommand(command);
}

function onSectionEnd() {
  forceAny();
}

function onClose() {
  writeBlock("!MC0"); // stop spindle
  goHome();

  onImpliedCommand(COMMAND_END);
  onImpliedCommand(COMMAND_STOP_SPINDLE);
  writeBlock((getMachineType() == "mdx-15/20") ? "^IN" : "^DF");
}

function setProperty(property, value) {
  properties[property].current = value;
}
