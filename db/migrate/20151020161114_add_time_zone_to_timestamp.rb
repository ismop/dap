class AddTimeZoneToTimestamp < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE measurements ALTER COLUMN timestamp TYPE TIMESTAMP WITH TIME ZONE'
  end

  def down
    execute 'ALTER TABLE measurements ALTER COLUMN timestamp TYPE TIMESTAMP'
  end
end
