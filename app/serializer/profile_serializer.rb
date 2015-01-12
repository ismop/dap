class ProfileSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :levee_id, :shape, :experiment_ids, :sensor_ids

  def shape
    RGeo::GeoJSON.encode(object.shape).as_json
  end

end

