class RenameSectionToProfile < ActiveRecord::Migration
  def change
    rename_table :sections, :profiles
    rename_table :section_types, :profile_types
    rename_table :section_selections, :profile_selections

    rename_column :profile_selections, :section_id, :profile_id
    rename_column :results, :section_id, :profile_id
    rename_column :sensors, :section_id, :profile_id
    rename_column :devices, :section_id, :profile_id
    rename_column :device_aggregations, :section_id, :profile_id

    rename_column :profiles, :section_type_id, :profile_type_id
    rename_column :scenarios, :section_type_id, :profile_type_id

  end
end
