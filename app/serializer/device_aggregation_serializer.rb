class DeviceAggregationSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :custom_id, :placement, :profile_id, :section_id, :levee_id, :type, :children_ids, :parent_id
  attributes :device_ids

  def type
    object.device_aggregation_type
  end

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

  def children_ids
    if object.children.blank?
      []
    else
      object.children.collect{|d| d.id}
    end
  end

end
