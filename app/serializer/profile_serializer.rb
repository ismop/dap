class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :levee_id, :profile_shape, :base_height, :vendors, :device_ids, :device_aggregation_ids, :section_id

  def vendors
    object.devices.collect{|d| d.vendor}.uniq.compact
  end

  def levee_id
    object.levee unless (object.levee.nil?)
  end

  def profile_shape
    RGeo::GeoJSON.encode(object.shape).as_json
  end

  def base_height
    if object.base_height.nil? && !object.levee.nil?
      return object.levee.base_height
    end
    return object.base_height
  end

end

