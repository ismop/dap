class ExtendProfileModel < ActiveRecord::Migration
  def change
    change_table :profiles do |t|
      t.string :custom_id, null: false, default: "unknown ID"
    end
    change_table :profile_types do |t|
      t.string :label, null: false, default: "unknown type"
    end
  end
end
