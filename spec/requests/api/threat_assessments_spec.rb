require 'rails_helper'

describe Api::V1::ThreatAssessmentsController do

  include ApiHelpers

  let(:user) { create(:user) }
  let!(:e1) { create(:threat_assessment) }


  describe 'GET /threat_assessments' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/threat_assessments")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      it 'returns 200 on success' do
        get api('/threat_assessments', user)
        expect(response.status).to eq 200
      end

      it 'returns all threat_assessments' do
        get api('/threat_assessments', user)
        expect(exps_response).to be_an Array
        expect(exps_response.size).to eq 1
        expect(exps_response[0]).to include 'selection'
        expect(exps_response[0]['selection']).to include 'coordinates'
        expect(exps_response[0]['selection']['coordinates']).to be_an Array
        expect(exps_response[0]['selection']['coordinates'].size).to eq 1 # Polygon definition without inner ring
        expect(exps_response[0]['selection']['coordinates'][0].size).to eq 5 # Four nodes in outer ring; polygon wraps on itself
        expect(exps_response[0]['selection']['coordinates'][0]).to include [49.981348,19.678777] # One of the outer nodes
      end

      it 'returns only selected threat_assessments' do
        get api("/threat_assessments?id=#{e1.id}", user)
        expect(exps_response).to be_an Array
        expect(exps_response.size).to eq 1
        expect(exps_response[0]).to include 'selection'
        expect(exps_response[0]['selection']).to include 'coordinates'
        expect(exps_response[0]['selection']['coordinates']).to be_an Array
        expect(exps_response[0]['selection']['coordinates'].size).to eq 1 # Polygon definition without inner ring
        expect(exps_response[0]['selection']['coordinates'][0].size).to eq 5 # Four nodes in outer ring; polygon wraps on itself
        expect(exps_response[0]['selection']['coordinates'][0]).to include [49.981348,19.678777] # One of the outer nodes
      end

      it 'returns only selected threat_assessments' do
        get api("/threat_assessments?id=#{e1.id+100}", user)
        expect(exps_response).to be_an Array
        expect(exps_response.size).to eq 0
      end

    end

    context 'when result set' do
      let!(:result) { create(:result) }
      let!(:e2) { create(:threat_assessment, results: [result]) }
      it 'returns only selected threat_assessments' do
        get api("/threat_assessments?id=#{e1.id}", user)
        expect(exps_response[0]).to include 'results'
        expect(exps_response[0]['results'].size).to eq 0
      end
      it 'returns only selected threat_assessments with proper results' do
        get api("/threat_assessments?id=#{e2.id}", user)
        expect(exps_response[0]).to include 'results'
        expect(exps_response[0]['results'].size).to eq 1
        expect(exps_response[0]['results'].first['id']).to eq result.id
      end
    end

  end

  describe 'POST /threat_assessments' do
    context 'when authenticated as user' do

      let!(:p1) { create(:section) }
      let!(:p2) { create(:section) }

      let(:create_json) do {threat_assessment: {
        name: "My new threat_assessment",
        status: "started",
        status_message: "threat_assessment in progress",
        start_date: "2014-09-10 15:15",
        end_date: nil,
        selection: "POLYGON ((49.981348 19.678777, 49.981665 19.678662, 49.981919 19.678856, 49.9815 19.678866, 49.981348 19.678777))",
        section_ids: [p1.id, p2.id]
      }} end

      it 'creates a new threat_assessment' do
        expect(ThreatAssessment.count).to eq 1
        post api("/threat_assessments", user), create_json
        expect(response.status).to eq 201
        expect(ThreatAssessment.count).to eq 2
        new_e = ThreatAssessment.last
        expect(new_e.id).to_not be_nil
        expect(new_e['status']).to eq "started"
        expect(new_e.sections).to eq [p1, p2]
      end

    end
  end

  describe 'PUT /threat_assessments/{id}' do
    let(:update_json) do {threat_assessment: {
      status: "started"
    }} end

    let(:longer_update_json) do {threat_assessment: {
        status: "finished",
        status_message: "threat_assessment finished successfully.",
        start_date: "2014-09-10 11:30",
        end_date: "2014-09-10 12:15"
    }} end

    let(:wrong_update_json) do {threat_assessment: {
        status: "foo"
    }} end

    it 'prevents updating wrong attributes' do
      old_status = ThreatAssessment.find(e1.id).status
      put api("/threat_assessments/#{e1.id}", user), wrong_update_json
      updated_e = ThreatAssessment.find(e1.id)
      expect(updated_e.id).to_not be_nil
      expect(updated_e.id).to eq e1.id
      expect(updated_e.status).to eq old_status
    end

    it 'updates threat_assessment status' do
      put api("/threat_assessments/#{e1.id}", user), update_json
      expect(ThreatAssessment.count).to eq 1
      updated_e = ThreatAssessment.find(e1.id)
      expect(updated_e.id).to_not be_nil
      expect(updated_e.id).to eq e1.id
      expect(updated_e['status']).to eq "started"
    end

    it 'updates multiple parameters' do
      put api("/threat_assessments/#{e1.id}", user), longer_update_json
      expect(ThreatAssessment.count).to eq 1
      updated_e = ThreatAssessment.find(e1.id)
      expect(updated_e.id).to_not be_nil
      expect(updated_e.status).to eq "finished"
      expect(updated_e.status_message).to eq "threat_assessment finished successfully."
      expect(updated_e.start_date). to eq "2014-09-10 11:30"
      expect(updated_e.end_date). to eq "2014-09-10 12:15"
    end

  end

  def exps_response
    json_response['threat_assessments']
  end

  def exp_response
    json_response['threat_assessment']
  end

end