module Api
  module V1
    class ThreatAssessmentsController < Api::ApiController
      #skip_authorization_check
      load_and_authorize_resource :threat_assessment
      respond_to :json

      def create
        threat_assessment = ThreatAssessment.create(threat_assessment_params)
        # If the list of sections is explicitly set, bind to these profiles
        if !params['threat_assessment']['profile_ids'].blank?
          params['threat_assessment']['profile_ids'].each do |id|
            p = Profile.find(id.to_i)
            if !p.blank?
              threat_assessment.profiles << p
            end
          end
        end
        threat_assessment.save!
        render json: threat_assessment, serializer: ThreatAssessmentSerializer, status: :created
      end

      def index
        respond_with @threat_assessments.where(filter).order(:id)
      end

      def show
        respond_with @threat_assessment
      end

      def update
        @threat_assessment.update_attributes!(threat_assessment_params)
        render json: @threat_assessment, serializer: ThreatAssessmentSerializer
      end

      private

      def threat_assessment_params
        params.require(:threat_assessment).permit(:name, :status, :status_message, :selection, :start_date, :end_date, :profile_ids)
      end
    end
    end
end