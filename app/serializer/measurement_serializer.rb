class MeasurementSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :value, :timestamp, :source_address, :timeline_id
end