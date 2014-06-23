require 'rails_helper'
require 'open-uri'

describe Api::V1::MeasurementsController do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /measurements' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/measurements")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do

      let!(:s) { create(:sensor) }
      let!(:m1) { create(:measurement, sensor: s, timeline: s.timelines.first)}
      let!(:m2) { create(:measurement, sensor: s, timeline: s.timelines.first)}
      let!(:m3) { create(:measurement, sensor: s, timeline: s.timelines.first)}

      it 'returns 200 on success' do
        get api('/measurements', user)
        expect(response.status).to eq 200
      end

      let(:mnode) { create(:measurement_node) }
      it 'returns all measurements' do
        get api('/measurements', user)
        expect(ms_response).to be_an Array
        expect(ms_response.length).to eq 3
      end
    end

    context 'filter measurements by time' do
      let!(:s) { create(:sensor) }
      let!(:m1) { create(:measurement, sensor: s, timeline: s.timelines.first, timestamp: Time.now-1.hour)}
      let!(:m2) { create(:measurement, sensor: s, timeline: s.timelines.first, timestamp: Time.now-4.hours)}
      let!(:m3) { create(:measurement, sensor: s, timeline: s.timelines.first, timestamp: Time.now-8.hours)}
      let!(:m4) { create(:measurement, sensor: s, timeline: s.timelines.first, timestamp: Time.now-24.hours)}
      let!(:m5) { create(:measurement, sensor: s, timeline: s.timelines.first, timestamp: Time.now-36.hours)}
      let!(:m6) { create(:measurement, sensor: s, timeline: s.timelines.first, timestamp: Time.now-60.hours)}

      it 'returns all measurements for wide range of dates' do
        get api("/measurements?time_from=#{URI::encode((Time.now-10.days).to_s)}&time_to=#{URI::encode(Time.now.to_s)}", user)
        expect(ms_response).to be_an Array
        expect(ms_response.length).to eq Measurement.all.length
      end

      it 'returns all measurements when dates not specified' do
        get api("/measurements", user)
        expect(ms_response).to be_an Array
        expect(ms_response.length).to eq Measurement.all.length
      end

      it 'returns all measurements following a certain timestamp' do
        get api("/measurements?time_from=#{URI::encode((Time.now-6.hours).to_s)}", user)
        expect(ms_response).to be_an Array
        expect(ms_response.length).to eq 2
      end

      it 'returns all measurements preceding a certain timestamp' do
        get api("/measurements?time_to=#{URI::encode((Time.now-6.hours).to_s)}", user)
        expect(ms_response).to be_an Array
        expect(ms_response.length).to eq 4
      end

      it 'return a narrowly matched measurement' do
        get api("/measurements?time_from=#{URI::encode((Time.now-61.minutes).to_s)}&time_to=#{URI::encode((Time.now-59.minutes).to_s)}", user)
        expect(ms_response.length).to eq 1
      end
    end

    context 'filter measurements by sensor ID' do
      let!(:s1) { create(:sensor) }
      let!(:s2) { create(:sensor) }
      let!(:m1_1) { create(:measurement, sensor: s1, timeline: s1.timelines.first)}
      let!(:m1_2) { create(:measurement, sensor: s1, timeline: s1.timelines.first)}
      let!(:m1_3) { create(:measurement, sensor: s1, timeline: s1.timelines.first)}
      let!(:m1_4) { create(:measurement, sensor: s1, timeline: s1.timelines.first)}
      let!(:m2_1) { create(:measurement, sensor: s2, timeline: s2.timelines.first, timestamp: Time.now-2.hours)}
      let!(:m2_2) { create(:measurement, sensor: s2, timeline: s2.timelines.first, timestamp: Time.now-30.minutes)}

      it 'returns measurements for selected sensor' do
        get api("/measurements?sensor_id=#{s1.id}", user)
        expect(ms_response.length).to eq 4
      end

      it 'combine filter params' do
        get api("/measurements?sensor_id=#{s2.id}&time_from=#{URI::encode((Time.now-1.hour).to_s)}", user)
        expect(ms_response.length).to eq 1
      end

    end

  end



  # describe 'GET /levees/{id}' do
  #
  #   context 'when unauthenticated' do
  #     it 'returns 401 Unauthorized error' do
  #       get api("/levees/#{l1.id}")
  #       expect(response.status).to eq 401
  #     end
  #   end
  #
  #   context 'when authenticated as user' do
  #     it 'returns 200 on success' do
  #       get api("/levees/#{l1.id}", user)
  #       #puts response.body
  #       expect(response.status).to eq 200
  #     end
  #
  #     it 'returns a chosen levee section' do
  #       get api("/levees/#{l1.id}", user)
  #       expect(l_response).to include 'shape'
  #       expect(l_response['shape']).to include 'coordinates'
  #       expect(l_response['shape']['coordinates']).to be_an Array
  #       expect(l_response['shape']['coordinates'].size).to eq 6
  #       expect(l_response['shape']['coordinates']).to include [49.98191,19.678662,211.14]
  #     end
  #   end
  # end

  # describe 'PUT /levees/{id}' do
  #
  #   let(:update_json) do {levee: {
  #       emergency_level: 'heightened'
  #   }} end
  #
  #   let(:longer_update_json) do {levee: {
  #       emergency_level: 'heightened',
  #       threat_level: 'heightened'
  #   }} end
  #
  #   let(:wrong_update_json) do {levee: {
  #       name: 'heightened'
  #   }} end
  #
  #   context 'when unauthenticated' do
  #     it 'returns 401 Unauthorized error' do
  #       put api("/levees/#{l1.id}")
  #       expect(response.status).to eq 401
  #     end
  #   end
  #
  #   context 'when authenticated as user' do
  #     it 'returns 200 Success' do
  #       put api("/levees/#{l1.id}", user), update_json
  #       #puts response.body
  #       expect(response.status).to eq 200
  #     end
  #
  #     it 'prevents updating wrong attributes' do
  #       old_name = Levee.find(l1.id).name
  #       put api("/levees/#{l1.id}", user), wrong_update_json
  #       updated_l = Levee.find(l1.id)
  #       expect(updated_l.id).to_not be_nil
  #       expect(updated_l.id).to eq l1.id
  #       expect(updated_l.name).to eq old_name
  #       expect(updated_l['emergency_level']).to eq l1.emergency_level
  #       expect(updated_l['threat_level']).to eq l1.threat_level
  #     end
  #
  #     it 'updates levee emergency level' do
  #       put api("/levees/#{l1.id}", user), update_json
  #       updated_l = Levee.find(l1.id)
  #       expect(updated_l.id).to_not be_nil
  #       expect(updated_l.id).to eq l1.id
  #       expect(updated_l['emergency_level']).to eq 'heightened'
  #       expect(updated_l['threat_level']).to eq l1.threat_level
  #     end
  #
  #     it 'updates levee threat level' do
  #       put api("/levees/#{l1.id}", user), longer_update_json
  #       updated_l = Levee.find(l1.id)
  #       expect(updated_l.id).to_not be_nil
  #       expect(updated_l.id).to eq l1.id
  #       expect(updated_l['emergency_level']).to eq 'heightened'
  #       expect(updated_l['threat_level']).to eq 'heightened'
  #     end
  #
  #   end
  # end

  def ms_response
    json_response['measurements']
  end

  def m_response
    json_response['measurement']
  end

end