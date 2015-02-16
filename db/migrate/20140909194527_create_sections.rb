class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :name,                    null:false, default: "Unnamed section"

      t.timestamps
    end

    # Add foreign key column to Sensors 
    add_column :sensors, :section_id, :integer
  end
end
