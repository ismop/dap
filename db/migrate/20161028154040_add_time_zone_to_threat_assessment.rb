class AddTimeZoneToThreatAssessment < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE threat_assessments ALTER COLUMN created_at TYPE timestamp with time zone'
    execute 'ALTER TABLE threat_assessments ALTER COLUMN updated_at TYPE timestamp with time zone'
  end

  def down
    execute 'ALTER TABLE threat_assessments ALTER COLUMN created_at TYPE timestamp without time zone'
    execute 'ALTER TABLE threat_assessments ALTER COLUMN updated_at TYPE timestamp without time zone'
  end
end
