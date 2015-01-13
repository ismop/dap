module Api
  module V1
    class ProfilesController < Api::ApiController
      load_and_authorize_resource :profile
      respond_to :json

      def index
        selected_profiles = @profiles.includes(:sensors).where(filter)
        if !params['selection'].blank?
          # Parse the selection parameter into an RGeo feature
          begin
            wkt_parser = RGeo::WKRep::WKTParser.new
            selection = wkt_parser.parse(params['selection'])
          rescue Exception => e
            raise ActionController::BadRequest.new('profiles', e)
          end

          if selection.blank?
            selected_profiles = [] # Or throw an exception instead? (400 Bad Request + message)
          else
            sensors = selected_profiles.collect{|p| p.sensors}.flatten.select{|s| selection.contains? s.placement}
            selected_profiles = sensors.collect{|s| s.profile}.uniq
          end
        end

        respond_with selected_profiles
      end

      def show
        respond_with @profile
      end

      def update
        @profile.update_attributes!(profile_params)
        render json: @profile, serializer: ProfileSerializer
      end

      private

      def sensor_params
        params.require(:profile).permit(:all)
      end
    end

  end
end