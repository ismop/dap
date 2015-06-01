
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

  # TODO implement

  def ens_response
    json_response['pumps']
  end

  def en_response
    json_response['pumps']
  end

end