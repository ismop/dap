class AddBaseHeightToLevee < ActiveRecord::Migration
  def up
    unless column_exists? :levees, :base_height
      add_column :levees, :base_height, :float, default: 211.0
    end
  end

  def down
    if column_exists? :levees, :base_height
      remove_column :levees, :base_height
    end
  end
end
