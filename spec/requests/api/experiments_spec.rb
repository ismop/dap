require 'rails_helper'

describe Api::V1::ExperimentsController do

  include ApiHelpers

  let(:user) { create(:user) }
  let!(:e1) { create(:experiment) }

  describe 'GET /experiments' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/experiments")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      it 'returns 200 on success' do
        get api('/experiments', user)
        #puts response.body
        expect(response.status).to eq 200
      end

      it 'returns all experiments' do
        get api('/experiments', user)
        expect(exps_response).to be_an Array
        expect(exps_response.size).to eq 1
        expect(exps_response[0]).to include 'selection'
        expect(exps_response[0]['selection']).to include 'coordinates'
        expect(exps_response[0]['selection']['coordinates']).to be_an Array
        expect(exps_response[0]['selection']['coordinates'].size).to eq 1 # Polygon definition without inner ring
        expect(exps_response[0]['selection']['coordinates'][0].size).to eq 5 # Four nodes in outer ring; polygon wraps on itself
        expect(exps_response[0]['selection']['coordinates'][0]).to include [49.981348,19.678777] # One of the outer nodes
      end
    end
  end

  describe 'POST /experiments' do
    context 'when authenticated as user' do

      let!(:p1) { create(:profile) }
      let!(:p2) { create(:profile) }

      let(:create_json) do {experiment: {
        name: "My new experiment",
        status: "started",
        start_date: "2014-09-10 15:15",
        end_date: nil,
        selection: "POLYGON ((49.981348 19.678777, 49.981665 19.678662, 49.981919 19.678856, 49.9815 19.678866, 49.981348 19.678777))",
        profile_ids: [p1.id, p2.id]
      }} end

      it 'creates a new experiment' do
        expect(Experiment.count).to eq 1
        post api("/experiments", user), create_json
        expect(response.status).to eq 200
        expect(Experiment.count).to eq 2
        new_e = Experiment.last
        expect(new_e.id).to_not be_nil
        expect(new_e['status']).to eq "started"
        expect(new_e.profiles).to eq [p1, p2]
      end

    end
  end

  describe 'PUT /experiments/{id}' do
    let(:update_json) do {experiment: {
      status: "started"
    }} end

    let(:longer_update_json) do {experiment: {
        status: "finished",
        start_date: "2014-09-10 11:30",
        end_date: "2014-09-10 12:15"
    }} end

    let(:wrong_update_json) do {experiment: {
        status: "foo"
    }} end

    it 'prevents updating wrong attributes' do
      old_status = Experiment.find(e1.id).status
      put api("/experiments/#{e1.id}", user), wrong_update_json
      updated_e = Experiment.find(e1.id)
      expect(updated_e.id).to_not be_nil
      expect(updated_e.id).to eq e1.id
      expect(updated_e.status).to eq old_status
    end

    it 'updates experiment status' do
      put api("/experiments/#{e1.id}", user), update_json
      expect(Experiment.count).to eq 1
      updated_e = Experiment.find(e1.id)
      expect(updated_e.id).to_not be_nil
      expect(updated_e.id).to eq e1.id
      expect(updated_e['status']).to eq "started"
    end

    it 'updates multiple parameters' do
      put api("/experiments/#{e1.id}", user), longer_update_json
      expect(Experiment.count).to eq 1
      updated_e = Experiment.find(e1.id)
      expect(updated_e.id).to_not be_nil
      expect(updated_e.status).to eq "finished"
      expect(updated_e.start_date). to eq "2014-09-10 11:30"
      expect(updated_e.end_date). to eq "2014-09-10 12:15"
    end

  end

  def exps_response
    json_response['experiments']
  end

  def exp_response
    json_response['experiment']
  end

end