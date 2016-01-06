class MonitoringWorker
  include Sidekiq::Worker

  sidekiq_options retry: false, queue: ENV['DAP_QUEUE_NAME']

  def perform
    Rails.logger.error "Performing monitoring task for sensor data."
    MonitoringService::perform_monitoring
  end
end