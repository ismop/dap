
require 'rails_helper'
require 'csv'
require 'fileutils'

describe Api::V1::ExperimentExporterController do

  include ApiHelpers

  let(:user) { create(:user) }

  before(:all) do
    Exporters::CSVExporter.temp_dir = Dir.mktmpdir
  end

  after(:all) do
    FileUtils.rm_rf(Exporters::CSVExporter.temp_dir)
  end

  describe 'GET /experiment_exporter' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/experiment_exporter/1")
        expect(response.status).to eq 401
      end
    end

  end

  describe 'GET /experiment_exporter' do

    let(:c1) { create(:context, context_type: 'measurements') }

    let!(:l1) { create(:levee) }
    let!(:d1) { create(:device, levee: l1) }
    let!(:p1) { create(:parameter, device: d1) }
    let!(:t1) { create(:timeline, context: c1, parameter: p1) }

    let!(:tt) { Time.now }

    let!(:m1) { create(:measurement, m_timestamp: (tt - 1.day), timeline: t1) }
    let!(:m2) { create(:measurement, m_timestamp: tt, timeline: t1) }
    let!(:m3) { create(:measurement, m_timestamp: (tt + 1.day), timeline: t1) }

    # c2 is not of type 'measurements' hence measurements from t2 should not be incuded in csv

    let(:c2) { create(:context, context_type: 'other') }

    let!(:d2) { create(:device, levee: l1) }
    let!(:p2) { create(:parameter, device: d2) }
    let!(:t2) { create(:timeline, context: c2, parameter: p2) }

    let!(:m21) { create(:measurement, timeline: t2) }
    let!(:m22) { create(:measurement, timeline: t2) }
    let!(:m23) { create(:measurement, timeline: t2) }

    let(:t3) { create(:timeline) }

    let!(:experiment) { create(:experiment, levee: l1, start_date: (m1.m_timestamp + 1.second), end_date: (m3.m_timestamp + 1.year), timelines: [t1, t2, t3]) }

    context 'when authenticated as user' do
      it 'returns 200' do
        get api("/experiment_exporter/#{experiment.id}", user)
        expect(response.status).to eq 200
      end
    end

    context 'when requesting export of an existing and fully featured experiment' do
      it 'exports experiment in a right way' do
        # given
        serializer = Exporters::ExperimentExporter::MeasurementSerializer.new
        # when
        get api("/experiment_exporter/#{experiment.id}", user)
        # then
        lines = response.body.lines
        expect(lines.size).to eq 3
        i = 1; [m2, m3].each do |m|
          expect(lines[i]).to eq CSV.generate { |csv| csv << serializer.serialize(m) }
          i+=1;
        end
      end
    end
  end
end