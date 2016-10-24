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
        get api('/threat_levels', user)
        expect(response.status).to eq 200
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
            it 'returns 5 latest assessments if specified limit is invalid' do
              get api("/threat_levels?limit=a", user)
              expect(assessments_from_response.size).to eq 5
            end
            it 'returns specified number of assessments' do
              limit = 3
              get api("/threat_levels?limit=#{limit}", user)
              expect(assessments_from_response.size).to eq limit
            end

            context 'from and to dates are specified' do
              it 'returns assessments created within specified period' do
                differentiate_assessments_created_at_date
                assessments = ThreatAssessment.order :created_at
                from = assessments[2].created_at - 1.second
                to = assessments[-2].created_at + 1.second
                from_param = URI::encode(from.to_s)
                to_param = URI::encode(to.to_s)

                get api("/threat_levels?limit=6&from=#{from_param}&to=#{to_param}", user)
                assessments_created_at_dates = assessments_from_response.collect do |a|
                  Time.parse a['date']
                end

                expect(dates_within_range(assessments_created_at_dates, from, to)).to be_truthy
              end

              context 'second profile with data present in DB' do
                let!(:second_profile) { create(:profile) }
                let!(:threat_assessment_2) { create(:threat_assessment, profiles: [second_profile]) }
                let!(:scenario2_1) { create(:scenario, threat_level: 2) }
                let!(:result2_1) do
                  create(:result,
                         threat_assessment: threat_assessment_2,
                         similarity: 0.8, scenario: scenario2_1)
                end

                it 'returns data for every profile' do
                  get api("/threat_levels?limit=1", user)
                  tls = json_response['threat_levels']
                  expect(tls.size).to eq Profile.count
                end
                it 'applies limit for every profile' do
                  get api("/threat_levels?limit=2", user)
                  json_response['threat_levels'].each do |tl|
                    expect(tl['threat_assessments'].size).to be <= 2
                  end
                end
              end
            end

          end

          context 'threat level assessment runs present in DB' do
            it 'includes valid assessment run data in response' do
              get api('/threat_levels', user)
              expect(contains_valid_assessment_run_data?).to be_truthy
            end
          end
        end
      end
    end
  end

end

private
def differentiate_assessments_created_at_date
  ThreatAssessment.all.each_with_index do |ta, i|
    ta.created_at += i.day
    ta.save!
  end
end

def dates_within_range(dates, from, to)
  dates.each { |date|
    return false unless from <= date && date <= to
  }
  true
end

def contains_valid_assessment_run_data?
  json_response['threat_levels'].each do |threat_level|
    threat_level['threat_level_assessment_runs'].each do |run|
      return false unless valid_run_data?(run)
    end
  end
  true
end
def valid_run_data?(run)
  run.is_a?(Hash) && (run.keys.sort == %w(explanation start_date status))
end

def threat_levels_with_results
  threat_levels = {
    'threat_levels' => [
      {
        'profile_id' => profile.id,
        'profile_custom_id' => profile.custom_id,
        'section_id' => profile.section_id,
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
