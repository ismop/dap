
require 'rails_helper'

describe Api::V1::MonitoringController do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'get /monitoring' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/monitoring")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      it 'returns 200' do
        get api("/monitoring", user)
        expect(response.status).to eq 200
      end
    end
  end

  describe 'GET /monitoring' do
    let!(:parameter1) { create(:parameter, parameter_name: 'p1', monitored: false, monitoring_status: :unknown) }
    let!(:parameter2) { create(:parameter, parameter_name: 'p2', monitored: false, monitoring_status: :up) }
    let!(:parameter3) { create(:parameter, parameter_name: 'p3', monitored: false, monitoring_status: :down) }
    let!(:parameter4) { create(:parameter, parameter_name: 'p4', monitored: true, monitoring_status: :unknown) }
    let!(:parameter5) { create(:parameter, parameter_name: 'p5', monitored: true, monitoring_status: :up) }
    let!(:parameter6) { create(:parameter, parameter_name: 'p6', monitored: true, monitoring_status: :down) }
    let!(:parameter7) { create(:parameter, parameter_name: 'p7', monitored: true, monitoring_status: :down) }

    it 'returns parameters which are both monitored and listed as down' do
      get api("/monitoring", user)
      expect(m_response.count).to eq 2
      expect(((m_response.collect{|p| p['parameter_name']}) & ['p6','p7']).length).to eq 2
    end
  end

  def m_response
    json_response['parameters']
  end

end