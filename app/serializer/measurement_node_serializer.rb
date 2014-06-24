class MeasurementNodeSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :custom_id, :battery_state, :battery_capacity, :manufacturer, :model, :serial_number, :firmware_version, :manufacture_date, :purchase_date, :warranty_date, :deployment_date, :last_state_change, :energy_consumption, :edge_node_id

  attributes :placement
  attributes :activity_state, :power_type, :interface_type

  def placement
    RGeo::GeoJSON.encode(object.placement).as_json
  end

  def activity_state
    object.activity_state.name
  end

  def power_type
    object.power_type.name
  end

  def interface_type
    object.interface_type.name
  end

end
