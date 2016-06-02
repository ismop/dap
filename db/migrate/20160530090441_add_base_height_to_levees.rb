class AddBaseHeightToLevees < ActiveRecord::Migration
  def change
    change_table :levees do |t|

      t.float :base_height

    end
  end
end
