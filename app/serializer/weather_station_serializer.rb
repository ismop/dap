class WeatherStationSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :device_id
end
