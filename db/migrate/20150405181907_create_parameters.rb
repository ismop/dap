class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.string :parameter_name,                null: false, default: "unknown parameter"

      t.belongs_to :device
      t.belongs_to :measurement_type
    end

    # TODO: Change timelines to reference parameters instead of sensors
    add_reference :timelines, :parameter, index: true
  end
end
