require 'rails_helper'

describe Api::V1::SectionsController do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /sections' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/sections")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      it 'returns 200 on success' do
        get api('/sections', user)
        expect(response.status).to eq 200
      end

      let!(:levee) { create(:levee) }
      # Group these sensors into two sections
      let!(:p1) { create(:section, levee: levee) }
      let!(:p2) { create(:section, levee: levee) }

      # Create four sensors with easy-to-manipulate geographical placement
      let!(:s1) { create(:sensor, section: p1, placement: "POINT (5 6 7)")}
      let!(:s2) { create(:sensor, section: p1, placement: "POINT (8 9 10)")}
      let!(:s3) { create(:sensor, section: p2, placement: "POINT (10 11 12)")}
      let!(:s4) { create(:sensor, section: p2, placement: "POINT (13 14 15)")}


      it 'returns all sections' do
        get api('/sections', user)
        expect(ps_response).to be_an Array
        expect(ps_response.size).to eq 2
        expect(ps_response.first["sensor_ids"]).to include(s1.id, s2.id)
        expect(ps_response.second["sensor_ids"]).to include(s3.id, s4.id)
      end

      it 'returns only 1 section' do
        get api("/sections?selection=#{URI::encode('POLYGON ((0 0, 0 10, 10 10, 10 0, 0 0))')}", user)
        expect(ps_response).to be_an Array
        expect(ps_response.size).to eq 1
        expect(ps_response[0]['id']).to eq p1.id
      end

      it 'returns only 2 sections' do
        get api("/sections?selection=#{URI::encode('POLYGON ((0 0, 0 20, 20 20, 20 0, 0 0))')}", user)
        expect(ps_response).to be_an Array
        expect(ps_response.size).to eq 2
        expect(ps_response.collect{|p| p['id']}.sort).to eq [p1.id, p2.id].sort
      end


      it 'returns 400 after unparseable input' do
        get api("/sections?selection=#{URI::encode('POLYGON ((0 0, 0 20, 20 20, 20 0, 0 0))')}231", user)
        expect(response.status).to eq 400
      end

    end
  end


  def ps_response
    json_response['sections']
  end

  def p_response
    json_response['section']
  end

end