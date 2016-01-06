module Api
  module V1
    class MonitoringController < Api::ApiController
      skip_authorization_check
      before_filter(only: [:index]) { authorize! :read, :monitoring }

      respond_to :json

      def index
        query = Parameter.monitorable.down
        render json: query
      end
    end
  end
end
