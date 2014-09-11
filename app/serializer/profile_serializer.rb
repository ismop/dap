class ProfileSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :experiment_ids, :sensor_ids

end