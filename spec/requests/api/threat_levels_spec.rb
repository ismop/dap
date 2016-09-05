require 'rails_helper'

describe Api::V1::ThreatLevelsController do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /threat_levels' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/threat_levels")

        expect(response.status).to eq 401
      end
    end

    context 'when authenticated' do
      it 'returns 200 OK' do
        get api("/threat_levels", user)
        expect(response.status).to eq 200
      end
    end

    it 'returns valid JSON' do
      get api("/threat_levels", user)
      expect { JSON.parse(response.body) }.not_to raise_error
    end

    it 'return empty threat levels array' do
      get api("/threat_levels", user)
      expect(json_response['threat_levels']).to eq []
    end

    context 'profile present in DB' do
      let!(:profile) { create(:profile) }

      it 'returns threat_levels with empty array value' do
        get api("/threat_levels", user)
        expect(json_response).to eq({'threat_levels' => []})
      end

      context 'threat level data present in DB' do
        let!(:threat_assessment) { create(:threat_assessment, profiles: [profile]) }
        let!(:scenario1) { create(:scenario, threat_level: 2) }
        let!(:scenario2) { create(:scenario, threat_level: 1) }
        let!(:result1) do
          create(:result,
                 threat_assessment: threat_assessment, similarity: 0.8, scenario: scenario1)
        end
        let!(:result2) { create(:result, threat_assessment: threat_assessment, similarity: 0.4, scenario: scenario2) }

        it 'returns threat levels data' do
          get api("/threat_levels", user)
          expect(json_response).to eq(threat_levels_with_results)
        end

        context '6 assessments exist in DB' do
          before do
            5.times do
              create(:result, threat_assessment: create(:threat_assessment, profiles: [profile]))
            end
          end

          it 'returns 5 latest assesments by default' do
            get api("/threat_levels", user)
            expect(contains_5_latest_assessment(assessments_from_response)).to be_truthy
          end
          it 'returns 5 latest assesments if specified limit is invalid' do
            get api("/threat_levels?limit=a", user)
            expect(assessments_from_response.size).to eq 5
          end
          it 'returns specified number of assessments' do
            limit = 3
            get api("/threat_levels?limit=#{limit}", user)
            expect(assessments_from_response.size).to eq limit
          end
        end

        context 'threat level assessment runs present in DB' do
          it 'includes assessment run data in response' do
            get api("/threat_levels", user)
            expect(assessment_runs_from_response).to eq expected_assessment_runs_data
          end
        end
      end
    end
  end

end

private
def assessment_runs_from_response
  json_response['threat_levels'].first['threat_level_assessment_runs']
end

def expected_assessment_runs_data
  threat_assessment_run = threat_assessment.threat_assessment_run
  [
    ThreatLevel::AssessmentRunStatusDataBuilderService.
      get(threat_assessment_run).as_json
  ]
end

def threat_levels_with_results
  threat_levels = {
    'threat_levels' => [
      {
        'profile_id' => profile.id,
        'threat_assessments' => [
          {
            'date' => threat_assessment.created_at.as_json,
            'status' => threat_assessment.status,
            'scenarios' => [
              {
                'similarity' => result1.similarity,
                'threat_level' => 2,
                'scenario_id' => result1.scenario_id,
                'offset' => result1.offset,
                'name' => result1.scenario.name,
                'description' => result1.scenario.description
              },
              {
                'similarity' => result2.similarity,
                'threat_level' => 1,
                'scenario_id' => result2.scenario_id,
                'offset' => result2.offset,
                'name' => result2.scenario.name,
                'description' => result2.scenario.description
              }
            ]
          }
        ],
        'threat_level_assessment_runs' => []
      }
    ]
  }

  threat_assessment_run = threat_assessment.threat_assessment_run
  threat_levels['threat_levels'][0]['threat_level_assessment_runs'] =
    [
      ThreatLevel::AssessmentRunStatusDataBuilderService.
          get(threat_assessment_run).as_json
    ]
  threat_levels
end

def threat_levels_with_results_and_runs
  threat_levels = threat_levels_with_results
  threat_levels['threat_levels'][0]['threat_level_assessment_runs'] = [

  ]
  threat_levels
end

def assessments_from_response
  json_response['threat_levels'].first['threat_assessments']
end

def contains_5_latest_assessment(assessments)
  assessments.size == 5 && !assessments.include?(threat_assessment)
end
