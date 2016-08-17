require 'rails_helper'

describe Api::V1::ThreatAssessmentsController do

  include ApiHelpers

  let(:user) { create(:user) }
  let!(:ta) { create(:threat_assessment) }


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
        expect(tas_response).to be_an Array
        expect(tas_response.size).to eq 1
      end

      it 'returns only selected threat_assessments' do
        get api("/threat_assessments?id=#{ta.id}", user)
        expect(tas_response).to be_an Array
        expect(tas_response.size).to eq 1
      end

      it 'returns only selected threat_assessments' do
        get api("/threat_assessments?id=#{ta.id+100}", user)
        expect(tas_response).to be_an Array
        expect(tas_response.size).to eq 0
      end

    end

    context 'when result set' do
      let!(:result) { create(:result) }
      let!(:ta2) { create(:threat_assessment, results: [result]) }
      it 'returns only selected threat_assessments' do
        get api("/threat_assessments?id=#{ta.id}", user)
        expect(tas_response[0]).to include 'results'
        expect(tas_response[0]['results'].size).to eq 0
      end
      it 'returns only selected threat_assessments with proper results' do
        get api("/threat_assessments?id=#{ta2.id}", user)
        expect(tas_response[0]).to include 'results'
        expect(tas_response[0]['results'].size).to eq 1
        expect(tas_response[0]['results'].first['id']).to eq result.id
      end
    end

  end

  describe 'POST /threat_assessments' do
    context 'when authenticated as user' do

      let!(:p1) { create(:profile) }
      let!(:p2) { create(:profile) }

      let!(:tar) { create(:threat_assessment_run) }

      let(:create_json) do {threat_assessment: {
        threat_assessment_run: tar,
        profile_ids: [p1.id, p2.id]
      }} end

      it 'creates a new threat_assessment' do
        expect(ThreatAssessment.count).to eq 1
        post api("/threat_assessments", user), create_json
        expect(response.status).to eq 201
        expect(ThreatAssessment.count).to eq 2
        new_ta = ThreatAssessment.last
        expect(new_ta.id).to_not be_nil
      end

    end
  end

  describe 'PUT /threat_assessments' do
    context 'when authenticated as user' do
      let!(:p1) { create(:profile) }
      let!(:p2) { create(:profile) }

      let!(:ta) { create(:threat_assessment) }

      let(:update_json) do {threat_assessment: {
        status: 'finished'
      }} end

      it 'updates the status of an existing threat_assessment' do
        ta1 = ThreatAssessment.first
        expect(ta1.status).to eq 'running'
        put api("/threat_assessments/#{ta1.id}", user), update_json
        expect(ta1.reload.status).to eq 'finished'
      end
    end
  end

  def tas_response
    json_response['threat_assessments']
  end

  def ta_response
    json_response['threat_assessment']
  end

end