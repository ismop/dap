class TimelineSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :measurement_type, :sensor_id
end
