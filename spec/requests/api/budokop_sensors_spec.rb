require 'rails_helper'

describe Api::V1::BudokopSensor do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /budokop_sensors' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/budokop_sensors")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      it 'returns 200' do
        get api("/budokop_sensors", user)
        expect(response.status).to eq 200
      end
    end

  end

  # TODO implement

  def ens_response
    json_response['budokop_sensors']
  end

  def en_response
    json_response['budokop_sensors']
  end

end