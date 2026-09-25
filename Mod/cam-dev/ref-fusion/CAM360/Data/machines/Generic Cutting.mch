{
   "controller" : {
      "default" : {
         "max_block_processing_speed" : 0,
         "max_normal_speed" : 0,
         "parts" : {
            "linear_0" : {
               "max_normal_speed" : 0,
               "max_rapid_speed" : 0
            },
            "linear_1" : {
               "max_normal_speed" : 0,
               "max_rapid_speed" : 0
            },
            "linear_2" : {
               "max_normal_speed" : 0,
               "max_rapid_speed" : 0
            }
         }
      }
   },
   "general" : {
      "capabilities" : [ "cutting" ],
      "description" : "Generic Cutting Machine",
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
                  "coolants" : null,
                  "max_tool_diameter" : 0,
                  "max_tool_length" : 0
               },
               "type" : "head"
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
      "default" : null
   },
   "post" : {
      "default" : null
   },
   "tooling" : {
      "default" : null
   }
}

