class AddCustomIdToParameter < ActiveRecord::Migration
  def change
    change_table :parameters do |t|
      t.string :custom_id,                null: false, default: "unknown ID"
    end
  end
end
