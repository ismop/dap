class ProfileSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :levee_id, :shape, :emergency_level, :threat_level, :experiment_ids, :sensor_ids

  def shape
    RGeo::GeoJSON.encode(object.shape).as_json
  end

end

