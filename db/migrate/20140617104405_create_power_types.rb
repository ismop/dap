class CreatePowerTypes < ActiveRecord::Migration
  def change
    create_table :power_types do |t|
      t.string :name,               null:false, default:"unnamed power type"
      t.timestamps
    end

  end
end
