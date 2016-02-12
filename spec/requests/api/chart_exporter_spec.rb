
require 'rails_helper'

describe Api::V1::ChartExporterController do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /chart_exporter' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/chart_exporter")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      it 'returns 200' do
        get api("/chart_exporter", user)
        expect(response.status).to eq 200
        expect(response.body).to eq " "
      end
    end

    context 'when given parameters as user' do
      it 'returns empty file' do
        get api("/chart_exporter?parameters=1,2,3", user) # parameters not existing
        expect(response.headers["Content-Disposition"]).to eq 'attachment; filename="chart.csv"'
      end
    end

  end

  describe 'GET /chart_exporter' do

    let(:c1) { create(:context, context_type: 'measurements') }

    let!(:l1) { create(:levee) }
    let!(:d1) { create(:device, levee: l1) }
    let!(:p1) { create(:parameter, device: d1) }
    let!(:t1) { create(:timeline, context: c1, parameter: p1) }

    let!(:tt) { Time.now }

    let!(:m1) { create(:measurement, timestamp: (tt - 1.day), timeline: t1) }
    let!(:m2) { create(:measurement, timestamp: tt, timeline: t1) }
    let!(:m3) { create(:measurement, timestamp: (tt + 1.day), timeline: t1) }

    context 'when given parameters as user' do
      it 'returns all measurements from param1' do
        get api("/chart_exporter?parameters=#{p1.id}", user)
        expect(response.body.lines.size).to eq 3
        i = 0
        [m1, m2, m3].each do |m|
          expect(response.body.lines[i]).to eq "#{m.timestamp.to_i},#{p1.id},#{'%.8f' % m.value}\n"
          i += 1
        end
      end
    end

    context 'when given parameters and time period' do
      it 'returns all measurements from param1 in given time period' do
        from = "#{URI::encode(m2.timestamp.to_s)}"
        to = "#{URI::encode((m3.timestamp + 1.year).to_s)}"
        get api("/chart_exporter?parameters=#{p1.id}&time_from=#{from}&time_to=#{to}", user)
        expect(response.body.lines.size).to eq 2
        i = 0;
        [m2, m3].each do |m|
          expect(response.body.lines[i]).to eq "#{m.timestamp.to_i},#{p1.id},#{'%.8f' % m.value}\n"
          i += 1
        end
      end
    end

  end

end