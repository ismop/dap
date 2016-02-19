require_relative 'csv_exporter.rb'

module Exporters
  class ExperimentExporter < Exporters::CSVExporter

    attr_accessor :file

    def initialize(experiment_id)
      @experiment_id = experiment_id
    end

    def measurements(id = @experiment_id)
      experiment = Experiment.find(id); return [] if experiment.blank?
      levee = experiment.levee; return [] if levee.blank?
      context = Context.find_by(context_type: 'measurements'); return [] if context.blank?
      devices = levee.devices.ids; return [] if devices.blank?
      Measurement
          .after_date(experiment.start_date, true)
          .before_date(experiment.end_date, true)
          .eager_load(timeline: { parameter: :device })
          .where("timelines.context_id" => context.id)
          .where("devices.id" => devices)
          .order(:m_timestamp)
    end

    def serializer
      MeasurementSerializer.new
    end

    class MeasurementSerializer
      def serialize(m)
        time = m.m_timestamp.to_i
        xyz = m.timeline.parameter.device.placement
        if xyz.blank?
          x = y = z = ''
        else
          x = xyz.x
          y = xyz.y
          z = xyz.z
        end
        name = m.timeline.parameter.measurement_type.name
        val = '%.8f' % m.value
        [time, x, y, z, name, val]

      end
    end

  end
end