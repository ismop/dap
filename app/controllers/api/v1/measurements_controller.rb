module Api
  module V1
    class MeasurementsController < Api::ApiController
      load_and_authorize_resource :measurement
      respond_to :json

      def index
        query = @measurements

        if params.keys.include? "time_from"
          time_from = Time.parse(params[:time_from]).utc.to_s
        else
          time_from = '1980-01-01'
        end
        if params.keys.include? "time_to"
          time_to = Time.parse(params[:time_to]).utc.to_s
        else
          time_to = '2100-01-01'
        end

        query = query.where(timestamp: time_from..time_to)

        if params.keys.include? "sensor_id"
          query = query.where(sensor_id: params[:sensor_id])
        end

        if params.keys.include? "timeline_id"
          query = query.where(timeline_id: params[:timeline_id])
        end

        respond_with query.order(:id)
      end

      def show
        respond_with @measurement
      end

      def update
        @measurement.update_attributes!(measurement_params)
        render json: @measurement, serializer: MeasurementSerializer
      end

      private

      def measurement_params
        params.require(:measurement).permit(:value, :timestamp, :source_address)
      end
    end
  end
end