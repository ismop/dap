require 'rails_helper'

describe PruningService do

  context 'standard levee setup' do
    let(:c) { create(:context, id: 1, context_type: 'measurements') }
    let(:l) { create(:levee) }

    let(:p1) { create(:parameter, monitored: true, monitoring_status: :unknown) }
    let(:p2) { create(:parameter, monitored: true, monitoring_status: :unknown) }
    let(:p3) { create(:parameter, monitored: true, monitoring_status: :unknown) }
    let(:t1) { create(:timeline, parameter: p1, context: c) }
    let(:t2) { create(:timeline, parameter: p2, context: c) }
    let(:t3) { create(:timeline, parameter: p3, context: c) }

    it 'prunes identical measurements' do
      timestamp = Time.now

      m1 = create(:measurement, value: 100, m_timestamp: timestamp, timeline: t1)
      m2 = create(:measurement, value: 200, m_timestamp: timestamp, timeline: t1)
      m3 = create(:measurement, value: 100, m_timestamp: timestamp, timeline: t1)
      m4 = create(:measurement, value: 100, m_timestamp: timestamp, timeline: t2)
      m5 = create(:measurement, value: 100, m_timestamp: timestamp+2.seconds, timeline: t3)
      m6 = create(:measurement, value: 100, m_timestamp: timestamp+2.seconds, timeline: t3)

      PruningService::prune_duplicates
      all_measurements = Measurement.all
      expect(all_measurements.length).to eq 4
      expect(all_measurements & [m1, m2, m4, m5]). to eq all_measurements
    end
  end
end