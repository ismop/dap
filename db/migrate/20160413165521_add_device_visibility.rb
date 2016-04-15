class AddDeviceVisibility < ActiveRecord::Migration
  def change
    change_table :devices do |t|
      t.boolean :visible, null: false, default: true
    end
  end
end
