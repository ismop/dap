class AddDeviceVendor < ActiveRecord::Migration
  def change
    change_table :devices do |t|
      t.string :vendor
    end
  end
end
