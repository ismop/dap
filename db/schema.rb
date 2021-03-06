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

ActiveRecord::Schema.define(version: 20161122061831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_topology"

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
    t.string  "vendor"
    t.boolean "visible",                                                                                      default: true,         null: false
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
    t.float    "base_height"
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
    t.datetime "m_timestamp",                                                             null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  create_table "measurements_child_1970_01_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_1970_01_01", ["m_timestamp"], :name => "idx_timestamp_1970_01_01"
  add_index "measurements_child_1970_01_01", ["timeline_id"], :name => "idx_timeline_1970_01_01"

  create_table "measurements_child_2015_01_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2015_01_01", ["m_timestamp"], :name => "idx_timestamp_2015_01_01"
  add_index "measurements_child_2015_01_01", ["timeline_id"], :name => "idx_timeline_2015_01_01"

  create_table "measurements_child_2015_02_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2015_02_01", ["m_timestamp"], :name => "idx_timestamp_2015_02_01"
  add_index "measurements_child_2015_02_01", ["timeline_id"], :name => "idx_timeline_2015_02_01"

  create_table "measurements_child_2015_03_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2015_03_01", ["m_timestamp"], :name => "idx_timestamp_2015_03_01"
  add_index "measurements_child_2015_03_01", ["timeline_id"], :name => "idx_timeline_2015_03_01"

  create_table "measurements_child_2015_04_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2015_04_01", ["m_timestamp"], :name => "idx_timestamp_2015_04_01"
  add_index "measurements_child_2015_04_01", ["timeline_id"], :name => "idx_timeline_2015_04_01"

  create_table "measurements_child_2015_05_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2015_05_01", ["m_timestamp"], :name => "idx_timestamp_2015_05_01"
  add_index "measurements_child_2015_05_01", ["timeline_id"], :name => "idx_timeline_2015_05_01"

  create_table "measurements_child_2015_06_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2015_06_01", ["m_timestamp"], :name => "idx_timestamp_2015_06_01"
  add_index "measurements_child_2015_06_01", ["timeline_id"], :name => "idx_timeline_2015_06_01"

  create_table "measurements_child_2015_07_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2015_07_01", ["m_timestamp"], :name => "idx_timestamp_2015_07_01"
  add_index "measurements_child_2015_07_01", ["timeline_id"], :name => "idx_timeline_2015_07_01"

  create_table "measurements_child_2015_08_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2015_08_01", ["m_timestamp"], :name => "idx_timestamp_2015_08_01"
  add_index "measurements_child_2015_08_01", ["timeline_id"], :name => "idx_timeline_2015_08_01"

  create_table "measurements_child_2015_09_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2015_09_01", ["m_timestamp"], :name => "idx_timestamp_2015_09_01"
  add_index "measurements_child_2015_09_01", ["timeline_id"], :name => "idx_timeline_2015_09_01"

  create_table "measurements_child_2015_10_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2015_10_01", ["m_timestamp"], :name => "idx_timestamp_2015_10_01"
  add_index "measurements_child_2015_10_01", ["timeline_id"], :name => "idx_timeline_2015_10_01"

  create_table "measurements_child_2015_11_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2015_11_01", ["m_timestamp"], :name => "idx_timestamp_2015_11_01"
  add_index "measurements_child_2015_11_01", ["timeline_id"], :name => "idx_timeline_2015_11_01"

  create_table "measurements_child_2015_12_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2015_12_01", ["m_timestamp"], :name => "idx_timestamp_2015_12_01"
  add_index "measurements_child_2015_12_01", ["timeline_id"], :name => "idx_timeline_2015_12_01"

  create_table "measurements_child_2016_01_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2016_01_01", ["m_timestamp"], :name => "idx_timestamp_2016_01_01"
  add_index "measurements_child_2016_01_01", ["timeline_id"], :name => "idx_timeline_2016_01_01"

  create_table "measurements_child_2016_02_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2016_02_01", ["m_timestamp"], :name => "idx_timestamp_2016_02_01"
  add_index "measurements_child_2016_02_01", ["timeline_id"], :name => "idx_timeline_2016_02_01"

  create_table "measurements_child_2016_03_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2016_03_01", ["m_timestamp"], :name => "idx_timestamp_2016_03_01"
  add_index "measurements_child_2016_03_01", ["timeline_id"], :name => "idx_timeline_2016_03_01"

  create_table "measurements_child_2016_04_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2016_04_01", ["m_timestamp"], :name => "idx_timestamp_2016_04_01"
  add_index "measurements_child_2016_04_01", ["timeline_id"], :name => "idx_timeline_2016_04_01"

  create_table "measurements_child_2016_05_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2016_05_01", ["m_timestamp"], :name => "idx_timestamp_2016_05_01"
  add_index "measurements_child_2016_05_01", ["timeline_id"], :name => "idx_timeline_2016_05_01"

  create_table "measurements_child_2016_06_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2016_06_01", ["m_timestamp"], :name => "idx_timestamp_2016_06_01"
  add_index "measurements_child_2016_06_01", ["timeline_id"], :name => "idx_timeline_2016_06_01"

  create_table "measurements_child_2016_07_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2016_07_01", ["m_timestamp"], :name => "idx_timestamp_2016_07_01"
  add_index "measurements_child_2016_07_01", ["timeline_id"], :name => "idx_timeline_2016_07_01"

  create_table "measurements_child_2016_08_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2016_08_01", ["m_timestamp"], :name => "idx_timestamp_2016_08_01"
  add_index "measurements_child_2016_08_01", ["timeline_id"], :name => "idx_timeline_2016_08_01"

  create_table "measurements_child_2016_09_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2016_09_01", ["m_timestamp"], :name => "idx_timestamp_2016_09_01"
  add_index "measurements_child_2016_09_01", ["timeline_id"], :name => "idx_timeline_2016_09_01"

  create_table "measurements_child_2016_10_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2016_10_01", ["m_timestamp"], :name => "idx_timestamp_2016_10_01"
  add_index "measurements_child_2016_10_01", ["timeline_id"], :name => "idx_timeline_2016_10_01"

  create_table "measurements_child_2016_11_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2016_11_01", ["m_timestamp"], :name => "idx_timestamp_2016_11_01"
  add_index "measurements_child_2016_11_01", ["timeline_id"], :name => "idx_timeline_2016_11_01"

  create_table "measurements_child_2016_12_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2016_12_01", ["m_timestamp"], :name => "idx_timestamp_2016_12_01"
  add_index "measurements_child_2016_12_01", ["timeline_id"], :name => "idx_timeline_2016_12_01"

  create_table "measurements_child_2017_01_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2017_01_01", ["m_timestamp"], :name => "idx_timestamp_2017_01_01"
  add_index "measurements_child_2017_01_01", ["timeline_id"], :name => "idx_timeline_2017_01_01"

  create_table "measurements_child_2017_02_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2017_02_01", ["m_timestamp"], :name => "idx_timestamp_2017_02_01"
  add_index "measurements_child_2017_02_01", ["timeline_id"], :name => "idx_timeline_2017_02_01"

  create_table "measurements_child_2017_03_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2017_03_01", ["m_timestamp"], :name => "idx_timestamp_2017_03_01"
  add_index "measurements_child_2017_03_01", ["timeline_id"], :name => "idx_timeline_2017_03_01"

  create_table "measurements_child_2017_04_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2017_04_01", ["m_timestamp"], :name => "idx_timestamp_2017_04_01"
  add_index "measurements_child_2017_04_01", ["timeline_id"], :name => "idx_timeline_2017_04_01"

  create_table "measurements_child_2017_05_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2017_05_01", ["m_timestamp"], :name => "idx_timestamp_2017_05_01"
  add_index "measurements_child_2017_05_01", ["timeline_id"], :name => "idx_timeline_2017_05_01"

  create_table "measurements_child_2017_06_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2017_06_01", ["m_timestamp"], :name => "idx_timestamp_2017_06_01"
  add_index "measurements_child_2017_06_01", ["timeline_id"], :name => "idx_timeline_2017_06_01"

  create_table "measurements_child_2017_07_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2017_07_01", ["m_timestamp"], :name => "idx_timestamp_2017_07_01"
  add_index "measurements_child_2017_07_01", ["timeline_id"], :name => "idx_timeline_2017_07_01"

  create_table "measurements_child_2017_08_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2017_08_01", ["m_timestamp"], :name => "idx_timestamp_2017_08_01"
  add_index "measurements_child_2017_08_01", ["timeline_id"], :name => "idx_timeline_2017_08_01"

  create_table "measurements_child_2017_09_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2017_09_01", ["m_timestamp"], :name => "idx_timestamp_2017_09_01"
  add_index "measurements_child_2017_09_01", ["timeline_id"], :name => "idx_timeline_2017_09_01"

  create_table "measurements_child_2017_10_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2017_10_01", ["m_timestamp"], :name => "idx_timestamp_2017_10_01"
  add_index "measurements_child_2017_10_01", ["timeline_id"], :name => "idx_timeline_2017_10_01"

  create_table "measurements_child_2017_11_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2017_11_01", ["m_timestamp"], :name => "idx_timestamp_2017_11_01"
  add_index "measurements_child_2017_11_01", ["timeline_id"], :name => "idx_timeline_2017_11_01"

  create_table "measurements_child_2017_12_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2017_12_01", ["m_timestamp"], :name => "idx_timestamp_2017_12_01"
  add_index "measurements_child_2017_12_01", ["timeline_id"], :name => "idx_timeline_2017_12_01"

  create_table "measurements_child_2018_01_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2018_01_01", ["m_timestamp"], :name => "idx_timestamp_2018_01_01"
  add_index "measurements_child_2018_01_01", ["timeline_id"], :name => "idx_timeline_2018_01_01"

  create_table "measurements_child_2018_02_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2018_02_01", ["m_timestamp"], :name => "idx_timestamp_2018_02_01"
  add_index "measurements_child_2018_02_01", ["timeline_id"], :name => "idx_timeline_2018_02_01"

  create_table "measurements_child_2018_03_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2018_03_01", ["m_timestamp"], :name => "idx_timestamp_2018_03_01"
  add_index "measurements_child_2018_03_01", ["timeline_id"], :name => "idx_timeline_2018_03_01"

  create_table "measurements_child_2018_04_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2018_04_01", ["m_timestamp"], :name => "idx_timestamp_2018_04_01"
  add_index "measurements_child_2018_04_01", ["timeline_id"], :name => "idx_timeline_2018_04_01"

  create_table "measurements_child_2018_05_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2018_05_01", ["m_timestamp"], :name => "idx_timestamp_2018_05_01"
  add_index "measurements_child_2018_05_01", ["timeline_id"], :name => "idx_timeline_2018_05_01"

  create_table "measurements_child_2018_06_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2018_06_01", ["m_timestamp"], :name => "idx_timestamp_2018_06_01"
  add_index "measurements_child_2018_06_01", ["timeline_id"], :name => "idx_timeline_2018_06_01"

  create_table "measurements_child_2018_07_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2018_07_01", ["m_timestamp"], :name => "idx_timestamp_2018_07_01"
  add_index "measurements_child_2018_07_01", ["timeline_id"], :name => "idx_timeline_2018_07_01"

  create_table "measurements_child_2018_08_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2018_08_01", ["m_timestamp"], :name => "idx_timestamp_2018_08_01"
  add_index "measurements_child_2018_08_01", ["timeline_id"], :name => "idx_timeline_2018_08_01"

  create_table "measurements_child_2018_09_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2018_09_01", ["m_timestamp"], :name => "idx_timestamp_2018_09_01"
  add_index "measurements_child_2018_09_01", ["timeline_id"], :name => "idx_timeline_2018_09_01"

  create_table "measurements_child_2018_10_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2018_10_01", ["m_timestamp"], :name => "idx_timestamp_2018_10_01"
  add_index "measurements_child_2018_10_01", ["timeline_id"], :name => "idx_timeline_2018_10_01"

  create_table "measurements_child_2018_11_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2018_11_01", ["m_timestamp"], :name => "idx_timestamp_2018_11_01"
  add_index "measurements_child_2018_11_01", ["timeline_id"], :name => "idx_timeline_2018_11_01"

  create_table "measurements_child_2018_12_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2018_12_01", ["m_timestamp"], :name => "idx_timestamp_2018_12_01"
  add_index "measurements_child_2018_12_01", ["timeline_id"], :name => "idx_timeline_2018_12_01"

  create_table "measurements_child_2019_01_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2019_01_01", ["m_timestamp"], :name => "idx_timestamp_2019_01_01"
  add_index "measurements_child_2019_01_01", ["timeline_id"], :name => "idx_timeline_2019_01_01"

  create_table "measurements_child_2019_02_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2019_02_01", ["m_timestamp"], :name => "idx_timestamp_2019_02_01"
  add_index "measurements_child_2019_02_01", ["timeline_id"], :name => "idx_timeline_2019_02_01"

  create_table "measurements_child_2019_03_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2019_03_01", ["m_timestamp"], :name => "idx_timestamp_2019_03_01"
  add_index "measurements_child_2019_03_01", ["timeline_id"], :name => "idx_timeline_2019_03_01"

  create_table "measurements_child_2019_04_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2019_04_01", ["m_timestamp"], :name => "idx_timestamp_2019_04_01"
  add_index "measurements_child_2019_04_01", ["timeline_id"], :name => "idx_timeline_2019_04_01"

  create_table "measurements_child_2019_05_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2019_05_01", ["m_timestamp"], :name => "idx_timestamp_2019_05_01"
  add_index "measurements_child_2019_05_01", ["timeline_id"], :name => "idx_timeline_2019_05_01"

  create_table "measurements_child_2019_06_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2019_06_01", ["m_timestamp"], :name => "idx_timestamp_2019_06_01"
  add_index "measurements_child_2019_06_01", ["timeline_id"], :name => "idx_timeline_2019_06_01"

  create_table "measurements_child_2019_07_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2019_07_01", ["m_timestamp"], :name => "idx_timestamp_2019_07_01"
  add_index "measurements_child_2019_07_01", ["timeline_id"], :name => "idx_timeline_2019_07_01"

  create_table "measurements_child_2019_08_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2019_08_01", ["m_timestamp"], :name => "idx_timestamp_2019_08_01"
  add_index "measurements_child_2019_08_01", ["timeline_id"], :name => "idx_timeline_2019_08_01"

  create_table "measurements_child_2019_09_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2019_09_01", ["m_timestamp"], :name => "idx_timestamp_2019_09_01"
  add_index "measurements_child_2019_09_01", ["timeline_id"], :name => "idx_timeline_2019_09_01"

  create_table "measurements_child_2019_10_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2019_10_01", ["m_timestamp"], :name => "idx_timestamp_2019_10_01"
  add_index "measurements_child_2019_10_01", ["timeline_id"], :name => "idx_timeline_2019_10_01"

  create_table "measurements_child_2019_11_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2019_11_01", ["m_timestamp"], :name => "idx_timestamp_2019_11_01"
  add_index "measurements_child_2019_11_01", ["timeline_id"], :name => "idx_timeline_2019_11_01"

  create_table "measurements_child_2019_12_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2019_12_01", ["m_timestamp"], :name => "idx_timestamp_2019_12_01"
  add_index "measurements_child_2019_12_01", ["timeline_id"], :name => "idx_timeline_2019_12_01"

  create_table "measurements_child_2020_01_01", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_child_2020_01_01", ["m_timestamp"], :name => "idx_timestamp_2020_01_01"
  add_index "measurements_child_2020_01_01", ["timeline_id"], :name => "idx_timeline_2020_01_01"

  create_table "measurements_old", force: true do |t|
    t.float    "value",          null: false
    t.datetime "m_timestamp",    null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements_old", ["m_timestamp"], :name => "index_measurements_on_timestamp"
  add_index "measurements_old", ["timeline_id"], :name => "index_measurements_on_timeline_id"

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
    t.string "label", default: "unknown type", null: false
  end

  create_table "profiles", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_type_id"
    t.integer  "section_id"
    t.spatial  "shape",           limit: {:srid=>4326, :type=>"line_string", :geographic=>true}
    t.float    "base_height"
    t.string   "custom_id",                                                                      default: "unknown ID",      null: false
    t.string   "name",                                                                           default: "unnamed profile", null: false
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
    t.float    "similarity"
    t.integer  "threat_assessment_id"
    t.integer  "scenario_id"
    t.integer  "rank"
    t.string   "payload"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "offset"
  end

  add_index "results", ["scenario_id"], :name => "index_results_on_scenario_id"

  create_table "scenarios", force: true do |t|
    t.string  "name"
    t.text    "description"
    t.integer "threat_level", default: 0, null: false
  end

  create_table "sections", force: true do |t|
    t.spatial "shape",        limit: {:srid=>0, :type=>"geometry"}
    t.integer "levee_id"
    t.integer "soil_type_id"
  end

  add_index "sections", ["levee_id"], :name => "index_sections_on_levee_id"
  add_index "sections", ["soil_type_id"], :name => "index_sections_on_soil_type_id"

  create_table "soil_types", force: true do |t|
    t.string "label"
    t.string "name"
    t.float  "bulk_density_min"
    t.float  "bulk_density_max"
    t.float  "bulk_density_avg"
    t.float  "granular_density_min"
    t.float  "granular_density_max"
    t.float  "granular_density_avg"
    t.float  "filtration_coefficient_min"
    t.float  "filtration_coefficient_max"
    t.float  "filtration_coefficient_avg"
  end

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
    t.string   "status",                   default: "running", null: false
  end

  create_table "timelines", force: true do |t|
    t.integer  "context_id"
    t.integer  "parameter_id"
    t.integer  "experiment_id"
    t.string   "label"
    t.integer  "scenario_id"
    t.datetime "earliest_measurement_timestamp"
    t.float    "earliest_measurement_value"
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
