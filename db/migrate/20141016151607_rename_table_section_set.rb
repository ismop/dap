class RenameTableSectionSet < ActiveRecord::Migration
  def change
    rename_table :section_sets, :section_selections
  end
end
