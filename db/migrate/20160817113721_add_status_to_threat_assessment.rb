class AddStatusToThreatAssessment < ActiveRecord::Migration
  def up
    add_column :threat_assessments, :status, :string, null: false, default: 'running'
  end

  def down
    remove_column :threat_assessments, :status
  end
end
