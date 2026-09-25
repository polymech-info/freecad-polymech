/**
  Copyright (c) 2014-2017 by Autodesk, Inc.
  http://cam.autodesk.com
*/

var shell = new ActiveXObject("WScript.Shell");
var fso = new ActiveXObject("Scripting.FileSystemObject");
var subkey = "HSMWorks\\HSMWorks\\";
var title = "NC Folder";

function localize(text) {
  return text;  
}

function makeFolder(path) {
  if (!fso.FolderExists(path)) {
    makeFolder(fso.GetParentFolderName(path));
    fso.CreateFolder(path);
  }
}

try {
  var path = shell.RegRead("HKCU\\Software\\" + subkey + "ui\\post process dialog\\output folder");
  if (path) {
    try {
      if (!fso.FolderExists(path)) {
        makeFolder(path);
      }
    } catch (e) {
    }
    shell.Run("explorer.exe /e," + path);
    WScript.Quit(1);
  }
} catch(e) {
}

var path = shell.ExpandEnvironmentStrings("%LOCALAPPDATA%");
if (path) {
  var path = path + "\\HSMWorks\\nc";
  if (path) {
    try {
      if (!fso.FolderExists(path)) {
        makeFolder(path);
      }
    } catch (e) {
    }
    shell.Run("explorer.exe /e," + path);
    WScript.Quit(1);
  }
}

shell.Popup(localize("Failed to locate NC output folder."), -1, title, 0);
