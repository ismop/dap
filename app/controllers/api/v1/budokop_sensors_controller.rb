module Api
  module V1
    class BudokopSensorsController < Api::ApiController
      load_and_authorize_resource :budokop_sensor
      respond_to :json

      def index
        respond_with @budokop_sensor.where(filter).order(:id)
      end

      def show
        respond_with @budokop_sensor
      end

      def update
        @budokop_sensor.update_attributes!(budokop_sensor_params)
        render json: @budokop_sensor, serializer: BudokopSensorSerializer
      end

      private

      def budokop_sensor_params
        params.require(:budokop_sensor).permit(:all)
      end
    end
  end
end