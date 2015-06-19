class BudokopSensorSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :battery_state, :battery_capacity, :manufacturer, :model, :serial_number, :firmware_version, :manufacture_date, :purchase_date, :warranty_date, :deployment_date, :last_state_change, :device_id
end
