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

      # Create four sensors with easy-to-manipulate geographical placement
      let!(:s1) { create(:sensor, placement: "POINT (5 5 5)")}
      let!(:s2) { create(:sensor, placement: "POINT (5 15 5)")}
      let!(:s3) { create(:sensor, placement: "POINT (15 5 5)")}
      let!(:s4) { create(:sensor, placement: "POINT (15 15 5)")}

      # Group these sensors into two profiles
      let!(:p1) { create(:profile, sensors: [s1, s2]) }
      let!(:p2) { create(:profile, sensors: [s3, s4]) }

      it 'returns all profiles' do
        get api('/profiles', user)
        expect(ps_response).to be_an Array
        expect(ps_response.size).to eq 6
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


      it 'returns 400 after unparseable input', focus: true do
        get api("/profiles?selection=#{URI::encode('POLYGON ((0 0, 0 20, 20 20, 20 0, 0 0))')}2", user)
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