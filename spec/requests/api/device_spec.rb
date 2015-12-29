
require 'rails_helper'

describe Api::V1::DevicesController do

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

      it 'returns device metadata' do
        pump = create(:pump)
        node = create(:fiber_optic_node)

        device3 = create(:device, device_type: 'pump', pump: pump)
        device4 = create(:device, device_type: 'fiber_optic_node', fiber_optic_node: node)

        get api("/devices", user)

        expect(ds[0]['metadata'].keys.length).to eq 17
        expect(ds[1]['metadata'].keys.length).to eq 11
        expect(ds[2]['metadata'].keys.length).to eq 6
        expect(ds[3]['metadata'].keys.length).to eq 4
      end

      it 'returns information on nonfunctioning params for each device' do
        p1 = create(:parameter, parameter_name: 'p1', monitored: false, monitoring_status: :down, device: device2)
        p2 = create(:parameter, parameter_name: 'p2', monitored: true, monitoring_status: :up, device: device2)
        p3 = create(:parameter, parameter_name: 'p3', monitored: true, monitoring_status: :down, device: device2)

        p4 = create(:parameter, parameter_name: 'p4', monitored: true, monitoring_status: :down, device: device1)
        p5 = create(:parameter, parameter_name: 'p5', monitored: true, monitoring_status: :down, device: device1)

        get api("/devices", user)

        expect((ds[0]['nonfunctioning_parameter_ids'] & [p4.id, p5.id]).length).to eq 2
        expect(ds[1]['nonfunctioning_parameter_ids']).to eq [p3.id]
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