# -*- coding: utf-8 -*-
"""
Heidenhain Post Processor (Ported from Fusion 360 CPS logic)
"""
import Path
import Path.Base.Util as PathUtil
import datetime

# Configuration
UNITS = "MM"  # Default to MM
OUTPUT_COMMENTS = True
TOOLTIP = "Heidenhain iTNC 530 (Fusion 360 Port)"

if open.__module__ in ["__builtin__", "io"]:
    pythonopen = open

def export(objectslist, filename, argstring):
    """Main entry point for the post processor."""
    
    # buffers
    gcode = []
    
    # HEADER
    gcode.append(onOpen(objectslist))
    
    # OPERATIONS
    # Build a flat list of operations and tool changes
    # This utility function flattens the job structure into a list that mimics
    # the sequential processing in Fusion 360
    post_list = buildPostList(objectslist)
    
    for obj in post_list:
        if hasattr(obj, "Proxy") and isinstance(obj.Proxy, Path.Tool.Controller.ToolController):
            gcode.append(onToolCall(obj))
        elif hasattr(obj, "Path"):
            gcode.append(onSection(obj))
            
    # FOOTER
    gcode.append(onClose(objectslist))
    
    # Output
    program = "\n".join([line for line in gcode if line])
    
    # Handle "memory" output vs file output
    if filename == "-":
        return program
        
    with pythonopen(filename, "w") as f:
        f.write(program)
        
    return program

