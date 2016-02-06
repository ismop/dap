class MonitoringService

  def self.perform_monitoring
    Rails.logger.info("#{Parameter.count} parameters registered (#{Parameter.monitorable.count} monitorable)")

    monitorable_ids = Parameter.monitorable.collect(&:id)

    # Quit if nothing to monitor
    if monitorable_ids.blank?
      return
    end

    timelines = Timeline.where("parameter_id IN (?) AND context_id = 1", monitorable_ids)

    # Quit with warning if no suitable timelines present
    if timelines.blank?
      Rails.logger.warn("No real timelines present for any of the monitored parameters. Exiting.")
      return
    end

    # Get latest measurements for each TL.
    # Use SQL for speed
    sql = "SELECT timeline_id, MAX(m_timestamp) FROM measurements "
    sql << " WHERE timeline_id IN (#{timelines.collect(&:id).join(',')}) "
    sql << " GROUP BY timeline_id"

    result = ActiveRecord::Base.connection.execute(sql).to_a

    result.each do |m|
      time_elapsed = (Time.now - Time.parse(m['max'])).to_i
      parameter = Timeline.find_by(id: m['timeline_id'].to_i).parameter
      if time_elapsed > Rails.configuration.sensor_data_alert_trigger
        # Write a warning to log if changing status from up to down
        if parameter.monitoring_status == :up
          Rails.logger.warn("Parameter #{parameter.id}: status flipping from up to down.")
        end
        # Regardless, set this parameter's status to down
        parameter.monitoring_status = :down
        parameter.save
      else
        if parameter.monitoring_status == :down
          # Write an info message to log if changing status from down to up
          Rails.logger.info("Parameter #{parameter.id}: status flipping from down to up.")
        end
        # Regardless, set this parameter's status to up
        parameter.monitoring_status = :up
        parameter.save
      end
    end
  end
end
