require 'rails_helper'

describe EarliestMeasurementService do

  context 'standard levee setup' do
    let(:c) { create(:context, id: 1, context_type: 'measurements') }
    let(:l) { create(:levee) }

    let(:p1) { create(:parameter, monitored: true, monitoring_status: :unknown) }
    let(:p2) { create(:parameter, monitored: true, monitoring_status: :unknown) }
    let(:p3) { create(:parameter, monitored: true, monitoring_status: :unknown) }
    let(:t1) { create(:timeline, parameter: p1, context: c) }
    let(:t2) { create(:timeline, parameter: p2, context: c) }
    let(:t3) { create(:timeline, parameter: p3, context: c) }

    it 'leaves status unchanged when no measurements are present' do
      EarliestMeasurementService::find_earliest_measurements
      expect(t1.reload.earliest_measurement_timestamp).to be nil
      expect(t1.reload.earliest_measurement_value).to be nil
    end

    it 'updates status when measurements appear' do
      t = Time.now
      create(:measurement, timeline: t1, m_timestamp: t, value: 2)
      create(:measurement, timeline: t1, m_timestamp: t+1.second, value: 3)
      create(:measurement, timeline: t2, m_timestamp: t+10.seconds, value: 5)

      EarliestMeasurementService::find_earliest_measurements
      expect(t1.reload.earliest_measurement_timestamp-t).to be <= 0.001
      expect(t1.reload.earliest_measurement_value).to eq 2
      expect(t2.reload.earliest_measurement_timestamp-(t+10.seconds)).to be <= 0.001
      expect(t2.reload.earliest_measurement_value).to eq 5
      expect(t3.reload.earliest_measurement_timestamp).to be nil
      expect(t3.reload.earliest_measurement_value).to be nil
    end

    it 'does not further update status when earliest measurement is already known' do
      t = Time.now
      create(:measurement, timeline: t1, m_timestamp: t, value: 2)

      EarliestMeasurementService::find_earliest_measurements
      expect(t1.reload.earliest_measurement_timestamp-t).to be <= 0.001
      expect(t1.reload.earliest_measurement_value).to eq 2

      create(:measurement, timeline: t1, m_timestamp: t-10.seconds, value: 1)
      EarliestMeasurementService::find_earliest_measurements
      expect(t1.reload.earliest_measurement_timestamp-t).to be <= 0.001
      expect(t1.reload.earliest_measurement_value).to eq 2
    end
  end
end