{
   "controller" : {
      "default" : {
         "max_block_processing_speed" : 0,
         "max_normal_speed" : 0,
         "parts" : {
            "linear_0" : {
               "coordinate" : 0,
               "max_normal_speed" : 0,
               "max_rapid_speed" : 0
            },
            "linear_1" : {
               "coordinate" : 1,
               "max_normal_speed" : 0,
               "max_rapid_speed" : 0
            },
            "linear_2" : {
               "coordinate" : 2,
               "max_normal_speed" : 0,
               "max_rapid_speed" : 0
            },
            "rotary_0" : {
               "coordinate" : 2,
               "max_normal_speed" : 0,
               "max_rapid_speed" : 0
            }
         }
      }
   },
   "general" : {
      "capabilities" : [ "milling", "turning" ],
      "description" : "Generic Mill-Turn Lathe",
      "vendor" : "Autodesk"
   },
   "kinematics" : {
      "default" : {
         "parts" : [
            {
               "control" : "driven",
               "direction" : [ -1, 0, 0 ],
               "id" : "linear_0",
               "name" : "X",
               "parts" : [
                  {
                     "control" : "driven",
                     "direction" : [ 0, -1, 0 ],
                     "id" : "linear_1",
                     "name" : "Y",
                     "parts" : [
                        {
                           "control" : "driven",
                           "direction" : [ 0, 0, -1 ],
                           "id" : "linear_2",
                           "name" : "Z",
                           "parts" : [
                              {
                                 "attach_frame" : {
                                    "point" : [ 0, 0, 0 ],
                                    "x_direction" : [ 1, 0, 0 ],
                                    "z_direction" : [ 0, 0, 1 ]
                                 },
                                 "display_name" : "table",
                                 "id" : "table",
                                 "type" : "table"
                              }
                           ],
                           "type" : "linear"
                        }
                     ],
                     "type" : "linear"
                  }
               ],
               "type" : "linear"
            },
            {
               "axis_of_rotation" : {
                  "direction" : [ 0, 0, -1 ],
                  "point" : [ 0, 0, 0 ]
               },
               "control" : "driven",
               "id" : "rotary_0",
               "max" : 360,
               "min" : 0,
               "name" : "C",
               "parts" : [
                  {
                     "attach_frame" : {
                        "point" : [ 0, 0, 0 ],
                        "x_direction" : [ 1, 0, 0 ],
                        "z_direction" : [ 0, 0, 1 ]
                     },
                     "display_name" : "head",
                     "id" : "head",
                     "spindle" : {
                        "max_speed" : 0,
                        "min_speed" : 0
                     },
                     "tool_station" : {
                        "coolants" : [
                           "air",
                           "air_through_tool",
                           "flood",
                           "flood_mist",
                           "flood_through_tool",
                           "mist",
                           "suction",
                           "through_tool"
                        ],
                        "max_tool_diameter" : 0,
                        "max_tool_length" : 0
                     },
                     "type" : "head"
                  }
               ],
               "type" : "rotary"
            }
         ],
         "units" : {
            "angle" : "degrees",
            "length" : "mm"
         }
      }
   },
   "machining" : {
      "default" : null
   },
   "multiaxis" : {
      "default" : {
         "singularity" : {
            "angle" : 0.17453292519943295,
            "cone" : 0.05235987755982989,
            "method" : "off",
            "tolerance" : 0.04
         }
      }
   },
   "post" : {
      "default" : null
   },
   "tooling" : {
      "default" : null
   }
}

