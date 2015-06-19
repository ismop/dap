
require 'rails_helper'

describe Api::V1::Pump do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /pumps' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/pumps")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      it 'returns 200' do
        get api("/pumps", user)
        expect(response.status).to eq 200
      end
    end

  end

  describe 'GET /pump' do

    let!(:pump1) { create(:pump) }
    let!(:pump2) { create(:pump) }

    context 'get all pupms' do
      it 'returns proper pumps' do
        get api("/pumps", user)
        expect(ps_response.size).to eq 2
        expect(ps_response[0]).to pump_eq pump1
        expect(ps_response[1]).to pump_eq pump2
      end
    end

    context 'get pump by id' do
      it 'returns proper pumps' do
        get api("/pumps/#{pump2.id}", user)
        expect(p_response).to pump_eq pump2
      end
    end

  end

  def ps_response
    json_response['pumps']
  end

  def p_response
    json_response['pump']
  end

end