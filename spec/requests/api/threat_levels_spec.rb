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
      expect {JSON.parse(response.body)}.not_to raise_error
    end

  end

end
