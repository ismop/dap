module Api
  module V1
    class ScenariosController < Api::ApiController
      load_and_authorize_resource :scenario
      respond_to :json

      def index
        query = @scenarios.joins(:experiments)

        if params.keys.include? "experiment_id"
          ids = params[:experiment_id]
          query = query.where("experiments.id = ?", params[:experiment_id])
        end

        respond_with query.where(filter).order(:id)
      end

      def show
        respond_with @scenario
      end

      def update
        @scenario.update_attributes!(scenario_params)
        render json: @scenario, serializer: ScenarioSerializer
      end

      private

      def scenario_params
        params.require(:experiment).permit(:all)
      end
    end
  end
end