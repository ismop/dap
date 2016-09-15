require 'rails_helper'

describe ThreatLevel::ThreatAssessmentRunsForProfileService do

  let!(:run) { create(:threat_assessment_run) }
  let!(:profile) { create(:profile) }
  let!(:threat_assessment) do
    create(:threat_assessment,
           profiles: [profile], threat_assessment_run: run)
  end
  # this will create also a profile and run associated with this assessment
  let!(:another_assessment) { create(:threat_assessment) }

  it 'returns assessment run associated with given profile' do
    runs = ThreatLevel::ThreatAssessmentRunsForProfileService.get(profile.id)
    expect(runs).to eq [run]
  end

  context 'six runs exist for a given profile' do
    before :each do
      5.times do |i|
        create(:threat_assessment,
           profiles: [profile],
           threat_assessment_run: create(:threat_assessment_run, created_at: Time.now - (i+1).hours))
      end
    end
    it 'returns at most 5 latest runs associated with given profile' do
      runs = ThreatLevel::ThreatAssessmentRunsForProfileService.get(profile.id)
      expect(runs).to eq five_latest_runs(profile)
    end
  end
end

private

def five_latest_runs(profile)
  all_runs_for_profile = ThreatAssessmentRun.joins(threat_assessments: :profiles).
          where("profiles.id = #{profile.id}")
  all_runs_for_profile.sort_by { |r| r.created_at}.reverse[0, 5]
end
