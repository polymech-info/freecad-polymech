/**
  Copyright (c) 2014 by Autodesk, Inc.
  http://www.hsmworks.com
  http://cam.autodesk.com
*/

var shell = new ActiveXObject("WScript.Shell");
var subkey = "HSMWorks\\HSMWorks\\";

var path;

if (!path) {
  try {
    path = shell.RegRead("HKLM\\Software\\Wow6432Node\\" + subkey + "installation folder");
  } catch(e) {
  }
}

if (!path) {
  try {
    path = shell.RegRead("HKLM\\Software\\" + subkey + "installation folder");
  } catch(e) {
  }
}

try {
  if (path) {
    shell.RegWrite("HKCU\\Software\\Classes\\HSMWorks Post\\shell\\Test Post\\command\\", "\"" + path + "\\testpost.bat\" \"%L\"", "REG_SZ");
    shell.RegWrite("HKCU\\Software\\Classes\\.cps\\", "HSMWorks Post", "REG_SZ");
  }
} catch(e) {
}
