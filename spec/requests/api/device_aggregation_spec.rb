
require 'rails_helper'

describe Api::V1::DeviceAggregation do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /devices' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/device_aggregations")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      it 'returns 200' do
        get api("/device_aggregations", user)
        expect(response.status).to eq 200
      end
    end

  end

  describe 'GET /device_aggregations' do

    let!(:device_aggregation) { create(:device_aggregation) }

    let(:sensor) { create(:neosentio_sensor) }
    let(:sensor2) { create(:budokop_sensor) }
    let!(:device1) { create(:device, device_type: 'neosentio-sensor', neosentio_sensor: sensor, device_aggregation: device_aggregation) }
    let!(:device2) { create(:device, device_type: 'budokop-sensor', budokop_sensor: sensor2, device_aggregation: device_aggregation) }

    context 'get all device aggregations' do
      it 'returns right device aggregations' do
        get api("/device_aggregations", user)
        expect(das.size).to eq 1
        expect(das[0]).to device_aggregation_eq device_aggregation
      end

      it 'returns right device aggregations' do
        get api("/device_aggregations/#{device_aggregation.id}", user)
        expect(da).to device_aggregation_eq device_aggregation
      end
    end

  end


  describe 'GET /device_aggregations' do

    let!(:device_aggregation_parent) { create(:device_aggregation) }
    let!(:device_aggregation) { create(:device_aggregation, parent: device_aggregation_parent) }

    let(:sensor) { create(:neosentio_sensor) }
    let(:sensor2) { create(:budokop_sensor) }
    let!(:device1) { create(:device, device_type: 'neosentio-sensor', neosentio_sensor: sensor, device_aggregation: device_aggregation) }
    let!(:device2) { create(:device, device_type: 'budokop-sensor', budokop_sensor: sensor2, device_aggregation: device_aggregation) }

    context 'get all device aggregations' do

      it 'returns right device aggregations' do
        get api("/device_aggregations/#{device_aggregation.id}", user)
        expect(da).to device_aggregation_eq device_aggregation
        get api("/device_aggregations/#{device_aggregation_parent.id}", user)
        expect(da).to device_aggregation_eq device_aggregation_parent
      end
    end

  end

  def das
    json_response['device_aggregations']
  end

  def da
    json_response['device_aggregation']
  end

end