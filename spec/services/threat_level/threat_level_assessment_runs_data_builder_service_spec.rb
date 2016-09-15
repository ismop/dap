require 'rails_helper'

describe ThreatLevel::AssessmentRunsDataBuilderService do
  let!(:profile) { create(:profile, threat_assessments: []) }

  context 'no runs associated with profile' do
    it 'returns empty array' do
      expect(ThreatLevel::AssessmentRunsDataBuilderService.get(profile.id)).to eq []
    end
  end

  context 'runs associated with profile' do
    let!(:run) { create(:threat_assessment_run) }
    let!(:assessment) do
      create(
        :threat_assessment,
        threat_assessment_run: run,
        profiles: [profile]
      )
    end

    it 'returns array with run data' do
      # reload are required to make associations visible
      profile.reload
      run.reload

      expect(ThreatLevel::AssessmentRunsDataBuilderService.get(profile.id)).
        to eq runs_data_array
    end
  end
end

private
def runs_data_array
  [
   ThreatLevel::AssessmentRunStatusDataBuilderService.get(run)
  ]
end
