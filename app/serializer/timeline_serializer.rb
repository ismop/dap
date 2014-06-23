class TimelineSerializer < ActiveModel::Serializer
  embed :ids
  attributes :name, :measurement_type, :sensor_id
end
