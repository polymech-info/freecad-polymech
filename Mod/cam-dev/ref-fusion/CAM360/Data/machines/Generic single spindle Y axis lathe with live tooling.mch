{
   "controller" : {
      "default" : {
         "head_info_part_id" : "turret_0",
         "max_block_processing_speed" : 0,
         "max_normal_speed" : 0,
         "parts" : {
            "linear_0" : {
               "coordinate" : 0,
               "max_normal_speed" : 0,
               "max_rapid_speed" : 0,
               "preference" : "negative",
               "reset" : "never",
               "reversed" : false,
               "tcp" : false,
               "zero_position_offset" : 0
            },
            "linear_1" : {
               "coordinate" : 1,
               "max_normal_speed" : 0,
               "max_rapid_speed" : 0,
               "preference" : "negative",
               "reset" : "never",
               "reversed" : false,
               "tcp" : false,
               "zero_position_offset" : 0
            },
            "linear_2" : {
               "coordinate" : 2,
               "max_normal_speed" : 0,
               "max_rapid_speed" : 0,
               "preference" : "negative",
               "reset" : "never",
               "reversed" : false,
               "tcp" : false,
               "zero_position_offset" : 0
            },
            "rotary_0" : {
               "coordinate" : 2,
               "max_normal_speed" : 0,
               "max_rapid_speed" : 0,
               "preference" : "no preference",
               "reset" : "never",
               "reversed" : false,
               "tcp" : false,
               "zero_position_offset" : 0
            }
         },
         "table_part_id" : "table"
      }
   },
   "fusion" : {
      "default" : {
         "guid" : "00d439bf-4faa-90d9-de4b-4991163a5079"
      }
   },
   "general" : {
      "capabilities" : [ "milling", "turning" ],
      "description" : "Generic single spindle Y axis lathe with live tooling",
      "minimumRevision" : 45805,
      "model" : "Generic single spindle Y axis lathe",
      "vendor" : "Autodesk"
   },
   "interactions" : {
      "default" : {
         "pairs" : [
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "linear_0",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "rotary_0",
                     "type" : "machine_part"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "linear_0",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "table",
                     "type" : "stock"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "linear_0",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "table",
                     "type" : "fixture"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "linear_1",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "rotary_0",
                     "type" : "machine_part"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "linear_1",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "table",
                     "type" : "stock"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "linear_1",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "table",
                     "type" : "fixture"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "linear_2",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "rotary_0",
                     "type" : "machine_part"
                  }
               ]
            },
            {
               "setting" : null,
               "solids" : [
                  {
                     "id" : "linear_2",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "table",
                     "type" : "stock"
                  }
               ]
            },
            {
               "setting" : null,
               "solids" : [
                  {
                     "id" : "linear_2",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "table",
                     "type" : "fixture"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "turret_0",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "rotary_0",
                     "type" : "machine_part"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "turret_0",
                     "type" : "turret_active_tool"
                  },
                  {
                     "id" : "rotary_0",
                     "type" : "machine_part"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "turret_0",
                     "type" : "turret_inactive_tool"
                  },
                  {
                     "id" : "rotary_0",
                     "type" : "machine_part"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "turret_0",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "table",
                     "type" : "stock"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "turret_0",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "table",
                     "type" : "fixture"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "turret_0",
                     "type" : "turret_active_tool"
                  },
                  {
                     "id" : "table",
                     "type" : "stock"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "turret_0",
                     "type" : "turret_active_tool"
                  },
                  {
                     "id" : "table",
                     "type" : "fixture"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "turret_0",
                     "type" : "turret_inactive_tool"
                  },
                  {
                     "id" : "table",
                     "type" : "stock"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "turret_0",
                     "type" : "turret_inactive_tool"
                  },
                  {
                     "id" : "table",
                     "type" : "fixture"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "rotary_0",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "table",
                     "type" : "stock"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "rotary_0",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "table",
                     "type" : "fixture"
                  }
               ]
            },
            {
               "setting" : null,
               "solids" : [
                  {
                     "id" : "linear_0",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "linear_1",
                     "type" : "machine_part"
                  }
               ]
            },
            {
               "setting" : null,
               "solids" : [
                  {
                     "id" : "linear_0",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "linear_2",
                     "type" : "machine_part"
                  }
               ]
            },
            {
               "setting" : null,
               "solids" : [
                  {
                     "id" : "linear_0",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "turret_0",
                     "type" : "machine_part"
                  }
               ]
            },
            {
               "setting" : null,
               "solids" : [
                  {
                     "id" : "linear_0",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "turret_0",
                     "type" : "turret_active_tool"
                  }
               ]
            },
            {
               "setting" : null,
               "solids" : [
                  {
                     "id" : "linear_0",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "turret_0",
                     "type" : "turret_inactive_tool"
                  }
               ]
            },
            {
               "setting" : null,
               "solids" : [
                  {
                     "id" : "linear_1",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "linear_2",
                     "type" : "machine_part"
                  }
               ]
            },
            {
               "setting" : null,
               "solids" : [
                  {
                     "id" : "linear_1",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "turret_0",
                     "type" : "machine_part"
                  }
               ]
            },
            {
               "setting" : null,
               "solids" : [
                  {
                     "id" : "linear_1",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "turret_0",
                     "type" : "turret_active_tool"
                  }
               ]
            },
            {
               "setting" : null,
               "solids" : [
                  {
                     "id" : "linear_1",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "turret_0",
                     "type" : "turret_inactive_tool"
                  }
               ]
            },
            {
               "setting" : null,
               "solids" : [
                  {
                     "id" : "linear_2",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "turret_0",
                     "type" : "machine_part"
                  }
               ]
            },
            {
               "setting" : null,
               "solids" : [
                  {
                     "id" : "linear_2",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "turret_0",
                     "type" : "turret_active_tool"
                  }
               ]
            },
            {
               "setting" : null,
               "solids" : [
                  {
                     "id" : "linear_2",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "turret_0",
                     "type" : "turret_inactive_tool"
                  }
               ]
            }
         ]
      }
   },
   "kinematics" : {
      "default" : {
         "conventions" : {
            "rotation" : "right-handed"
         },
         "parts" : [
            {
               "control" : "driven",
               "direction" : [ 1, 0, 0 ],
               "id" : "linear_0",
               "name" : "X",
               "parts" : [
                  {
                     "control" : "driven",
                     "direction" : [ 0, 1, 0 ],
                     "id" : "linear_1",
                     "name" : "Y",
                     "parts" : [
                        {
                           "control" : "driven",
                           "direction" : [ 0, 0, 1 ],
                           "id" : "linear_2",
                           "name" : "Z",
                           "parts" : [
                              {
                                 "axis_of_rotation" : {
                                    "direction" : [ 0, 0, -1 ],
                                    "point" : [ 0, 0, 0 ]
                                 },
                                 "control" : "ancillary",
                                 "id" : "turret_0",
                                 "name" : "Turret",
                                 "parts" : [
                                    {
                                       "attach_frame" : {
                                          "point" : [ 0, 0, 0 ],
                                          "x_direction" : [ 1, 0, 0 ],
                                          "z_direction" : [ 0, 0, 1 ]
                                       },
                                       "id" : "turret_0_station_1",
                                       "type" : "head"
                                    },
                                    {
                                       "attach_frame" : {
                                          "point" : [ 0, 0, 0 ],
                                          "x_direction" : [ 1, 0, 0 ],
                                          "z_direction" : [ 0, 0, 1 ]
                                       },
                                       "id" : "turret_0_station_2",
                                       "type" : "head"
                                    },
                                    {
                                       "attach_frame" : {
                                          "point" : [ 0, 0, 0 ],
                                          "x_direction" : [ 1, 0, 0 ],
                                          "z_direction" : [ 0, 0, 1 ]
                                       },
                                       "id" : "turret_0_station_3",
                                       "type" : "head"
                                    },
                                    {
                                       "attach_frame" : {
                                          "point" : [ 0, 0, 0 ],
                                          "x_direction" : [ 1, 0, 0 ],
                                          "z_direction" : [ 0, 0, 1 ]
                                       },
                                       "id" : "turret_0_station_4",
                                       "type" : "head"
                                    },
                                    {
                                       "attach_frame" : {
                                          "point" : [ 0, 0, 0 ],
                                          "x_direction" : [ 1, 0, 0 ],
                                          "z_direction" : [ 0, 0, 1 ]
                                       },
                                       "id" : "turret_0_station_5",
                                       "type" : "head"
                                    },
                                    {
                                       "attach_frame" : {
                                          "point" : [ 0, 0, 0 ],
                                          "x_direction" : [ 1, 0, 0 ],
                                          "z_direction" : [ 0, 0, 1 ]
                                       },
                                       "id" : "turret_0_station_6",
                                       "type" : "head"
                                    },
                                    {
                                       "attach_frame" : {
                                          "point" : [ 0, 0, 0 ],
                                          "x_direction" : [ 1, 0, 0 ],
                                          "z_direction" : [ 0, 0, 1 ]
                                       },
                                       "id" : "turret_0_station_7",
                                       "type" : "head"
                                    },
                                    {
                                       "attach_frame" : {
                                          "point" : [ 0, 0, 0 ],
                                          "x_direction" : [ 1, 0, 0 ],
                                          "z_direction" : [ 0, 0, 1 ]
                                       },
                                       "id" : "turret_0_station_8",
                                       "type" : "head"
                                    },
                                    {
                                       "attach_frame" : {
                                          "point" : [ 0, 0, 0 ],
                                          "x_direction" : [ 1, 0, 0 ],
                                          "z_direction" : [ 0, 0, 1 ]
                                       },
                                       "id" : "turret_0_station_9",
                                       "type" : "head"
                                    },
                                    {
                                       "attach_frame" : {
                                          "point" : [ 0, 0, 0 ],
                                          "x_direction" : [ 1, 0, 0 ],
                                          "z_direction" : [ 0, 0, 1 ]
                                       },
                                       "id" : "turret_0_station_10",
                                       "type" : "head"
                                    },
                                    {
                                       "attach_frame" : {
                                          "point" : [ 0, 0, 0 ],
                                          "x_direction" : [ 1, 0, 0 ],
                                          "z_direction" : [ 0, 0, 1 ]
                                       },
                                       "id" : "turret_0_station_11",
                                       "type" : "head"
                                    },
                                    {
                                       "attach_frame" : {
                                          "point" : [ 0, 0, 0 ],
                                          "x_direction" : [ 1, 0, 0 ],
                                          "z_direction" : [ 0, 0, 1 ]
                                       },
                                       "id" : "turret_0_station_12",
                                       "type" : "head"
                                    }
                                 ],
                                 "spindle" : {
                                    "max_speed" : 8000,
                                    "min_speed" : 0
                                 },
                                 "tool_station" : {
                                    "coolants" : [ "flood", "through_tool" ],
                                    "max_tool_diameter" : 0,
                                    "max_tool_length" : 0
                                 },
                                 "turret" : {
                                    "index_count" : 24
                                 },
                                 "type" : "rotary"
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
                  "direction" : [ -0, -0, -1 ],
                  "point" : [ 0, 0, 0 ]
               },
               "control" : "driven",
               "id" : "rotary_0",
               "name" : "C",
               "parts" : [
                  {
                     "attach_frame" : {
                        "point" : [ 0, 0, 0 ],
                        "x_direction" : [ 1, -0, 0 ],
                        "z_direction" : [ 0, 0, 1 ]
                     },
                     "display_name" : "table",
                     "id" : "table",
                     "type" : "table"
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
      "default" : {
         "feedrate_ratio" : 1,
         "tool_change_time" : 15
      }
   },
   "multiaxis" : {
      "default" : {
         "feedrate" : {
            "BPW_ratio" : 1,
            "max_feedrate" : 9999.9899999999998,
            "method" : "FPM",
            "output_tolerance" : 0.5,
            "type" : "combination"
         },
         "retract_and_reconfigure" : {
            "enabled" : false,
            "safe_plunge_feedrate" : 250,
            "safe_retract_distance" : 25,
            "safe_retract_feedrate" : 500,
            "stock_expansion" : [ 2.5, 2.5, 2.5 ]
         },
         "singularity" : {
            "adjust" : true,
            "angle" : 0.17453292519943295,
            "cone" : 0.05235987755982989,
            "method" : "off",
            "tolerance" : 0.040000000000000001
         },
         "virtual_tool_tip" : false
      }
   },
   "post" : {
      "default" : null
   },
   "tooling" : {
      "default" : {
         "has_tool_changer" : true,
         "number_of_tools" : 24,
         "supports_tool_preload" : true
      }
   }
}

