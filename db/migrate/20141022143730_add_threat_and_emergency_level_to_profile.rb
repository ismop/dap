class AddThreatAndEmergencyLevelToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :emergency_level, :string, null:false, default:"none" # Allowed values: none, heightened, severe
    add_column :profiles, :threat_level, :string, null:false, default:"none" # Allowed values: none, heightened, severe
  end
end