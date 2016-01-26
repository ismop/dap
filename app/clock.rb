require 'clockwork'
module Clockwork
  require_relative '../config/boot'
  require_relative '../config/environment'

  every(Rails.configuration.sensor_data_polling_interval.seconds, 'monitoring.sensor_data') do
    MonitoringWorker.perform_async
  end

  every(Rails.configuration.timeline_earliest_measurement_polling_interval.seconds, 'monitoring.earliest_measurements') do
    EarliestMeasurementService.perform_async
  end
end