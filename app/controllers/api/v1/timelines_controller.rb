module Api
  module V1
    class TimelinesController < Api::ApiController
      load_and_authorize_resource :timeline
      respond_to :json

      def index
        respond_with @timelines.where(filter).order(:id)
      end

      def show
        respond_with @timeline
      end

      def update
        @timeline.update_attributes!(timeline_params)
        render json: @timeline, serializer: TimelineSerializer
      end

      private

      def timeline_params
        params.require(:timeline).permit(:name, :measurement_type)
      end
    end
  end
end