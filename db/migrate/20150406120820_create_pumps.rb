class CreatePumps < ActiveRecord::Migration
  def change
    create_table :pumps do |t|

      t.string :manufacturer,             null: false, default: "unknown manufacturer"
      t.string :model,                    null: false, default: "unknown model"

      t.date :manufacture_date,           null: true
      t.date :purchase_date,              null: true
      t.date :deployment_date,            null: true

      t.timestamp :last_state_change,     null: true

      t.belongs_to :device

    end
  end
end
