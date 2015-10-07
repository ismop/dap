module Api
  module V1
    class DevicesController < Api::ApiController
      load_and_authorize_resource :device
      respond_to :json

      def index
        respond_with(@devices.
                     includes(:budokop_sensor, :neosentio_sensor, :pump,
                              :weather_station, :fiber_optic_node, :parameters).
                     where(filter).
                     order(:id))
      end

      def show
        respond_with @device
      end

      def update
        @device.update_attributes!(device_params)
        render json: @device, serializer: DeviceSerializer
      end

      private

      def device_params
        params.require(:device).permit(:all)
      end
    end
  end
end
