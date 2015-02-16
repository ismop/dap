class ResultSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :similarity, :experiment_id, :section_id, :scenario_id, :threat_level

end