
require 'rails_helper'

describe Api::V1::ContextsController do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /contexts' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/contexts")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do
      it 'returns 200' do
        get api("/contexts", user)
        expect(response.status).to eq 200
      end
    end

  end

  describe 'GET /devices' do

    let!(:context) { create(:context) }

    context 'get all contexts' do
      it 'returns right contexts' do
        get api("/contexts", user)
        expect(ds[0]).to context_eq context
      end
    end

    context 'get context by id' do
      it 'returns right context' do
        get api("/contexts/#{context.id}", user)
        expect(d).to context_eq context
      end
    end

  end

  def ds
    json_response['contexts']
  end

  def d
    json_response['context']
  end

end