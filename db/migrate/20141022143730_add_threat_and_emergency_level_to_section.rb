class AddThreatAndEmergencyLevelToSection < ActiveRecord::Migration
  def change
    add_column :sections, :emergency_level, :string, null:false, default:"none" # Allowed values: none, heightened, severe
    add_column :sections, :threat_level, :string, null:false, default:"none" # Allowed values: none, heightened, severe
  end
end