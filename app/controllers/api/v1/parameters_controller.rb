module Api
  module V1
    class ParametersController < Api::ApiController
      load_and_authorize_resource :parmeter
      respond_to :json

      def index
        respond_with @parameters.where(filter).order(:id)
      end

      def show
        respond_with @parameter
      end

      def update
        @parameter.update_attributes!(parameter_params)
        render json: @parameter, serializer: ParameterSerializer
      end

      private

      def parameter_params
        params.require(:parameter).permit(:all)
      end
    end
  end
end