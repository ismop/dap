module Api
  module V1
    class ResultsController < Api::ApiController
      load_and_authorize_resource :result
      respond_to :json

      def create
        result = Result.create(result_params)
        if !params['result']['profile_id'].blank?
          result.profile = Profile.find(params['result']['profile_id'].to_i)
        end
        if !params['result']['scenario_id'].blank?
          result.scenario = Scenario.find(params['result']['scenario_id'].to_i)
        end
        if !params['result']['experiment_id'].blank?
          result.experiment = Experiment.find(params['result']['experiment_id'].to_i)
        end

        result.save!
        render json: result, serializer: ResultSerializer
      end

      def index
        respond_with @results.where(filter).order(:id)
      end

      def show
        respond_with @result
      end

      def update
        @result.update_attributes!(result_params)
        render json: @result, serializer: ResultSerializer
      end

      private

      def result_params
        params.require(:result).permit(:similarity, :experiment_id, :profile_id, :scenario_id)
      end
    end
  end
end