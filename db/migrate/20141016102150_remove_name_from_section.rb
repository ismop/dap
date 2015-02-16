class RemoveNameFromSection < ActiveRecord::Migration
  def change
    remove_column :sections, :name
  end
end
