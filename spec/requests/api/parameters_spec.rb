
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

  # TODO implement

  def ens_response
    json_response['parameters']
  end

  def en_response
    json_response['parameters']
  end

end