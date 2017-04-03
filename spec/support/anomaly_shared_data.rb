require 'rails_helper'

RSpec.shared_context 'anomaly_shared_data' do
  let!(:ctx) { create(:context, id: 1) }

  # coordinates of section with id = 4 in production DB
  let(:lon1) { 19.676957440998 }
  let(:lat1) { 49.980045585294 }
  let(:lon2) { 19.676954693317 }
  let(:lat2) { 49.979870212959 }
  let(:lon3) { 19.677277693466 }
  let(:lat3) { 49.979868106122 }
  let(:lon4) { 19.677280442326 }
  let(:lat4) { 49.980043478454 }

  let!(:to) { Time.now }
  let!(:from) { Time.now - 60.minutes }

  # section with location identical to section with id=4 in production DB
  let(:section_4) { create(:section, shape: "MULTIPOINT ((#{lon1} #{lat1}), (#{lon2} #{lat2}), (#{lon3} #{lat3}), (#{lon4} #{lat4}), (#{lon1} #{lat1})") }

  let!(:tension_measurement_type) { create(:measurement_type, id: 0, name: 'Naprężenie') }
  let!(:temperature_measurement_type) { create(:measurement_type, id: 1, name: 'Temperatura') }

  # devices within dist 3 and 4 meters from section_4 edge
  let!(:dev1) { create(:device, placement: 'POINT (19.677006 49.98003 211.83)', section: section_4) }
  let!(:param_1_1) {create(:parameter, device: dev1, measurement_type: temperature_measurement_type, monitoring_status: :up) }
  let!(:timeline_1_1) { create(:timeline, context: ctx, parameter: param_1_1) }
  let!(:m_1_1_0) { create(:measurement, timeline: timeline_1_1, m_timestamp: from - 15.seconds) }
  let!(:m_1_1_1) { create(:measurement, timeline: timeline_1_1, m_timestamp: from + 15.seconds) }
  let!(:m_1_1_2) { create(:measurement, timeline: timeline_1_1, m_timestamp: from + 30.seconds) }
  let!(:m_1_1_3) { create(:measurement, timeline: timeline_1_1, m_timestamp: to + 15.seconds) }
  let!(:param_1_2) {create(:parameter, device: dev1, measurement_type: tension_measurement_type, monitoring_status: :up) }
  let!(:timeline_1_2) { create(:timeline, context: ctx, parameter: param_1_2) }
  let!(:m_1_2_0) { create(:measurement, timeline: timeline_1_2, m_timestamp: from - 15.seconds) }
  let!(:m_1_2_1) { create(:measurement, timeline: timeline_1_2, m_timestamp: from + 15.seconds) }
  let!(:m_1_2_2) { create(:measurement, timeline: timeline_1_2, m_timestamp: from + 30.seconds) }
  let!(:m_1_2_3) { create(:measurement, timeline: timeline_1_2, m_timestamp: to + 15.seconds) }

  let!(:dev2) { create(:device, placement: 'POINT (19.677005 49.980007 211.85)', section: section_4) }
  let!(:param_2_1) {create(:parameter, device: dev2, measurement_type: temperature_measurement_type, monitoring_status: :up) }
  let!(:timeline_2_1) { create(:timeline, context: ctx, parameter: param_2_1) }
  let!(:m_2_1_0) { create(:measurement, timeline: timeline_2_1, m_timestamp: from - 15.seconds) }
  let!(:m_2_1_1) { create(:measurement, timeline: timeline_2_1, m_timestamp: from + 15.seconds) }
  let!(:m_2_1_2) { create(:measurement, timeline: timeline_2_1, m_timestamp: from + 30.seconds) }
  let!(:m_2_1_3) { create(:measurement, timeline: timeline_2_1, m_timestamp: to + 15.seconds) }
  let!(:param_2_2) {create(:parameter, device: dev2, measurement_type: tension_measurement_type, monitoring_status: :up) }
  let!(:timeline_2_2) { create(:timeline, context: ctx, parameter: param_2_2) }
  let!(:m_2_2_0) { create(:measurement, timeline: timeline_2_2, m_timestamp: from - 15.seconds) }
  let!(:m_2_2_1) { create(:measurement, timeline: timeline_2_2, m_timestamp: from + 15.seconds) }
  let!(:m_2_2_2) { create(:measurement, timeline: timeline_2_2, m_timestamp: from + 30.seconds) }
  let!(:m_2_2_3) { create(:measurement, timeline: timeline_2_2, m_timestamp: to + 15.seconds) }

  # devices within dist 7 and 8 meters from section_4 edge
  let!(:dev3) { create(:device, placement: 'POINT (19.677058 49.98003 211.83)', section: section_4) }
  let!(:param_3_1) {create(:parameter, device: dev3, measurement_type: temperature_measurement_type, monitoring_status: :up) }
  let!(:timeline_3_1) { create(:timeline, context: ctx, parameter: param_3_1) }
  let!(:m_3_1_0) { create(:measurement, timeline: timeline_3_1, m_timestamp: from - 15.seconds) }
  let!(:m_3_1_1) { create(:measurement, timeline: timeline_3_1, m_timestamp: from + 15.seconds) }
  let!(:m_3_1_2) { create(:measurement, timeline: timeline_3_1, m_timestamp: from + 30.seconds) }
  let!(:m_3_1_3) { create(:measurement, timeline: timeline_3_1, m_timestamp: to + 15.seconds) }
  let!(:param_3_2) {create(:parameter, device: dev3, measurement_type: tension_measurement_type, monitoring_status: :up) }
  let!(:timeline_3_2) { create(:timeline, context: ctx, parameter: param_3_2) }
  let!(:m_3_2_0) { create(:measurement, timeline: timeline_3_2, m_timestamp: from - 15.seconds) }
  let!(:m_3_2_1) { create(:measurement, timeline: timeline_3_2, m_timestamp: from + 15.seconds) }
  let!(:m_3_2_2) { create(:measurement, timeline: timeline_3_2, m_timestamp: from + 30.seconds) }
  let!(:m_3_2_3) { create(:measurement, timeline: timeline_3_2, m_timestamp: to + 15.seconds) }

  let!(:dev4) { create(:device, placement: 'POINT (19.677057 49.980006 211.8)', section: section_4) }
  let!(:param_4_1) {create(:parameter, device: dev4, measurement_type: temperature_measurement_type, monitoring_status: :up) }
  let!(:timeline_4_1) { create(:timeline, context: ctx, parameter: param_4_1) }
  let!(:m_4_1_0) { create(:measurement, timeline: timeline_4_1, m_timestamp: from - 15.seconds) }
  let!(:m_4_1_1) { create(:measurement, timeline: timeline_4_1, m_timestamp: from + 15.seconds) }
  let!(:m_4_1_2) { create(:measurement, timeline: timeline_4_1, m_timestamp: from + 30.seconds) }
  let!(:m_4_1_3) { create(:measurement, timeline: timeline_4_1, m_timestamp: to + 15.seconds) }
  let!(:param_4_2) {create(:parameter, device: dev4, measurement_type: tension_measurement_type, monitoring_status: :up) }
  let!(:timeline_4_2) { create(:timeline, context: ctx, parameter: param_4_2) }
  let!(:m_4_2_0) { create(:measurement, timeline: timeline_4_2, m_timestamp: from - 15.seconds) }
  let!(:m_4_2_1) { create(:measurement, timeline: timeline_4_2, m_timestamp: from + 15.seconds) }
  let!(:m_4_2_2) { create(:measurement, timeline: timeline_4_2, m_timestamp: from + 30.seconds) }
  let!(:m_4_2_3) { create(:measurement, timeline: timeline_4_2, m_timestamp: to + 15.seconds) }

  # section with location identical to section with id=3 in production DB
  let(:section_3) { create(:section, shape: 'MULTIPOINT ((19.676962231857 49.980351362692), (19.676957440998 49.980045585294), (19.677280442326 49.980043478454), (19.677285235243 49.980349255847), (19.676962231857 49.980351362692))') }

  # device in section 3 with data
  let!(:dev5) { create(:device, placement: 'POINT (19.677013 49.980299 211.89)', section: section_3) }
  let!(:param_5_1) {create(:parameter, device: dev5, measurement_type: temperature_measurement_type, monitoring_status: :up) }
  let!(:timeline_5_1) { create(:timeline, context: ctx, parameter: param_5_1) }
  let!(:m_5_1_0) { create(:measurement, timeline: timeline_5_1, m_timestamp: from - 15.seconds) }
  let!(:m_5_1_1) { create(:measurement, timeline: timeline_5_1, m_timestamp: from + 15.seconds) }
  let!(:m_5_1_2) { create(:measurement, timeline: timeline_5_1, m_timestamp: from + 30.seconds) }
  let!(:m_5_1_3) { create(:measurement, timeline: timeline_5_1, m_timestamp: to + 15.seconds) }
  let!(:param_5_2) {create(:parameter, device: dev5, measurement_type: tension_measurement_type, monitoring_status: :up) }
  let!(:timeline_5_2) { create(:timeline, context: ctx, parameter: param_5_2) }
  let!(:m_5_2_0) { create(:measurement, timeline: timeline_5_2, m_timestamp: from - 15.seconds) }
  let!(:m_5_2_1) { create(:measurement, timeline: timeline_5_2, m_timestamp: from + 15.seconds) }
  let!(:m_5_2_2) { create(:measurement, timeline: timeline_5_2, m_timestamp: from + 30.seconds) }
  let!(:m_5_2_3) { create(:measurement, timeline: timeline_5_2, m_timestamp: to + 15.seconds) }

  # distance from section edge and height
  let(:d1) { 3 }
  let(:d2) { 4 }
  let(:h1) { 211.5 }
  let(:h2) { 212.5 }
end
