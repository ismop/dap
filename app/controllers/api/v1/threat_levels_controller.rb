module Api
  module V1
    class ThreatLevelsController < Api::ApiController
      skip_authorization_check
      before_filter(only: [:index]) { authorize! :read, :threat_level }

      respond_to :json

      def index
        set_limit
        render json: {threat_levels: threat_levels_for_profiles}
      end

      private
      def set_limit
        @limit = params.fetch(:limit, 5).to_i
        @limit = @limit > 0 ? @limit : 5
      end

      def threat_levels_for_profiles
        @assessments_data = {}
        @threat_assessments = ThreatAssessment.find_by_sql(sql)
        threat_assessment_ids = @threat_assessments.collect {|ta| ta.id}
        if threat_assessment_ids.present?
          results_data = build_results_data(threat_assessment_ids)
          fill_threat_assessments_data(results_data)
        end
        @assessments_data.values
      end

      def fill_threat_assessments_data(results_data)
        @threat_assessments.each do |ta|
          profile = ta.profiles.first
          next unless profile
          if @assessments_data[profile.id].nil?
            @assessments_data[profile.id] = {
              profile_id: profile.id,
              threat_assessments: []
            }
          end
          @assessments_data[profile.id][:threat_assessments] << assessment_entry(ta, results_data)
        end

        @assessments_data.each do |profile_id, assessments|
          assessments[:threat_level_assessment_runs] =
            ThreatLevel::AssessmentRunsDataBuilderService.get(profile_id)
        end
      end

      def build_results_data(threat_assessment_ids)
        results_data = {}
        results(threat_assessment_ids).each do |result|
          ta = result.threat_assessment
          results_data[ta.id] = [] if results_data[ta.id].nil?
          results_data[ta.id] << result_entry(result)
        end
        results_data
      end

      def sql
        <<-SQL
          SELECT id, profile_id, created_at, status, rank
            FROM (
              SELECT id, profile_id, created_at, status, rank()
              OVER (PARTITION BY profile_id ORDER BY created_at DESC)
              FROM threat_assessments) inq
          WHERE rank < #{@limit + 1}
        SQL
      end

      def results(threat_assessment_ids)
        Result.includes(threat_assessment:[:profiles]).includes(:scenario).
          joins(:threat_assessment).
          where("threat_assessments.id IN (#{threat_assessment_ids.join(',')})")
      end

      def result_entry(result)
        {
          similarity: result.similarity,
          scenario_id: result.scenario.id,
          threat_level: result.scenario.threat_level,
          offset: result.offset,
          name: result.scenario.name,
          description: result.scenario.description
        }
      end

      def assessment_entry(assessment, results_data)
        {
          date: assessment.created_at,
          status: assessment.status,
          scenarios: results_data[assessment.id]
        }
      end
    end
  end
end
