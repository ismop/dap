
require 'rails_helper'

describe Api::V1::ParametersController do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /parameters' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/parameters")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      it 'returns 200' do
        get api("/parameters", user)
        expect(response.status).to eq 200
      end
    end

  end

  describe 'GET /parameters' do

    let!(:parameter1) { create(:parameter) }

    context 'when authenticated as user' do
      it 'returns proper sensors' do
        get api("/parameters", user)
        expect(ps_response.size).to eq 1
        expect(ps_response[0]).to parameter_eq parameter1
      end
    end

    context 'when authenticated as user' do
      it 'returns proper sensors' do
        get api("/parameters/#{parameter1.id}", user)
        expect(p_response).to parameter_eq parameter1
      end
    end

    context 'filter parameters by id' do
      let!(:p1) { create(:parameter)}
      let!(:p2) { create(:parameter)}
      let!(:p3) { create(:parameter)}
      let!(:p4) { create(:parameter)}

      it 'returns parameters with selected ids' do
        get api("/parameters?id=#{p2.id},#{p3.id}", user)
        expect(ps_response).to be_an Array
        expect(ps_response.length).to eq 2
        expect(ps_response.collect{|r| r['id']}).to include p2.id
        expect(ps_response.collect{|r| r['id']}).to include p3.id
      end
    end

    context 'filter parameters by levee_id' do
      let!(:l1) { create(:levee) }
      let!(:l2) { create(:levee) }

      let!(:d1_1) { create(:device, levee: l1) }
      let!(:d1_2) { create(:device, levee: l1) }
      let!(:d2_1) { create(:device, levee: l2) }
      let!(:d2_2) { create(:device, levee: l2) }

      let!(:p1_1) { create(:parameter, device: d1_1)}
      let!(:p1_2) { create(:parameter, device: d1_2)}
      let!(:p2_1) { create(:parameter, device: d2_1)}
      let!(:p2_2) { create(:parameter, device: d2_2)}

      it 'returns parameters which match selected levee id' do
        get api("/parameters?levee_id=#{l2.id}", user)

        expect(ps_response).to be_an Array
        expect(ps_response.length).to eq 2
        expect(ps_response.collect{|r| r['id']}).to include p2_1.id
        expect(ps_response.collect{|r| r['id']}).to include p2_2.id
      end
    end

  end

  def ps_response
    json_response['parameters']
  end

  def p_response
    json_response['parameter']
  end

end