require 'rails_helper'

describe Api::V1::FiberOpticNodesController do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /fiber_optic_nodes' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/fiber_optic_nodes")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      it 'returns 200' do
        get api("/fiber_optic_nodes", user)
        expect(response.status).to eq 200
      end
    end

  end

  describe 'GET /fiber_optic_nodes' do

    let!(:fo1) { create(:fiber_optic_node) }
    let!(:fo2) { create(:fiber_optic_node) }

    context 'get all FO nodes' do
      it 'returns proper nodes' do
        get api("/fiber_optic_nodes", user)
        expect(fons_response.size).to eq 2
        expect(fons_response[0]).to fiber_optic_node_eq fo1
        expect(fons_response[1]).to fiber_optic_node_eq fo2
      end
    end

    context 'get FO node by id' do
      it 'returns proper node' do
        get api("/fiber_optic_nodes/#{fo2.id}", user)
        expect(fon_response).to fiber_optic_node_eq fo2
      end
    end

  end

  def fons_response
    json_response['fiber_optic_nodes']
  end

  def fon_response
    json_response['fiber_optic_node']
  end

end