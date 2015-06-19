class DeviceAggregationSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :custom_id, :placement, :section_id
  attributes :device_ids

  def placement
    RGeo::GeoJSON.encode(object.placement).as_json
  end

  def device_ids
    if object.devices.blank?
      []
    else
      object.devices.collect{|d| d.id}
    end
  end

end
