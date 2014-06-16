module Api
  module V1
    class LeveesController < Api::ApiController
      load_and_authorize_resource :levee
      respond_to :json

      def index
        respond_with @levees.order(:id)
      end

      def show
        respond_with @levee
      end

      def update
        @levee.update_attributes!(levee_params)

        puts levee_params.inspect

        render json: @levee, serializer: LeveeSerializer
      end

      private

      def levee_params
        params.require(:levee).permit(:emergency_level, :threat_level)
      end
    end
  end
end