module Api
  module V1
    class ResultsController < Api::ApiController
      load_and_authorize_resource :result
      respond_to :json

      def index
        respond_with @results.order(:id)
      end

      def show
        respond_with @results
      end

      def update
        puts "Updating with #{params}"
        puts "Updating with #{result_params}"
        @result.update_attributes!(result_params)
        render json: @result, serializer: ResultSerializer
      end

      private

      def result_params
        params.require(:result).permit(:similarity)
      end
    end
  end
end