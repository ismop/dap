class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :levee_id, :profile_shape, :vendor, :device_ids, :device_aggregation_ids, :section_id

  def levee_id
    object.levee unless (object.levee.nil?)
  end

  def profile_shape
    RGeo::GeoJSON.encode(object.shape).as_json
  end

end

