module Api
  module V1
    class ExperimentsController < Api::ApiController
      load_and_authorize_resource :experiment
      respond_to :json

      def index
        respond_with @experiments.order(:id)
      end

      def show
        respond_with @experiments
      end

      def update
        @experiment.update_attributes!(experiment_params)
        render json: @experiment, serializer: ExperimentSerializer
      end

      private

      def experiment_params
        params.require(:experiment).permit(:status, :selection, :start_date, :end_date, :profile_ids)
      end
    end
  end
end