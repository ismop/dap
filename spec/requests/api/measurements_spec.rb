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
      let!(:m1) { create(:measurement, timeline: s.timelines.first)}
      let!(:m2) { create(:measurement, timeline: s.timelines.first)}
      let!(:m3) { create(:measurement, timeline: s.timelines.first)}

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

    context 'filter measurements by id' do
      let!(:t) { create(:timeline) }
      let!(:m1) { create(:measurement, timeline: t, timestamp: Time.now-1.hour)}
      let!(:m2) { create(:measurement, timeline: t, timestamp: Time.now-4.hours)}
      let!(:m3) { create(:measurement, timeline: t, timestamp: Time.now-8.hours)}
      let!(:m4) { create(:measurement, timeline: t, timestamp: Time.now-24.hours)}

      it 'returns measurements with selected ids' do
        get api("/measurements?id=#{m2.id},#{m4.id}", user)
        expect(ms_response).to be_an Array
        expect(ms_response.length).to eq 2
        expect(ms_response.collect{|r| r['id']}).to include m2.id
        expect(ms_response.collect{|r| r['id']}).to include m4.id
      end
    end

    context 'filter measurements by time' do
      let!(:s) { create(:sensor) }
      let!(:m1) { create(:measurement, timeline: s.timelines.first, timestamp: Time.now-1.hour)}
      let!(:m2) { create(:measurement, timeline: s.timelines.first, timestamp: Time.now-4.hours)}
      let!(:m3) { create(:measurement, timeline: s.timelines.first, timestamp: Time.now-8.hours)}
      let!(:m4) { create(:measurement, timeline: s.timelines.first, timestamp: Time.now-24.hours)}
      let!(:m5) { create(:measurement, timeline: s.timelines.first, timestamp: Time.now-36.hours)}
      let!(:m6) { create(:measurement, timeline: s.timelines.first, timestamp: Time.now-60.hours)}

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
      let!(:m1_1) { create(:measurement, timeline: s1.timelines.first)}
      let!(:m1_2) { create(:measurement, timeline: s1.timelines.first)}
      let!(:m1_3) { create(:measurement, timeline: s1.timelines.first)}
      let!(:m1_4) { create(:measurement, timeline: s1.timelines.first)}
      let!(:m2_1) { create(:measurement, timeline: s2.timelines.first, timestamp: Time.now-2.hours)}
      let!(:m2_2) { create(:measurement, timeline: s2.timelines.first, timestamp: Time.now-30.minutes)}

      it 'returns measurements for selected sensor' do
        get api("/measurements?sensor_id=#{s1.id}", user)
        expect(ms_response.length).to eq 4
      end

      it 'returns measurements for two sensors' do
        get api("/measurements?sensor_id=#{s1.id},#{s2.id}", user)
        expect(ms_response.length).to eq 6
      end

      it 'combine filter params' do
        get api("/measurements?sensor_id=#{s2.id}&time_from=#{URI::encode((Time.now-1.hour).to_s)}", user)
        expect(ms_response.length).to eq 1
      end

    end

    context 'filter measurements by context ID' do

      let!(:c1) { create(:context) }
      let!(:c2) { create(:context) }

      let!(:s1) { create(:sensor) }
      let!(:s2) { create(:sensor) }

      let!(:t11) { create(:timeline, sensor: s1, context: c1) }
      let!(:t12) { create(:timeline, sensor: s2, context: c1) }
      let!(:t2) { create(:timeline, sensor: s2, context: c2) }

      let!(:m11) { create(:measurement, timeline: t11)}
      let!(:m12) { create(:measurement, timeline: t12)}
      let!(:m2) { create(:measurement, timeline: t2)}

      it 'returns measurements for selected context' do
        get api("/measurements?context_id=#{m11.timeline.context_id}", user)
        expect(ms_response.length).to eq 2
      end

      it 'returns measurements for two contexts' do
        get api("/measurements?context_id=#{m11.timeline.context_id},#{m2.timeline.context_id}", user)
        expect(ms_response.length).to eq 3
      end

      it 'combine filter params' do
        get api("/measurements?context_id=#{m11.timeline.context_id}&sensor_id=#{s2.id}", user)
        expect(ms_response.length).to eq 1
      end

    end

    context 'return first and last measurements when requested' do
      let(:t1) { create(:timeline) }
      let(:t2) { create(:timeline) }
      let(:t3) { create(:timeline) }

      it 'properly returns first measurement' do
        time = Time.now
        ms = []
        for i in 1..10 do
          ms << create(:measurement, timeline: t1, timestamp: time+i.seconds)
        end

        get api("/measurements?limit=first", user)
        expect(ms_response.length).to eq 1
        expect(ms_response.collect{|r| r['id']}).to include ms.first.id
      end

      it 'properly returns last measurement' do
        time = Time.now
        ms = []
        for i in 1..10 do
          ms << create(:measurement, timeline: t1, timestamp: time+i.seconds)
        end

        get api("/measurements?limit=last", user)
        expect(ms_response.length).to eq 1
        expect(ms_response.collect{|r| r['id']}).to include ms.last.id
      end

      it 'properly returns one measurement per timeline' do
        time = Time.now
        ms1, ms2, ms3 = [], [], []
        for i in 1..10 do
          ms1 << create(:measurement, timeline: t1, timestamp: time+i.seconds)
          ms2 << create(:measurement, timeline: t2, timestamp: time+(i*5).seconds)
          ms3 << create(:measurement, timeline: t3, timestamp: time+(i*100).seconds)
        end

        get api("/measurements?limit=first", user)
        expect(ms_response.length).to eq 3
        expect(ms_response.collect{|r| r['id']}).to include ms1.first.id
        expect(ms_response.collect{|r| r['id']}).to include ms2.first.id
        expect(ms_response.collect{|r| r['id']}).to include ms3.first.id

        get api("/measurements?limit=last", user)
        expect(ms_response.length).to eq 3
        expect(ms_response.collect{|r| r['id']}).to include ms1.last.id
        expect(ms_response.collect{|r| r['id']}).to include ms2.last.id
        expect(ms_response.collect{|r| r['id']}).to include ms3.last.id
      end

      it 'properly returns first and last measurements when time_from and time_to are used' do
        time = Time.now
        ms = []
        for i in 1..10 do
          ms << create(:measurement, timeline: t1, timestamp: time+i.seconds)
        end

        get api("/measurements?time_from=#{URI::encode((time+3.seconds).to_s)}&time_to=#{URI::encode((time+7.seconds).to_s)}&limit=first", user)
        expect(ms_response.collect{|r| r['id']}).to include ms[2].id
        get api("/measurements?time_from=#{URI::encode((time+3.seconds).to_s)}&time_to=#{URI::encode((time+7.seconds).to_s)}&limit=last", user)
        expect(ms_response.collect{|r| r['id']}).to include ms[5].id
      end

      it 'returns exactly the requested number of measurements when the quantity flag is used' do
        time = Time.now
        ms1, ms2, ms3 = [], [], []
        for i in 1..1000 do
          ms1 << create(:measurement, timeline: t1, timestamp: time+i.seconds)
          ms2 << create(:measurement, timeline: t2, timestamp: time+(i*5).seconds)
          ms3 << create(:measurement, timeline: t3, timestamp: time+(i*100).seconds)
        end

        get api("/measurements?quantity=27", user)
        expect(ms_response.length).to eq 81
        expect(ms_response.select{|m| m['timeline_id'] == t1.id}.length).to eq 27
        expect(ms_response.select{|m| m['timeline_id'] == t2.id}.length).to eq 27
        expect(ms_response.select{|m| m['timeline_id'] == t3.id}.length).to eq 27
      end

      it 'returns an empty table when no results are found' do
        time = Time.now
        ms = []
        for i in 1..10 do
          ms << create(:measurement, timeline: t1, timestamp: time+i.seconds)
        end

        get api("/measurements?time_from=#{URI::encode((time+20.seconds).to_s)}&time_to=#{URI::encode((time+30.seconds).to_s)}&limit=first", user)
        expect(ms_response).to eq []
      end
    end
  end

  def ms_response
    json_response['measurements']
  end

  def m_response
    json_response['measurement']
  end

end