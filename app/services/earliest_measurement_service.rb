class EarliestMeasurementService

  def self.find_earliest_measurements
    Rails.logger.info("#{Timeline.count} timelines registered")

    timelines = Timeline.where("earliest_measurement_value IS NULL")

    Rails.logger.info("#{timelines.count} timelines need processing")

    # Quit if nothing to be done
    if timelines.blank?
      return
    end

    timeline_ids = timelines.collect(&:id).join(',')

    sql = <<-SQL
      SELECT DISTINCT ON (timeline_id) timeline_id, m_timestamp, value
      FROM measurements
      WHERE timeline_id IN (#{timeline_ids})
      ORDER BY timeline_id, m_timestamp ASC
    SQL

    result = ActiveRecord::Base.connection.execute(sql).to_a

    result.each do |data|
      t = Timeline.find(data['timeline_id'])
      t.earliest_measurement_timestamp = data['m_timestamp']
      t.earliest_measurement_value = data['value']
      t.save

      Rails.logger.info("Timeline #{data['timeline_id']} updated")
    end
  end
end
