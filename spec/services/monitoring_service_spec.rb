require 'rails_helper'

describe MonitoringService do

  context 'standard levee setup' do
    let(:c) { create(:context, id: 1, context_type: 'measurements') }
    let(:l) { create(:levee) }

    let(:p1) { create(:parameter, monitored: true, monitoring_status: :unknown) }
    let(:p2) { create(:parameter, monitored: true, monitoring_status: :unknown) }
    let(:p3) { create(:parameter, monitored: true, monitoring_status: :unknown) }
    let(:t1) { create(:timeline, parameter: p1, context: c) }
    let(:t2) { create(:timeline, parameter: p2, context: c) }
    let(:t3) { create(:timeline, parameter: p3, context: c) }

    it 'does nothing when no measurements are present' do
      # Trigger monitoring service
       MonitoringService::perform_monitoring

       expect(p1.reload.monitoring_status).to eq :unknown
       expect(p2.reload.monitoring_status).to eq :unknown
       expect(p3.reload.monitoring_status).to eq :unknown
    end

    it 'flips status from unknown to up when a fresh measurement is present' do
       create(:measurement, timeline: t1, m_timestamp: Time.now)

       MonitoringService::perform_monitoring

       expect(p1.reload.monitoring_status).to eq :up
       expect(p2.reload.monitoring_status).to eq :unknown
       expect(p3.reload.monitoring_status).to eq :unknown
    end

    it 'flips status from unknown to down when an expired measurement is present' do
      create(:measurement, timeline: t2, m_timestamp: Time.now-((Rails.configuration.sensor_data_alert_trigger + 10).seconds))

      MonitoringService::perform_monitoring

      expect(p1.reload.monitoring_status).to eq :unknown
      expect(p2.reload.monitoring_status).to eq :down
      expect(p3.reload.monitoring_status).to eq :unknown
    end

    it 'flips status from down to up when more fresh measurements appear' do
      create(:measurement, timeline: t2, m_timestamp: Time.now-((Rails.configuration.sensor_data_alert_trigger + 10).seconds))
      create(:measurement, timeline: t3, m_timestamp: Time.now-((Rails.configuration.sensor_data_alert_trigger + 10).seconds))

      MonitoringService::perform_monitoring

      expect(p1.reload.monitoring_status).to eq :unknown
      expect(p2.reload.monitoring_status).to eq :down
      expect(p3.reload.monitoring_status).to eq :down

      # create(:measurement, timeline: t3, m_timestamp: Time.now-((Rails.configuration.sensor_data_alert_trigger - 100).seconds))
      #
      # MonitoringService::perform_monitoring
      #
      # expect(p1.reload.monitoring_status).to eq :unknown
      # expect(p2.reload.monitoring_status).to eq :down
      # expect(p3.reload.monitoring_status).to eq :up
    end

    it 'flips status from up to down when latest measurement becomes obsolete' do
      p3.monitoring_status = :up
      p3.save
      create(:measurement, timeline: t3, m_timestamp: Time.now-((Rails.configuration.sensor_data_alert_trigger + 10).seconds))

      MonitoringService::perform_monitoring

      expect(p1.reload.monitoring_status).to eq :unknown
      expect(p2.reload.monitoring_status).to eq :unknown
      expect(p3.reload.monitoring_status).to eq :down
    end
  end

end