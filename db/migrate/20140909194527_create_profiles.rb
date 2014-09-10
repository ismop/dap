class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name,                    null:false, default: "Unnamed profile"

      t.timestamps
    end

    # Add foreign key column to Sensors 
    add_column :sensors, :profile_id, :integer
  end
end
