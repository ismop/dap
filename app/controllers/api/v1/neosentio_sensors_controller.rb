module Api
  module V1
    class NeosentioSensorsController < Api::ApiController
      load_and_authorize_resource :neosentio_sensor
      respond_to :json

      def index
        respond_with @neosentio_sensors.where(filter).order(:id)
      end

      def show
        respond_with @neosentio_sensor
      end

      def update
        @neosentio_sensor.update_attributes!(neosentio_sensor_params)
        render json: @neosentio_sensor, serializer: NeosentioSensorSerializer
      end

      private

      def neosentio_sensor_params
        params.require(:neosentio_sensor).permit(:all)
      end
    end
  end
end