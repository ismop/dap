require 'rails_helper'

describe Api::V1::BudokopSensorsController do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /budokop_sensors' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/budokop_sensors")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      it 'returns 200' do
        get api("/budokop_sensors", user)
        expect(response.status).to eq 200
      end
    end

  end

  describe 'GET /budokop_sensors' do

    let!(:sensor1) { create(:budokop_sensor) }
    let!(:sensor2) { create(:budokop_sensor) }

    context 'get all budokop sensors' do
      it 'returns proper sensors' do
        get api("/budokop_sensors", user)
        expect(bss_response.size).to eq 2
        expect(bss_response[0]).to budokop_sensor_eq sensor1
        expect(bss_response[1]).to budokop_sensor_eq sensor2
      end
    end

    context 'get budokop sensor by id' do
      it 'returns proper sensors' do
        get api("/budokop_sensors/#{sensor2.id}", user)
        expect(bs_response).to budokop_sensor_eq sensor2
      end
    end

  end

  def bss_response
    json_response['budokop_sensors']
  end

  def bs_response
    json_response['budokop_sensor']
  end

end