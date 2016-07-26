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
    runs = ThreatLevel::ThreatAssessmentRunsForProfileService.get(profile)
    expect(runs).to eq [run]
  end
end
