class RemoveNameFromProfile < ActiveRecord::Migration
  def change
    remove_column :profiles, :name
  end
end
