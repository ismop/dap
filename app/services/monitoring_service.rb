class MonitoringService

  def self.perform_monitoring
    monitorable = Parameter.monitorable
    Rails.logger.info("#{Parameter.count} parameters registered (#{monitorable.count} monitorable)")
    monitorable_ids = monitorable.collect(&:id)

    # Quit if nothing to monitor
    if monitorable_ids.blank?
      return
    end

    timelines = Timeline.where("parameter_id IN (?) AND context_id = 1", monitorable_ids).includes(:parameter).references(:parameter)

    # Quit with warning if no suitable timelines present
    if timelines.blank?
      Rails.logger.warn("No real timelines present for any of the monitored parameters. Exiting.")
      return
    end

    alert_trigger = Rails.configuration.sensor_data_alert_trigger

    # Get latest measurements for each TL.
    # Use SQL for speed
    sql = "SELECT timeline_id, MAX(m_timestamp) FROM measurements "
    sql << " WHERE timeline_id IN (#{timelines.collect(&:id).join(',')}) "
    sql << " AND m_timestamp >= \'#{Time.now-4*alert_trigger.seconds}\'"
    sql << " GROUP BY timeline_id"

    result = ActiveRecord::Base.connection.execute(sql).to_a
    update = {up: [], down: []}

    timelines_map = timelines.map { |t| [t.id, { timeline: t, measurement: nil}] }.to_h

    result.each do |m|
      timelines_map[m['timeline_id'].to_i][:measurement] = m
    end

    timelines_map.each_value do |tm_value|
      t = tm_value[:timeline]
      m = tm_value[:measurement]
      parameter = t.parameter
      if m.nil? || (Time.now - Time.parse(m['max']+' UTC')).to_i > alert_trigger
        # Write a warning to log if changing status from up to down
        if parameter.monitoring_status == :up
          Rails.logger.warn("Parameter #{parameter.custom_id} (id: #{parameter.id}) - status flipping from up to down.")
          update[:down].push(parameter.custom_id)
          parameter.monitoring_status = :down
          parameter.save
        end
      else
        if parameter.monitoring_status == :down
          # Write an info message to log if changing status from down to up
          Rails.logger.info("Parameter #{parameter.custom_id} (id: #{parameter.id}) - status flipping from down to up.")
          update[:up].push(parameter.custom_id)
          parameter.monitoring_status = :up
          parameter.save
        end
      end
    end
    SentryWorker.perform_async(update)
  end
end
