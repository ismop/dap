class RemoveEmergencyLevelFromSection < ActiveRecord::Migration
  def change
    remove_column :sections, :emergency_level
  end
end
