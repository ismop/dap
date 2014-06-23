module Api
  module V1
    class EdgeNodesController < Api::ApiController
      load_and_authorize_resource :edge_node
      respond_to :json

      def index
        respond_with @edge_nodes.where(filter).order(:id)
      end

      def show
        respond_with @edge_node
      end

      def update
        @edge_node.update_attributes!(edge_node_params)
        render json: @edge_node, serializer: EdgeNodeSerializer
      end

      private

      def edge_node_params
        params.require(:edge_node).permit(:all)
      end
    end
  end
end