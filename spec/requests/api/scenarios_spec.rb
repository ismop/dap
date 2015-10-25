require 'rails_helper'

describe Api::V1::ScenariosController do

  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /scenarios' do

    context 'when unauthenticated' do
      it 'returns 401 Unauthorized error' do
        get api("/scenarios")
        expect(response.status).to eq 401
      end
    end

    context 'when authenticated as user' do

      it 'returns 200' do
        get api("/scenarios", user)
        expect(response.status).to eq 200
      end

      it 'returns correct experiment info' do

        s1 = create(:scenario)
        s2 = create(:scenario)
        s3 = create(:scenario)

        e1 = create(:experiment, scenarios: [s1])
        e2 = create(:experiment, scenarios: [s2, s3])

        get api('/scenarios', user)

        expect(ss.size).to eq 3
        expect(ss[0]).to scenario_eq s1
        expect(ss[1]).to scenario_eq s2
        expect(ss[2]).to scenario_eq s3

      end

      it 'filters scenarios by experiment ids' do

        s1 = create(:scenario)
        s2 = create(:scenario)
        s3 = create(:scenario)

        e1 = create(:experiment, scenarios: [s1])
        e2 = create(:experiment, scenarios: [s1, s3])
        e3 = create(:experiment, scenarios: [s3])

        get api("/scenarios?experiment_ids=#{e2.id.to_s},#{e3.id.to_s}", user)
        expect(ss.size).to eq 2
        expect(ss[0]).to scenario_eq s1
        expect(ss[1]).to scenario_eq s3

      end

      it 'filters scenarios by timeline ids' do

        t1 = create(:timeline)
        t2 = create(:timeline)
        t3 = create(:timeline)
        t4 = create(:timeline)

        s1 = create(:scenario, timelines: [t1])
        s2 = create(:scenario, timelines: [t2, t3, t4])

        get api("/scenarios?timeline_ids=#{t2.id.to_s},#{t3.id.to_s}", user)
        expect(ss.size).to eq 1
        expect(ss[0]).to scenario_eq s2

        get api("/scenarios?timeline_ids=#{t1.id.to_s},#{t4.id.to_s}", user)
        expect(ss.size).to eq 2
        expect(ss[0]).to scenario_eq s1
        expect(ss[1]).to scenario_eq s2

      end

    end
  end

  def ss
    json_response['scenarios']
  end

  def s
    json_response['scenario']
  end

end