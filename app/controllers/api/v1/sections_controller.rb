module Api
  module V1
    class SectionsController < Api::ApiController
      load_and_authorize_resource :section
      respond_to :json

      def index
        respond_with @sections
      end

      def show
        respond_with @section
      end

      def update
        @section.update_attributes!(section)
        render json: section, serializer: SectionSerializer
      end

      private

      def section
        params.require(:section).permit(:all)
      end
    end

  end
end