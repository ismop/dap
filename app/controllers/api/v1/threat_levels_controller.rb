module Api
  module V1
    class ThreatLevelsController < Api::ApiController
      skip_authorization_check
      before_filter(only: [:index]) { authorize! :read, :threat_level }

      respond_to :json

      def index
        set_limit
        render json: threat_levels_data
      end

      private
      def set_limit
        @limit = params.fetch(:limit, 5).to_i
        @limit = @limit > 0 ? @limit : 5
      end

      def threat_levels_data
        {threat_levels: threat_levels_for_profiles}
      end

      def threat_levels_for_profiles
        Profile.all.collect { |p| threat_levels_for_profile(p) }
      end

      def threat_levels_for_profile(profile)
        {
          profile_id: profile.id,
          threat_assessments: threat_assessments_for_profile(profile),
          threat_level_assessment_runs: ThreatLevel::AssessmentRunsDataBuilderService.get(profile)
        }
      end

      def threat_assessments_for_profile(profile)
        assessments = profile.threat_assessments.order(created_at: :desc).limit(@limit)
        assessments.collect do |a|
          {
            date: a.created_at,
            scenarios: scenarios_for_assessment(a)
          }
        end
      end

      def scenarios_for_assessment(assessment)
        assessment.results.collect do |result|
          {
            similarity: result.similarity,
            scenario_id: result.scenario.id,
            threat_level: result.scenario.threat_level,
            offset: result.offset,
            name: result.scenario.name,
            description: result.scenario.description
          }
        end
      end
    end
  end
end
