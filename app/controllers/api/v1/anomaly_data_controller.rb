module Api
  module V1
    class AnomalyDataController < Api::ApiController
      authorize_resource :device
      respond_to :json

      def index

        #respond_with Anomaly::DataProvider.get(query_params)
        anomaly_data = produce_anomaly_data Anomaly::DataProvider.get(query_params)
        render json: anomaly_data

      end

      private

      def query_params
        {
          lon1: params.require(:lon1).to_f,
          lat1: params.require(:lat1).to_f,
          lon2: params.require(:lon2).to_f,
          lat2: params.require(:lat2).to_f,
          dist1: params.require(:dist1).to_f,
          dist2: params.require(:dist2).to_f,
          h1: params.require(:h1).to_f,
          h2: params.require(:h2).to_f,
          from: Time.parse(params.require(:from)).utc.to_s,
          to: Time.parse(params.require(:to)).utc.to_s,
          section_ids: JSON.parse(params.require(:section_ids))
        }
      end

      def produce_anomaly_data(devices)
        anomaly_data = {devices: []}
        devices.each do |dev|
          anomaly_data[:devices] << data_for_dev(dev)
        end
        anomaly_data
      end

      def data_for_dev(dev)
        {
          id: dev.id,
          placement: dev.placement,
          section_id: dev.section_id,
          parameters: data_for_parameters(dev.parameters)
        }
      end

      def data_for_parameters(parameters)
        parameters.collect { |p| data_for_parameter(p) }
      end

      def data_for_parameter(parameter)
        {
          id: parameter.id,
          timelines: data_for_timelines(parameter.timelines)
        }
      end
      def data_for_timelines(timelines)

        timelines.collect { |t| data_for_timeline(t) }
      end

      def data_for_timeline(timeline)
        {
          id: timeline.id,
          measurements: data_for_measurements(timeline.measurements)
        }
      end

      def data_for_measurements(measurements)
        measurements.collect { |m| data_for_measurement(m) }
      end

      def data_for_measurement(measurement)
        {
          id: measurement.id,
          value: measurement.value,
          timestamp: measurement.m_timestamp
        }
      end
    end
  end
end
