# freecad-polymech
Polymech Contribs

Windows FreeCAD tree for CAM work, including `Mod/cam-dev` reference data (Fusion CAM360, HSMWorks, and related samples).

DLL and EXE binaries are not stored in git. GitHub rejects files larger than 100 MB, and this tree includes several above that limit:

- `bin/libclang-13.dll`
- `Mod/cam-dev/ref-fusion/CAM360/mwgeolib.dll`
- `Mod/cam-dev/ref-fusion/CAM360/5axui_res_neutral.dll`

`*.dll` and `*.exe` are gitignored. They stay on the local disk and are not part of the commit that is pushed.
