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
            .where(parameter_id: @parameter_ids).ids
    end

    def measurements(tl = timelines)
      return Measurement.none if tl.empty?
      Measurement.where(timeline_id: tl)
          .eager_load(:timeline)
          .after_date(@time_from, true)
          .before_date(@time_to, true)
          .eager_load(timeline: { parameter: [:measurement_type ]})
          .select('measurements.timeline_id, timelines.parameter_id, parameters.device_id, parameters.measurement_type_id, '\
            'measurement_types.name, parameters.custom_id, '\
            'measurements.value, measurements.m_timestamp')
          .order(:m_timestamp)
    end

    def export_slices(writer, slice_size = 30)
      timelines.each_slice(slice_size) do |timelines_slice|
        measurements = measurements(timelines_slice)
        csv_chunk = CSV.generate do |csv|
          measurements.each do |m|
            csv << serializer.serialize(m)
          end
        end
        writer.write(csv_chunk)
      end
      writer.close
    end

    def serializer
      MeasurementSerializer.new
    end

    class MeasurementSerializer
      def serialize(m)
        time = m.m_timestamp.to_i
        custom_id = m.timeline.parameter.custom_id
        type_name = m.timeline.parameter.measurement_type.name
        value = '%.8f' % m.value
        [time, custom_id, type_name, value]
      end
    end

  end
end