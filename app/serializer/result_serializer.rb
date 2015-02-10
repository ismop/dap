class ResultSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :similarity, :experiment_id, :profile_id, :scenario_id, :threat_level

end