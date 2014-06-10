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

ActiveRecord::Schema.define(version: 20140401100017) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_topology"

  create_table "levees", force: true do |t|
    t.string   "name",                                                                                                 default: "unnamed levee", null: false
    t.string   "emergency_level",                                                                                      default: "none",          null: false
    t.string   "threat_level",                                                                                         default: "none",          null: false
    t.spatial  "shape",                   limit: {:srid=>4326, :type=>"multi_point", :has_z=>true, :geographic=>true}
    t.datetime "threat_level_updated_at",                                                                              default: "now()",         null: false
  end

end
