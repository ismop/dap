require 'rails_helper'

describe Api::V1::TimelinesController do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /timelines' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/timelines")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do

      let!(:s) { create(:sensor) } # Will automatically create 1 timeline
      let!(:t2) { create(:timeline, sensor: s) }
      let!(:t3) { create(:timeline, sensor: s) }
      let!(:t4) { create(:timeline, sensor: s) }

      it 'returns 200 and all timelines on success' do
        get api('/timelines', user)
        expect(response.status).to eq 200
        expect(ts_response).to be_an Array
        expect(ts_response.length).to eq 4
      end
    end
  end

  describe 'GET /timelines/{id}' do

    context 'when authenticated as user' do
      let!(:s) { create(:sensor) }
      let!(:t2) { create(:timeline, sensor: s) }

      it 'returns the selected timeline' do
        get api("/timelines/#{s.timelines.first.id}", user)

        expect(t_response["id"]).to eq s.timelines.first.id
      end
    end
  end

  def ts_response
    json_response['timelines']
  end

  def t_response
    json_response['timeline']
  end

end