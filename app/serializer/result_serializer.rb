class ResultSerializer < ActiveModel::Serializer

  attributes :id, :similarity, :rank, :payload, :threat_assessment_id, :scenario_id

end
