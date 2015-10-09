class NeosentioSensorSerializer < ActiveModel::Serializer
  attributes :id, :x_orientation, :y_orientation, :z_orientation, :battery_state, :battery_capacity, :manufacturer, :model, :serial_number, :firmware_version, :manufacture_date, :purchase_date, :warranty_date, :deployment_date, :last_state_change, :energy_consumption, :precision, :measurement_node_id, :device_id
  attributes :activity_state, :power_type, :interface_type

  def activity_state
    object.activity_state.nil? ? nil : object.activity_state.name
  end

  def power_type
    object.power_type.nil? ? nil : object.power_type.name
  end

  def interface_type
    object.interface_type.nil? ? nil : object.interface_type.name
  end

end
