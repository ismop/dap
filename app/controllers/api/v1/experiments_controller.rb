module Api
  module V1
    class ExperimentsController < Api::ApiController
      load_and_authorize_resource :experiment
      respond_to :json

      def index
        respond_with @experiments.where(filter).order(:id)
      end

      def show
        respond_with @experiment
      end

      def update
        @experiment.update_attributes!(experiment_params)
        render json: @experiment, serializer: ExperimentSerializer
      end

      private

      def experiment_params
        params.require(:experiment).permit(:all)
      end
    end
  end
end