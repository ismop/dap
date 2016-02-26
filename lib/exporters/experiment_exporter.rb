require_relative 'csv_exporter.rb'
require 'csv'

module Exporters
  class ExperimentExporter < Exporters::CSVExporter

    attr_accessor :file

    def initialize(experiment_id)
      @experiment_id = experiment_id
    end

    def measurements(device_ids = nil)
      if device_ids.nil?
        device_ids = devices
      end
      Measurement
          .after_date(@experiment.start_date, true)
          .before_date(@experiment.end_date, true)
          .eager_load(timeline: { parameter: [:device, :measurement_type ]})
          .where("timelines.context_id" => @context.id)
          .where("devices.id" => device_ids)
          .select('measurements.timeline_id, timelines.parameter_id, timelines.context_id, parameters.device_id, '\
            'measurements.value, measurements.m_timestamp, '\
            'parameters.custom_id, '\
            'devices.placement')
          .order(Parameter.arel_table[:device_id], :m_timestamp)
    end

    def devices
      @experiment = Experiment.find(@experiment_id); return [] if @experiment.blank?
      @levee = @experiment.levee; return [] if @levee.blank?
      @context = Context.find_by(context_type: 'measurements'); return [] if @context.blank?
      devices = @levee.devices.ids; return [] if devices.blank?
      devices
    end

    def export_slices(writer)
      device_ids = devices
      device_ids.each_slice(30) do |devices_slice|
        measurements = measurements(devices_slice)
        csv_chunk = CSV.generate do |csv|
          measurements.each do |m|
            csv << serializer.serialize(m)
          end
        end
        writer.write(csv_chunk)
      end
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