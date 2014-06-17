require 'rails_helper'

describe Api::V1::LeveesController do

  include ApiHelpers

  let(:user) { create(:user) }
  #let(:levee) { create(:levee) }
  #let(:as1) { create(:appliance_set, user: user) }
  let!(:l1) { create(:levee) }
  let!(:l2) { create(:levee) }

  describe 'GET /levees' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/levees")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      it 'returns 200 on success' do
        get api('/levees', user)
        #puts response.body
        expect(response.status).to eq 200
      end

      it 'returns all levee sections' do
        get api('/levees', user)
        expect(ls_response).to be_an Array
        expect(ls_response.size).to eq 2
        expect(ls_response[0]).to include 'shape'
        expect(ls_response[0]['shape']).to include 'coordinates'
        expect(ls_response[0]['shape']['coordinates']).to be_an Array
        expect(ls_response[0]['shape']['coordinates'].size).to eq 6
        expect(ls_response[0]['shape']['coordinates']).to include [49.98191,19.678662,211.14]
      end
    end
  end

  describe 'GET /levees/{id}' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/levees/#{l1.id}")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      it 'returns 200 on success' do
        get api("/levees/#{l1.id}", user)
        #puts response.body
        expect(response.status).to eq 200
      end

      it 'returns a chosen levee section' do
        get api("/levees/#{l1.id}", user)
        expect(l_response).to include 'shape'
        expect(l_response['shape']).to include 'coordinates'
        expect(l_response['shape']['coordinates']).to be_an Array
        expect(l_response['shape']['coordinates'].size).to eq 6
        expect(l_response['shape']['coordinates']).to include [49.98191,19.678662,211.14]
      end
    end
  end

  describe 'PUT /levees/{id}' do

    let(:update_json) do {levee: {
        emergency_level: 'heightened'
    }} end

    let(:longer_update_json) do {levee: {
        emergency_level: 'heightened',
        threat_level: 'heightened'
    }} end

    let(:wrong_update_json) do {levee: {
        name: 'heightened'
    }} end

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        put api("/levees/#{l1.id}")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      it 'returns 200 Success' do
        put api("/levees/#{l1.id}", user), update_json
        #puts response.body
        expect(response.status).to eq 200
      end

      it 'prevents updating wrong attributes' do
        old_name = Levee.find(l1.id).name
        put api("/levees/#{l1.id}", user), wrong_update_json
        updated_l = Levee.find(l1.id)
        expect(updated_l.id).to_not be_nil
        expect(updated_l.id).to eq l1.id
        expect(updated_l.name).to eq old_name
        expect(updated_l['emergency_level']).to eq l1.emergency_level
        expect(updated_l['threat_level']).to eq l1.threat_level
      end

      it 'updates levee emergency level' do
        put api("/levees/#{l1.id}", user), update_json
        updated_l = Levee.find(l1.id)
        expect(updated_l.id).to_not be_nil
        expect(updated_l.id).to eq l1.id
        expect(updated_l['emergency_level']).to eq 'heightened'
        expect(updated_l['threat_level']).to eq l1.threat_level
      end

      it 'updates levee threat level' do
        put api("/levees/#{l1.id}", user), longer_update_json
        updated_l = Levee.find(l1.id)
        expect(updated_l.id).to_not be_nil
        expect(updated_l.id).to eq l1.id
        expect(updated_l['emergency_level']).to eq 'heightened'
        expect(updated_l['threat_level']).to eq 'heightened'
      end

    end
  end

  def ls_response
    json_response['levees']
  end

  def l_response
    json_response['levee']
  end

end