
require 'rails_helper'

describe Api::V1::Parameter do

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

  end

  def ps_response
    json_response['parameters']
  end

  def p_response
    json_response['parameter']
  end

end