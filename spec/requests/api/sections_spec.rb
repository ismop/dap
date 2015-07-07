require 'rails_helper'

describe Api::V1::ProfilesController do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /sections' do
    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/sections")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      it 'returns 200 on success' do
        get api('/sections', user)
        expect(response.status).to eq 200
      end
    end
  end

  describe 'GET /sections' do
    let!(:levee) { create(:levee) }
    let!(:levee2) { create(:levee) }
    let!(:s1) { create(:section, levee: levee) }
    let!(:s2) { create(:section, levee: levee2) }
    context 'when getting all the sections' do
      it 'returns 200 on success' do
        get api('/sections', user)
        expect(ss_response.size).to eq 2
      end
    end
    context 'when getting all the sections' do
      it 'returns all sections' do
        get api('/sections', user)
        expect(ss_response.size).to eq 2
      end
    end

    context 'when getting defined section' do
      it 'returns proper section' do
        get api("/sections/#{s1.id}", user)
        expect(s_response).to section_eq s1
      end
    end
  end


  def ss_response
    json_response['sections']
  end

  def s_response
    json_response['section']
  end

end