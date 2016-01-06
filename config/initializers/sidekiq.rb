sidekiq_connection = {
    url: Rails.configuration.redis_url,
    namespace: Rails.configuration.redis_namespace
}

Sidekiq.configure_server do |config|
  config.redis = sidekiq_connection
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_connection
end