class ExtendScenarioModelWithThreatLevel < ActiveRecord::Migration
  def change
    change_table :scenarios do |t|
      t.integer :threat_level, null: false, default: 0
    end
  end
end
