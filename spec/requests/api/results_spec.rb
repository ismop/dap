require 'rails_helper'

describe Api::V1::ResultsController do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'Get /results' do
    context 'when authenticated as user' do
      let!(:e1) { create(:threat_assessment) }
      let!(:p1) { create(:section)}
      let!(:p2) { create(:section)}
      let!(:s1) { create(:sensor, section: p1) } # Will automatically create 1 scenario
      let!(:s2) { create(:sensor, section: p2) } # Will automatically create 1 scenario
      let!(:r1) { create(:result, threat_assessment: e1)}
      let!(:r2) { create(:result, threat_assessment: e1)}

      it 'returns 200 on success' do
        get api('/results', user)
        #puts response.body
        expect(response.status).to eq 200
      end

      it 'returns all results' do
        get api('/results', user)
        expect(rs_response).to be_an Array
        expect(rs_response.size).to eq 2
        expect(rs_response[0]).to include 'similarity'
        expect(rs_response[0]['similarity']).to be_a Float
      end
    end
  end

  describe 'POST /results' do
    context 'when authenticated as user' do

      let!(:p1) { create(:section) }
      let!(:e1) { create(:threat_assessment) }
      let!(:s1) { create(:scenario) }

      let(:create_json) do {result: {
        similarity: 37.3,
        section_id: p1.id,
        scenario_id: s1.id,
        threat_assessment_id: e1.id
      }} end

      it 'creates a new result' do
        expect(Result.count).to eq 0
        post api("/results", user), create_json
        expect(response.status).to eq 200
        expect(ThreatAssessment.count).to eq 1
        new_r = Result.last
        expect(new_r.id).to_not be_nil
        expect(new_r['similarity']).to eq 37.3
        expect(new_r.section).to eq p1
        expect(new_r.scenario).to eq s1
        expect(new_r.threat_assessment).to eq e1
      end

    end
  end

  describe 'PUT /results/{id}' do

    let!(:r1) { create(:result)}

    let(:update_json) do {result: {
      similarity: "7.7772"
    }} end

    it 'updates result' do
      put api("/results/#{r1.id}", user), update_json
      expect(Result.count).to eq 1
      updated_r = Result.find(r1.id)
      expect(updated_r.id).to_not be_nil
      expect(updated_r.id).to eq r1.id
      expect(updated_r['similarity']).to eq 7.7772
    end

  end

  def rs_response
    json_response['results']
  end

  def r_response
    json_response['result']
  end

end