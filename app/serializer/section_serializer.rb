class SectionSerializer < ActiveModel::Serializer
  attributes :id, :levee_id, :shape
  attributes :ground_type_label, :ground_type_description

  def shape
    RGeo::GeoJSON.encode(object.shape).as_json
  end

  def ground_type_label
    object.ground_type.blank? ? 'unknown' : object.ground_type.label
  end

  def ground_type_description
    object.ground_type.blank? ? '' : object.ground_type.description.blank? ? '' : object.ground_type.description
  end

end

