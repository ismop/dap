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

ActiveRecord::Schema.define(version: 20150112122456) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_topology"

  create_table "activity_states", force: true do |t|
    t.string   "name",       default: "unnamed activity", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contexts", force: true do |t|
    t.string "name",                           null: false
    t.string "context_type", default: "tests", null: false
  end

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
    t.string   "name",                                                                      default: "Unnamed experiment", null: false
    t.datetime "start_date",                                                                                               null: false
    t.datetime "end_date"
    t.string   "status",                                                                    default: "unknown",            null: false
    t.string   "status_message",                                                            default: ""
    t.spatial  "selection",      limit: {:srid=>4326, :type=>"polygon", :geographic=>true}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "experiments", ["end_date"], :name => "index_experiments_on_end_date"
  add_index "experiments", ["start_date"], :name => "index_experiments_on_start_date"

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
  end

  create_table "measurements", force: true do |t|
    t.float    "value",          null: false
    t.datetime "timestamp",      null: false
    t.string   "source_address"
    t.integer  "timeline_id"
  end

  add_index "measurements", ["timeline_id"], :name => "index_measurements_on_timeline_id"
  add_index "measurements", ["timestamp"], :name => "index_measurements_on_timestamp"

  create_table "power_types", force: true do |t|
    t.string   "name",       default: "unnamed power type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "results", force: true do |t|
    t.float   "similarity"
    t.integer "experiment_id"
    t.integer "section_id"
    t.integer "scenario_id"
  end

  add_index "results", ["scenario_id"], :name => "index_results_on_scenario_id"

  create_table "scenarios", force: true do |t|
    t.string  "file_name"
    t.binary  "payload",                          null: false
    t.integer "context_id"
    t.integer "section_type_id"
    t.string  "threat_level",    default: "none"
  end

  add_index "scenarios", ["context_id"], :name => "index_scenarios_on_context_id"
  add_index "scenarios", ["section_type_id"], :name => "index_scenarios_on_section_type_id"

  create_table "section_selections", id: false, force: true do |t|
    t.integer "experiment_id"
    t.integer "section_id"
  end

  add_index "section_selections", ["experiment_id", "section_id"], :name => "index_section_selections_on_experiment_id_and_section_id"
  add_index "section_selections", ["experiment_id"], :name => "index_section_selections_on_experiment_id"
  add_index "section_selections", ["section_id"], :name => "index_section_selections_on_section_id"

  create_table "section_types", force: true do |t|
  end

  create_table "sections", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "shape",           limit: {:srid=>4326, :type=>"multi_point", :geographic=>true}
    t.integer  "levee_id"
    t.integer  "section_type_id"
  end

  add_index "sections", ["levee_id"], :name => "index_sections_on_levee_id"
  add_index "sections", ["section_type_id"], :name => "index_sections_on_section_type_id"

  create_table "sensors", force: true do |t|
    t.string   "custom_id",                                                                                  default: "unknown ID",            null: false
    t.spatial  "placement",           limit: {:srid=>4326, :type=>"point", :has_z=>true, :geographic=>true}
    t.float    "x_orientation",                                                                              default: 0.0,                     null: false
    t.float    "y_orientation",                                                                              default: 0.0,                     null: false
    t.float    "z_orientation",                                                                              default: 0.0,                     null: false
    t.integer  "battery_state"
    t.integer  "battery_capacity"
    t.string   "manufacturer",                                                                               default: "unknown manufacturer",  null: false
    t.string   "model",                                                                                      default: "unknown model",         null: false
    t.string   "serial_number",                                                                              default: "unknown serial number", null: false
    t.string   "firmware_version",                                                                           default: "unknown version",       null: false
    t.date     "manufacture_date"
    t.date     "purchase_date"
    t.date     "warranty_date"
    t.date     "deployment_date"
    t.datetime "last_state_change"
    t.integer  "energy_consumption",                                                                         default: 0,                       null: false
    t.float    "precision",                                                                                  default: 0.0,                     null: false
    t.integer  "measurement_node_id"
    t.integer  "activity_state_id"
    t.integer  "power_type_id"
    t.integer  "interface_type_id"
    t.integer  "measurement_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "section_id"
  end

  add_index "sensors", ["activity_state_id"], :name => "index_sensors_on_activity_state_id"
  add_index "sensors", ["custom_id"], :name => "index_sensors_on_custom_id", :unique => true
  add_index "sensors", ["interface_type_id"], :name => "index_sensors_on_interface_type_id"
  add_index "sensors", ["last_state_change"], :name => "index_sensors_on_last_state_change"
  add_index "sensors", ["power_type_id"], :name => "index_sensors_on_power_type_id"

  create_table "timelines", force: true do |t|
    t.integer "sensor_id"
    t.integer "context_id"
  end

  add_index "timelines", ["context_id"], :name => "index_timelines_on_context_id"
  add_index "timelines", ["sensor_id"], :name => "index_timelines_on_sensor_id"

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

end
