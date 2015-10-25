module Api
  module V1
    class ScenariosController < Api::ApiController
      load_and_authorize_resource :scenario
      respond_to :json

      def index
        query = @scenarios

        if params.keys.include? "experiment_ids"
          query = query.joins(:experiments)
          ids = params[:experiment_ids].split(',').collect{|id| id.to_i}
          query = query.where("experiments.id IN (?)", ids)
        end

        if params.keys.include? "timeline_ids"
          query = query.joins(:timelines)
          ids = params[:timeline_ids]
          query = query.where("timelines.id IN (?)", params[:timeline_ids].split(','))
        end

        respond_with query.where(filter).uniq.order(:id)
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