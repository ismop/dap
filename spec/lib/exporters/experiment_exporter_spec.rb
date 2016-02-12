require 'rails_helper'
require './lib/exporters/experiment_exporter.rb'

describe Exporters::ExperimentExporter do

  let(:c1) { create(:context, context_type: 'measurements') }

  let!(:l1) { create(:levee) }
  let!(:d1) { create(:device, levee: l1) }
  let!(:p1) { create(:parameter, device: d1) }
  let!(:t1) { create(:timeline, context: c1, parameter: p1) }

  let!(:tt) { Time.now }

  let!(:m1) { create(:measurement, timestamp: (tt - 1.day), timeline: t1) }
  let!(:m2) { create(:measurement, timestamp: tt, timeline: t1) }
  let!(:m3) { create(:measurement, timestamp: (tt + 1.day), timeline: t1) }

  # c2 is not of type 'measurements' hence measurements from t2 should not be incuded in csv

  let(:c2) { create(:context, context_type: 'other') }

  let!(:d2) { create(:device, levee: l1) }
  let!(:p2) { create(:parameter, device: d2) }
  let!(:t2) { create(:timeline, context: c2, parameter: p2) }

  let!(:m21) { create(:measurement, timeline: t2) }
  let!(:m22) { create(:measurement, timeline: t2) }
  let!(:m23) { create(:measurement, timeline: t2) }

  let(:t3) { create(:timeline) }

  let!(:experiment) { create(:experiment, levee: l1, start_date: (m1.timestamp + 1.second), end_date: (m3.timestamp + 1.year), timelines: [t1, t2, t3]) }

  it 'should find appropriate timeline' do
    exp = Exporters::ExperimentExporter.new(experiment.id)
    timelines = exp.timelines.ids
    expect(timelines.size).to eq 1
    expect(timelines[0]).to eq t1.id
  end

  it 'should find appropriate measurements' do
    exp = Exporters::ExperimentExporter.new(experiment.id)
    measurements = exp.measurements
    expect(measurements.size).to eq 2
    expect(measurements).not_to include m1 # m1 timestamp is before experiment start_date
    expect(measurements).to include m2
    expect(measurements).to include m3
  end

  it 'should export appropriate number of lines' do
    exp = Exporters::ExperimentExporter.new(experiment.id)
    file = exp.export
    expect(File.exist?(file.path)).to be true
    # puts "#{File.read(file.path)}"
    lines = 0;
    IO.foreach(file.path) { lines+=1 }
    expect(lines).to eq 2
    exp.cleanup
  end

end