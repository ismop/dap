module Api
  module V1
    class ThreatLevelsController < Api::ApiController
      skip_authorization_check
      before_filter(only: [:index]) { authorize! :read, :threat_level }

      respond_to :json


      def index
        respond_with []
      end
    end
  end
end
