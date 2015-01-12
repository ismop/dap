class MoveThreatLevelFromProfileToScenario < ActiveRecord::Migration
  def change
    remove_column :profiles, :threat_level
    add_column :scenarios, :threat_level, :string, default:"none" # Allowed values: none, heightened, severe
  end
end
