module Api
  module V1
    class ProfilesController < Api::ApiController
      load_and_authorize_resource :profile
      respond_to :json

      def index
        respond_with @profiles.where(filter).order(:id)
      end

      def show
        respond_with @profiles
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