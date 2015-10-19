class ExtendScenarioModel < ActiveRecord::Migration
  def change

    add_reference :timelines, :scenario, references: :scenarios, index: true, null: true

    create_table :experiments_scenarios do |t|
      t.integer "scenario_id", index: true, null: false
      t.integer "experiment_id", index: true, null: false
    end
  end
end
