class SectionSerializer < ActiveModel::Serializer
  attributes :id, :levee_id, :shape
  attributes :soil_type_label, :soil_type_name
  attributes :bulk_density_min, :bulk_density_max, :bulk_density_avg
  attributes :granular_density_min, :granular_density_max, :granular_density_avg
  attributes :filtration_coefficient_min, :filtration_coefficient_max, :filtration_coefficient_avg

  def shape
    RGeo::GeoJSON.encode(object.shape).as_json
  end

  def soil_type_label
    object.soil_type && object.soil_type.label
  end

  def soil_type_name
    object.soil_type && object.soil_type.name
  end

  def bulk_density_min
    object.soil_type && object.soil_type.bulk_density_min
  end

  def bulk_density_max
    object.soil_type && object.soil_type.bulk_density_max
  end

  def bulk_density_avg
    object.soil_type && object.soil_type.bulk_density_avg
  end

  def granular_density_min
    object.soil_type && object.soil_type.granular_density_min
  end

  def granular_density_max
    object.soil_type && object.soil_type.granular_density_max
  end

  def granular_density_avg
    object.soil_type && object.soil_type.granular_density_avg
  end

  def filtration_coefficient_min
    object.soil_type && object.soil_type.filtration_coefficient_min
  end

  def filtration_coefficient_max
    object.soil_type && object.soil_type.filtration_coefficient_max
  end

  def filtration_coefficient_avg
    object.soil_type && object.soil_type.filtration_coefficient_avg
  end

end

