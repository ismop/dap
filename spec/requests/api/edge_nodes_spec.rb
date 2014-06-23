require 'rails_helper'

describe Api::V1::EdgeNodesController do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /edge_nodes' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/edge_nodes")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do

      let!(:en1) { create(:edge_node) }
      let!(:en2) { create(:edge_node) }
      let!(:en3) { create(:edge_node) }

      it 'returns 200 and all edge nodes on success' do
        get api('/edge_nodes', user)
        expect(response.status).to eq 200
        expect(ens_response).to be_an Array
        expect(ens_response.length).to eq 3
      end
    end
  end

  describe 'GET /edge_nodes/{id}' do

    context 'when authenticated as user' do
      let!(:en1) { create(:edge_node, custom_id: "foo") }
      let!(:en2) { create(:edge_node) }

      it 'returns the selected edge node' do
        get api("/edge_nodes/#{en1.id}", user)

        expect(en_response).to include 'custom_id'
        expect(en_response['custom_id']).to eq 'foo'
      end
    end
  end

  def ens_response
    json_response['edge_nodes']
  end

  def en_response
    json_response['edge_node']
  end

end