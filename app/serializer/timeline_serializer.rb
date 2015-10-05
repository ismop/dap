class TimelineSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :sensor_id, :context_id, :parameter_id, :experiment_id
end
