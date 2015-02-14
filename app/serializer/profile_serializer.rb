class ProfileSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :levee_id, :shape, :sensor_ids, :profile_shape

  def shape
    RGeo::GeoJSON.encode(object.shape).as_json
  end


  def profile_shape
    RGeo::GeoJSON.encode(object.profile_shape).as_json
  end

end

