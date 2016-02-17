require_relative 'csv_exporter.rb'

module Exporters
  class ExperimentExporter < Exporters::CSVExporter

    attr_accessor :file

    def initialize(experiment_id)
      @experiment_id = experiment_id
    end

    # TODO optimize queries
    def timelines
      @experiment = Experiment.find(@experiment_id)
      levee = @experiment.levee; return [] if levee.blank?
      devices = levee.devices; return [] if devices.blank?
      parameters = Parameter.where(device_id: devices.ids); return [] if parameters.blank?
      context = Context.find_by(context_type: 'measurements'); return [] if context.blank?
      Timeline.where(context_id: context.id)
            .where(parameter_id: parameters.ids)
    end

    # TODO optimize queries
    def measurements
      tls = timelines
      return [] if tls.blank?
      Measurement.where(timeline_id: tls.ids)
          .after_date(@experiment.start_date, true)
          .before_date(@experiment.end_date, true)
          .order(:m_timestamp)
    end

    def serializer
      MeasurementSerializer.new
    end

    class MeasurementSerializer
      def serialize(m)
        time = m.m_timestamp.to_i
        xyz = m.timeline.parameter.device.placement
        name = m.timeline.parameter.measurement_type.name
        val = '%.8f' % m.value
        [time, xyz.x, xyz.y, xyz.z, name, val]
      end
    end

  end
end