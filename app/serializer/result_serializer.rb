class ResultSerializer < ActiveModel::Serializer
  attributes :id, :similarity, :threat_assessment_id, :profile_id, :scenario_id

end
