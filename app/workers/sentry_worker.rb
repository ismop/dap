class SentryWorker

  include Sidekiq::Worker

  sidekiq_options retry: false, queue: ENV['DAP_QUEUE_NAME']

  def perform(params_down)
    if (!params_down.empty?)exit
      event = Raven::Event.new(:message =>  "Parameters down: #{params_down.sort}",
                               :level => 'warn',
                               :tags => {'category' => 'reporting'})
      Raven.send_event(event)
    end
  end

end