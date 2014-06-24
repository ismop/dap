require 'rails_helper'

describe Api::V1::SensorsController do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /sensors' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/sensors")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do

      let!(:s1) { create(:sensor) }
      let!(:s2) { create(:sensor) }

      it 'returns 200 and all sensors on success' do
        get api('/sensors', user)
        expect(response.status).to eq 200
        expect(ss_response).to be_an Array
        expect(ss_response.length).to eq 2
      end
    end
  end

  describe 'GET /sensors/{id}' do

    context 'when authenticated as user' do
      let!(:s1) { create(:sensor, custom_id: "foo") }
      let!(:s2) { create(:sensor) }

      it 'returns the selected sensor' do
        get api("/sensors/#{s1.id}", user)

        expect(s_response).to include 'id'
        expect(s_response).to include 'custom_id'
        expect(s_response['custom_id']).to eq 'foo'
      end
    end
  end

  def ss_response
    json_response['sensors']
  end

  def s_response
    json_response['sensor']
  end

end