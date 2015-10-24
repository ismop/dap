require 'rails_helper'

describe Api::V1::ThreatAssessmentRunsController do

  include ApiHelpers

  let(:user) { create(:user) }
  let!(:r) { create(:threat_assessment_run) }


  describe 'GET /threat_assessment_runs' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/threat_assessment_runs")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      it 'returns 200 on success' do
        get api('/threat_assessment_runs', user)
        expect(response.status).to eq 200
      end

      it 'returns all threat_assessment_runs' do
        get api('/threat_assessment_runs', user)
        expect(runs_response).to be_an Array
        expect(runs_response.size).to eq 1
      end

      it 'returns only selected threat_assessment_runs' do
        get api("/threat_assessment_runs?id=#{r.id}", user)
        expect(runs_response).to be_an Array
        expect(runs_response.size).to eq 1
      end

      it 'returns only selected threat_assessment runs' do
        get api("/threat_assessment_runs?id=#{r.id+100}", user)
        expect(runs_response).to be_an Array
        expect(runs_response.size).to eq 0
      end
    end
  end

  describe 'POST /threat_assessment_runs' do
    context 'when authenticated as user' do

      let!(:ta1) { create(:threat_assessment) }
      let!(:ta2) { create(:threat_assessment) }

      let(:create_json) do {threat_assessment_run: {
        name: "My new threat_assessment_run",
        status: "started",
        start_date: "2014-09-10 15:15",
        end_date: nil,
        threat_assessment_ids: [ta1.id, ta2.id]
      }} end

      it 'creates a new threat_assessment_run' do
        expect(ThreatAssessmentRun.count).to eq 3
        post api("/threat_assessment_runs", user), create_json
        expect(response.status).to eq 201
        expect(ThreatAssessmentRun.count).to eq 4
        new_r = ThreatAssessmentRun.last
        expect(new_r.id).to_not be_nil
        expect(new_r['status']).to eq "started"
      end

    end
  end

  describe 'PUT /threat_assessment_runs/{id}' do
    let(:update_json) do {threat_assessment_run: {
      status: "started"
    }} end

    let(:longer_update_json) do {threat_assessment_run: {
        status: "finished",
        start_date: "2014-09-10 11:30",
        end_date: "2014-09-10 12:15"
    }} end

    let(:wrong_update_json) do {threat_assessment_run: {
        status: "foo"
    }} end

    it 'prevents updating wrong attributes' do
      old_status = ThreatAssessmentRun.find(r.id).status
      put api("/threat_assessment_runs/#{r.id}", user), wrong_update_json
      updated_r = ThreatAssessmentRun.find(r.id)
      expect(updated_r.id).to_not be_nil
      expect(updated_r.id).to eq r.id
      expect(updated_r.status).to eq old_status
    end

    it 'updates threat_assessment_run status' do
      put api("/threat_assessment_runs/#{r.id}", user), update_json
      expect(ThreatAssessmentRun.count).to eq 1
      updated_r = ThreatAssessmentRun.find(r.id)
      expect(updated_r.id).to_not be_nil
      expect(updated_r.id).to eq r.id
      expect(updated_r['status']).to eq "started"
    end

    it 'updates multiple parameters' do
      put api("/threat_assessment_runs/#{r.id}", user), longer_update_json
      expect(ThreatAssessmentRun.count).to eq 1
      updated_r = ThreatAssessmentRun.find(r.id)
      expect(updated_r.id).to_not be_nil
      expect(updated_r.status).to eq "finished"
      expect(updated_r.start_date). to eq "2014-09-10 11:30"
      expect(updated_r.end_date). to eq "2014-09-10 12:15"
    end

  end

  def runs_response
    json_response['threat_assessment_runs']
  end

  def run_response
    json_response['threat_assessment_run']
  end

end