require 'rails_helper'

describe Api::V1::ExperimentsController do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /experiments' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/experiments")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      let(:levee) { create(:levee) }

      let(:timeline1) { create(:timeline) }
      let(:timeline2) { create(:timeline) }
      let(:timeline3) { create(:timeline) }
      let(:timeline4) { create(:timeline) }

      it 'returns 200' do
        get api("/experiments", user)
        expect(response.status).to eq 200
      end

      it 'returns correct experiment info' do

        e1 = create(:experiment, levee: levee, timelines: [timeline1, timeline2])
        e2 = create(:experiment, levee: levee, timelines: [timeline3, timeline4])

        get api('/experiments', user)

        expect(exs.size).to eq 2
        expect(exs[0]).to experiment_eq e1
        expect(exs[1]).to experiment_eq e2
      end
    end
  end

  def exs
    json_response['experiments']
  end

  def ex
    json_response['experiment']
  end

end