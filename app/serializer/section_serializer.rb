class SectionSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :levee_id, :shape

  def shape
    RGeo::GeoJSON.encode(object.shape).as_json
  end

end

