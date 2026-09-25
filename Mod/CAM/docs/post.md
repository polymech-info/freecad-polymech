# FreeCAD CAM Post Processors

## How it Works

FreeCAD CAM uses **Python scripts** to generate G-code. When you post-process a job, FreeCAD:

1.  Locates the selected post-processor script (e.g., `heidenhain_1_post.py`).
2.  Passes the list of Operations (the path objects) to the script's `export` function.
3.  The script iterates through the operations, reads the underlying commands (G1, G2, etc.), and formats them into the specific string dialect required by the machine.

### The Files
Post processors are standard Python (`.py`) files located in `Mod/CAM/Path/Post/scripts/` (or your user macro directory).

### Key Functions
A post-processor must implement at least:
```python
def export(objectslist, filename, argstring):
    # objectslist: List of Path objects involved in the job
    # filename: output file path (or "-" for memory)
    # argstring: arguments passed from the job properties
    
    # Logic to iterate objects and generate G-code string
    # ...
    return gcode_string
```

## Porting from Fusion 360

**You cannot directly use Fusion 360 post processors (.cps files) in FreeCAD.**

### The Difference
-   **Fusion 360 / Autodesk HSM**: Uses `CPS` files, which are **JavaScript** based. They rely on an event-driven system (e.g., `onOpen()`, `onLinear()`, `onRapid()`, `onCycle()`). The engine calls these functions as it processes the toolpath.
-   **FreeCAD**: Uses **Python**. It gives you the entire list of path commands upfront. You iterate through them and decide how to translate each command.

### Porting Strategy: The "Manual Transpiler" Approach
To "port" a Fusion 360 post to FreeCAD, you are essentially **re-writing** the logic from JavaScript to Python, but more importantly, you are adapting to a different data flow.

#### 1. Data Flow Difference: Event-Driven vs. Object Iteration
- **Fusion 360 (Event-Driven):** The CAM engine "drives" the post. It calls `onLinear(x, y, z)` or `onRapid(x, y, z)` for every single move. You just write the handler.
- **FreeCAD (Object Iteration):** You receive a list of **Feature Objects** (e.g., `[OpDrill, OpPocket, OpContour]`). You must:
    1.  Iterate through this list.
    2.  Extract the `Path` object from each operation.
    3.  Iterate through the `Commands` inside that path.
    4.  Switch on the command name (`G0`, `G1`, `G2`, `G38.2`).

#### 2. The "Flattening" Problem (Tool Changes)
In Fusion, tool changes happens via `onSection` triggers. In FreeCAD, the input list might just contain operations. You need to explicitly detect when the tool changes between operations and insert your own "Tool Change" logic.

**Best Practice:** Implement a `buildPostList(objects)` function (local to your script) that flattens the hierarchy:
- Input: `[OpA (Tool 1), OpB (Tool 1), OpC (Tool 2)]`
- Output: `[ToolController(1), OpA, OpB, ToolController(2), OpC]`

*Note: Do not try to import `buildPostList` from `Path.Post.Utils` as it is internal APIs. Implement it locally.*

#### 3. Logic Mapping Table

| Logic | Fusion 360 (.cps) | FreeCAD (.py) |
| :--- | :--- | :--- |
| **Header** | `onOpen()` | Function called at start of `export`. Manually checks valid `Stock` object. |
| **Tool Change** | `onSection()` (new tool detected) | Logic inside your main loop needed to compare `obj.ToolController` vs `current_tool`. |
| **Rapid Move** | `onRapid(_x, _y, _z)` | `if cmd.Name == "G0": ...` |
| **Linear Move** | `onLinear(_x, _y, _z)` | `if cmd.Name == "G1": ...` |
| **Arcs** | `onCircular(...)` | `if cmd.Name in ["G2", "G3"]: ...` |
| **Probing** | `onCyclePoint(...)` (probe) | `if cmd.Name == "G38.2": ...` (FreeCAD uses G38.2 internally for probing) |
| **Footer** | `onClose()` | Function called after loop. |

### 4. Probing Example
FreeCAD usually represents probing moves as `G38.2` (Probe toward workpiece). A ported post-processor must intercept this G-code and generate the machine-specific cycle.

**Example (Heidenhain):**
- **FreeCAD:** `G38.2 Z-10 F100`
- **Output:**
  ```
  TCH PROBE 427 MEASURE COORDINATE
   Q263=+0.000 ...
   ...
  ```

## Debugging & Validation

### Validate Syntax
Since post-processors are loaded dynamically, syntax errors might cause silent failures or generic "Failed to load" errors.
Use the bundled Python executable to validate your script syntax:
```bat
"C:\Program Files\FreeCAD 1.0\bin\python.exe" -m py_compile your_post.py
```

### Common Gotchas
- **Imports:** Do not assume standard FreeCAD internal modules (like `Path.Post.Utils`) expose all their helper functions. Check the source or implement helpers locally.
- **Output Policy:** The `export` function can return a string. If the filename argument is `"-"`, return the string directly (used for displaying in the editor window). If it's a path, write to the file.
