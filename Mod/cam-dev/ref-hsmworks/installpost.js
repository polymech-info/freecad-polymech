/**
  Copyright (c) 2014-2017 by Autodesk, Inc.
  http://cam.autodesk.com
*/

var shell = new ActiveXObject("WScript.Shell");
var fso = new ActiveXObject("Scripting.FileSystemObject");

var subkey = "HSMWorks\\HSMWorks\\";

var localeDocument;

function loadLocale(localePath) {
  try {
    var document = new ActiveXObject("Microsoft.XMLDOM");
    document.load(localePath);

    document.setProperty("SelectionLanguage", "XPath");
    document.setProperty("SelectionNamespaces", "xmlns:locale='http://www.hsmworks.com/xml/2008/locale'");

    pattern = ".//locale:locale/locale:message";
    if (!document.selectSingleNode(pattern)) {
      return;
    }

    localeDocument = document;
  } catch(e) {
  }
}

function localize(text) {
  if (localeDocument) {
    pattern = ".//locale:locale/locale:message[@name='" + text + "']";
    try {
      localized = localeDocument.selectSingleNode(pattern).text;
      return localized;
    } catch(e) {
    }
  }
  return text;
}

function localize2(text) {
  var result = localize(text);
  for (var i = 0; i < arguments.length; ++i) {
    result = result.split("%" + (i + 1)).join(arguments[i + 1]);
  }
  return result;
}

function makeFolder(path) {
  if (!fso.FolderExists(path)) {
    makeFolder(fso.GetParentFolderName(path));
    fso.CreateFolder(path);
  }
}

try {
  var localePath = shell.RegRead("HKCU\\Software\\HSMWorks\\HSMWorks\\locale path");
  loadLocale(localePath);
} catch(e) {
}

var product = localize("Install Post for HSMWorks");

var sourceLink = false;
var sourcePathPresentation;
var sourcePath;
var sourceData;
var sourceName;

var arguments = WScript.Arguments;
if (arguments.length == 1) {
  var path = arguments(0);
  if (path.indexOf("autodeskcam-post://") == 0) {
    var url = "https://" + path.substring("autodeskcam-post://".length);
    var downloaded = false;
    if (url.indexOf("https://cam.autodesk.com/posts/") != 0) {
      var result = shell.Popup(localize2("You are about to download content from '%1'. If you do not trust the source you should abort here." + "\n\n" + localize("Do you want to continue?"), url), -1, product, 4 + 32);
      if (result != 6) {
        WScript.Quit(1);
      }
    }
    try {
      var http = WScript.CreateObject('MSXML2.XMLHTTP');
      http.Open('GET', url, false);
      http.Send();
      if (http.Status == 200) {
        var data = http.responseText;
        if ((data.indexOf("description") >= 0) &&
            (data.indexOf("vendor") >= 0) &&
            (data.indexOf("function") >= 0)) { // quick test if it looks like a post
          sourceData = data;
          downloaded = true;
        }
      }
    } catch(e) {
    }
    if (!downloaded) {
      shell.Popup(localize2("Failed to download post from '%1'.", url) + "\n\n" + localize("If the problem persists please let us know at cam.support@autodesk.com."), -1, product, 0);
      WScript.Quit(1);
    }
    sourceLink = true;
    sourcePathPresentation = url;
    sourcePath = fso.BuildPath(fso.GetSpecialFolder(2), fso.GetTempName());
    try {
      var f = fso.OpenTextFile(sourcePath, 2, true);
      f.Write(sourceData);
      f.Close();
    } catch(e) {
      shell.Popup(localize2("Failed to store post '%1'.", sourcePath), -1, product, 0);
      WScript.Quit(1);
    }
	
    var filename = url;
    var i = filename.indexOf("=");
    if (i >= 0) {
      filename = filename.substring(i + 1);
    }
    sourceName = fso.GetBaseName(filename);
	
  } else {
    if (!fso.FileExists(path)) {
      shell.Popup(localize2("The source post '%1' does not exist.", path), -1, product, 0);
      WScript.Quit(1);
    }
    sourcePathPresentation = path;
    sourcePath = path;
    sourceName = fso.GetBaseName(path);
  }
}

var path = shell.ExpandEnvironmentStrings("%APPDATA%");
if (!path) {
  shell.Popup(localize("Failed to locate personal post folder"), -1, product, 0);
  WScript.Quit(1);
}
var postFolder = fso.BuildPath(path, fso.BuildPath("HSMWorks", "posts"));

if (arguments.length != 1) {
  var result = shell.Popup(localize("No post has been selected.") + "\n\n" + localize("Do you want to open the personal post folder?"), -1, product, 4 + 32);
  if (result == 6) {
    shell.Run("explorer.exe /e," + postFolder);
  }
  WScript.Quit(1);
}

