# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160104105510) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "activity_states", force: true do |t|
    t.string   "name",       default: "unnamed activity", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "budokop_sensors", force: true do |t|
    t.integer  "battery_state"
    t.integer  "battery_capacity"
    t.string   "manufacturer",      default: "unknown manufacturer",  null: false
    t.string   "model",             default: "unknown model",         null: false
    t.string   "serial_number",     default: "unknown serial number", null: false
    t.string   "firmware_version",  default: "unknown version",       null: false
    t.date     "manufacture_date"
    t.date     "purchase_date"
    t.date     "warranty_date"
    t.date     "deployment_date"
    t.datetime "last_state_change"
    t.integer  "device_id"
  end

  create_table "contexts", force: true do |t|
    t.string "name",                           null: false
    t.string "context_type", default: "tests", null: false
  end

  create_table "device_aggregations", force: true do |t|
    t.string  "custom_id",                                                                           default: "unknown ID", null: false
    t.integer "profile_id"
    t.integer "section_id"
    t.integer "levee_id"
    t.string  "device_aggregation_type"
    t.integer "parent_id"
    t.spatial "shape",                   limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
  end

  add_index "device_aggregations", ["levee_id"], :name => "index_device_aggregations_on_levee_id"
  add_index "device_aggregations", ["parent_id"], :name => "index_device_aggregations_on_parent_id"
  add_index "device_aggregations", ["section_id"], :name => "index_device_aggregations_on_section_id"

  create_table "devices", force: true do |t|
    t.string  "custom_id",                                                                                    default: "unknown ID", null: false
    t.spatial "placement",             limit: {:srid=>4326, :type=>"point", :has_z=>true, :geographic=>true}
    t.string  "device_type",                                                                                  default: "unknown",    null: false
    t.integer "device_aggregation_id"
    t.integer "profile_id"
    t.integer "section_id"
    t.integer "levee_id"
    t.string  "label"
  end

  add_index "devices", ["levee_id"], :name => "index_devices_on_levee_id"
  add_index "devices", ["section_id"], :name => "index_devices_on_section_id"

  create_table "edge_nodes", force: true do |t|
    t.string   "custom_id",                                                                   default: "unknown ID",            null: false
    t.spatial  "placement",          limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.string   "manufacturer",                                                                default: "unknown manufacturer",  null: false
    t.string   "model",                                                                       default: "unknown model",         null: false
    t.string   "serial_number",                                                               default: "unknown serial number", null: false
    t.string   "firmware_version",                                                            default: "unknown version",       null: false
    t.date     "manufacture_date"
    t.date     "purchase_date"
    t.date     "warranty_date"
    t.date     "deployment_date"
    t.datetime "last_state_change"
    t.integer  "energy_consumption",                                                          default: 0,                       null: false
    t.integer  "activity_state_id"
    t.integer  "interface_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "edge_nodes", ["activity_state_id"], :name => "index_edge_nodes_on_activity_state_id"
  add_index "edge_nodes", ["custom_id"], :name => "index_edge_nodes_on_custom_id", :unique => true
  add_index "edge_nodes", ["interface_type_id"], :name => "index_edge_nodes_on_interface_type_id"
  add_index "edge_nodes", ["last_state_change"], :name => "index_edge_nodes_on_last_state_change"

  create_table "experiments", force: true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "name"
    t.text     "description"
    t.integer  "levee_id"
  end

  create_table "experiments_scenarios", force: true do |t|
    t.integer "scenario_id",   null: false
    t.integer "experiment_id", null: false
  end

  create_table "fiber_optic_nodes", force: true do |t|
    t.float    "cable_distance_marker"
    t.float    "levee_distance_marker"
    t.date     "deployment_date"
    t.datetime "last_state_change"
    t.integer  "device_id"
  end

  create_table "ground_types", force: true do |t|
    t.string "label",       default: "unknown ground type", null: false
    t.string "description"
  end

  create_table "interface_types", force: true do |t|
    t.string   "name",       default: "unnamed interface type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "levees", force: true do |t|
    t.string   "name",                    default: "unnamed levee", null: false
    t.string   "emergency_level",         default: "none",          null: false
    t.string   "threat_level",            default: "none",          null: false
    t.datetime "threat_level_updated_at", default: "now()",         null: false
  end

  create_table "measurement_nodes", force: true do |t|
    t.string   "custom_id",                                                                                 default: "unknown ID",            null: false
    t.spatial  "placement",          limit: {:srid=>4326, :type=>"point", :has_z=>true, :geographic=>true}
    t.integer  "battery_state"
    t.integer  "battery_capacity"
    t.string   "manufacturer",                                                                              default: "unknown manufacturer",  null: false
    t.string   "model",                                                                                     default: "unknown model",         null: false
    t.string   "serial_number",                                                                             default: "unknown serial number", null: false
    t.string   "firmware_version",                                                                          default: "unknown version",       null: false
    t.date     "manufacture_date"
    t.date     "purchase_date"
    t.date     "warranty_date"
    t.date     "deployment_date"
    t.datetime "last_state_change"
    t.integer  "energy_consumption",                                                                        default: 0,                       null: false
    t.integer  "edge_node_id"
    t.integer  "activity_state_id"
    t.integer  "power_type_id"
    t.integer  "interface_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measurement_nodes", ["activity_state_id"], :name => "index_measurement_nodes_on_activity_state_id"
  add_index "measurement_nodes", ["custom_id"], :name => "index_measurement_nodes_on_custom_id", :unique => true
  add_index "measurement_nodes", ["interface_type_id"], :name => "index_measurement_nodes_on_interface_type_id"
  add_index "measurement_nodes", ["last_state_change"], :name => "index_measurement_nodes_on_last_state_change"

  create_table "measurement_types", force: true do |t|
    t.string   "name",       default: "unnamed measurement", null: false
    t.string   "unit",       default: "unnamed unit",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "label"
  end

  create_table "measurements", id: false, force: true do |t|
    t.integer  "id",             default: "nextval('measurements_new_id_seq'::regclass)", null: false
    t.float    "value",                                                                   null: false
    t.datetime "timestamp",                                                               null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  create_table "measurements_child_0", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_0", ["timestamp"], :name => "idx_timestamp_0"

  create_table "measurements_child_1", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_1", ["timestamp"], :name => "idx_timestamp_1"

  create_table "measurements_child_10", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_10", ["timestamp"], :name => "idx_timestamp_10"

  create_table "measurements_child_100", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_100", ["timestamp"], :name => "idx_timestamp_100"

  create_table "measurements_child_101", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_101", ["timestamp"], :name => "idx_timestamp_101"

  create_table "measurements_child_102", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_102", ["timestamp"], :name => "idx_timestamp_102"

  create_table "measurements_child_103", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_103", ["timestamp"], :name => "idx_timestamp_103"

  create_table "measurements_child_104", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_104", ["timestamp"], :name => "idx_timestamp_104"

  create_table "measurements_child_105", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_105", ["timestamp"], :name => "idx_timestamp_105"

  create_table "measurements_child_106", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_106", ["timestamp"], :name => "idx_timestamp_106"

  create_table "measurements_child_107", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_107", ["timestamp"], :name => "idx_timestamp_107"

  create_table "measurements_child_108", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_108", ["timestamp"], :name => "idx_timestamp_108"

  create_table "measurements_child_109", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_109", ["timestamp"], :name => "idx_timestamp_109"

  create_table "measurements_child_11", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_11", ["timestamp"], :name => "idx_timestamp_11"

  create_table "measurements_child_110", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_110", ["timestamp"], :name => "idx_timestamp_110"

  create_table "measurements_child_111", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_111", ["timestamp"], :name => "idx_timestamp_111"

  create_table "measurements_child_112", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_112", ["timestamp"], :name => "idx_timestamp_112"

  create_table "measurements_child_113", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_113", ["timestamp"], :name => "idx_timestamp_113"

  create_table "measurements_child_114", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_114", ["timestamp"], :name => "idx_timestamp_114"

  create_table "measurements_child_115", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_115", ["timestamp"], :name => "idx_timestamp_115"

  create_table "measurements_child_116", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_116", ["timestamp"], :name => "idx_timestamp_116"

  create_table "measurements_child_117", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_117", ["timestamp"], :name => "idx_timestamp_117"

  create_table "measurements_child_118", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_118", ["timestamp"], :name => "idx_timestamp_118"

  create_table "measurements_child_119", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_119", ["timestamp"], :name => "idx_timestamp_119"

  create_table "measurements_child_12", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_12", ["timestamp"], :name => "idx_timestamp_12"

  create_table "measurements_child_120", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_120", ["timestamp"], :name => "idx_timestamp_120"

  create_table "measurements_child_121", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_121", ["timestamp"], :name => "idx_timestamp_121"

  create_table "measurements_child_122", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_122", ["timestamp"], :name => "idx_timestamp_122"

  create_table "measurements_child_123", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_123", ["timestamp"], :name => "idx_timestamp_123"

  create_table "measurements_child_124", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_124", ["timestamp"], :name => "idx_timestamp_124"

  create_table "measurements_child_125", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_125", ["timestamp"], :name => "idx_timestamp_125"

  create_table "measurements_child_126", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_126", ["timestamp"], :name => "idx_timestamp_126"

  create_table "measurements_child_127", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_127", ["timestamp"], :name => "idx_timestamp_127"

  create_table "measurements_child_128", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_128", ["timestamp"], :name => "idx_timestamp_128"

  create_table "measurements_child_129", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_129", ["timestamp"], :name => "idx_timestamp_129"

  create_table "measurements_child_13", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_13", ["timestamp"], :name => "idx_timestamp_13"

  create_table "measurements_child_130", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_130", ["timestamp"], :name => "idx_timestamp_130"

  create_table "measurements_child_131", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_131", ["timestamp"], :name => "idx_timestamp_131"

  create_table "measurements_child_132", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_132", ["timestamp"], :name => "idx_timestamp_132"

  create_table "measurements_child_133", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_133", ["timestamp"], :name => "idx_timestamp_133"

  create_table "measurements_child_134", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_134", ["timestamp"], :name => "idx_timestamp_134"

  create_table "measurements_child_135", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_135", ["timestamp"], :name => "idx_timestamp_135"

  create_table "measurements_child_136", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_136", ["timestamp"], :name => "idx_timestamp_136"

  create_table "measurements_child_137", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_137", ["timestamp"], :name => "idx_timestamp_137"

  create_table "measurements_child_138", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_138", ["timestamp"], :name => "idx_timestamp_138"

  create_table "measurements_child_139", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_139", ["timestamp"], :name => "idx_timestamp_139"

  create_table "measurements_child_14", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_14", ["timestamp"], :name => "idx_timestamp_14"

  create_table "measurements_child_140", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_140", ["timestamp"], :name => "idx_timestamp_140"

  create_table "measurements_child_141", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_141", ["timestamp"], :name => "idx_timestamp_141"

  create_table "measurements_child_142", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_142", ["timestamp"], :name => "idx_timestamp_142"

  create_table "measurements_child_143", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_143", ["timestamp"], :name => "idx_timestamp_143"

  create_table "measurements_child_144", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_144", ["timestamp"], :name => "idx_timestamp_144"

  create_table "measurements_child_145", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_145", ["timestamp"], :name => "idx_timestamp_145"

  create_table "measurements_child_146", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_146", ["timestamp"], :name => "idx_timestamp_146"

  create_table "measurements_child_147", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_147", ["timestamp"], :name => "idx_timestamp_147"

  create_table "measurements_child_148", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_148", ["timestamp"], :name => "idx_timestamp_148"

  create_table "measurements_child_149", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_149", ["timestamp"], :name => "idx_timestamp_149"

  create_table "measurements_child_15", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_15", ["timestamp"], :name => "idx_timestamp_15"

  create_table "measurements_child_150", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_150", ["timestamp"], :name => "idx_timestamp_150"

  create_table "measurements_child_151", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_151", ["timestamp"], :name => "idx_timestamp_151"

  create_table "measurements_child_152", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_152", ["timestamp"], :name => "idx_timestamp_152"

  create_table "measurements_child_153", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_153", ["timestamp"], :name => "idx_timestamp_153"

  create_table "measurements_child_154", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_154", ["timestamp"], :name => "idx_timestamp_154"

  create_table "measurements_child_155", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_155", ["timestamp"], :name => "idx_timestamp_155"

  create_table "measurements_child_156", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_156", ["timestamp"], :name => "idx_timestamp_156"

  create_table "measurements_child_157", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_157", ["timestamp"], :name => "idx_timestamp_157"

  create_table "measurements_child_158", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_158", ["timestamp"], :name => "idx_timestamp_158"

  create_table "measurements_child_159", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_159", ["timestamp"], :name => "idx_timestamp_159"

  create_table "measurements_child_16", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_16", ["timestamp"], :name => "idx_timestamp_16"

  create_table "measurements_child_160", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_160", ["timestamp"], :name => "idx_timestamp_160"

  create_table "measurements_child_161", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_161", ["timestamp"], :name => "idx_timestamp_161"

  create_table "measurements_child_162", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_162", ["timestamp"], :name => "idx_timestamp_162"

  create_table "measurements_child_163", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_163", ["timestamp"], :name => "idx_timestamp_163"

  create_table "measurements_child_164", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_164", ["timestamp"], :name => "idx_timestamp_164"

  create_table "measurements_child_165", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_165", ["timestamp"], :name => "idx_timestamp_165"

  create_table "measurements_child_166", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_166", ["timestamp"], :name => "idx_timestamp_166"

  create_table "measurements_child_167", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_167", ["timestamp"], :name => "idx_timestamp_167"

  create_table "measurements_child_168", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_168", ["timestamp"], :name => "idx_timestamp_168"

  create_table "measurements_child_169", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_169", ["timestamp"], :name => "idx_timestamp_169"

  create_table "measurements_child_17", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_17", ["timestamp"], :name => "idx_timestamp_17"

  create_table "measurements_child_170", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_170", ["timestamp"], :name => "idx_timestamp_170"

  create_table "measurements_child_171", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_171", ["timestamp"], :name => "idx_timestamp_171"

  create_table "measurements_child_172", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_172", ["timestamp"], :name => "idx_timestamp_172"

  create_table "measurements_child_173", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_173", ["timestamp"], :name => "idx_timestamp_173"

  create_table "measurements_child_174", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_174", ["timestamp"], :name => "idx_timestamp_174"

  create_table "measurements_child_175", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_175", ["timestamp"], :name => "idx_timestamp_175"

  create_table "measurements_child_176", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_176", ["timestamp"], :name => "idx_timestamp_176"

  create_table "measurements_child_177", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_177", ["timestamp"], :name => "idx_timestamp_177"

  create_table "measurements_child_178", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_178", ["timestamp"], :name => "idx_timestamp_178"

  create_table "measurements_child_179", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_179", ["timestamp"], :name => "idx_timestamp_179"

  create_table "measurements_child_18", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_18", ["timestamp"], :name => "idx_timestamp_18"

  create_table "measurements_child_180", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_180", ["timestamp"], :name => "idx_timestamp_180"

  create_table "measurements_child_181", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_181", ["timestamp"], :name => "idx_timestamp_181"

  create_table "measurements_child_182", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_182", ["timestamp"], :name => "idx_timestamp_182"

  create_table "measurements_child_183", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_183", ["timestamp"], :name => "idx_timestamp_183"

  create_table "measurements_child_184", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_184", ["timestamp"], :name => "idx_timestamp_184"

  create_table "measurements_child_185", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_185", ["timestamp"], :name => "idx_timestamp_185"

  create_table "measurements_child_186", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_186", ["timestamp"], :name => "idx_timestamp_186"

  create_table "measurements_child_187", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_187", ["timestamp"], :name => "idx_timestamp_187"

  create_table "measurements_child_188", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_188", ["timestamp"], :name => "idx_timestamp_188"

  create_table "measurements_child_189", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_189", ["timestamp"], :name => "idx_timestamp_189"

  create_table "measurements_child_19", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_19", ["timestamp"], :name => "idx_timestamp_19"

  create_table "measurements_child_190", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_190", ["timestamp"], :name => "idx_timestamp_190"

  create_table "measurements_child_191", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_191", ["timestamp"], :name => "idx_timestamp_191"

  create_table "measurements_child_192", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_192", ["timestamp"], :name => "idx_timestamp_192"

  create_table "measurements_child_193", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_193", ["timestamp"], :name => "idx_timestamp_193"

  create_table "measurements_child_194", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_194", ["timestamp"], :name => "idx_timestamp_194"

  create_table "measurements_child_195", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_195", ["timestamp"], :name => "idx_timestamp_195"

  create_table "measurements_child_196", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_196", ["timestamp"], :name => "idx_timestamp_196"

  create_table "measurements_child_197", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_197", ["timestamp"], :name => "idx_timestamp_197"

  create_table "measurements_child_198", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_198", ["timestamp"], :name => "idx_timestamp_198"

  create_table "measurements_child_199", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_199", ["timestamp"], :name => "idx_timestamp_199"

  create_table "measurements_child_2", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2", ["timestamp"], :name => "idx_timestamp_2"

  create_table "measurements_child_20", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_20", ["timestamp"], :name => "idx_timestamp_20"

  create_table "measurements_child_200", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_200", ["timestamp"], :name => "idx_timestamp_200"

  create_table "measurements_child_201", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_201", ["timestamp"], :name => "idx_timestamp_201"

  create_table "measurements_child_202", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_202", ["timestamp"], :name => "idx_timestamp_202"

  create_table "measurements_child_203", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_203", ["timestamp"], :name => "idx_timestamp_203"

  create_table "measurements_child_204", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_204", ["timestamp"], :name => "idx_timestamp_204"

  create_table "measurements_child_205", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_205", ["timestamp"], :name => "idx_timestamp_205"

  create_table "measurements_child_206", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_206", ["timestamp"], :name => "idx_timestamp_206"

  create_table "measurements_child_207", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_207", ["timestamp"], :name => "idx_timestamp_207"

  create_table "measurements_child_208", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_208", ["timestamp"], :name => "idx_timestamp_208"

  create_table "measurements_child_209", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_209", ["timestamp"], :name => "idx_timestamp_209"

  create_table "measurements_child_21", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_21", ["timestamp"], :name => "idx_timestamp_21"

  create_table "measurements_child_210", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_210", ["timestamp"], :name => "idx_timestamp_210"

  create_table "measurements_child_211", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_211", ["timestamp"], :name => "idx_timestamp_211"

  create_table "measurements_child_212", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_212", ["timestamp"], :name => "idx_timestamp_212"

  create_table "measurements_child_213", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_213", ["timestamp"], :name => "idx_timestamp_213"

  create_table "measurements_child_214", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_214", ["timestamp"], :name => "idx_timestamp_214"

  create_table "measurements_child_215", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_215", ["timestamp"], :name => "idx_timestamp_215"

  create_table "measurements_child_216", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_216", ["timestamp"], :name => "idx_timestamp_216"

  create_table "measurements_child_217", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_217", ["timestamp"], :name => "idx_timestamp_217"

  create_table "measurements_child_218", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_218", ["timestamp"], :name => "idx_timestamp_218"

  create_table "measurements_child_219", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_219", ["timestamp"], :name => "idx_timestamp_219"

  create_table "measurements_child_22", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_22", ["timestamp"], :name => "idx_timestamp_22"

  create_table "measurements_child_220", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_220", ["timestamp"], :name => "idx_timestamp_220"

  create_table "measurements_child_221", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_221", ["timestamp"], :name => "idx_timestamp_221"

  create_table "measurements_child_222", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_222", ["timestamp"], :name => "idx_timestamp_222"

  create_table "measurements_child_223", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_223", ["timestamp"], :name => "idx_timestamp_223"

  create_table "measurements_child_224", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_224", ["timestamp"], :name => "idx_timestamp_224"

  create_table "measurements_child_225", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_225", ["timestamp"], :name => "idx_timestamp_225"

  create_table "measurements_child_226", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_226", ["timestamp"], :name => "idx_timestamp_226"

  create_table "measurements_child_227", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_227", ["timestamp"], :name => "idx_timestamp_227"

  create_table "measurements_child_228", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_228", ["timestamp"], :name => "idx_timestamp_228"

  create_table "measurements_child_229", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_229", ["timestamp"], :name => "idx_timestamp_229"

  create_table "measurements_child_23", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_23", ["timestamp"], :name => "idx_timestamp_23"

  create_table "measurements_child_230", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_230", ["timestamp"], :name => "idx_timestamp_230"

  create_table "measurements_child_231", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_231", ["timestamp"], :name => "idx_timestamp_231"

  create_table "measurements_child_232", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_232", ["timestamp"], :name => "idx_timestamp_232"

  create_table "measurements_child_233", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_233", ["timestamp"], :name => "idx_timestamp_233"

  create_table "measurements_child_234", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_234", ["timestamp"], :name => "idx_timestamp_234"

  create_table "measurements_child_235", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_235", ["timestamp"], :name => "idx_timestamp_235"

  create_table "measurements_child_236", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_236", ["timestamp"], :name => "idx_timestamp_236"

  create_table "measurements_child_237", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_237", ["timestamp"], :name => "idx_timestamp_237"

  create_table "measurements_child_238", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_238", ["timestamp"], :name => "idx_timestamp_238"

  create_table "measurements_child_239", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_239", ["timestamp"], :name => "idx_timestamp_239"

  create_table "measurements_child_24", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_24", ["timestamp"], :name => "idx_timestamp_24"

  create_table "measurements_child_240", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_240", ["timestamp"], :name => "idx_timestamp_240"

  create_table "measurements_child_241", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_241", ["timestamp"], :name => "idx_timestamp_241"

  create_table "measurements_child_242", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_242", ["timestamp"], :name => "idx_timestamp_242"

  create_table "measurements_child_243", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_243", ["timestamp"], :name => "idx_timestamp_243"

  create_table "measurements_child_244", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_244", ["timestamp"], :name => "idx_timestamp_244"

  create_table "measurements_child_245", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_245", ["timestamp"], :name => "idx_timestamp_245"

  create_table "measurements_child_246", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_246", ["timestamp"], :name => "idx_timestamp_246"

  create_table "measurements_child_247", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_247", ["timestamp"], :name => "idx_timestamp_247"

  create_table "measurements_child_248", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_248", ["timestamp"], :name => "idx_timestamp_248"

  create_table "measurements_child_249", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_249", ["timestamp"], :name => "idx_timestamp_249"

  create_table "measurements_child_25", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_25", ["timestamp"], :name => "idx_timestamp_25"

  create_table "measurements_child_250", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_250", ["timestamp"], :name => "idx_timestamp_250"

  create_table "measurements_child_251", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_251", ["timestamp"], :name => "idx_timestamp_251"

  create_table "measurements_child_252", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_252", ["timestamp"], :name => "idx_timestamp_252"

  create_table "measurements_child_253", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_253", ["timestamp"], :name => "idx_timestamp_253"

  create_table "measurements_child_254", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_254", ["timestamp"], :name => "idx_timestamp_254"

  create_table "measurements_child_255", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_255", ["timestamp"], :name => "idx_timestamp_255"

  create_table "measurements_child_256", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_256", ["timestamp"], :name => "idx_timestamp_256"

  create_table "measurements_child_257", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_257", ["timestamp"], :name => "idx_timestamp_257"

  create_table "measurements_child_258", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_258", ["timestamp"], :name => "idx_timestamp_258"

  create_table "measurements_child_259", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_259", ["timestamp"], :name => "idx_timestamp_259"

  create_table "measurements_child_26", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_26", ["timestamp"], :name => "idx_timestamp_26"

  create_table "measurements_child_260", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_260", ["timestamp"], :name => "idx_timestamp_260"

  create_table "measurements_child_261", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_261", ["timestamp"], :name => "idx_timestamp_261"

  create_table "measurements_child_262", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_262", ["timestamp"], :name => "idx_timestamp_262"

  create_table "measurements_child_263", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_263", ["timestamp"], :name => "idx_timestamp_263"

  create_table "measurements_child_264", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_264", ["timestamp"], :name => "idx_timestamp_264"

  create_table "measurements_child_265", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_265", ["timestamp"], :name => "idx_timestamp_265"

  create_table "measurements_child_266", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_266", ["timestamp"], :name => "idx_timestamp_266"

  create_table "measurements_child_267", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_267", ["timestamp"], :name => "idx_timestamp_267"

  create_table "measurements_child_268", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_268", ["timestamp"], :name => "idx_timestamp_268"

  create_table "measurements_child_269", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_269", ["timestamp"], :name => "idx_timestamp_269"

  create_table "measurements_child_27", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_27", ["timestamp"], :name => "idx_timestamp_27"

  create_table "measurements_child_270", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_270", ["timestamp"], :name => "idx_timestamp_270"

  create_table "measurements_child_271", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_271", ["timestamp"], :name => "idx_timestamp_271"

  create_table "measurements_child_272", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_272", ["timestamp"], :name => "idx_timestamp_272"

  create_table "measurements_child_273", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_273", ["timestamp"], :name => "idx_timestamp_273"

  create_table "measurements_child_274", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_274", ["timestamp"], :name => "idx_timestamp_274"

  create_table "measurements_child_275", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_275", ["timestamp"], :name => "idx_timestamp_275"

  create_table "measurements_child_276", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_276", ["timestamp"], :name => "idx_timestamp_276"

  create_table "measurements_child_277", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_277", ["timestamp"], :name => "idx_timestamp_277"

  create_table "measurements_child_278", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_278", ["timestamp"], :name => "idx_timestamp_278"

  create_table "measurements_child_279", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_279", ["timestamp"], :name => "idx_timestamp_279"

  create_table "measurements_child_28", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_28", ["timestamp"], :name => "idx_timestamp_28"

  create_table "measurements_child_280", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_280", ["timestamp"], :name => "idx_timestamp_280"

  create_table "measurements_child_281", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_281", ["timestamp"], :name => "idx_timestamp_281"

  create_table "measurements_child_282", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_282", ["timestamp"], :name => "idx_timestamp_282"

  create_table "measurements_child_283", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_283", ["timestamp"], :name => "idx_timestamp_283"

  create_table "measurements_child_284", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_284", ["timestamp"], :name => "idx_timestamp_284"

  create_table "measurements_child_285", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_285", ["timestamp"], :name => "idx_timestamp_285"

  create_table "measurements_child_286", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_286", ["timestamp"], :name => "idx_timestamp_286"

  create_table "measurements_child_287", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_287", ["timestamp"], :name => "idx_timestamp_287"

  create_table "measurements_child_288", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_288", ["timestamp"], :name => "idx_timestamp_288"

  create_table "measurements_child_289", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_289", ["timestamp"], :name => "idx_timestamp_289"

  create_table "measurements_child_29", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_29", ["timestamp"], :name => "idx_timestamp_29"

  create_table "measurements_child_290", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_290", ["timestamp"], :name => "idx_timestamp_290"

  create_table "measurements_child_291", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_291", ["timestamp"], :name => "idx_timestamp_291"

  create_table "measurements_child_292", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_292", ["timestamp"], :name => "idx_timestamp_292"

  create_table "measurements_child_293", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_293", ["timestamp"], :name => "idx_timestamp_293"

  create_table "measurements_child_294", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_294", ["timestamp"], :name => "idx_timestamp_294"

  create_table "measurements_child_295", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_295", ["timestamp"], :name => "idx_timestamp_295"

  create_table "measurements_child_296", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_296", ["timestamp"], :name => "idx_timestamp_296"

  create_table "measurements_child_297", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_297", ["timestamp"], :name => "idx_timestamp_297"

  create_table "measurements_child_298", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_298", ["timestamp"], :name => "idx_timestamp_298"

  create_table "measurements_child_299", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_299", ["timestamp"], :name => "idx_timestamp_299"

  create_table "measurements_child_3", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_3", ["timestamp"], :name => "idx_timestamp_3"

  create_table "measurements_child_30", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_30", ["timestamp"], :name => "idx_timestamp_30"

  create_table "measurements_child_300", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_300", ["timestamp"], :name => "idx_timestamp_300"

  create_table "measurements_child_301", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_301", ["timestamp"], :name => "idx_timestamp_301"

  create_table "measurements_child_302", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_302", ["timestamp"], :name => "idx_timestamp_302"

  create_table "measurements_child_303", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_303", ["timestamp"], :name => "idx_timestamp_303"

  create_table "measurements_child_304", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_304", ["timestamp"], :name => "idx_timestamp_304"

  create_table "measurements_child_305", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_305", ["timestamp"], :name => "idx_timestamp_305"

  create_table "measurements_child_306", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_306", ["timestamp"], :name => "idx_timestamp_306"

  create_table "measurements_child_307", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_307", ["timestamp"], :name => "idx_timestamp_307"

  create_table "measurements_child_308", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_308", ["timestamp"], :name => "idx_timestamp_308"

  create_table "measurements_child_309", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_309", ["timestamp"], :name => "idx_timestamp_309"

  create_table "measurements_child_31", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_31", ["timestamp"], :name => "idx_timestamp_31"

  create_table "measurements_child_310", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_310", ["timestamp"], :name => "idx_timestamp_310"

  create_table "measurements_child_311", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_311", ["timestamp"], :name => "idx_timestamp_311"

  create_table "measurements_child_312", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_312", ["timestamp"], :name => "idx_timestamp_312"

  create_table "measurements_child_313", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_313", ["timestamp"], :name => "idx_timestamp_313"

  create_table "measurements_child_314", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_314", ["timestamp"], :name => "idx_timestamp_314"

  create_table "measurements_child_315", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_315", ["timestamp"], :name => "idx_timestamp_315"

  create_table "measurements_child_316", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_316", ["timestamp"], :name => "idx_timestamp_316"

  create_table "measurements_child_317", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_317", ["timestamp"], :name => "idx_timestamp_317"

  create_table "measurements_child_318", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_318", ["timestamp"], :name => "idx_timestamp_318"

  create_table "measurements_child_319", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_319", ["timestamp"], :name => "idx_timestamp_319"

  create_table "measurements_child_32", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_32", ["timestamp"], :name => "idx_timestamp_32"

  create_table "measurements_child_320", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_320", ["timestamp"], :name => "idx_timestamp_320"

  create_table "measurements_child_321", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_321", ["timestamp"], :name => "idx_timestamp_321"

  create_table "measurements_child_322", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_322", ["timestamp"], :name => "idx_timestamp_322"

  create_table "measurements_child_323", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_323", ["timestamp"], :name => "idx_timestamp_323"

  create_table "measurements_child_324", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_324", ["timestamp"], :name => "idx_timestamp_324"

  create_table "measurements_child_325", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_325", ["timestamp"], :name => "idx_timestamp_325"

  create_table "measurements_child_326", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_326", ["timestamp"], :name => "idx_timestamp_326"

  create_table "measurements_child_327", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_327", ["timestamp"], :name => "idx_timestamp_327"

  create_table "measurements_child_328", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_328", ["timestamp"], :name => "idx_timestamp_328"

  create_table "measurements_child_329", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_329", ["timestamp"], :name => "idx_timestamp_329"

  create_table "measurements_child_33", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_33", ["timestamp"], :name => "idx_timestamp_33"

  create_table "measurements_child_330", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_330", ["timestamp"], :name => "idx_timestamp_330"

  create_table "measurements_child_331", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_331", ["timestamp"], :name => "idx_timestamp_331"

  create_table "measurements_child_332", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_332", ["timestamp"], :name => "idx_timestamp_332"

  create_table "measurements_child_333", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_333", ["timestamp"], :name => "idx_timestamp_333"

  create_table "measurements_child_334", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_334", ["timestamp"], :name => "idx_timestamp_334"

  create_table "measurements_child_335", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_335", ["timestamp"], :name => "idx_timestamp_335"

  create_table "measurements_child_336", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_336", ["timestamp"], :name => "idx_timestamp_336"

  create_table "measurements_child_337", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_337", ["timestamp"], :name => "idx_timestamp_337"

  create_table "measurements_child_338", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_338", ["timestamp"], :name => "idx_timestamp_338"

  create_table "measurements_child_339", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_339", ["timestamp"], :name => "idx_timestamp_339"

  create_table "measurements_child_34", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_34", ["timestamp"], :name => "idx_timestamp_34"

  create_table "measurements_child_340", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_340", ["timestamp"], :name => "idx_timestamp_340"

  create_table "measurements_child_341", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_341", ["timestamp"], :name => "idx_timestamp_341"

  create_table "measurements_child_342", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_342", ["timestamp"], :name => "idx_timestamp_342"

  create_table "measurements_child_343", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_343", ["timestamp"], :name => "idx_timestamp_343"

  create_table "measurements_child_344", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_344", ["timestamp"], :name => "idx_timestamp_344"

  create_table "measurements_child_345", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_345", ["timestamp"], :name => "idx_timestamp_345"

  create_table "measurements_child_346", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_346", ["timestamp"], :name => "idx_timestamp_346"

  create_table "measurements_child_347", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_347", ["timestamp"], :name => "idx_timestamp_347"

  create_table "measurements_child_348", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_348", ["timestamp"], :name => "idx_timestamp_348"

  create_table "measurements_child_349", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_349", ["timestamp"], :name => "idx_timestamp_349"

  create_table "measurements_child_35", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_35", ["timestamp"], :name => "idx_timestamp_35"

  create_table "measurements_child_350", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_350", ["timestamp"], :name => "idx_timestamp_350"

  create_table "measurements_child_351", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_351", ["timestamp"], :name => "idx_timestamp_351"

  create_table "measurements_child_352", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_352", ["timestamp"], :name => "idx_timestamp_352"

  create_table "measurements_child_353", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_353", ["timestamp"], :name => "idx_timestamp_353"

  create_table "measurements_child_354", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_354", ["timestamp"], :name => "idx_timestamp_354"

  create_table "measurements_child_355", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_355", ["timestamp"], :name => "idx_timestamp_355"

  create_table "measurements_child_356", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_356", ["timestamp"], :name => "idx_timestamp_356"

  create_table "measurements_child_357", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_357", ["timestamp"], :name => "idx_timestamp_357"

  create_table "measurements_child_358", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_358", ["timestamp"], :name => "idx_timestamp_358"

  create_table "measurements_child_359", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_359", ["timestamp"], :name => "idx_timestamp_359"

  create_table "measurements_child_36", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_36", ["timestamp"], :name => "idx_timestamp_36"

  create_table "measurements_child_360", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_360", ["timestamp"], :name => "idx_timestamp_360"

  create_table "measurements_child_361", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_361", ["timestamp"], :name => "idx_timestamp_361"

  create_table "measurements_child_362", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_362", ["timestamp"], :name => "idx_timestamp_362"

  create_table "measurements_child_363", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_363", ["timestamp"], :name => "idx_timestamp_363"

  create_table "measurements_child_364", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_364", ["timestamp"], :name => "idx_timestamp_364"

  create_table "measurements_child_365", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_365", ["timestamp"], :name => "idx_timestamp_365"

  create_table "measurements_child_366", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_366", ["timestamp"], :name => "idx_timestamp_366"

  create_table "measurements_child_367", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_367", ["timestamp"], :name => "idx_timestamp_367"

  create_table "measurements_child_368", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_368", ["timestamp"], :name => "idx_timestamp_368"

  create_table "measurements_child_369", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_369", ["timestamp"], :name => "idx_timestamp_369"

  create_table "measurements_child_37", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_37", ["timestamp"], :name => "idx_timestamp_37"

  create_table "measurements_child_370", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_370", ["timestamp"], :name => "idx_timestamp_370"

  create_table "measurements_child_371", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_371", ["timestamp"], :name => "idx_timestamp_371"

  create_table "measurements_child_372", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_372", ["timestamp"], :name => "idx_timestamp_372"

  create_table "measurements_child_373", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_373", ["timestamp"], :name => "idx_timestamp_373"

  create_table "measurements_child_374", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_374", ["timestamp"], :name => "idx_timestamp_374"

  create_table "measurements_child_375", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_375", ["timestamp"], :name => "idx_timestamp_375"

  create_table "measurements_child_376", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_376", ["timestamp"], :name => "idx_timestamp_376"

  create_table "measurements_child_377", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_377", ["timestamp"], :name => "idx_timestamp_377"

  create_table "measurements_child_378", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_378", ["timestamp"], :name => "idx_timestamp_378"

  create_table "measurements_child_379", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_379", ["timestamp"], :name => "idx_timestamp_379"

  create_table "measurements_child_38", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_38", ["timestamp"], :name => "idx_timestamp_38"

  create_table "measurements_child_380", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_380", ["timestamp"], :name => "idx_timestamp_380"

  create_table "measurements_child_381", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_381", ["timestamp"], :name => "idx_timestamp_381"

  create_table "measurements_child_382", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_382", ["timestamp"], :name => "idx_timestamp_382"

  create_table "measurements_child_383", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_383", ["timestamp"], :name => "idx_timestamp_383"

  create_table "measurements_child_384", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_384", ["timestamp"], :name => "idx_timestamp_384"

  create_table "measurements_child_385", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_385", ["timestamp"], :name => "idx_timestamp_385"

  create_table "measurements_child_386", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_386", ["timestamp"], :name => "idx_timestamp_386"

  create_table "measurements_child_387", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_387", ["timestamp"], :name => "idx_timestamp_387"

  create_table "measurements_child_388", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_388", ["timestamp"], :name => "idx_timestamp_388"

  create_table "measurements_child_389", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_389", ["timestamp"], :name => "idx_timestamp_389"

  create_table "measurements_child_39", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_39", ["timestamp"], :name => "idx_timestamp_39"

  create_table "measurements_child_390", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_390", ["timestamp"], :name => "idx_timestamp_390"

  create_table "measurements_child_391", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_391", ["timestamp"], :name => "idx_timestamp_391"

  create_table "measurements_child_392", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_392", ["timestamp"], :name => "idx_timestamp_392"

  create_table "measurements_child_393", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_393", ["timestamp"], :name => "idx_timestamp_393"

  create_table "measurements_child_394", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_394", ["timestamp"], :name => "idx_timestamp_394"

  create_table "measurements_child_395", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_395", ["timestamp"], :name => "idx_timestamp_395"

  create_table "measurements_child_396", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_396", ["timestamp"], :name => "idx_timestamp_396"

  create_table "measurements_child_397", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_397", ["timestamp"], :name => "idx_timestamp_397"

  create_table "measurements_child_398", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_398", ["timestamp"], :name => "idx_timestamp_398"

  create_table "measurements_child_399", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_399", ["timestamp"], :name => "idx_timestamp_399"

  create_table "measurements_child_4", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_4", ["timestamp"], :name => "idx_timestamp_4"

  create_table "measurements_child_40", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_40", ["timestamp"], :name => "idx_timestamp_40"

  create_table "measurements_child_400", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_400", ["timestamp"], :name => "idx_timestamp_400"

  create_table "measurements_child_401", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_401", ["timestamp"], :name => "idx_timestamp_401"

  create_table "measurements_child_402", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_402", ["timestamp"], :name => "idx_timestamp_402"

  create_table "measurements_child_403", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_403", ["timestamp"], :name => "idx_timestamp_403"

  create_table "measurements_child_404", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_404", ["timestamp"], :name => "idx_timestamp_404"

  create_table "measurements_child_405", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_405", ["timestamp"], :name => "idx_timestamp_405"

  create_table "measurements_child_406", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_406", ["timestamp"], :name => "idx_timestamp_406"

  create_table "measurements_child_407", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_407", ["timestamp"], :name => "idx_timestamp_407"

  create_table "measurements_child_408", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_408", ["timestamp"], :name => "idx_timestamp_408"

  create_table "measurements_child_409", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_409", ["timestamp"], :name => "idx_timestamp_409"

  create_table "measurements_child_41", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_41", ["timestamp"], :name => "idx_timestamp_41"

  create_table "measurements_child_410", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_410", ["timestamp"], :name => "idx_timestamp_410"

  create_table "measurements_child_411", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_411", ["timestamp"], :name => "idx_timestamp_411"

  create_table "measurements_child_412", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_412", ["timestamp"], :name => "idx_timestamp_412"

  create_table "measurements_child_413", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_413", ["timestamp"], :name => "idx_timestamp_413"

  create_table "measurements_child_414", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_414", ["timestamp"], :name => "idx_timestamp_414"

  create_table "measurements_child_415", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_415", ["timestamp"], :name => "idx_timestamp_415"

  create_table "measurements_child_416", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_416", ["timestamp"], :name => "idx_timestamp_416"

  create_table "measurements_child_417", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_417", ["timestamp"], :name => "idx_timestamp_417"

  create_table "measurements_child_418", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_418", ["timestamp"], :name => "idx_timestamp_418"

  create_table "measurements_child_419", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_419", ["timestamp"], :name => "idx_timestamp_419"

  create_table "measurements_child_42", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_42", ["timestamp"], :name => "idx_timestamp_42"

  create_table "measurements_child_420", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_420", ["timestamp"], :name => "idx_timestamp_420"

  create_table "measurements_child_421", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_421", ["timestamp"], :name => "idx_timestamp_421"

  create_table "measurements_child_422", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_422", ["timestamp"], :name => "idx_timestamp_422"

  create_table "measurements_child_423", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_423", ["timestamp"], :name => "idx_timestamp_423"

  create_table "measurements_child_424", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_424", ["timestamp"], :name => "idx_timestamp_424"

  create_table "measurements_child_425", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_425", ["timestamp"], :name => "idx_timestamp_425"

  create_table "measurements_child_426", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_426", ["timestamp"], :name => "idx_timestamp_426"

  create_table "measurements_child_427", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_427", ["timestamp"], :name => "idx_timestamp_427"

  create_table "measurements_child_428", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_428", ["timestamp"], :name => "idx_timestamp_428"

  create_table "measurements_child_429", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_429", ["timestamp"], :name => "idx_timestamp_429"

  create_table "measurements_child_43", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_43", ["timestamp"], :name => "idx_timestamp_43"

  create_table "measurements_child_430", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_430", ["timestamp"], :name => "idx_timestamp_430"

  create_table "measurements_child_431", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_431", ["timestamp"], :name => "idx_timestamp_431"

  create_table "measurements_child_432", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_432", ["timestamp"], :name => "idx_timestamp_432"

  create_table "measurements_child_433", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_433", ["timestamp"], :name => "idx_timestamp_433"

  create_table "measurements_child_434", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_434", ["timestamp"], :name => "idx_timestamp_434"

  create_table "measurements_child_435", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_435", ["timestamp"], :name => "idx_timestamp_435"

  create_table "measurements_child_436", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_436", ["timestamp"], :name => "idx_timestamp_436"

  create_table "measurements_child_437", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_437", ["timestamp"], :name => "idx_timestamp_437"

  create_table "measurements_child_438", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_438", ["timestamp"], :name => "idx_timestamp_438"

  create_table "measurements_child_439", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_439", ["timestamp"], :name => "idx_timestamp_439"

  create_table "measurements_child_44", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_44", ["timestamp"], :name => "idx_timestamp_44"

  create_table "measurements_child_440", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_440", ["timestamp"], :name => "idx_timestamp_440"

  create_table "measurements_child_441", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_441", ["timestamp"], :name => "idx_timestamp_441"

  create_table "measurements_child_442", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_442", ["timestamp"], :name => "idx_timestamp_442"

  create_table "measurements_child_443", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_443", ["timestamp"], :name => "idx_timestamp_443"

  create_table "measurements_child_444", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_444", ["timestamp"], :name => "idx_timestamp_444"

  create_table "measurements_child_445", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_445", ["timestamp"], :name => "idx_timestamp_445"

  create_table "measurements_child_446", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_446", ["timestamp"], :name => "idx_timestamp_446"

  create_table "measurements_child_447", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_447", ["timestamp"], :name => "idx_timestamp_447"

  create_table "measurements_child_448", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_448", ["timestamp"], :name => "idx_timestamp_448"

  create_table "measurements_child_449", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_449", ["timestamp"], :name => "idx_timestamp_449"

  create_table "measurements_child_45", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_45", ["timestamp"], :name => "idx_timestamp_45"

  create_table "measurements_child_450", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_450", ["timestamp"], :name => "idx_timestamp_450"

  create_table "measurements_child_451", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_451", ["timestamp"], :name => "idx_timestamp_451"

  create_table "measurements_child_452", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_452", ["timestamp"], :name => "idx_timestamp_452"

  create_table "measurements_child_453", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_453", ["timestamp"], :name => "idx_timestamp_453"

  create_table "measurements_child_454", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_454", ["timestamp"], :name => "idx_timestamp_454"

  create_table "measurements_child_455", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_455", ["timestamp"], :name => "idx_timestamp_455"

  create_table "measurements_child_456", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_456", ["timestamp"], :name => "idx_timestamp_456"

  create_table "measurements_child_457", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_457", ["timestamp"], :name => "idx_timestamp_457"

  create_table "measurements_child_458", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_458", ["timestamp"], :name => "idx_timestamp_458"

  create_table "measurements_child_459", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_459", ["timestamp"], :name => "idx_timestamp_459"

  create_table "measurements_child_46", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_46", ["timestamp"], :name => "idx_timestamp_46"

  create_table "measurements_child_460", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_460", ["timestamp"], :name => "idx_timestamp_460"

  create_table "measurements_child_461", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_461", ["timestamp"], :name => "idx_timestamp_461"

  create_table "measurements_child_462", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_462", ["timestamp"], :name => "idx_timestamp_462"

  create_table "measurements_child_463", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_463", ["timestamp"], :name => "idx_timestamp_463"

  create_table "measurements_child_464", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_464", ["timestamp"], :name => "idx_timestamp_464"

  create_table "measurements_child_465", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_465", ["timestamp"], :name => "idx_timestamp_465"

  create_table "measurements_child_466", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_466", ["timestamp"], :name => "idx_timestamp_466"

  create_table "measurements_child_467", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_467", ["timestamp"], :name => "idx_timestamp_467"

  create_table "measurements_child_468", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_468", ["timestamp"], :name => "idx_timestamp_468"

  create_table "measurements_child_469", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_469", ["timestamp"], :name => "idx_timestamp_469"

  create_table "measurements_child_47", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_47", ["timestamp"], :name => "idx_timestamp_47"

  create_table "measurements_child_470", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_470", ["timestamp"], :name => "idx_timestamp_470"

  create_table "measurements_child_471", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_471", ["timestamp"], :name => "idx_timestamp_471"

  create_table "measurements_child_472", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_472", ["timestamp"], :name => "idx_timestamp_472"

  create_table "measurements_child_473", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_473", ["timestamp"], :name => "idx_timestamp_473"

  create_table "measurements_child_474", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_474", ["timestamp"], :name => "idx_timestamp_474"

  create_table "measurements_child_475", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_475", ["timestamp"], :name => "idx_timestamp_475"

  create_table "measurements_child_476", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_476", ["timestamp"], :name => "idx_timestamp_476"

  create_table "measurements_child_477", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_477", ["timestamp"], :name => "idx_timestamp_477"

  create_table "measurements_child_478", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_478", ["timestamp"], :name => "idx_timestamp_478"

  create_table "measurements_child_479", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_479", ["timestamp"], :name => "idx_timestamp_479"

  create_table "measurements_child_48", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_48", ["timestamp"], :name => "idx_timestamp_48"

  create_table "measurements_child_480", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_480", ["timestamp"], :name => "idx_timestamp_480"

  create_table "measurements_child_481", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_481", ["timestamp"], :name => "idx_timestamp_481"

  create_table "measurements_child_482", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_482", ["timestamp"], :name => "idx_timestamp_482"

  create_table "measurements_child_483", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_483", ["timestamp"], :name => "idx_timestamp_483"

  create_table "measurements_child_484", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_484", ["timestamp"], :name => "idx_timestamp_484"

  create_table "measurements_child_485", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_485", ["timestamp"], :name => "idx_timestamp_485"

  create_table "measurements_child_486", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_486", ["timestamp"], :name => "idx_timestamp_486"

  create_table "measurements_child_487", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_487", ["timestamp"], :name => "idx_timestamp_487"

  create_table "measurements_child_488", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_488", ["timestamp"], :name => "idx_timestamp_488"

  create_table "measurements_child_489", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_489", ["timestamp"], :name => "idx_timestamp_489"

  create_table "measurements_child_49", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_49", ["timestamp"], :name => "idx_timestamp_49"

  create_table "measurements_child_490", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_490", ["timestamp"], :name => "idx_timestamp_490"

  create_table "measurements_child_491", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_491", ["timestamp"], :name => "idx_timestamp_491"

  create_table "measurements_child_492", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_492", ["timestamp"], :name => "idx_timestamp_492"

  create_table "measurements_child_493", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_493", ["timestamp"], :name => "idx_timestamp_493"

  create_table "measurements_child_494", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_494", ["timestamp"], :name => "idx_timestamp_494"

  create_table "measurements_child_495", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_495", ["timestamp"], :name => "idx_timestamp_495"

  create_table "measurements_child_496", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_496", ["timestamp"], :name => "idx_timestamp_496"

  create_table "measurements_child_497", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_497", ["timestamp"], :name => "idx_timestamp_497"

  create_table "measurements_child_498", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_498", ["timestamp"], :name => "idx_timestamp_498"

  create_table "measurements_child_499", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_499", ["timestamp"], :name => "idx_timestamp_499"

  create_table "measurements_child_5", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_5", ["timestamp"], :name => "idx_timestamp_5"

  create_table "measurements_child_50", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_50", ["timestamp"], :name => "idx_timestamp_50"

  create_table "measurements_child_500", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_500", ["timestamp"], :name => "idx_timestamp_500"

  create_table "measurements_child_501", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_501", ["timestamp"], :name => "idx_timestamp_501"

  create_table "measurements_child_502", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_502", ["timestamp"], :name => "idx_timestamp_502"

  create_table "measurements_child_503", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_503", ["timestamp"], :name => "idx_timestamp_503"

  create_table "measurements_child_504", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_504", ["timestamp"], :name => "idx_timestamp_504"

  create_table "measurements_child_505", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_505", ["timestamp"], :name => "idx_timestamp_505"

  create_table "measurements_child_506", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_506", ["timestamp"], :name => "idx_timestamp_506"

  create_table "measurements_child_507", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_507", ["timestamp"], :name => "idx_timestamp_507"

  create_table "measurements_child_508", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_508", ["timestamp"], :name => "idx_timestamp_508"

  create_table "measurements_child_509", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_509", ["timestamp"], :name => "idx_timestamp_509"

  create_table "measurements_child_51", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_51", ["timestamp"], :name => "idx_timestamp_51"

  create_table "measurements_child_510", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_510", ["timestamp"], :name => "idx_timestamp_510"

  create_table "measurements_child_511", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_511", ["timestamp"], :name => "idx_timestamp_511"

  create_table "measurements_child_512", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_512", ["timestamp"], :name => "idx_timestamp_512"

  create_table "measurements_child_513", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_513", ["timestamp"], :name => "idx_timestamp_513"

  create_table "measurements_child_514", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_514", ["timestamp"], :name => "idx_timestamp_514"

  create_table "measurements_child_515", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_515", ["timestamp"], :name => "idx_timestamp_515"

  create_table "measurements_child_516", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_516", ["timestamp"], :name => "idx_timestamp_516"

  create_table "measurements_child_517", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_517", ["timestamp"], :name => "idx_timestamp_517"

  create_table "measurements_child_518", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_518", ["timestamp"], :name => "idx_timestamp_518"

  create_table "measurements_child_519", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_519", ["timestamp"], :name => "idx_timestamp_519"

  create_table "measurements_child_52", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_52", ["timestamp"], :name => "idx_timestamp_52"

  create_table "measurements_child_520", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_520", ["timestamp"], :name => "idx_timestamp_520"

  create_table "measurements_child_521", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_521", ["timestamp"], :name => "idx_timestamp_521"

  create_table "measurements_child_522", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_522", ["timestamp"], :name => "idx_timestamp_522"

  create_table "measurements_child_523", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_523", ["timestamp"], :name => "idx_timestamp_523"

  create_table "measurements_child_524", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_524", ["timestamp"], :name => "idx_timestamp_524"

  create_table "measurements_child_525", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_525", ["timestamp"], :name => "idx_timestamp_525"

  create_table "measurements_child_526", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_526", ["timestamp"], :name => "idx_timestamp_526"

  create_table "measurements_child_527", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_527", ["timestamp"], :name => "idx_timestamp_527"

  create_table "measurements_child_528", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_528", ["timestamp"], :name => "idx_timestamp_528"

  create_table "measurements_child_529", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_529", ["timestamp"], :name => "idx_timestamp_529"

  create_table "measurements_child_53", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_53", ["timestamp"], :name => "idx_timestamp_53"

  create_table "measurements_child_530", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_530", ["timestamp"], :name => "idx_timestamp_530"

  create_table "measurements_child_531", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_531", ["timestamp"], :name => "idx_timestamp_531"

  create_table "measurements_child_532", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_532", ["timestamp"], :name => "idx_timestamp_532"

  create_table "measurements_child_533", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_533", ["timestamp"], :name => "idx_timestamp_533"

  create_table "measurements_child_534", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_534", ["timestamp"], :name => "idx_timestamp_534"

  create_table "measurements_child_535", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_535", ["timestamp"], :name => "idx_timestamp_535"

  create_table "measurements_child_536", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_536", ["timestamp"], :name => "idx_timestamp_536"

  create_table "measurements_child_537", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_537", ["timestamp"], :name => "idx_timestamp_537"

  create_table "measurements_child_538", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_538", ["timestamp"], :name => "idx_timestamp_538"

  create_table "measurements_child_539", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_539", ["timestamp"], :name => "idx_timestamp_539"

  create_table "measurements_child_54", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_54", ["timestamp"], :name => "idx_timestamp_54"

  create_table "measurements_child_540", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_540", ["timestamp"], :name => "idx_timestamp_540"

  create_table "measurements_child_541", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_541", ["timestamp"], :name => "idx_timestamp_541"

  create_table "measurements_child_542", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_542", ["timestamp"], :name => "idx_timestamp_542"

  create_table "measurements_child_543", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_543", ["timestamp"], :name => "idx_timestamp_543"

  create_table "measurements_child_544", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_544", ["timestamp"], :name => "idx_timestamp_544"

  create_table "measurements_child_545", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_545", ["timestamp"], :name => "idx_timestamp_545"

  create_table "measurements_child_546", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_546", ["timestamp"], :name => "idx_timestamp_546"

  create_table "measurements_child_547", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_547", ["timestamp"], :name => "idx_timestamp_547"

  create_table "measurements_child_548", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_548", ["timestamp"], :name => "idx_timestamp_548"

  create_table "measurements_child_549", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_549", ["timestamp"], :name => "idx_timestamp_549"

  create_table "measurements_child_55", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_55", ["timestamp"], :name => "idx_timestamp_55"

  create_table "measurements_child_550", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_550", ["timestamp"], :name => "idx_timestamp_550"

  create_table "measurements_child_551", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_551", ["timestamp"], :name => "idx_timestamp_551"

  create_table "measurements_child_552", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_552", ["timestamp"], :name => "idx_timestamp_552"

  create_table "measurements_child_553", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_553", ["timestamp"], :name => "idx_timestamp_553"

  create_table "measurements_child_554", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_554", ["timestamp"], :name => "idx_timestamp_554"

  create_table "measurements_child_555", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_555", ["timestamp"], :name => "idx_timestamp_555"

  create_table "measurements_child_556", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_556", ["timestamp"], :name => "idx_timestamp_556"

  create_table "measurements_child_557", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_557", ["timestamp"], :name => "idx_timestamp_557"

  create_table "measurements_child_558", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_558", ["timestamp"], :name => "idx_timestamp_558"

  create_table "measurements_child_559", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_559", ["timestamp"], :name => "idx_timestamp_559"

  create_table "measurements_child_56", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_56", ["timestamp"], :name => "idx_timestamp_56"

  create_table "measurements_child_560", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_560", ["timestamp"], :name => "idx_timestamp_560"

  create_table "measurements_child_561", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_561", ["timestamp"], :name => "idx_timestamp_561"

  create_table "measurements_child_562", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_562", ["timestamp"], :name => "idx_timestamp_562"

  create_table "measurements_child_563", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_563", ["timestamp"], :name => "idx_timestamp_563"

  create_table "measurements_child_564", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_564", ["timestamp"], :name => "idx_timestamp_564"

  create_table "measurements_child_565", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_565", ["timestamp"], :name => "idx_timestamp_565"

  create_table "measurements_child_566", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_566", ["timestamp"], :name => "idx_timestamp_566"

  create_table "measurements_child_567", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_567", ["timestamp"], :name => "idx_timestamp_567"

  create_table "measurements_child_568", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_568", ["timestamp"], :name => "idx_timestamp_568"

  create_table "measurements_child_569", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_569", ["timestamp"], :name => "idx_timestamp_569"

  create_table "measurements_child_57", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_57", ["timestamp"], :name => "idx_timestamp_57"

  create_table "measurements_child_570", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_570", ["timestamp"], :name => "idx_timestamp_570"

  create_table "measurements_child_571", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_571", ["timestamp"], :name => "idx_timestamp_571"

  create_table "measurements_child_572", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_572", ["timestamp"], :name => "idx_timestamp_572"

  create_table "measurements_child_573", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_573", ["timestamp"], :name => "idx_timestamp_573"

  create_table "measurements_child_574", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_574", ["timestamp"], :name => "idx_timestamp_574"

  create_table "measurements_child_575", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_575", ["timestamp"], :name => "idx_timestamp_575"

  create_table "measurements_child_576", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_576", ["timestamp"], :name => "idx_timestamp_576"

  create_table "measurements_child_577", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_577", ["timestamp"], :name => "idx_timestamp_577"

  create_table "measurements_child_578", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_578", ["timestamp"], :name => "idx_timestamp_578"

  create_table "measurements_child_579", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_579", ["timestamp"], :name => "idx_timestamp_579"

  create_table "measurements_child_58", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_58", ["timestamp"], :name => "idx_timestamp_58"

  create_table "measurements_child_580", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_580", ["timestamp"], :name => "idx_timestamp_580"

  create_table "measurements_child_581", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_581", ["timestamp"], :name => "idx_timestamp_581"

  create_table "measurements_child_582", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_582", ["timestamp"], :name => "idx_timestamp_582"

  create_table "measurements_child_583", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_583", ["timestamp"], :name => "idx_timestamp_583"

  create_table "measurements_child_584", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_584", ["timestamp"], :name => "idx_timestamp_584"

  create_table "measurements_child_585", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_585", ["timestamp"], :name => "idx_timestamp_585"

  create_table "measurements_child_586", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_586", ["timestamp"], :name => "idx_timestamp_586"

  create_table "measurements_child_587", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_587", ["timestamp"], :name => "idx_timestamp_587"

  create_table "measurements_child_588", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_588", ["timestamp"], :name => "idx_timestamp_588"

  create_table "measurements_child_589", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_589", ["timestamp"], :name => "idx_timestamp_589"

  create_table "measurements_child_59", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_59", ["timestamp"], :name => "idx_timestamp_59"

  create_table "measurements_child_590", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_590", ["timestamp"], :name => "idx_timestamp_590"

  create_table "measurements_child_591", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_591", ["timestamp"], :name => "idx_timestamp_591"

  create_table "measurements_child_592", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_592", ["timestamp"], :name => "idx_timestamp_592"

  create_table "measurements_child_593", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_593", ["timestamp"], :name => "idx_timestamp_593"

  create_table "measurements_child_594", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_594", ["timestamp"], :name => "idx_timestamp_594"

  create_table "measurements_child_595", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_595", ["timestamp"], :name => "idx_timestamp_595"

  create_table "measurements_child_596", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_596", ["timestamp"], :name => "idx_timestamp_596"

  create_table "measurements_child_597", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_597", ["timestamp"], :name => "idx_timestamp_597"

  create_table "measurements_child_598", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_598", ["timestamp"], :name => "idx_timestamp_598"

  create_table "measurements_child_599", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_599", ["timestamp"], :name => "idx_timestamp_599"

  create_table "measurements_child_6", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_6", ["timestamp"], :name => "idx_timestamp_6"

  create_table "measurements_child_60", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_60", ["timestamp"], :name => "idx_timestamp_60"

  create_table "measurements_child_600", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_600", ["timestamp"], :name => "idx_timestamp_600"

  create_table "measurements_child_601", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_601", ["timestamp"], :name => "idx_timestamp_601"

  create_table "measurements_child_602", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_602", ["timestamp"], :name => "idx_timestamp_602"

  create_table "measurements_child_603", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_603", ["timestamp"], :name => "idx_timestamp_603"

  create_table "measurements_child_604", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_604", ["timestamp"], :name => "idx_timestamp_604"

  create_table "measurements_child_605", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_605", ["timestamp"], :name => "idx_timestamp_605"

  create_table "measurements_child_606", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_606", ["timestamp"], :name => "idx_timestamp_606"

  create_table "measurements_child_607", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_607", ["timestamp"], :name => "idx_timestamp_607"

  create_table "measurements_child_608", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_608", ["timestamp"], :name => "idx_timestamp_608"

  create_table "measurements_child_609", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_609", ["timestamp"], :name => "idx_timestamp_609"

  create_table "measurements_child_61", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_61", ["timestamp"], :name => "idx_timestamp_61"

  create_table "measurements_child_610", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_610", ["timestamp"], :name => "idx_timestamp_610"

  create_table "measurements_child_611", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_611", ["timestamp"], :name => "idx_timestamp_611"

  create_table "measurements_child_612", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_612", ["timestamp"], :name => "idx_timestamp_612"

  create_table "measurements_child_613", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_613", ["timestamp"], :name => "idx_timestamp_613"

  create_table "measurements_child_614", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_614", ["timestamp"], :name => "idx_timestamp_614"

  create_table "measurements_child_615", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_615", ["timestamp"], :name => "idx_timestamp_615"

  create_table "measurements_child_616", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_616", ["timestamp"], :name => "idx_timestamp_616"

  create_table "measurements_child_617", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_617", ["timestamp"], :name => "idx_timestamp_617"

  create_table "measurements_child_618", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_618", ["timestamp"], :name => "idx_timestamp_618"

  create_table "measurements_child_619", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_619", ["timestamp"], :name => "idx_timestamp_619"

  create_table "measurements_child_62", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_62", ["timestamp"], :name => "idx_timestamp_62"

  create_table "measurements_child_620", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_620", ["timestamp"], :name => "idx_timestamp_620"

  create_table "measurements_child_621", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_621", ["timestamp"], :name => "idx_timestamp_621"

  create_table "measurements_child_622", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_622", ["timestamp"], :name => "idx_timestamp_622"

  create_table "measurements_child_623", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_623", ["timestamp"], :name => "idx_timestamp_623"

  create_table "measurements_child_624", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_624", ["timestamp"], :name => "idx_timestamp_624"

  create_table "measurements_child_625", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_625", ["timestamp"], :name => "idx_timestamp_625"

  create_table "measurements_child_626", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_626", ["timestamp"], :name => "idx_timestamp_626"

  create_table "measurements_child_627", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_627", ["timestamp"], :name => "idx_timestamp_627"

  create_table "measurements_child_628", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_628", ["timestamp"], :name => "idx_timestamp_628"

  create_table "measurements_child_629", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_629", ["timestamp"], :name => "idx_timestamp_629"

  create_table "measurements_child_63", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_63", ["timestamp"], :name => "idx_timestamp_63"

  create_table "measurements_child_630", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_630", ["timestamp"], :name => "idx_timestamp_630"

  create_table "measurements_child_631", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_631", ["timestamp"], :name => "idx_timestamp_631"

  create_table "measurements_child_632", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_632", ["timestamp"], :name => "idx_timestamp_632"

  create_table "measurements_child_633", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_633", ["timestamp"], :name => "idx_timestamp_633"

  create_table "measurements_child_634", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_634", ["timestamp"], :name => "idx_timestamp_634"

  create_table "measurements_child_635", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_635", ["timestamp"], :name => "idx_timestamp_635"

  create_table "measurements_child_636", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_636", ["timestamp"], :name => "idx_timestamp_636"

  create_table "measurements_child_637", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_637", ["timestamp"], :name => "idx_timestamp_637"

  create_table "measurements_child_638", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_638", ["timestamp"], :name => "idx_timestamp_638"

  create_table "measurements_child_639", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_639", ["timestamp"], :name => "idx_timestamp_639"

  create_table "measurements_child_64", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_64", ["timestamp"], :name => "idx_timestamp_64"

  create_table "measurements_child_640", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_640", ["timestamp"], :name => "idx_timestamp_640"

  create_table "measurements_child_641", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_641", ["timestamp"], :name => "idx_timestamp_641"

  create_table "measurements_child_642", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_642", ["timestamp"], :name => "idx_timestamp_642"

  create_table "measurements_child_643", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_643", ["timestamp"], :name => "idx_timestamp_643"

  create_table "measurements_child_644", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_644", ["timestamp"], :name => "idx_timestamp_644"

  create_table "measurements_child_645", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_645", ["timestamp"], :name => "idx_timestamp_645"

  create_table "measurements_child_646", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_646", ["timestamp"], :name => "idx_timestamp_646"

  create_table "measurements_child_647", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_647", ["timestamp"], :name => "idx_timestamp_647"

  create_table "measurements_child_648", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_648", ["timestamp"], :name => "idx_timestamp_648"

  create_table "measurements_child_649", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_649", ["timestamp"], :name => "idx_timestamp_649"

  create_table "measurements_child_65", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_65", ["timestamp"], :name => "idx_timestamp_65"

  create_table "measurements_child_650", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_650", ["timestamp"], :name => "idx_timestamp_650"

  create_table "measurements_child_651", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_651", ["timestamp"], :name => "idx_timestamp_651"

  create_table "measurements_child_652", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_652", ["timestamp"], :name => "idx_timestamp_652"

  create_table "measurements_child_653", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_653", ["timestamp"], :name => "idx_timestamp_653"

  create_table "measurements_child_654", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_654", ["timestamp"], :name => "idx_timestamp_654"

  create_table "measurements_child_655", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_655", ["timestamp"], :name => "idx_timestamp_655"

  create_table "measurements_child_656", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_656", ["timestamp"], :name => "idx_timestamp_656"

  create_table "measurements_child_657", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_657", ["timestamp"], :name => "idx_timestamp_657"

  create_table "measurements_child_658", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_658", ["timestamp"], :name => "idx_timestamp_658"

  create_table "measurements_child_659", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_659", ["timestamp"], :name => "idx_timestamp_659"

  create_table "measurements_child_66", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_66", ["timestamp"], :name => "idx_timestamp_66"

  create_table "measurements_child_660", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_660", ["timestamp"], :name => "idx_timestamp_660"

  create_table "measurements_child_661", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_661", ["timestamp"], :name => "idx_timestamp_661"

  create_table "measurements_child_662", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_662", ["timestamp"], :name => "idx_timestamp_662"

  create_table "measurements_child_663", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_663", ["timestamp"], :name => "idx_timestamp_663"

  create_table "measurements_child_664", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_664", ["timestamp"], :name => "idx_timestamp_664"

  create_table "measurements_child_665", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_665", ["timestamp"], :name => "idx_timestamp_665"

  create_table "measurements_child_666", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_666", ["timestamp"], :name => "idx_timestamp_666"

  create_table "measurements_child_667", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_667", ["timestamp"], :name => "idx_timestamp_667"

  create_table "measurements_child_668", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_668", ["timestamp"], :name => "idx_timestamp_668"

  create_table "measurements_child_669", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_669", ["timestamp"], :name => "idx_timestamp_669"

  create_table "measurements_child_67", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_67", ["timestamp"], :name => "idx_timestamp_67"

  create_table "measurements_child_670", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_670", ["timestamp"], :name => "idx_timestamp_670"

  create_table "measurements_child_671", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_671", ["timestamp"], :name => "idx_timestamp_671"

  create_table "measurements_child_672", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_672", ["timestamp"], :name => "idx_timestamp_672"

  create_table "measurements_child_673", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_673", ["timestamp"], :name => "idx_timestamp_673"

  create_table "measurements_child_674", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_674", ["timestamp"], :name => "idx_timestamp_674"

  create_table "measurements_child_675", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_675", ["timestamp"], :name => "idx_timestamp_675"

  create_table "measurements_child_676", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_676", ["timestamp"], :name => "idx_timestamp_676"

  create_table "measurements_child_677", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_677", ["timestamp"], :name => "idx_timestamp_677"

  create_table "measurements_child_678", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_678", ["timestamp"], :name => "idx_timestamp_678"

  create_table "measurements_child_679", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_679", ["timestamp"], :name => "idx_timestamp_679"

  create_table "measurements_child_68", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_68", ["timestamp"], :name => "idx_timestamp_68"

  create_table "measurements_child_680", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_680", ["timestamp"], :name => "idx_timestamp_680"

  create_table "measurements_child_681", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_681", ["timestamp"], :name => "idx_timestamp_681"

  create_table "measurements_child_682", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_682", ["timestamp"], :name => "idx_timestamp_682"

  create_table "measurements_child_683", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_683", ["timestamp"], :name => "idx_timestamp_683"

  create_table "measurements_child_684", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_684", ["timestamp"], :name => "idx_timestamp_684"

  create_table "measurements_child_685", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_685", ["timestamp"], :name => "idx_timestamp_685"

  create_table "measurements_child_686", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_686", ["timestamp"], :name => "idx_timestamp_686"

  create_table "measurements_child_687", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_687", ["timestamp"], :name => "idx_timestamp_687"

  create_table "measurements_child_688", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_688", ["timestamp"], :name => "idx_timestamp_688"

  create_table "measurements_child_689", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_689", ["timestamp"], :name => "idx_timestamp_689"

  create_table "measurements_child_69", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_69", ["timestamp"], :name => "idx_timestamp_69"

  create_table "measurements_child_690", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_690", ["timestamp"], :name => "idx_timestamp_690"

  create_table "measurements_child_691", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_691", ["timestamp"], :name => "idx_timestamp_691"

  create_table "measurements_child_692", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_692", ["timestamp"], :name => "idx_timestamp_692"

  create_table "measurements_child_693", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_693", ["timestamp"], :name => "idx_timestamp_693"

  create_table "measurements_child_694", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_694", ["timestamp"], :name => "idx_timestamp_694"

  create_table "measurements_child_695", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_695", ["timestamp"], :name => "idx_timestamp_695"

  create_table "measurements_child_696", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_696", ["timestamp"], :name => "idx_timestamp_696"

  create_table "measurements_child_697", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_697", ["timestamp"], :name => "idx_timestamp_697"

  create_table "measurements_child_698", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_698", ["timestamp"], :name => "idx_timestamp_698"

  create_table "measurements_child_699", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_699", ["timestamp"], :name => "idx_timestamp_699"

  create_table "measurements_child_7", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_7", ["timestamp"], :name => "idx_timestamp_7"

  create_table "measurements_child_70", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_70", ["timestamp"], :name => "idx_timestamp_70"

  create_table "measurements_child_700", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_700", ["timestamp"], :name => "idx_timestamp_700"

  create_table "measurements_child_701", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_701", ["timestamp"], :name => "idx_timestamp_701"

  create_table "measurements_child_702", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_702", ["timestamp"], :name => "idx_timestamp_702"

  create_table "measurements_child_703", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_703", ["timestamp"], :name => "idx_timestamp_703"

  create_table "measurements_child_704", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_704", ["timestamp"], :name => "idx_timestamp_704"

  create_table "measurements_child_705", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_705", ["timestamp"], :name => "idx_timestamp_705"

  create_table "measurements_child_706", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_706", ["timestamp"], :name => "idx_timestamp_706"

  create_table "measurements_child_707", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_707", ["timestamp"], :name => "idx_timestamp_707"

  create_table "measurements_child_708", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_708", ["timestamp"], :name => "idx_timestamp_708"

  create_table "measurements_child_709", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_709", ["timestamp"], :name => "idx_timestamp_709"

  create_table "measurements_child_71", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_71", ["timestamp"], :name => "idx_timestamp_71"

  create_table "measurements_child_710", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_710", ["timestamp"], :name => "idx_timestamp_710"

  create_table "measurements_child_711", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_711", ["timestamp"], :name => "idx_timestamp_711"

  create_table "measurements_child_712", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_712", ["timestamp"], :name => "idx_timestamp_712"

  create_table "measurements_child_713", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_713", ["timestamp"], :name => "idx_timestamp_713"

  create_table "measurements_child_714", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_714", ["timestamp"], :name => "idx_timestamp_714"

  create_table "measurements_child_715", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_715", ["timestamp"], :name => "idx_timestamp_715"

  create_table "measurements_child_716", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_716", ["timestamp"], :name => "idx_timestamp_716"

  create_table "measurements_child_717", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_717", ["timestamp"], :name => "idx_timestamp_717"

  create_table "measurements_child_718", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_718", ["timestamp"], :name => "idx_timestamp_718"

  create_table "measurements_child_719", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_719", ["timestamp"], :name => "idx_timestamp_719"

  create_table "measurements_child_72", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_72", ["timestamp"], :name => "idx_timestamp_72"

  create_table "measurements_child_720", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_720", ["timestamp"], :name => "idx_timestamp_720"

  create_table "measurements_child_721", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_721", ["timestamp"], :name => "idx_timestamp_721"

  create_table "measurements_child_722", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_722", ["timestamp"], :name => "idx_timestamp_722"

  create_table "measurements_child_723", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_723", ["timestamp"], :name => "idx_timestamp_723"

  create_table "measurements_child_724", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_724", ["timestamp"], :name => "idx_timestamp_724"

  create_table "measurements_child_725", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_725", ["timestamp"], :name => "idx_timestamp_725"

  create_table "measurements_child_726", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_726", ["timestamp"], :name => "idx_timestamp_726"

  create_table "measurements_child_727", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_727", ["timestamp"], :name => "idx_timestamp_727"

  create_table "measurements_child_728", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_728", ["timestamp"], :name => "idx_timestamp_728"

  create_table "measurements_child_729", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_729", ["timestamp"], :name => "idx_timestamp_729"

  create_table "measurements_child_73", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_73", ["timestamp"], :name => "idx_timestamp_73"

  create_table "measurements_child_730", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_730", ["timestamp"], :name => "idx_timestamp_730"

  create_table "measurements_child_731", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_731", ["timestamp"], :name => "idx_timestamp_731"

  create_table "measurements_child_732", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_732", ["timestamp"], :name => "idx_timestamp_732"

  create_table "measurements_child_733", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_733", ["timestamp"], :name => "idx_timestamp_733"

  create_table "measurements_child_734", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_734", ["timestamp"], :name => "idx_timestamp_734"

  create_table "measurements_child_735", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_735", ["timestamp"], :name => "idx_timestamp_735"

  create_table "measurements_child_736", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_736", ["timestamp"], :name => "idx_timestamp_736"

  create_table "measurements_child_737", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_737", ["timestamp"], :name => "idx_timestamp_737"

  create_table "measurements_child_738", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_738", ["timestamp"], :name => "idx_timestamp_738"

  create_table "measurements_child_739", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_739", ["timestamp"], :name => "idx_timestamp_739"

  create_table "measurements_child_74", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_74", ["timestamp"], :name => "idx_timestamp_74"

  create_table "measurements_child_740", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_740", ["timestamp"], :name => "idx_timestamp_740"

  create_table "measurements_child_741", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_741", ["timestamp"], :name => "idx_timestamp_741"

  create_table "measurements_child_742", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_742", ["timestamp"], :name => "idx_timestamp_742"

  create_table "measurements_child_743", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_743", ["timestamp"], :name => "idx_timestamp_743"

  create_table "measurements_child_744", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_744", ["timestamp"], :name => "idx_timestamp_744"

  create_table "measurements_child_745", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_745", ["timestamp"], :name => "idx_timestamp_745"

  create_table "measurements_child_746", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_746", ["timestamp"], :name => "idx_timestamp_746"

  create_table "measurements_child_747", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_747", ["timestamp"], :name => "idx_timestamp_747"

  create_table "measurements_child_748", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_748", ["timestamp"], :name => "idx_timestamp_748"

  create_table "measurements_child_749", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_749", ["timestamp"], :name => "idx_timestamp_749"

  create_table "measurements_child_75", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_75", ["timestamp"], :name => "idx_timestamp_75"

  create_table "measurements_child_750", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_750", ["timestamp"], :name => "idx_timestamp_750"

  create_table "measurements_child_751", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_751", ["timestamp"], :name => "idx_timestamp_751"

  create_table "measurements_child_752", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_752", ["timestamp"], :name => "idx_timestamp_752"

  create_table "measurements_child_753", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_753", ["timestamp"], :name => "idx_timestamp_753"

  create_table "measurements_child_754", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_754", ["timestamp"], :name => "idx_timestamp_754"

  create_table "measurements_child_755", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_755", ["timestamp"], :name => "idx_timestamp_755"

  create_table "measurements_child_756", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_756", ["timestamp"], :name => "idx_timestamp_756"

  create_table "measurements_child_757", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_757", ["timestamp"], :name => "idx_timestamp_757"

  create_table "measurements_child_758", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_758", ["timestamp"], :name => "idx_timestamp_758"

  create_table "measurements_child_759", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_759", ["timestamp"], :name => "idx_timestamp_759"

  create_table "measurements_child_76", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_76", ["timestamp"], :name => "idx_timestamp_76"

  create_table "measurements_child_760", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_760", ["timestamp"], :name => "idx_timestamp_760"

  create_table "measurements_child_761", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_761", ["timestamp"], :name => "idx_timestamp_761"

  create_table "measurements_child_762", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_762", ["timestamp"], :name => "idx_timestamp_762"

  create_table "measurements_child_763", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_763", ["timestamp"], :name => "idx_timestamp_763"

  create_table "measurements_child_764", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_764", ["timestamp"], :name => "idx_timestamp_764"

  create_table "measurements_child_765", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_765", ["timestamp"], :name => "idx_timestamp_765"

  create_table "measurements_child_766", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_766", ["timestamp"], :name => "idx_timestamp_766"

  create_table "measurements_child_767", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_767", ["timestamp"], :name => "idx_timestamp_767"

  create_table "measurements_child_768", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_768", ["timestamp"], :name => "idx_timestamp_768"

  create_table "measurements_child_769", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_769", ["timestamp"], :name => "idx_timestamp_769"

  create_table "measurements_child_77", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_77", ["timestamp"], :name => "idx_timestamp_77"

  create_table "measurements_child_770", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_770", ["timestamp"], :name => "idx_timestamp_770"

  create_table "measurements_child_771", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_771", ["timestamp"], :name => "idx_timestamp_771"

  create_table "measurements_child_772", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_772", ["timestamp"], :name => "idx_timestamp_772"

  create_table "measurements_child_773", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_773", ["timestamp"], :name => "idx_timestamp_773"

  create_table "measurements_child_774", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_774", ["timestamp"], :name => "idx_timestamp_774"

  create_table "measurements_child_775", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_775", ["timestamp"], :name => "idx_timestamp_775"

  create_table "measurements_child_776", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_776", ["timestamp"], :name => "idx_timestamp_776"

  create_table "measurements_child_777", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_777", ["timestamp"], :name => "idx_timestamp_777"

  create_table "measurements_child_778", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_778", ["timestamp"], :name => "idx_timestamp_778"

  create_table "measurements_child_779", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_779", ["timestamp"], :name => "idx_timestamp_779"

  create_table "measurements_child_78", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_78", ["timestamp"], :name => "idx_timestamp_78"

  create_table "measurements_child_780", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_780", ["timestamp"], :name => "idx_timestamp_780"

  create_table "measurements_child_781", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_781", ["timestamp"], :name => "idx_timestamp_781"

  create_table "measurements_child_782", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_782", ["timestamp"], :name => "idx_timestamp_782"

  create_table "measurements_child_783", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_783", ["timestamp"], :name => "idx_timestamp_783"

  create_table "measurements_child_784", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_784", ["timestamp"], :name => "idx_timestamp_784"

  create_table "measurements_child_785", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_785", ["timestamp"], :name => "idx_timestamp_785"

  create_table "measurements_child_786", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_786", ["timestamp"], :name => "idx_timestamp_786"

  create_table "measurements_child_787", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_787", ["timestamp"], :name => "idx_timestamp_787"

  create_table "measurements_child_788", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_788", ["timestamp"], :name => "idx_timestamp_788"

  create_table "measurements_child_789", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_789", ["timestamp"], :name => "idx_timestamp_789"

  create_table "measurements_child_79", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_79", ["timestamp"], :name => "idx_timestamp_79"

  create_table "measurements_child_790", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_790", ["timestamp"], :name => "idx_timestamp_790"

  create_table "measurements_child_791", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_791", ["timestamp"], :name => "idx_timestamp_791"

  create_table "measurements_child_792", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_792", ["timestamp"], :name => "idx_timestamp_792"

  create_table "measurements_child_793", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_793", ["timestamp"], :name => "idx_timestamp_793"

  create_table "measurements_child_794", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_794", ["timestamp"], :name => "idx_timestamp_794"

  create_table "measurements_child_795", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_795", ["timestamp"], :name => "idx_timestamp_795"

  create_table "measurements_child_796", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_796", ["timestamp"], :name => "idx_timestamp_796"

  create_table "measurements_child_797", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_797", ["timestamp"], :name => "idx_timestamp_797"

  create_table "measurements_child_798", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_798", ["timestamp"], :name => "idx_timestamp_798"

  create_table "measurements_child_799", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_799", ["timestamp"], :name => "idx_timestamp_799"

  create_table "measurements_child_8", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_8", ["timestamp"], :name => "idx_timestamp_8"

  create_table "measurements_child_80", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_80", ["timestamp"], :name => "idx_timestamp_80"

  create_table "measurements_child_800", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_800", ["timestamp"], :name => "idx_timestamp_800"

  create_table "measurements_child_801", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_801", ["timestamp"], :name => "idx_timestamp_801"

  create_table "measurements_child_802", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_802", ["timestamp"], :name => "idx_timestamp_802"

  create_table "measurements_child_803", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_803", ["timestamp"], :name => "idx_timestamp_803"

  create_table "measurements_child_804", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_804", ["timestamp"], :name => "idx_timestamp_804"

  create_table "measurements_child_805", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_805", ["timestamp"], :name => "idx_timestamp_805"

  create_table "measurements_child_806", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_806", ["timestamp"], :name => "idx_timestamp_806"

  create_table "measurements_child_807", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_807", ["timestamp"], :name => "idx_timestamp_807"

  create_table "measurements_child_808", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_808", ["timestamp"], :name => "idx_timestamp_808"

  create_table "measurements_child_809", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_809", ["timestamp"], :name => "idx_timestamp_809"

  create_table "measurements_child_81", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_81", ["timestamp"], :name => "idx_timestamp_81"

  create_table "measurements_child_810", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_810", ["timestamp"], :name => "idx_timestamp_810"

  create_table "measurements_child_811", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_811", ["timestamp"], :name => "idx_timestamp_811"

  create_table "measurements_child_812", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_812", ["timestamp"], :name => "idx_timestamp_812"

  create_table "measurements_child_813", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_813", ["timestamp"], :name => "idx_timestamp_813"

  create_table "measurements_child_814", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_814", ["timestamp"], :name => "idx_timestamp_814"

  create_table "measurements_child_815", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_815", ["timestamp"], :name => "idx_timestamp_815"

  create_table "measurements_child_816", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_816", ["timestamp"], :name => "idx_timestamp_816"

  create_table "measurements_child_817", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_817", ["timestamp"], :name => "idx_timestamp_817"

  create_table "measurements_child_818", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_818", ["timestamp"], :name => "idx_timestamp_818"

  create_table "measurements_child_819", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_819", ["timestamp"], :name => "idx_timestamp_819"

  create_table "measurements_child_82", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_82", ["timestamp"], :name => "idx_timestamp_82"

  create_table "measurements_child_820", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_820", ["timestamp"], :name => "idx_timestamp_820"

  create_table "measurements_child_821", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_821", ["timestamp"], :name => "idx_timestamp_821"

  create_table "measurements_child_822", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_822", ["timestamp"], :name => "idx_timestamp_822"

  create_table "measurements_child_823", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_823", ["timestamp"], :name => "idx_timestamp_823"

  create_table "measurements_child_824", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_824", ["timestamp"], :name => "idx_timestamp_824"

  create_table "measurements_child_825", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_825", ["timestamp"], :name => "idx_timestamp_825"

  create_table "measurements_child_826", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_826", ["timestamp"], :name => "idx_timestamp_826"

  create_table "measurements_child_827", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_827", ["timestamp"], :name => "idx_timestamp_827"

  create_table "measurements_child_828", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_828", ["timestamp"], :name => "idx_timestamp_828"

  create_table "measurements_child_829", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_829", ["timestamp"], :name => "idx_timestamp_829"

  create_table "measurements_child_83", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_83", ["timestamp"], :name => "idx_timestamp_83"

  create_table "measurements_child_830", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_830", ["timestamp"], :name => "idx_timestamp_830"

  create_table "measurements_child_831", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_831", ["timestamp"], :name => "idx_timestamp_831"

  create_table "measurements_child_832", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_832", ["timestamp"], :name => "idx_timestamp_832"

  create_table "measurements_child_833", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_833", ["timestamp"], :name => "idx_timestamp_833"

  create_table "measurements_child_834", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_834", ["timestamp"], :name => "idx_timestamp_834"

  create_table "measurements_child_835", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_835", ["timestamp"], :name => "idx_timestamp_835"

  create_table "measurements_child_836", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_836", ["timestamp"], :name => "idx_timestamp_836"

  create_table "measurements_child_837", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_837", ["timestamp"], :name => "idx_timestamp_837"

  create_table "measurements_child_838", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_838", ["timestamp"], :name => "idx_timestamp_838"

  create_table "measurements_child_839", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_839", ["timestamp"], :name => "idx_timestamp_839"

  create_table "measurements_child_84", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_84", ["timestamp"], :name => "idx_timestamp_84"

  create_table "measurements_child_840", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_840", ["timestamp"], :name => "idx_timestamp_840"

  create_table "measurements_child_841", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_841", ["timestamp"], :name => "idx_timestamp_841"

  create_table "measurements_child_842", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_842", ["timestamp"], :name => "idx_timestamp_842"

  create_table "measurements_child_843", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_843", ["timestamp"], :name => "idx_timestamp_843"

  create_table "measurements_child_844", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_844", ["timestamp"], :name => "idx_timestamp_844"

  create_table "measurements_child_845", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_845", ["timestamp"], :name => "idx_timestamp_845"

  create_table "measurements_child_846", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_846", ["timestamp"], :name => "idx_timestamp_846"

  create_table "measurements_child_847", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_847", ["timestamp"], :name => "idx_timestamp_847"

  create_table "measurements_child_848", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_848", ["timestamp"], :name => "idx_timestamp_848"

  create_table "measurements_child_849", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_849", ["timestamp"], :name => "idx_timestamp_849"

  create_table "measurements_child_85", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_85", ["timestamp"], :name => "idx_timestamp_85"

  create_table "measurements_child_850", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_850", ["timestamp"], :name => "idx_timestamp_850"

  create_table "measurements_child_851", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_851", ["timestamp"], :name => "idx_timestamp_851"

  create_table "measurements_child_852", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_852", ["timestamp"], :name => "idx_timestamp_852"

  create_table "measurements_child_853", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_853", ["timestamp"], :name => "idx_timestamp_853"

  create_table "measurements_child_854", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_854", ["timestamp"], :name => "idx_timestamp_854"

  create_table "measurements_child_855", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_855", ["timestamp"], :name => "idx_timestamp_855"

  create_table "measurements_child_856", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_856", ["timestamp"], :name => "idx_timestamp_856"

  create_table "measurements_child_857", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_857", ["timestamp"], :name => "idx_timestamp_857"

  create_table "measurements_child_858", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_858", ["timestamp"], :name => "idx_timestamp_858"

  create_table "measurements_child_859", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_859", ["timestamp"], :name => "idx_timestamp_859"

  create_table "measurements_child_86", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_86", ["timestamp"], :name => "idx_timestamp_86"

  create_table "measurements_child_860", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_860", ["timestamp"], :name => "idx_timestamp_860"

  create_table "measurements_child_861", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_861", ["timestamp"], :name => "idx_timestamp_861"

  create_table "measurements_child_862", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_862", ["timestamp"], :name => "idx_timestamp_862"

  create_table "measurements_child_863", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_863", ["timestamp"], :name => "idx_timestamp_863"

  create_table "measurements_child_864", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_864", ["timestamp"], :name => "idx_timestamp_864"

  create_table "measurements_child_865", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_865", ["timestamp"], :name => "idx_timestamp_865"

  create_table "measurements_child_866", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_866", ["timestamp"], :name => "idx_timestamp_866"

  create_table "measurements_child_867", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_867", ["timestamp"], :name => "idx_timestamp_867"

  create_table "measurements_child_868", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_868", ["timestamp"], :name => "idx_timestamp_868"

  create_table "measurements_child_869", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_869", ["timestamp"], :name => "idx_timestamp_869"

  create_table "measurements_child_87", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_87", ["timestamp"], :name => "idx_timestamp_87"

  create_table "measurements_child_870", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_870", ["timestamp"], :name => "idx_timestamp_870"

  create_table "measurements_child_871", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_871", ["timestamp"], :name => "idx_timestamp_871"

  create_table "measurements_child_872", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_872", ["timestamp"], :name => "idx_timestamp_872"

  create_table "measurements_child_873", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_873", ["timestamp"], :name => "idx_timestamp_873"

  create_table "measurements_child_874", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_874", ["timestamp"], :name => "idx_timestamp_874"

  create_table "measurements_child_875", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_875", ["timestamp"], :name => "idx_timestamp_875"

  create_table "measurements_child_876", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_876", ["timestamp"], :name => "idx_timestamp_876"

  create_table "measurements_child_877", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_877", ["timestamp"], :name => "idx_timestamp_877"

  create_table "measurements_child_878", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_878", ["timestamp"], :name => "idx_timestamp_878"

  create_table "measurements_child_879", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_879", ["timestamp"], :name => "idx_timestamp_879"

  create_table "measurements_child_88", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_88", ["timestamp"], :name => "idx_timestamp_88"

  create_table "measurements_child_880", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_880", ["timestamp"], :name => "idx_timestamp_880"

  create_table "measurements_child_881", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_881", ["timestamp"], :name => "idx_timestamp_881"

  create_table "measurements_child_882", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_882", ["timestamp"], :name => "idx_timestamp_882"

  create_table "measurements_child_883", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_883", ["timestamp"], :name => "idx_timestamp_883"

  create_table "measurements_child_884", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_884", ["timestamp"], :name => "idx_timestamp_884"

  create_table "measurements_child_885", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_885", ["timestamp"], :name => "idx_timestamp_885"

  create_table "measurements_child_886", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_886", ["timestamp"], :name => "idx_timestamp_886"

  create_table "measurements_child_887", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_887", ["timestamp"], :name => "idx_timestamp_887"

  create_table "measurements_child_888", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_888", ["timestamp"], :name => "idx_timestamp_888"

  create_table "measurements_child_889", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_889", ["timestamp"], :name => "idx_timestamp_889"

  create_table "measurements_child_89", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_89", ["timestamp"], :name => "idx_timestamp_89"

  create_table "measurements_child_890", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_890", ["timestamp"], :name => "idx_timestamp_890"

  create_table "measurements_child_891", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_891", ["timestamp"], :name => "idx_timestamp_891"

  create_table "measurements_child_892", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_892", ["timestamp"], :name => "idx_timestamp_892"

  create_table "measurements_child_893", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_893", ["timestamp"], :name => "idx_timestamp_893"

  create_table "measurements_child_894", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_894", ["timestamp"], :name => "idx_timestamp_894"

  create_table "measurements_child_895", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_895", ["timestamp"], :name => "idx_timestamp_895"

  create_table "measurements_child_896", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_896", ["timestamp"], :name => "idx_timestamp_896"

  create_table "measurements_child_897", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_897", ["timestamp"], :name => "idx_timestamp_897"

  create_table "measurements_child_898", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_898", ["timestamp"], :name => "idx_timestamp_898"

  create_table "measurements_child_899", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_899", ["timestamp"], :name => "idx_timestamp_899"

  create_table "measurements_child_9", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_9", ["timestamp"], :name => "idx_timestamp_9"

  create_table "measurements_child_90", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_90", ["timestamp"], :name => "idx_timestamp_90"

  create_table "measurements_child_900", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_900", ["timestamp"], :name => "idx_timestamp_900"

  create_table "measurements_child_901", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_901", ["timestamp"], :name => "idx_timestamp_901"

  create_table "measurements_child_902", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_902", ["timestamp"], :name => "idx_timestamp_902"

  create_table "measurements_child_903", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_903", ["timestamp"], :name => "idx_timestamp_903"

  create_table "measurements_child_904", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_904", ["timestamp"], :name => "idx_timestamp_904"

  create_table "measurements_child_905", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_905", ["timestamp"], :name => "idx_timestamp_905"

  create_table "measurements_child_906", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_906", ["timestamp"], :name => "idx_timestamp_906"

  create_table "measurements_child_907", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_907", ["timestamp"], :name => "idx_timestamp_907"

  create_table "measurements_child_908", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_908", ["timestamp"], :name => "idx_timestamp_908"

  create_table "measurements_child_909", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_909", ["timestamp"], :name => "idx_timestamp_909"

  create_table "measurements_child_91", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_91", ["timestamp"], :name => "idx_timestamp_91"

  create_table "measurements_child_910", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_910", ["timestamp"], :name => "idx_timestamp_910"

  create_table "measurements_child_911", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_911", ["timestamp"], :name => "idx_timestamp_911"

  create_table "measurements_child_912", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_912", ["timestamp"], :name => "idx_timestamp_912"

  create_table "measurements_child_913", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_913", ["timestamp"], :name => "idx_timestamp_913"

  create_table "measurements_child_914", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_914", ["timestamp"], :name => "idx_timestamp_914"

  create_table "measurements_child_915", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_915", ["timestamp"], :name => "idx_timestamp_915"

  create_table "measurements_child_916", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_916", ["timestamp"], :name => "idx_timestamp_916"

  create_table "measurements_child_917", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_917", ["timestamp"], :name => "idx_timestamp_917"

  create_table "measurements_child_918", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_918", ["timestamp"], :name => "idx_timestamp_918"

  create_table "measurements_child_919", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_919", ["timestamp"], :name => "idx_timestamp_919"

  create_table "measurements_child_92", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_92", ["timestamp"], :name => "idx_timestamp_92"

  create_table "measurements_child_920", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_920", ["timestamp"], :name => "idx_timestamp_920"

  create_table "measurements_child_921", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_921", ["timestamp"], :name => "idx_timestamp_921"

  create_table "measurements_child_922", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_922", ["timestamp"], :name => "idx_timestamp_922"

  create_table "measurements_child_923", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_923", ["timestamp"], :name => "idx_timestamp_923"

  create_table "measurements_child_924", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_924", ["timestamp"], :name => "idx_timestamp_924"

  create_table "measurements_child_925", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_925", ["timestamp"], :name => "idx_timestamp_925"

  create_table "measurements_child_926", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_926", ["timestamp"], :name => "idx_timestamp_926"

  create_table "measurements_child_927", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_927", ["timestamp"], :name => "idx_timestamp_927"

  create_table "measurements_child_928", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_928", ["timestamp"], :name => "idx_timestamp_928"

  create_table "measurements_child_929", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_929", ["timestamp"], :name => "idx_timestamp_929"

  create_table "measurements_child_93", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_93", ["timestamp"], :name => "idx_timestamp_93"

  create_table "measurements_child_930", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_930", ["timestamp"], :name => "idx_timestamp_930"

  create_table "measurements_child_931", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_931", ["timestamp"], :name => "idx_timestamp_931"

  create_table "measurements_child_932", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_932", ["timestamp"], :name => "idx_timestamp_932"

  create_table "measurements_child_933", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_933", ["timestamp"], :name => "idx_timestamp_933"

  create_table "measurements_child_934", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_934", ["timestamp"], :name => "idx_timestamp_934"

  create_table "measurements_child_935", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_935", ["timestamp"], :name => "idx_timestamp_935"

  create_table "measurements_child_936", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_936", ["timestamp"], :name => "idx_timestamp_936"

  create_table "measurements_child_937", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_937", ["timestamp"], :name => "idx_timestamp_937"

  create_table "measurements_child_938", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_938", ["timestamp"], :name => "idx_timestamp_938"

  create_table "measurements_child_939", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_939", ["timestamp"], :name => "idx_timestamp_939"

  create_table "measurements_child_94", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_94", ["timestamp"], :name => "idx_timestamp_94"

  create_table "measurements_child_940", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_940", ["timestamp"], :name => "idx_timestamp_940"

  create_table "measurements_child_941", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_941", ["timestamp"], :name => "idx_timestamp_941"

  create_table "measurements_child_942", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_942", ["timestamp"], :name => "idx_timestamp_942"

  create_table "measurements_child_943", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_943", ["timestamp"], :name => "idx_timestamp_943"

  create_table "measurements_child_944", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_944", ["timestamp"], :name => "idx_timestamp_944"

  create_table "measurements_child_945", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_945", ["timestamp"], :name => "idx_timestamp_945"

  create_table "measurements_child_946", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_946", ["timestamp"], :name => "idx_timestamp_946"

  create_table "measurements_child_947", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_947", ["timestamp"], :name => "idx_timestamp_947"

  create_table "measurements_child_948", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_948", ["timestamp"], :name => "idx_timestamp_948"

  create_table "measurements_child_949", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_949", ["timestamp"], :name => "idx_timestamp_949"

  create_table "measurements_child_95", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_95", ["timestamp"], :name => "idx_timestamp_95"

  create_table "measurements_child_950", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_950", ["timestamp"], :name => "idx_timestamp_950"

  create_table "measurements_child_951", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_951", ["timestamp"], :name => "idx_timestamp_951"

  create_table "measurements_child_952", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_952", ["timestamp"], :name => "idx_timestamp_952"

  create_table "measurements_child_953", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_953", ["timestamp"], :name => "idx_timestamp_953"

  create_table "measurements_child_954", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_954", ["timestamp"], :name => "idx_timestamp_954"

  create_table "measurements_child_955", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_955", ["timestamp"], :name => "idx_timestamp_955"

  create_table "measurements_child_956", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_956", ["timestamp"], :name => "idx_timestamp_956"

  create_table "measurements_child_957", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_957", ["timestamp"], :name => "idx_timestamp_957"

  create_table "measurements_child_958", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_958", ["timestamp"], :name => "idx_timestamp_958"

  create_table "measurements_child_959", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_959", ["timestamp"], :name => "idx_timestamp_959"

  create_table "measurements_child_96", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_96", ["timestamp"], :name => "idx_timestamp_96"

  create_table "measurements_child_960", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_960", ["timestamp"], :name => "idx_timestamp_960"

  create_table "measurements_child_961", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_961", ["timestamp"], :name => "idx_timestamp_961"

  create_table "measurements_child_962", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_962", ["timestamp"], :name => "idx_timestamp_962"

  create_table "measurements_child_963", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_963", ["timestamp"], :name => "idx_timestamp_963"

  create_table "measurements_child_964", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_964", ["timestamp"], :name => "idx_timestamp_964"

  create_table "measurements_child_965", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_965", ["timestamp"], :name => "idx_timestamp_965"

  create_table "measurements_child_966", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_966", ["timestamp"], :name => "idx_timestamp_966"

  create_table "measurements_child_967", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_967", ["timestamp"], :name => "idx_timestamp_967"

  create_table "measurements_child_968", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_968", ["timestamp"], :name => "idx_timestamp_968"

  create_table "measurements_child_969", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_969", ["timestamp"], :name => "idx_timestamp_969"

  create_table "measurements_child_97", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_97", ["timestamp"], :name => "idx_timestamp_97"

  create_table "measurements_child_970", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_970", ["timestamp"], :name => "idx_timestamp_970"

  create_table "measurements_child_971", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_971", ["timestamp"], :name => "idx_timestamp_971"

  create_table "measurements_child_972", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_972", ["timestamp"], :name => "idx_timestamp_972"

  create_table "measurements_child_973", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_973", ["timestamp"], :name => "idx_timestamp_973"

  create_table "measurements_child_974", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_974", ["timestamp"], :name => "idx_timestamp_974"

  create_table "measurements_child_975", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_975", ["timestamp"], :name => "idx_timestamp_975"

  create_table "measurements_child_976", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_976", ["timestamp"], :name => "idx_timestamp_976"

  create_table "measurements_child_977", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_977", ["timestamp"], :name => "idx_timestamp_977"

  create_table "measurements_child_978", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_978", ["timestamp"], :name => "idx_timestamp_978"

  create_table "measurements_child_979", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_979", ["timestamp"], :name => "idx_timestamp_979"

  create_table "measurements_child_98", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_98", ["timestamp"], :name => "idx_timestamp_98"

  create_table "measurements_child_980", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_980", ["timestamp"], :name => "idx_timestamp_980"

  create_table "measurements_child_981", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_981", ["timestamp"], :name => "idx_timestamp_981"

  create_table "measurements_child_982", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_982", ["timestamp"], :name => "idx_timestamp_982"

  create_table "measurements_child_983", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_983", ["timestamp"], :name => "idx_timestamp_983"

  create_table "measurements_child_984", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_984", ["timestamp"], :name => "idx_timestamp_984"

  create_table "measurements_child_985", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_985", ["timestamp"], :name => "idx_timestamp_985"

  create_table "measurements_child_986", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_986", ["timestamp"], :name => "idx_timestamp_986"

  create_table "measurements_child_987", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_987", ["timestamp"], :name => "idx_timestamp_987"

  create_table "measurements_child_988", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_988", ["timestamp"], :name => "idx_timestamp_988"

  create_table "measurements_child_989", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_989", ["timestamp"], :name => "idx_timestamp_989"

  create_table "measurements_child_99", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_99", ["timestamp"], :name => "idx_timestamp_99"

  create_table "measurements_child_990", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_990", ["timestamp"], :name => "idx_timestamp_990"

  create_table "measurements_child_991", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_991", ["timestamp"], :name => "idx_timestamp_991"

  create_table "measurements_child_992", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_992", ["timestamp"], :name => "idx_timestamp_992"

  create_table "measurements_child_993", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_993", ["timestamp"], :name => "idx_timestamp_993"

  create_table "measurements_child_994", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_994", ["timestamp"], :name => "idx_timestamp_994"

  create_table "measurements_child_995", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_995", ["timestamp"], :name => "idx_timestamp_995"

  create_table "measurements_child_996", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_996", ["timestamp"], :name => "idx_timestamp_996"

  create_table "measurements_child_997", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_997", ["timestamp"], :name => "idx_timestamp_997"

  create_table "measurements_child_998", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_998", ["timestamp"], :name => "idx_timestamp_998"

  create_table "measurements_child_999", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_999", ["timestamp"], :name => "idx_timestamp_999"

  create_table "measurements_old", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_old", ["timeline_id"], :name => "index_measurements_on_timeline_id"
  add_index "measurements_old", ["timestamp"], :name => "index_measurements_on_timestamp"

  create_table "neosentio_sensors", force: true do |t|
    t.float    "x_orientation",       default: 0.0,                     null: false
    t.float    "y_orientation",       default: 0.0,                     null: false
    t.float    "z_orientation",       default: 0.0,                     null: false
    t.integer  "battery_state"
    t.integer  "battery_capacity"
    t.string   "manufacturer",        default: "unknown manufacturer",  null: false
    t.string   "model",               default: "unknown model",         null: false
    t.string   "serial_number",       default: "unknown serial number", null: false
    t.string   "firmware_version",    default: "unknown version",       null: false
    t.date     "manufacture_date"
    t.date     "purchase_date"
    t.date     "warranty_date"
    t.date     "deployment_date"
    t.datetime "last_state_change"
    t.integer  "energy_consumption",  default: 0,                       null: false
    t.float    "precision",           default: 0.0,                     null: false
    t.integer  "measurement_node_id"
    t.integer  "device_id"
  end

  create_table "parameters", force: true do |t|
    t.string  "parameter_name",      default: "unknown parameter", null: false
    t.integer "device_id"
    t.integer "measurement_type_id"
    t.string  "custom_id",           default: "unknown ID",        null: false
    t.boolean "monitored",           default: false
    t.integer "monitoring_status",   default: 0
  end

  add_index "parameters", ["monitored"], :name => "index_parameters_on_monitored"
  add_index "parameters", ["monitoring_status"], :name => "index_parameters_on_monitoring_status"

  create_table "power_types", force: true do |t|
    t.string   "name",       default: "unnamed power type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profile_selections", id: false, force: true do |t|
    t.integer "threat_assessment_id"
    t.integer "profile_id"
  end

  add_index "profile_selections", ["profile_id"], :name => "index_profile_selections_on_profile_id"
  add_index "profile_selections", ["threat_assessment_id", "profile_id"], :name => "index_profile_selections_on_threat_assessment_id_and_profile_id"
  add_index "profile_selections", ["threat_assessment_id"], :name => "index_profile_selections_on_threat_assessment_id"

  create_table "profile_types", force: true do |t|
  end

  create_table "profiles", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_type_id"
    t.integer  "section_id"
    t.spatial  "shape",           limit: {:srid=>4326, :type=>"line_string", :geographic=>true}
  end

  add_index "profiles", ["profile_type_id"], :name => "index_profiles_on_profile_type_id"
  add_index "profiles", ["section_id"], :name => "index_profiles_on_section_id"

  create_table "pumps", force: true do |t|
    t.string   "manufacturer",      default: "unknown manufacturer", null: false
    t.string   "model",             default: "unknown model",        null: false
    t.date     "manufacture_date"
    t.date     "purchase_date"
    t.date     "deployment_date"
    t.datetime "last_state_change"
    t.integer  "device_id"
  end

  create_table "results", force: true do |t|
    t.float   "similarity"
    t.integer "threat_assessment_id"
    t.integer "scenario_id"
    t.integer "rank"
    t.string  "payload"
  end

  add_index "results", ["scenario_id"], :name => "index_results_on_scenario_id"

  create_table "scenarios", force: true do |t|
    t.string "name"
    t.text   "description"
  end

  create_table "sections", force: true do |t|
    t.spatial "shape",          limit: {:srid=>0, :type=>"geometry"}
    t.integer "levee_id"
    t.integer "ground_type_id"
  end

  add_index "sections", ["ground_type_id"], :name => "index_sections_on_ground_type_id"
  add_index "sections", ["levee_id"], :name => "index_sections_on_levee_id"

  create_table "threat_assessment_runs", force: true do |t|
    t.string   "name",          default: "Unnamed threat assessment run", null: false
    t.string   "status",        default: "unknown",                       null: false
    t.datetime "start_date",                                              null: false
    t.datetime "end_date"
    t.integer  "experiment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "threat_assessment_runs", ["end_date"], :name => "index_threat_assessment_runs_on_end_date"
  add_index "threat_assessment_runs", ["start_date"], :name => "index_threat_assessment_runs_on_start_date"

  create_table "threat_assessments", force: true do |t|
    t.integer  "threat_assessment_run_id"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timelines", force: true do |t|
    t.integer "context_id"
    t.integer "parameter_id"
    t.integer "experiment_id"
    t.string  "label"
    t.integer "scenario_id"
  end

  add_index "timelines", ["context_id"], :name => "index_timelines_on_context_id"
  add_index "timelines", ["experiment_id"], :name => "index_timelines_on_experiment_id"
  add_index "timelines", ["parameter_id"], :name => "index_timelines_on_parameter_id"
  add_index "timelines", ["scenario_id"], :name => "index_timelines_on_scenario_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "login",                               null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "weather_stations", force: true do |t|
    t.integer "device_id"
  end

end
