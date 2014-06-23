module Api
  module V1
    class SensorsController < Api::ApiController
      load_and_authorize_resource :sensor
      respond_to :json

      def index
        respond_with @sensors.where(filter).order(:id)
      end

      def show
        respond_with @sensor
      end

      def update
        @sensor.update_attributes!(sensor_params)
        render json: @sensor, serializer: SensorSerializer
      end

      private

      def sensor_params
        params.require(:sensor).permit(:all)
      end
    end
  end
end