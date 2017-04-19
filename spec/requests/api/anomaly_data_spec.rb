require 'rails_helper'
require 'support/anomaly_shared_data'

describe Api::V1::AnomalyDataController do
  include_context 'anomaly_shared_data'

  include ApiHelpers

  let(:user) { create(:user) }

  context 'unauthenticated' do
    it 'returns 401 Unauthorized error' do
      get api('/anomaly_data')
      expect(response.status).to eq 401
    end
  end

  context 'authenticated' do

    context 'invalid request' do
      it 'returns error if required parameters are missing' do
        get api('/anomaly_data', user)
        expect(response.status).to eq 422
      end
    end

    context 'valid request' do
      it 'returns 200 for valid request' do
        get api(valid_get_url, user)
        expect(response.status).to eq 200
      end

      it 'returns data for devices within correct distance' do
        get api(valid_get_url, user)
        data = JSON.parse(response.body)
        expect(data['devices'].collect { |e| e['id'] }).to contain_exactly(dev1.id, dev2.id)
      end

      it 'returns data with timestamp within specified interval' do
        get api(valid_get_url, user)
        data = JSON.parse(response.body)
        measurement_timestamps = measurement_timestamps(data)
        expect(measurement_timestamps).to all((be >= from).and be <= to)
      end

      it 'returns devices from specified section' do
        get api(valid_get_url, user)
        data = JSON.parse(response.body)
        device_section_ids = device_section_ids(data)
        expect(device_section_ids).to all(be section_4.id)
      end

      private

      def valid_get_url
        "/anomaly_data?lon1=#{lon1}&lat1=#{lat1}&lon2=#{lon2}&lat2=#{lat2}&"\
        "dist1=#{d1}&dist2=#{d2}&h1=#{h1}&h2=#{h2}&from=#{URI.encode(from.to_s)}&to=#{URI.encode(to.to_s)}&"\
        "section_ids=[#{section_4.id}]"
      end

      def measurement_timestamps(data)
        data['devices'].collect do |dev|
          dev['parameters'].collect do |p|
            p['timelines'].collect do |t|
              t['measurements'].collect { |m| Time.parse(m['timestamp']) }
            end
          end
        end.flatten
      end

      def device_section_ids(data)
        data['devices'].collect { |dev| dev['section_id'] }
      end
    end
  end
end
