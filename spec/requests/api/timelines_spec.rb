require 'rails_helper'

describe Api::V1::TimelinesController do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /timelines' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/timelines")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do

      let!(:p) { create(:parameter) }
      let!(:t2) { create(:timeline, parameter: p) }
      let!(:t3) { create(:timeline, parameter: p) }
      let!(:t4) { create(:timeline, parameter: p) }

      it 'returns 200 and all timelines on success' do
        get api('/timelines', user)
        expect(response.status).to eq 200
        expect(ts_response).to be_an Array
        expect(ts_response.length).to eq 3
      end
    end

    context 'filter timelines by id' do
      let!(:t1) { create(:timeline)}
      let!(:t2) { create(:timeline)}
      let!(:t3) { create(:timeline)}
      let!(:t4) { create(:timeline)}

      it 'returns timelines with selected ids' do
        get api("/timelines?id=#{t1.id},#{t4.id}", user)
        expect(ts_response).to be_an Array
        expect(ts_response.length).to eq 2
        expect(ts_response.collect{|r| r['id']}).to include t1.id
        expect(ts_response.collect{|r| r['id']}).to include t4.id
      end
    end
  end

  describe 'GET /timelines/{id}' do

    context 'when authenticated as user' do
      let!(:p) { create(:parameter) }
      let!(:t2) { create(:timeline, parameter: p) }

      it 'returns the selected timeline' do
        get api("/timelines/#{p.timelines.first.id}", user)

        expect(t_response["id"]).to eq p.timelines.first.id
      end
    end
  end

  def ts_response
    json_response['timelines']
  end

  def t_response
    json_response['timeline']
  end

end