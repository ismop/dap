class ResultSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :similarity, :experiment_id, :profile_id, :timeline_id
end