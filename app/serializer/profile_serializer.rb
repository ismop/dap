class ProfileSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :levee_id, :profile_shape, :sensor_ids, :device_ids, :device_aggregation_ids, :section_id

  def levee_id
    object.levee unless (object.levee.nil?)
  end

  def profile_shape
    RGeo::GeoJSON.encode(object.profile_shape).as_json
  end

end
