class PruningService

  def self.prune_duplicates
    working_date = Date.today
    target_tables = []

    for i in 0..Rails.configuration.pruning_retroactivity do
      target_tables << "measurements_child_#{working_date.year.to_s.rjust(2, '0')}_#{working_date.month.to_s.rjust(2, '0')}_01"
      working_date = working_date.last_month
    end

    Rails.logger.info("Pruning records in #{target_tables.length} partitions:")

    target_tables.each do |table|
      Rails.logger.info("Processing partition #{table}...")

      pre_count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM #{table}").to_a.first['count']

      sql = <<-SQL
      DELETE FROM #{table} a USING (
        SELECT MIN(ctid) as ctid, value, m_timestamp, timeline_id
          FROM #{table}
          GROUP BY value, m_timestamp, timeline_id HAVING COUNT(*) > 1
        ) b
        WHERE a.value = b.value
          AND a.m_timestamp = b.m_timestamp
          AND a.timeline_id = b.timeline_id
          AND a.ctid <> b.ctid;
      SQL

      result = ActiveRecord::Base.connection.execute(sql)
      Rails.logger.info("Partition #{table}: #{result.cmd_tuples} of #{pre_count} measurements purged.")
    end

    Rails.logger.info("Pruning complete.")

  end
end