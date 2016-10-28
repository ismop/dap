module Api
  module V1
    class ThreatLevelsController < Api::ApiController
      skip_authorization_check
      before_filter(only: [:index]) { authorize! :read, :threat_level }
      before_filter(only: [:index]) { set_limit }
      before_filter(only: [:index]) { set_from_to }

      respond_to :json

      def index
        render json: {threat_levels: threat_levels_for_profiles}
      end

      private
      def set_from_to
        @from = params.fetch(:from, nil)
        @to = params.fetch(:to, nil)

        @from = Time.parse(@from).to_s unless @from.blank?
        @to = Time.parse(@to).to_s unless @to.blank?
      end
      def set_limit
        @limit = params.fetch(:limit, 5).to_i
        @limit = @limit > 0 ? @limit : 5
      end

      def threat_levels_for_profiles
        @assessments_data = {}
        @threat_assessments = []
        threat_assessment_ids = ThreatAssessment.find_by_sql(sql).collect do |ta|
          ta.id
        end
        if threat_assessment_ids.present?
          results_data = build_results_data(threat_assessment_ids)
          fill_threat_assessments_data(results_data)
        end
        @assessments_data.values
      end

      def fill_threat_assessments_data(results_data)
        @threat_assessments.uniq!
        @threat_assessments.each do |ta|
          profile = ta.profiles.first
          next unless profile
          if @assessments_data[profile.id].nil?
            @assessments_data[profile.id] = {
              profile_id: profile.id,
              profile_custom_id: profile.custom_id,
              section_id: profile.section_id,
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
          @threat_assessments << ta
          results_data[ta.id] = [] if results_data[ta.id].nil?
          results_data[ta.id] << result_entry(result)
        end
        results_data
      end

      def sql
        <<-SQL
          SELECT id, created_at, status, rank
            FROM (
              SELECT id, created_at, status, rank()
              OVER (PARTITION BY profile_id ORDER BY created_at DESC)
              FROM (
                SELECT threat_assessments.id, threat_assessments.created_at, threat_assessments.status, profile_selections.profile_id
                FROM threat_assessments JOIN profile_selections ON threat_assessments.id=profile_selections.threat_assessment_id
                #{"WHERE threat_assessments.created_at BETWEEN '#{@from}' AND '#{@to}'" if @from && @to}) tpq
            ) inq
          WHERE rank < #{@limit + 1}
        SQL
      end

      def results(threat_assessment_ids)
        Result.includes(threat_assessment:[:profiles]).includes(:scenario).
          joins(threat_assessment: :profiles).
          where("threat_assessments.id IN (#{threat_assessment_ids.join(',')})").
          references(:threat_assessment)
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
