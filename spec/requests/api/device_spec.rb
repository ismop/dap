
require 'rails_helper'

describe Api::V1::Device do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /devices' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/devices")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      it 'returns 200' do
        get api("/devices", user)
        expect(response.status).to eq 200
      end
    end

  end

  describe 'GET /devices' do

    let(:sensor) { create(:neosentio_sensor) }
    let(:sensor2) { create(:budokop_sensor) }
    let!(:device1) { create(:device, device_type: 'neosentio-sensor', neosentio_sensor: sensor) }
    let!(:device2) { create(:device, device_type: 'budokop-sensor', budokop_sensor: sensor2) }

    context 'get all devices' do
      it 'returns right devices' do
        get api("/devices", user)
        expect(ds.size).to eq 2
        expect(ds[0]).to device_eq device1
        expect(ds[1]).to device_eq device2
      end
    end

    context 'get device by id' do
      it 'returns right device' do
        get api("/devices/#{device2.id}", user)
        expect(d).to device_eq device2
      end
    end

  end

  def ds
    json_response['devices']
  end

  def d
    json_response['device']
  end

end