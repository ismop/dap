class SentryWorker

  include Sidekiq::Worker

  sidekiq_options retry: false, queue: ENV['DAP_QUEUE_NAME']

  def perform(updates)
    if (!updates['up'].empty? || !updates['down'].empty?)
      down = Parameter.where('monitoring_status = ? AND monitored = ?', 2, true)
      message = "Parameter status change\n"
      message << '- parameters lost: ' << updates['down'].collect() { |e| "#{e}" }.to_s << "\n"
      message << '- parameters found: ' << updates['up'].collect() { |e| "#{e}" }.to_s << "\n"
      message << '- parameters down: ' << down.collect() { |e| "#{e.custom_id}" }.to_s << "\n"
      event = Raven::Event.new(:message =>  message,
                               :level => 'warn',
                               :tags => {'category' => 'sensor_status'})
      Raven.send_event(event)
    end
  end

end