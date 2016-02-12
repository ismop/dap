require_relative 'csv_exporter.rb'

module Exporters
  class ChartExporter < Exporters::CSVExporter

    attr_accessor :file

    def initialize(parameter_ids, time_from = nil, time_to = nil)
      @parameter_ids = parameter_ids
      @time_from = time_from
      @time_to = time_to
    end

    def timelines
      context = Context.find_by(context_type: 'measurements')
      return [] if context.nil?
      Timeline.where(context_id: context.id)
            .where(parameter_id: @parameter_ids)
    end

    # TODO optimize queries
    def measurements
      tl = timelines
      return [] if tl.empty?
      Measurement.where(timeline_id: tl.ids)
          .after_date(@time_from, true)
          .before_date(@time_to, true)
          .order(:timestamp)
    end

    def serializer
      MeasurementSerializer.new
    end

    class MeasurementSerializer
      def serialize(m)
        time = m.timestamp.to_i
        id = m.timeline.parameter_id
        value = '%.8f' % m.value
        [time, id, value]
      end
    end

  end
end