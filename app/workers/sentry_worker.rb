class SentryWorker

  include Sidekiq::Worker

  sidekiq_options retry: false, queue: ENV['DAP_QUEUE_NAME']

  def perform(message)
    if (!message.empty?)
      event = Raven::Event.new(:message =>  message,
                               :level => 'warn',
                               :tags => {'category' => 'sensor_status'})
      Raven.send_event(event)
    end
  end

end