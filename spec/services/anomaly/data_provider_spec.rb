require 'rails_helper'
require 'support/anomaly_shared_data'

describe Anomaly::DataProvider do
  include_context 'anomaly_shared_data'

  it 'returns data for devices within correct distance' do
    devices = Anomaly::DataProvider.get(lon1:lon1,lat1:lat1,lon2:lon2,lat2:lat2,dist1:d1, dist2:d2, h1:h1,h2:h2,from:from,to: to, section_ids:[section_4.id])
    expect(devices).to contain_exactly(dev1, dev2)
  end

  it 'returns data with timestamp within specified interval' do
    devices = Anomaly::DataProvider.get(lon1:lon1,lat1:lat1,lon2:lon2,lat2:lat2,dist1:d1, dist2:d2, h1:h1,h2:h2,from:from,to: to, section_ids:[section_4.id])
    measurement_timestamps = devices.collect { |d| d.parameters.first.timelines.first.measurements.collect {|m| m.m_timestamp } }.flatten
    expect(measurement_timestamps).to all((be >= from).and be <= to)
  end

  it 'returns devices from specified section' do
    device_section_ids = Anomaly::DataProvider.get(lon1:lon1, lat1:lat1, lon2:lon2,lat2:lat2,dist1:d1, dist2:d2, h1:h1,h2:h2,from:from,to: to, section_ids:[section_4.id])
      .collect{ |d| d.section_id }
    expect(device_section_ids).to all(be section_4.id)
  end

end