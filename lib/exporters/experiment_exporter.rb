require_relative 'csv_exporter.rb'
require 'csv'

module Exporters
  class ExperimentExporter < Exporters::CSVExporter

    attr_accessor :file

    def initialize(experiment_id, levee_id = nil, start_date = nil, end_date = nil)
      @experiment_id = experiment_id
      @levee_id = levee_id
      @start_date = start_date
      @end_date = end_date
    end

    def measurements(device_ids = nil)
      if device_ids.nil?
        device_ids = devices
      end
      if @start_date
        start_date = @start_date
      elsif @experiment
        start_date = @experiment.start_date
      end
      if @end_date
        end_date = @end_date
      elsif @experiment
        end_date = @experiment.end_date
      end
      Measurement
          .after_date(start_date, true)
          .before_date(end_date, true)
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
      if @levee_id.present?
        @levee = Levee.find(@levee_id)
      elsif @experiment_id.present?
        @experiment = Experiment.find(@experiment_id)
        @levee = @experiment.levee
      end
      return [] if @levee.blank?
      @context = Context.find_by(context_type: 'measurements'); return [] if @context.blank?
      devices = @levee.devices.ids; return [] if devices.blank?
      devices
    end

    def export_slices(writer, slice_size = 30)
      device_ids = devices
      device_ids.each_slice(slice_size) do |devices_slice|
        measurements = measurements(devices_slice)
        Rails.logger.debug("Retrieved #{measurements.length} measurements in this slice.")
        csv_chunk = CSV.generate do |csv|
          m_counter = 0
          measurements.each do |m|
            m_counter += 1
            csv << serializer.serialize(m)
            if m_counter % 1000 == 0
              Rails.logger.debug("#{m_counter} row pushed to CSV: #{serializer.serialize(m).inspect}")
            end
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
        xyz = m.timeline.parameter.device.placement
        param_id = m.timeline.parameter.custom_id
        if xyz.blank?
          x = y = z = ''
        else
          x = xyz.x
          y = xyz.y
          z = xyz.z
        end
        type_name = m.timeline.parameter.measurement_type.name
        val = '%.8f' % m.value
        [time, x, y, z, param_id, type_name, val]
      end
    end

  end
end