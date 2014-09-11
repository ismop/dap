module Api
  module V1
    class ExperimentsController < Api::ApiController
      #skip_authorization_check
      load_and_authorize_resource :experiment
      respond_to :json

      def create
        experiment = Experiment.create(experiment_params)
        # If the list of profiles is explicitly set, bind to these profiles
        if !params['experiment']['profile_ids'].blank?
          params['experiment']['profile_ids'].each do |id|
            p = Profile.find(id.to_i)
            if !p.blank?
              experiment.profiles << p
            end
          end
        end
        experiment.save!
        render json: experiment, serializer: ExperimentSerializer, status: :created
      end

      def index
        respond_with @experiments.order(:id)
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
        params.require(:experiment).permit(:name, :status, :status_message, :selection, :start_date, :end_date, :profile_ids)
      end
    end
  end
end