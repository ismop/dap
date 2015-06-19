module Api
  module V1
    class DeviceAggregationsController < Api::ApiController
      load_and_authorize_resource :device_aggregation
      respond_to :json

      def index
        respond_with @device_aggregations.where(filter).order(:id)
      end

      def show
        respond_with @device_aggregation
      end

      def update
        @device_aggregation.update_attributes!(device_aggregation_params)
        render json: @device_aggregation, serializer: DeviceAggregationSerializer
      end

      private

      def device_aggregation_params
        params.require(:device_aggregation).permit(:all)
      end
    end
  end
end