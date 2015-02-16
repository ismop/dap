class SensorSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :custom_id, :x_orientation, :y_orientation, :z_orientation, :battery_state, :battery_capacity, :manufacturer, :model, :serial_number, :firmware_version, :manufacture_date, :purchase_date, :warranty_date, :deployment_date, :last_state_change, :energy_consumption, :precision, :measurement_node_id, :section_id

  attributes :placement
  attributes :activity_state, :power_type, :interface_type, :measurement_type_name, :measurement_type_unit

  attributes :timeline_ids

  def placement
    RGeo::GeoJSON.encode(object.placement).as_json
  end

  def activity_state
    object.activity_state.nil? ? nil : object.activity_state.name
  end

  def power_type
    object.power_type.nil? ? nil : object.power_type.name
  end

  def interface_type
    object.interface_type.nil? ? nil : object.interface_type.name
  end

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
