class AddProfileVendor < ActiveRecord::Migration
  def change
    change_table :profiles do |t|
      t.string :vendor
    end
  end
end
