class RenameTableProfileSet < ActiveRecord::Migration
  def change
    rename_table :profile_sets, :profile_selections
  end
end
