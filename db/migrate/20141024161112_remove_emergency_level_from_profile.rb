class RemoveEmergencyLevelFromProfile < ActiveRecord::Migration
  def change
    remove_column :profiles, :emergency_level
  end
end
