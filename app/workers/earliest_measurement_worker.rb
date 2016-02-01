class EarliestMeasurementWorker
  include Sidekiq::Worker

  sidekiq_options retry: false, queue: ENV['DAP_QUEUE_NAME']

  def perform
    Rails.logger.error "Finding earliest measurements for timelines."
    EarliestMeasurementService::find_earliest_measurements
  end
end