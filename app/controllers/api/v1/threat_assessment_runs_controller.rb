module Api
  module V1
    class ThreatAssessmentRunsController < Api::ApiController
      #skip_authorization_check
      load_and_authorize_resource :threat_assessment_run
      respond_to :json

      def create
        threat_assessment_run = ThreatAssessmentRun.create(threat_assessment_run_params)
        threat_assessment_run.save!
        render json: threat_assessment_run, serializer: ThreatAssessmentRunSerializer, status: :created
      end

      def index
        respond_with @threat_assessment_runs.where(filter).order(:id)
      end

      def show
        respond_with @threat_assessment_run
      end

      def update
        @threat_assessment_run.update_attributes!(threat_assessment_run_params)
        render json: @threat_assessment_run, serializer: ThreatAssessmentRunSerializer
      end

      private

      def threat_assessment_run_params
        params.require(:threat_assessment_run).permit(:name, :status, :start_date, :end_date, :experiment_id)
      end
    end
    end
end