/**
  Copyright (c) 2014-2015 by Autodesk, Inc.
  http://cam.autodesk.com
*/

var shell = new ActiveXObject("WScript.Shell");
var fso = new ActiveXObject("Scripting.FileSystemObject");
var subkey = "HSMWorks\\HSMWorks\\";

var title = "Post Folder";

function localize(text) {
  return text;  
}

try {
  var path = shell.RegRead("HKCU\\Software\\" + subkey + "ui\\post process dialog\\pst folder");
  if (path) {
    if (fso.FolderExists(path)) {
      shell.Run("explorer.exe /e," + path);
      WScript.Quit(1);
    }
  }
} catch(e) {
}

try {
  var path = shell.RegRead("HKLM\\Software\\Wow6432Node\\" + subkey + "installation folder");
  if (path) {
    if (fso.FolderExists(path)) {
      shell.Run("explorer.exe /e," + path + "\\posts");
      WScript.Quit(1);
    }
  }
} catch(e) {
}

try {
  var path = shell.RegRead("HKLM\\Software\\" + subkey + "installation folder");
  if (path) {
    if (fso.FolderExists(path)) {
      shell.Run("explorer.exe /e," + path + "\\posts");
      WScript.Quit(1);
    }
  }
} catch(e) {
}

shell.Popup(localize("Failed to locate post folder."), -1, title, 0);
