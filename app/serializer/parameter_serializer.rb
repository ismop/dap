class ParameterSerializer < ActiveModel::Serializer
  attributes :id, :custom_id, :parameter_name, :device_id
  attributes :measurement_type_name, :measurement_type_unit

  attributes :timeline_ids

  def measurement_type_name
    object.measurement_type.nil? ? nil : object.measurement_type.name
  end

  def measurement_type_unit
    object.measurement_type.nil? ? nil : object.measurement_type.unit
  end

  def timeline_ids
    if object.timelines.blank?
      []
    else
      object.timelines.collect{|t| t.id}
    end
  end

end
