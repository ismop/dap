class PruningWorker
  include Sidekiq::Worker

  sidekiq_options retry: false, queue: ENV['DAP_QUEUE_NAME']

  def perform
    Rails.logger.error "Pruning duplicate measurements."
    PruningService::prune_duplicates
  end
end