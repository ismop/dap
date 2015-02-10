class RemoveShapeFromLevees < ActiveRecord::Migration
  def change
    remove_column :levees, :shape
  end
end
