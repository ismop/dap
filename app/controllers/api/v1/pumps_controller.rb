module Api
  module V1
    class PumpsController < Api::ApiController
      load_and_authorize_resource :pump
      respond_to :json

      def index
        respond_with @pump.where(filter).order(:id)
      end

      def show
        respond_with @pump
      end

      def update
        @pump.update_attributes!(pump_params)
        render json: @pump, serializer: PumpSerializer
      end

      private

      def pump_params
        params.require(:pump).permit(:all)
      end
    end
  end
end