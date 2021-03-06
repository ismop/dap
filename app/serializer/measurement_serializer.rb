class MeasurementSerializer < ActiveModel::Serializer
  attributes :id, :value, :timestamp, :source_address, :timeline_id

  def timestamp
    object.m_timestamp
  end

end