var installationFolder;
if (!installationFolder) {
  try {
    installationFolder = shell.RegRead("HKLM\\Software\\" + subkey + "installation folder");
  } catch(e) {
  }
}
if (!installationFolder) {
  try {
    installationFolder = shell.RegRead("HKLM\\Software\\Wow6432Node\\" + subkey + "installation folder");
  } catch(e) {
  }
}
if (!installationFolder) {
  installationFolder = "C:\\Program Files\\HSMWorks";
}

if (!this.JSON) {
  this.JSON = {};
}

var description;
var vendor;
var vendorUrl;
var legal;
var extension;
var capabilities;
var revision;
var changed;
var longDescription;

try {
  // use Run to avoid prompt
  // need timeout
  var e = shell.Exec("\"" + installationFolder + "\\post.exe\" --interrogate --quiet \"" + sourcePath + "\"");
  var raw;
  if (e) {
    raw = e.StdOut.ReadAll();
  }
  var data;
  if (raw) {
    if (false && JSON) {
      data = JSON.parse(raw);
    } else {
      eval("data = " + raw); // undesired
    }
  }

  if (sourceLink && sourceData) {
    try {
      fso.DeleteFile(sourcePath, true);
    } catch(e) {
    }
  }
  
  description = data.description ? data.description : "";
  vendor = data.vendor ? data.vendor : "";
  vendorUrl = data.vendorUrl ? data.vendorUrl : "";
  legal = data.legal ? data.legal : "";
  extension = data.extension ? data.extension : "";
  capabilities = data.capabilities ? data.capabilities : "";
  // capabilities = data.capabilities ? data.capabilities.split(" ") : [];
  longDescription = data.longDescription ? data.longDescription : "";
} catch(e) {
  shell.Popup(localize("Failed to verify post.") + "\n\n" + localize("If the problem persists please let us know at cam.support@autodesk.com."), -1, product, 0);
  WScript.Quit(1);
}

if (!description || !vendor) {
  shell.Popup(localize("Failed to verify post.") + "\n\n" + localize("If the problem persists please let us know at cam.support@autodesk.com."), -1, product, 0);
  WScript.Quit(1);
}

// get other data
if (!sourceData) {
  try {
    var f = fso.OpenTextFile(sourcePath, 1);
    sourceData = f.ReadAll();
    f.Close();
  } catch(e) {
    shell.Popup(localize("Failed to read post."), -1, product, 0);
    WScript.Quit(1);
  }
}

try {
  var re = /\$Revision: *([0-9]+)( +.* *)?\$/; // just first match
  var m = re.exec(sourceData);
  revision = m[1];
} catch(e) {
  // ignore if we cannot get revision
}

try {
  var re = /\$Date: *([0-9]+)-([0-9]+)-([0-9]+) ([0-9]+):([0-9]+):([0-9]+)( +([+-][0-9]{4}))? .*\$/; // get date/time
  var m = re.exec(sourceData);
  var tz = m[7] ? parseInt(m[7], 10) : 0;
  var toffset = ((tz >= 0) ? 1 : -1) * ((Math.abs(tz) % 100) + (Math.abs(tz)/100)*60);
  var year = m[1];
  var month = m[2] - 1;
  var date = m[3];
  var hours = m[4];
  var minutes = m[5];
  var seconds = m[6];
  if ((year > 1970) && (month >= 0) && (month <= 11) && (date >= 1) && (date <= 31) &&
      (hours >= 0) && (hours <= 24) &&
      (minutes >= 0) && (minutes < 60) &&
      (seconds >= 0) && (seconds <= 60)) {
    changed = new Date(year, month, date, hours, minutes, seconds);
    changed = new Date(changed.getTime() + toffset * 60 * 1000);
  }
} catch(e) {
  // ignore if we cannot get change date
}

if (!postFolder) {
  try {
    postFolder = shell.RegRead("HKCU\\Software\\" + subkey + "ui\\post process dialog\\pst folder");
  } catch(e) {
  }
}

if (!postFolder) {
  shell.Popup(localize("The post folder could not be found."), -1, product, 0);
  WScript.Quit(1);
}

try {
  makeFolder(postFolder);
} catch(e) {
  shell.Popup(localize("Failed to create personal post folder."), -1, product, 0);
  WScript.Quit(1);
}

if (!fso.FolderExists(postFolder)) {
  shell.Popup(localize("The post folder does not exist."), -1, product, 0);
  WScript.Quit(1);
}

