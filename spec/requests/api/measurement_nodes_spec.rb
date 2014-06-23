require 'rails_helper'

describe Api::V1::MeasurementNodesController do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /measurement_nodes' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/measurement_nodes")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do

      let!(:mn1) { create(:measurement_node) }
      let!(:mn2) { create(:measurement_node) }

      it 'returns 200 and all measurement nodes on success' do
        get api('/measurement_nodes', user)
        expect(response.status).to eq 200
        expect(mns_response).to be_an Array
        expect(mns_response.length).to eq 2
      end
    end
  end

  describe 'GET /measurement_nodes/{id}' do

    context 'when authenticated as user' do
      let!(:mn1) { create(:measurement_node, custom_id: "foo") }
      let!(:mn2) { create(:measurement_node) }

      it 'returns the selected measurement node' do
        get api("/measurement_nodes/#{mn1.id}", user)

        expect(mn_response).to include 'custom_id'
        expect(mn_response['custom_id']).to eq 'foo'
      end
    end
  end

  def mns_response
    json_response['measurement_nodes']
  end

  def mn_response
    json_response['measurement_node']
  end

end