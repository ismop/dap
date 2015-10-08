class DeviceAggregationSerializer < ActiveModel::Serializer
  attributes :id, :custom_id, :shape, :profile_id, :section_id, :levee_id, :type, :children_ids, :parent_id
  attributes :device_ids

  def type
    object.device_aggregation_type
  end

  def shape
    RGeo::GeoJSON.encode(object.shape).as_json
  end

  def device_ids
    if object.devices.blank?
      []
    else
      object.devices.collect{|d| d.id}
    end
  end

  def children_ids
    if object.children.blank?
      []
    else
      object.children.collect{|d| d.id}
    end
  end

end
