module Anomaly
  class SimpleDetector
    include Sidekiq::Worker

    EPOCH = 15.minutes
    AVG_DEV = 5

    attr_reader :lon1, :lat1, :lon2, :lat2, :dist1, :dist2, :h1, :h2, :exp_id, :section_ids

    def initialize(lon1:, lat1:, lon2:, lat2:, dist1:, dist2:, h1:, h2:, exp_id:, section_ids:)
      @lon1 = lon1
      @lat1 = lat1
      @lon2 = lon2
      @lat2 = lat2
      @dist1 = dist1
      @dist2 = dist2
      @h1 = h1
      @h2 = h2
      @exp = Experiment.find(exp_id)
      @section_ids = section_ids
    end

    def perform
      if (Time.now < exp.start_date + EPOCH)
        Rails.logger.info('Not enough data to detect anomalies')
        return
      end
      get_reference_data
      get_current_data
      detect_anomaly
    end

    private

    def sorted_measurements(dev)
      dev.parameters.first.timelines.first.measurements
        .sort{|m1, m2| m1.m_timestamp <=> m2.m_timestamp}
        .first
    end

    def get_reference_data
      @reference_data = DataProvider.get(
        lon1: lon1, lat1: lat1, lon2: lon2, lat2: lat2,
        dist1: dist1, dist2: dist2, h1: h1, h2: h2,
        from: exp.start_date, to: from + EPOCH,
        section_ids: section_ids
      ).map { |d| [d.id, sorted_measurements(d).first] }.to_h
    end

    def get_current_data
      now = Time.now
      @current_data = DataProvider.get(
        lon1: lon1, lat1: lat1, lon2: lon2, lat2: lat2,
        dist1: dist1, dist2: dist2, h1: h1, h2: h2,
        from: now - EPOCH, to: now,
        section_ids: section_ids
      )
    end

    def detect_anomaly
      @delta_map = {}
      @current_data.each do |dev|
        current_measurement = sorted_measurements(dev).last
        ref_measurement = @reference_data[dev.id]
        @delta_map[dev.custom_id] = current_measurement - ref_measurement
      end
      return if @delta_map.blank?
      @avg_delta = @delta_map.values.sum.to_f / @delta_map.size
      anomalies = @delta_map.select {|_, delta| (delta - avg_delta).abs > AVG_DEV }
      report(anomalies) if anomalies.present?
    end

    def report(anomalies)
      message = msg_for_anomalies(anomalies)
      event = Raven::Event.new(:message =>  message,
                               :level => 'warn',
                               :tags => {'category' => 'anomalies'})
      Raven.send_event(event)
    end

    def msg_for_anomalies(anomalies)
      "Detected anomalies:\n#{ anomalies.each {|dev, delta| "Device #{dev} has parameter delta equal #{delta}\n"} }" \
      "while average delta is #{@avg_delta}"
    end
  end
end