def onOpen(objectslist):
    """Header Logic: BEGIN PGM, BLK FORM"""
    lines = []
    program_name = "1001" # Default name
    
    # 1. BEGIN PGM
    lines.append(f"BEGIN PGM {program_name} {UNITS}")
    
    # 2. BLK FORM (Stock definition)
    # Try to find the Stock object in the job
    stock = None
    for obj in objectslist:
        # Navigate up to find Job if we are passed operations
        if hasattr(obj, "Stock") and obj.Stock:
            stock = obj.Stock
            break
            
    if stock and hasattr(stock, "Shape"):
        bbox = stock.Shape.BoundBox
        # BLK FORM 0.1 Z X... Y... Z...
        lines.append(f"BLK FORM 0.1 Z X{fmt(bbox.XMin)} Y{fmt(bbox.YMin)} Z{fmt(bbox.ZMin)}")
        # BLK FORM 0.2 X... Y... Z...
        lines.append(f"BLK FORM 0.2 X{fmt(bbox.XMax)} Y{fmt(bbox.YMax)} Z{fmt(bbox.ZMax)}")
        
    # 3. Comments
    if OUTPUT_COMMENTS:
        lines.append(f"; Post Processor: Heidenhain (FreeCAD Port)")
        lines.append(f"; Date: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

    return "\n".join(lines)

def onToolCall(tool_controller):
    """Tool Call Logic"""
    tool = tool_controller.Tool
    tool_num = tool.ToolNumber if hasattr(tool, "ToolNumber") else 0
    spindle_speed = tool_controller.SpindleSpeed if hasattr(tool_controller, "SpindleSpeed") else 1000
    
    # TOOL CALL 5 Z S2000
    return f"TOOL CALL {tool_num} Z S{spindle_speed}"

def onSection(op):
    """Process an operation (Path object)"""
    lines = []
    if not hasattr(op, "Path"):
        return ""
        
    commands = op.Path.Commands
    
    # Add operation comment
    if OUTPUT_COMMENTS and op.Label:
        lines.append(f"; Op: {op.Label}")
        
    # Variables for Circular Interpolation
    last_pos = {'x':0, 'y':0, 'z':0} # Simplified tracking
    
    for cmd in commands:
        g = cmd.Name
        params = cmd.Parameters
        
        # Linear Moves (G0, G1) -> L
        if g == "G0" or g == "G1":
            parts = ["L"]
            
            # X, Y, Z
            if 'X' in params: parts.append(f"X{fmt(params['X'])}")
            if 'Y' in params: parts.append(f"Y{fmt(params['Y'])}")
            if 'Z' in params: parts.append(f"Z{fmt(params['Z'])}")
            
            # Feed
            if g == "G0":
                parts.append("FMAX") # Rapid
            elif 'F' in params:
                parts.append(f"F{int(params['F'])}") # Feed
                
            # M-codes (M3/M4/M5 handled roughly here or in tool change)
            
            lines.append(" ".join(parts))
            
            # Update last pos (for circular logic if needed)
            if 'X' in params: last_pos['x'] = params['X']
            if 'Y' in params: last_pos['y'] = params['Y']
            if 'Z' in params: last_pos['z'] = params['Z']
            
        # Circular Moves (G2, G3) -> CC + C
        elif g == "G2" or g == "G3":
            # Heidenhain splits circle into Center (CC) and Move (C)
            # CC X... Y...
            # C  X... Y... DR-
            
            # 1. Circle Center
            # FreeCAD G2/G3 parameters are usually center relative to arc start (I, J, K) 
            # OR absolute center (which we need to calculate if given I,J)
            # CAUTION: FreeCAD Paths store I,J,K as RELATIVE to start point usually.
            
            # For this simple port, let's assume XY plane
            cx = last_pos['x'] + params.get('I', 0)
            cy = last_pos['y'] + params.get('J', 0)
            
            lines.append(f"CC X{fmt(cx)} Y{fmt(cy)}")
            
            # 2. Circular Move
            parts = ["C"]
            if 'X' in params: parts.append(f"X{fmt(params['X'])}")
            if 'Y' in params: parts.append(f"Y{fmt(params['Y'])}")
            
            # Direction
            if g == "G2": # CW
                parts.append("DR-")
            else: # CCW
                parts.append("DR+")
                
            # Feed
            if 'F' in params:
                parts.append(f"F{int(params['F'])}")
                
            lines.append(" ".join(parts))
            
            # Update last pos
            if 'X' in params: last_pos['x'] = params['X']
            if 'Y' in params: last_pos['y'] = params['Y']

        # Probing (G38.2)
        elif g == "G38.2":
             # TCH PROBE 427 MEASURE COORDINATE
             lines.append(f"; Probing {g} {params}")
             
             z_target = params.get('Z', 0)
             
             # We use the Tildes (~) typically seen in conversational format or just separate lines
             # Mapping to Cycle 427 (Measure Coordinate)
             lines.append("TCH PROBE 427 MEASURE COORDINATE")
             lines.append(f"  Q263={fmt(last_pos['x'])} ;1ST POINT 1ST AXIS")
             lines.append(f"  Q264={fmt(last_pos['y'])} ;1ST POINT 2ND AXIS")
             lines.append(f"  Q261={fmt(z_target)} ;MEASURING HEIGHT") 
             lines.append("  Q320=0 ;SET-UP CLEARANCE")
             lines.append("  Q272=3 ;MEASURING AXIS")
             lines.append("  Q267=-1 ;TRAVERSE DIRECTION")
             lines.append("  Q260=+50 ;CLEARANCE HEIGHT")
             lines.append("  Q281=1 ;MEASURING LOG")
             lines.append("  Q288=0.1 ;MAXIMUM DIMENSION")
             lines.append("  Q289=0 ;MINIMUM DIMENSION")
             lines.append("  Q309=0 ;PGM STOP TOLERANCE")
             lines.append("  Q330=0 ;TOOL")

    return "\n".join(lines)

def onClose(objectslist):
    """Footer Logic: M30, END PGM"""
    lines = []
    
    # M30 or M2
    lines.append("M30")
    
    # END PGM
    program_name = "1001"
    lines.append(f"END PGM {program_name} {UNITS}")
    
    return "\n".join(lines)

def fmt(value):
    """Format float to string (3 decimal places for mm)"""
    return f"{value:.3f}"

def buildPostList(objectslist):
    """
    Traverse the job operations and build a flat list of items to process,
    inserting Tool Controllers where tool changes occur.
    """
    post_list = []
    current_tool_number = None

    # Ensure we are iterating a list
    ops = objectslist
    if not isinstance(ops, list) and not isinstance(ops, tuple):
        if hasattr(ops, "Group"):
             ops = ops.Group
        else:
             ops = [ops]

    for obj in ops:
        # Check if operation is active
        if hasattr(obj, "Active") and not obj.Active:
            continue
            
        # Handle Tool Change Logic
        tc = PathUtil.toolControllerForOp(obj)
        if tc:
            # If tool changed or this is the first tool
            if current_tool_number is None or tc.ToolNumber != current_tool_number:
                post_list.append(tc)
                current_tool_number = tc.ToolNumber
        
        post_list.append(obj)
        
    return post_list
