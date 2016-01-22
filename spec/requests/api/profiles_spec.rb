require 'rails_helper'

describe Api::V1::ProfilesController do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /profiles' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/profiles")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      it 'returns 200 on success' do
        get api('/profiles', user)
        expect(response.status).to eq 200
      end

      let!(:levee) { create(:levee) }
      # Group these sensors into two profiles
      let!(:p1) { create(:profile, levee: levee) }
      let!(:p2) { create(:profile, levee: levee) }

      # Create four sensors with easy-to-manipulate geographical placement
      let!(:d1) { create(:device, profile: p1, placement: "POINT (5 6 7)")}
      let!(:d2) { create(:device, profile: p1, placement: "POINT (8 9 10)")}
      let!(:d3) { create(:device, profile: p2, placement: "POINT (10 11 12)")}
      let!(:d4) { create(:device, profile: p2, placement: "POINT (13 14 15)")}


      it 'returns all profiles' do
        get api('/profiles', user)
        expect(ps_response).to be_an Array
        expect(ps_response.size).to eq 2
        expect(ps_response.first["device_ids"]).to include(d1.id, d2.id)
        expect(ps_response.second["device_ids"]).to include(d3.id, d4.id)
      end

      it 'returns only 1 profile' do
        get api("/profiles?selection=#{URI::encode('POLYGON ((0 0, 0 10, 10 10, 10 0, 0 0))')}", user)
        expect(ps_response).to be_an Array
        expect(ps_response.size).to eq 1
        expect(ps_response[0]['id']).to eq p1.id
      end

      it 'returns only 2 profiles' do
        get api("/profiles?selection=#{URI::encode('POLYGON ((0 0, 0 20, 20 20, 20 0, 0 0))')}", user)
        expect(ps_response).to be_an Array
        expect(ps_response.size).to eq 2
        expect(ps_response.collect{|p| p['id']}.sort).to eq [p1.id, p2.id].sort
      end

      it 'returns profile vendor info' do
        p = create(:profile)
        d1 = create(:device, profile: p, vendor: 'foo')
        d2 = create(:device, profile: p, vendor: 'bar')
        d3 = create(:device, profile: p, vendor: 'foo')

        get api('/profiles', user)
        expect(ps_response.last['vendors'].length).to eq 2
        expect(ps_response.last['vendors']).to include 'foo'
        expect(ps_response.last['vendors']).to include 'bar'
      end

      it 'returns 400 after unparseable input' do
        get api("/profiles?selection=#{URI::encode('POLYGON ((0 0, 0 20, 20 20, 20 0, 0 0))')}231", user)
        expect(response.status).to eq 400
      end

    end
  end


  def ps_response
    json_response['profiles']
  end

  def p_response
    json_response['profile']
  end

end