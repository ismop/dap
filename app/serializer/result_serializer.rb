class ResultSerializer < ActiveModel::Serializer

  attributes :id, :similarity, :rank, :offset, :payload, :threat_assessment_id, :scenario_id

end
