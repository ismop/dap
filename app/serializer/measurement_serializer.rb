class MeasurementSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :value, :timestamp, :source_address, :timeline_id, :sensor_id

  def sensor_id
     object.timeline.sensor_id
  end

end