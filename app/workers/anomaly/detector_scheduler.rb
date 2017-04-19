# frozen_string_literal: true

module Anomaly
  class DetectorScheduler
    include Sidekiq::Worker

    def perform
      active_experiments = Experiment.where("start_date <= :t AND end_date >= :t", { t: Time.now })
      active_experiments.each do |exp|
        schedule_analysis_for_exp(exp)
      end
    end

    private

    def schedule_analysis_for_exp(exp)
      egdes = DapConfig['anomaly']['edges']
      egdes.each { |_, e| schedule_analysis_for_edge(exp, e) }
    end

    def schedule_analysis_for_edge(exp, edge)
      axises = DapConfig['anomaly']['edges']
      axises.each { |_, a| schedule_analysis_for_axis(exp, edge,a) }
    end

    def schedule_analysis_for_axis(exp, edge, axis)
      analysis_params = { exp_id: exp.id }.merge(edge).merge(axis).symbolize_keys
      detector = DapConfig['anomaly']['detector_class_name'].constantize
      detector.new(analysis_params).perform_async
    end
  end
end
