require 'rails_helper'
require './lib/exporters/chart_exporter.rb'

describe Exporters::ChartExporter do

  before(:all) do
    @@tmp_dir = Dir.mktmpdir
  end

  after(:all) do
      FileUtils.rm_rf(@@tmp_dir)
  end

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

  let!(:experiment) { create(:experiment, levee: l1, timelines: [t1, t2, t3]) }

  it 'should find appropriate timeline' do
    exp = Exporters::ChartExporter.new([p1])
    timelines = exp.timelines
    expect(timelines.size).to eq 1
    expect(timelines[0]).to eq t1.id
  end

  it 'should find appropriate measurements' do
    exp = Exporters::ChartExporter.new([p1], (m1.m_timestamp+1.second), m3.m_timestamp)
    measurements = exp.measurements
    expect(measurements.size).to eq 2
    expect(measurements).not_to include m1
    expect(measurements).to include m2
    expect(measurements).to include m3
  end

  it 'should export appropriate number of lines' do
    exp = Exporters::ChartExporter.new([p1], (m1.m_timestamp+1.second), m3.m_timestamp)
    file = exp.export(@@tmp_dir)
    expect(File.exist?(file.path)).to be true
    serializer = Exporters::ChartExporter::MeasurementSerializer.new

    puts "#{file.path}"
    lines = File.read(file.path).lines
    expect(lines.size).to eq 2
    i = 0; [m2, m3].each do |m|
      expect(lines[i]).to eq CSV.generate { |csv| csv << serializer.serialize(m) }
      i+=1;
    end
  end

end