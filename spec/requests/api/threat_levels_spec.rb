require 'rails_helper'

describe Api::V1::ThreatLevelsController do

  include ApiHelpers

  let(:user) { create(:user) }
  
  describe 'GET /threat_levels' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        url = api("/threat_levels")
        get url

        expect(response.status).to eq 401
      end
    end

    context 'when authenticated' do
      it 'returns 200 OK' do
        get api("/threat_levels", user)
        expect(response.status).to eq 200
      end
    end

  end

end
