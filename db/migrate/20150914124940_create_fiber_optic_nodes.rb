class CreateFiberOpticNodes < ActiveRecord::Migration
  def change
    create_table :fiber_optic_nodes do |t|

      t.float :cable_distance_marker
      t.float :levee_distance_marker

      t.date :deployment_date,            null: true

      t.timestamp :last_state_change,     null: true

      t.belongs_to :device

    end
  end
end
