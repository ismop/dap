
require 'rails_helper'

describe Api::V1::NeosentioSensorsController do

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

  describe 'GET /neosentio_sensors' do

    let!(:sensor1) { create(:neosentio_sensor) }

    context 'when authenticated as user' do
      it 'returns 200' do
        get api("/neosentio_sensors", user)
        expect(nss_response.size).to eq 1
        expect(nss_response[0]).to neosentio_sensor_eq sensor1
      end
    end

  end

  def nss_response
    json_response['neosentio_sensors']
  end

  def ns_response
    json_response['neosentio_sensors']
  end

end