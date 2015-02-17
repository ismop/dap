class SectionSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :levee_id, :shape, :profile_shape, :sensor_ids

  def shape
    RGeo::GeoJSON.encode(object.shape).as_json
  end


  def profile_shape
    RGeo::GeoJSON.encode(object.profile_shape).as_json
  end

end