var EOL = "\n";
var meta = "";
if (description) {
  meta += localize("Description") + ": " + description.substr(0, 50) + EOL;
}
if (vendor) {
  meta += localize("Vendor") + ": " + vendor.substr(0, 50) + EOL;
}
if (vendorUrl) {
  meta += localize("Link") + ": " + vendorUrl.substr(0, 50) + EOL;
}
if (legal) {
  meta += localize("Legal") + ": " + legal.substr(0, 50) + EOL;
}
if (extension) {
  meta += localize("Extension") + ": " + extension.substr(0, 50) + EOL;
}
if (capabilities) {
  var text = "";
  if ((capabilities.indexOf("MILLING") >= 0) && (capabilities.indexOf("TURNING") >= 0)) {
    text = localize("Mill/Turn");
  } else if ((capabilities.indexOf("MILLING") >= 0) && (capabilities.indexOf("JET") >= 0)) {
    text = localize("Mill and Waterjet / Laser / Plasma");
  } else if (capabilities.indexOf("MILLING") >= 0) {
    text = localize("Milling");
  } else if (capabilities.indexOf("TURNING") >= 0) {
    text = localize("Turning");
  } else if (capabilities.indexOf("JET") >= 0) {
    text = localize("Waterjet / Laser / Plasma");
  }
  if (text) {
    meta += localize("Capabilities") + ": " + text + EOL;
  } else {
    meta += localize("Capabilities") + ": " + capabilities + EOL;
  }
}
if (revision) {
  meta += localize("Version") + ": " + revision + EOL;
}
if (changed) {
  meta += localize("Changed") + ": " + changed.toLocaleString() + EOL;
}
if (longDescription) {
  meta += EOL;
  var trimmed = longDescription;
  if (trimmed.length > 400) {
    trimmed = trimmed.substring(0, 400) + "...";
  }
  meta += localize("Details") + ": " + trimmed + EOL;
}

var logPath = fso.BuildPath(postFolder, "history.log");
var destPath = fso.BuildPath(postFolder, sourceName + ".cps");

var result = shell.Popup(localize("Do you want to install the post for use with HSMWorks?") + "\n\n" + meta + "\n" + localize("Source") + ": " + sourcePathPresentation + "\n" + localize("Destination") + ": " + destPath + "\n\n" + localize("Please note that the post will be copied from its current location to your personal post folder and that you need to choose the 'Personal Posts' folder from within the post processing dialog. Don't forget to backup all your posts to a safe location. It is also recommended that you rename your post to match your CNC machine."), -1, product, 4 + 32);
if (result != 6) {
  WScript.Quit(1);
}

var success = false;
if (fso.FileExists(destPath)) {
  var result = shell.Popup(localize("A post file with the same name already exists.") + "\n\n" + localize2("File: %1", destPath) + "\n\n" + localize("Do you want to overwrite the post?"), -1, product, 4 + 32);
  if (result != 6) {
    WScript.Quit(1);
  }

  // backup
  try {
    var i = destPath.lastIndexOf(".");
    var backupPath = destPath.substring(0, i) + ".bak";
    try {
      fso.DeleteFile(backupPath, true);
    } catch(e) {
    }
    fso.MoveFile(destPath, backupPath);
  } catch(e) {
    shell.Popup(localize("Failed to backup current post."), -1, product, 0);
    WScript.Quit(1);
  }
}

try {
  if (sourceData) {
    var now = new Date();
    var f = fso.OpenTextFile(logPath, 8, true);
    f.writeLine(now + " Installed post '" + destPath + "' from '" + sourcePathPresentation + "'.");
    if (description) {
      f.writeLine(now + " - DESCRIPTION=" + description);
    }
    if (revision) {
      f.writeLine(now + " - VERSION=" + revision);
    }
    if (changed) {
      f.writeLine(now + " - CHANGED=" + changed.toLocaleString());
    }
    f.writeLine(now + " - SIZE=" + sourceData.length);
    f.Close();

    var f = fso.OpenTextFile(destPath, 2, true);
    f.Write(sourceData);
    f.Close();
    success = true;
  }
} catch(e) {
  // shell.Popup(localize2("Failed to store post '%1'.", destPath), -1, product, 0);
}

if (success && fso.FileExists(destPath)) {
  try {
    shell.RegWrite("HKCU\\Software\\" + subkey + "ui\\post process dialog\\pst path", fso.GetFileName(destPath));
    var current = shell.RegRead("HKCU\\Software\\" + subkey + "ui\\post process dialog\\pst folder");
    if (current != postFolder) {
      shell.RegWrite("HKCU\\Software\\" + subkey + "ui\\post process dialog\\pst folder", postFolder);
    }
  } catch(e) {
  }
  
  var result = shell.Popup(localize("The post has been successfully installed.") + "\n\n" + localize("Do you want to open the personal post folder?"), -1, product, 4 + 32);
  if (result == 6) {
    shell.Run("explorer.exe /e," + postFolder);
  }
} else {
  shell.Popup(localize("Failed to install the post."), -1, product, 0);
}
