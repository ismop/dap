module Api
  module V1
    class FiberOpticNodesController < Api::ApiController
      load_and_authorize_resource :fiber_optic_node
      respond_to :json

      def index
        respond_with @fiber_optic_nodes.where(filter).order(:id)
      end

      def show
        respond_with @fiber_optic_node
      end

      def update
        @fiber_optic_node.update_attributes!(fiber_optic_node_params)
        render json: @fiber_optic_node, serializer: FiberOpticNodeSerializer
      end

      private

      def fiber_optic_node_prams
        params.require(:fiber_optic_node).permit(:all)
      end
    end
  end
end