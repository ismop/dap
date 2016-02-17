
require 'rails_helper'

describe Api::V1::ChartExporterController do

  include ApiHelpers

  before(:all) do
    Exporters::CSVExporter.temp_dir = Dir.mktmpdir
  end

  after(:all) do
    FileUtils.rm_rf(Exporters::CSVExporter.temp_dir)
  end

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

    let!(:m1) { create(:measurement, m_timestamp: (tt - 1.day), timeline: t1) }
    let!(:m2) { create(:measurement, m_timestamp: tt, timeline: t1) }
    let!(:m3) { create(:measurement, m_timestamp: (tt + 1.day), timeline: t1) }

    context 'when given parameters as user' do
      it 'returns all measurements from param1' do
        # given
        serializer = Exporters::ChartExporter::MeasurementSerializer.new
        # when
        get api("/chart_exporter?parameters=#{p1.id}", user)
        # then
        lines = response.body.lines
        expect(lines.size).to eq 3
        i = 0; [m1, m2, m3].each do |m|
          expect(lines[i]).to eq CSV.generate { |csv| csv << serializer.serialize(m) }
          i += 1
        end
      end
    end

    context 'when given parameters and time period' do
      it 'returns all measurements from param1 in given time period' do
        # given
        serializer = Exporters::ChartExporter::MeasurementSerializer.new
        from = "#{URI::encode(m2.m_timestamp.to_s)}"
        to = "#{URI::encode((m3.m_timestamp + 1.year).to_s)}"
        # when
        get api("/chart_exporter?parameters=#{p1.id}&time_from=#{from}&time_to=#{to}", user)
        # then
        lines = response.body.lines
        expect(lines.size).to eq 2
        i = 0; [m2, m3].each do |m|
          expect(lines[i]).to eq CSV.generate { |csv| csv << serializer.serialize(m) }
          i+=1;
        end
      end
    end

  end

end