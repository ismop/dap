class EdgeNodeSerializer < ActiveModel::Serializer
  embed :ids
  attributes :custom_id, :manufacturer, :model, :serial_number, :firmware_version, :manufacture_date, :purchase_date, :warranty_date, :deployment_date, :last_state_change, :energy_consumption

  attributes :placement
  attributes :activity_state, :interface_type

  def placement
    RGeo::GeoJSON.encode(object.placement).as_json
  end

  def activity_state
    object.activity_state.name
  end

  def interface_type
    object.interface_type.name
  end

end