module Api
  module V1
    class MeasurementNodesController < Api::ApiController
      load_and_authorize_resource :measurement_node
      respond_to :json

      def index
        respond_with @measurement_nodes.where(filter).order(:id)
      end

      def show
        respond_with @measurement_node
      end

      def update
        @measurement_node.update_attributes!(measurement_node_params)
        render json: @measurement_node, serializer: MeasurementNodeSerializer
      end

      private

      def measurement_node_params
        params.require(:measurement_node).permit(:all)
      end
    end
  end
end