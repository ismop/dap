class ExtendScenarioModelWithThreatLevel < ActiveRecord::Migration
  def up
    add_column :scenarios, :threat_level, :integer, null: false, default: 0
  end

  def down
    remove_column :scenarios, :threat_level
  end
end
