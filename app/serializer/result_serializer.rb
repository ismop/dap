class ResultSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :similarity, :threat_assessment_id, :profile_id, :scenario_id, :threat_level

end