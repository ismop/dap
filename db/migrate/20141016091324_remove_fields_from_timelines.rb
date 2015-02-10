class RemoveFieldsFromTimelines < ActiveRecord::Migration
  change_table :timelines do |t|
    t.remove :created_at, :updated_at, :name, :measurement_type
  end
end
