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
               "coordinate" : 2,
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
            "linear_3" : {
               "coordinate" : 1,
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
            },
            "rotary_1" : {
               "coordinate" : 2,
               "max_normal_speed" : 21600,
               "max_rapid_speed" : 0,
               "preference" : "no preference",
               "reset" : "never",
               "reversed" : false,
               "tcp" : false,
               "zero_position_offset" : 0
            }
         },
         "table_part_id" : "primary_spindle"
      },
      "secondary_spindle_turret_0" : {
         "head_info_part_id" : "turret_0",
         "parts" : {
            "linear_0" : {
               "coordinate" : 0,
               "home" : 0,
               "max_normal_speed" : 0,
               "max_rapid_speed" : 0,
               "preference" : "negative",
               "reset" : "never",
               "reversed" : false,
               "tcp" : false,
               "zero_position_offset" : 0
            },
            "linear_1" : {
               "coordinate" : 2,
               "home" : 0,
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
            "linear_3" : {
               "coordinate" : 1,
               "home" : 0,
               "max_normal_speed" : 0,
               "max_rapid_speed" : 0,
               "preference" : "negative",
               "reset" : "never",
               "reversed" : false,
               "tcp" : false,
               "zero_position_offset" : 0
            },
            "rotary_1" : {
               "coordinate" : 2,
               "home" : 0,
               "max_normal_speed" : 21600,
               "max_rapid_speed" : 0,
               "preference" : "no preference",
               "reset" : "never",
               "reversed" : false,
               "tcp" : false,
               "zero_position_offset" : 0
            },
            "secondary_spindle" : {
               "preference" : "no preference",
               "reset" : "never",
               "reversed" : false,
               "tcp" : true,
               "zero_position_offset" : 0
            },
            "turret_0" : {
               "preference" : "no preference",
               "reset" : "never",
               "reversed" : false,
               "tcp" : true,
               "zero_position_offset" : 0
            }
         },
         "table_part_id" : "secondary_spindle"
      }
   },
   "fusion" : {
      "default" : {
         "guid" : "1f7ab3f4-4b86-1c10-5912-1a86e8155542"
      }
   },
   "general" : {
      "capabilities" : [ "milling", "turning" ],
      "description" : "Generic dual spindle Y axis lathe with live tooling",
      "minimumRevision" : 45805,
      "model" : "Generic dual spindle Y axis lathe",
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
                     "id" : "primary_spindle",
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
                     "id" : "primary_spindle",
                     "type" : "fixture"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "linear_3",
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
                     "id" : "linear_3",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "primary_spindle",
                     "type" : "stock"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "linear_3",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "primary_spindle",
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
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "linear_2",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "primary_spindle",
                     "type" : "stock"
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
                     "id" : "primary_spindle",
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
                     "id" : "primary_spindle",
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
                     "id" : "primary_spindle",
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
                     "id" : "primary_spindle",
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
                     "id" : "primary_spindle",
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
                     "id" : "primary_spindle",
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
                     "id" : "primary_spindle",
                     "type" : "fixture"
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
                     "id" : "linear_1",
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
                     "id" : "rotary_1",
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
                     "id" : "secondary_spindle",
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
                     "id" : "secondary_spindle",
                     "type" : "fixture"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "linear_3",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "linear_1",
                     "type" : "machine_part"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "linear_3",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "rotary_1",
                     "type" : "machine_part"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "linear_3",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "secondary_spindle",
                     "type" : "stock"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "linear_3",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "secondary_spindle",
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
                     "id" : "linear_1",
                     "type" : "machine_part"
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
                     "id" : "rotary_1",
                     "type" : "machine_part"
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
                     "id" : "secondary_spindle",
                     "type" : "stock"
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
                     "id" : "secondary_spindle",
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
                     "id" : "linear_1",
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
                     "id" : "linear_1",
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
                     "id" : "linear_1",
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
                     "id" : "rotary_1",
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
                     "id" : "rotary_1",
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
                     "id" : "rotary_1",
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
                     "id" : "secondary_spindle",
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
                     "id" : "secondary_spindle",
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
                     "id" : "secondary_spindle",
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
                     "id" : "secondary_spindle",
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
                     "id" : "secondary_spindle",
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
                     "id" : "secondary_spindle",
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
                     "id" : "primary_spindle",
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
                     "id" : "primary_spindle",
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
                     "id" : "linear_1",
                     "type" : "machine_part"
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
                     "id" : "rotary_1",
                     "type" : "machine_part"
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
                     "id" : "secondary_spindle",
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
                     "id" : "secondary_spindle",
                     "type" : "fixture"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "primary_spindle",
                     "type" : "stock"
                  },
                  {
                     "id" : "linear_1",
                     "type" : "machine_part"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "primary_spindle",
                     "type" : "fixture"
                  },
                  {
                     "id" : "linear_1",
                     "type" : "machine_part"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "primary_spindle",
                     "type" : "stock"
                  },
                  {
                     "id" : "rotary_1",
                     "type" : "machine_part"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "primary_spindle",
                     "type" : "fixture"
                  },
                  {
                     "id" : "rotary_1",
                     "type" : "machine_part"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "primary_spindle",
                     "type" : "stock"
                  },
                  {
                     "id" : "secondary_spindle",
                     "type" : "stock"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "primary_spindle",
                     "type" : "stock"
                  },
                  {
                     "id" : "secondary_spindle",
                     "type" : "fixture"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "primary_spindle",
                     "type" : "fixture"
                  },
                  {
                     "id" : "secondary_spindle",
                     "type" : "stock"
                  }
               ]
            },
            {
               "setting" : [ "check_collisions" ],
               "solids" : [
                  {
                     "id" : "primary_spindle",
                     "type" : "fixture"
                  },
                  {
                     "id" : "secondary_spindle",
                     "type" : "fixture"
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
                     "id" : "rotary_1",
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
                     "id" : "secondary_spindle",
                     "type" : "stock"
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
                     "id" : "secondary_spindle",
                     "type" : "fixture"
                  }
               ]
            },
            {
               "setting" : null,
               "solids" : [
                  {
                     "id" : "rotary_1",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "secondary_spindle",
                     "type" : "stock"
                  }
               ]
            },
            {
               "setting" : null,
               "solids" : [
                  {
                     "id" : "rotary_1",
                     "type" : "machine_part"
                  },
                  {
                     "id" : "secondary_spindle",
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
                     "id" : "linear_3",
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
                     "id" : "linear_3",
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
                     "id" : "linear_3",
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
                     "id" : "linear_3",
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
                     "id" : "linear_3",
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
                     "id" : "linear_3",
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
                  "direction" : [ 0, 0, -1 ],
                  "point" : [ 0, 0, 0 ]
               },
               "control" : "driven",
               "id" : "rotary_0",
               "name" : "C",
               "parts" : [
                  {
                     "attach_frame" : {
                        "point" : [ 0, 0, 0 ],
                        "x_direction" : [ 1, 0, 0 ],
                        "z_direction" : [ 0, 0, 1 ]
                     },
                     "display_name" : "Main spindle",
                     "id" : "primary_spindle",
                     "spindle" : {
                        "max_speed" : 0,
                        "min_speed" : 0
                     },
                     "type" : "table"
                  }
               ],
               "type" : "rotary"
            },
            {
               "control" : "secondary",
               "direction" : [ -0, -0, -1 ],
               "id" : "linear_1",
               "name" : "Z2",
               "parts" : [
                  {
                     "axis_of_rotation" : {
                        "direction" : [ 0, 0, -1 ],
                        "point" : [ 0, 0, 0 ]
                     },
                     "control" : "driven",
                     "id" : "rotary_1",
                     "name" : "C",
                     "parts" : [
                        {
                           "attach_frame" : {
                              "point" : [ 0, 0, 0 ],
                              "x_direction" : [ 1, 0, 0 ],
                              "z_direction" : [ 0, 0, 1 ]
                           },
                           "display_name" : "Sub spindle",
                           "id" : "secondary_spindle",
                           "spindle" : {
                              "max_speed" : 0,
                              "min_speed" : 0
                           },
                           "type" : "table"
                        }
                     ],
                     "type" : "rotary"
                  }
               ],
               "type" : "linear"
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

