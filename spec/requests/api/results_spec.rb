require 'rails_helper'

describe Api::V1::ResultsController do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'Get /results' do
    context 'when authenticated as user' do
      let!(:e1) { create(:experiment) }
      let!(:p1) { create(:profile)}
      let!(:p2) { create(:profile)}
      let!(:s1) { create(:sensor, profile: p1) } # Will automatically create 1 timeline
      let!(:s2) { create(:sensor, profile: p2) } # Will automatically create 1 timeline
      let!(:r1) { create(:result, experiment: e1)}
      let!(:r2) { create(:result, experiment: e1)}

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