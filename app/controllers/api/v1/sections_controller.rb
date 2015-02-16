module Api
  module V1
    class SectionsController < Api::ApiController
      load_and_authorize_resource :section
      respond_to :json

      def index
        selected_sections = @sections.includes(:sensors).where(filter)
        if !params['selection'].blank?
          # Parse the selection parameter into an RGeo feature
          begin
            wkt_parser = RGeo::WKRep::WKTParser.new
            selection = wkt_parser.parse(params['selection'])
          rescue Exception => e
            raise ActionController::BadRequest.new('sections', e)
          end

          if selection.blank?
            selected_sections = [] # Or throw an exception instead? (400 Bad Request + message)
          else
            sensors = selected_sections.collect{|p| p.sensors}.flatten.select{|s| selection.contains? s.placement}
            selected_sections = sensors.collect{|s| s.section}.uniq
          end
        end

        respond_with selected_sections
      end

      def show
        respond_with section
      end

      def update
        @section.update_attributes!(section_params)
        render json: section, serializer: SectionSerializer
      end

      private

      def section_params
        params.require(:section).permit(:all)
      end
    end

  end
end