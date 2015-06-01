
require 'rails_helper'

describe Api::V1::NeosentioSensor do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /neosentio_sensors' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/neosentio_sensors")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      it 'returns 200' do
        get api("/neosentio_sensors", user)
        expect(response.status).to eq 200
      end
    end

  end

  # TODO implement

  def ens_response
    json_response['neosentio_sensors']
  end

  def en_response
    json_response['neosentio_sensors']
  end

end