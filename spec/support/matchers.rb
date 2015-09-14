RSpec::Matchers.define :neosentio_sensor_eq do |expected|
  match do |actual|
    actual['id'] == expected.id &&
    actual['battery_state'] == expected.battery_state &&
        actual['battery_capacity'] == expected.battery_capacity

  end
end

RSpec::Matchers.define :budokop_sensor_eq do |expected|
  match do |actual|
    actual['id'] == expected.id &&
        actual['battery_state'] == expected.battery_state &&
        actual['battery_capacity'] == expected.battery_capacity &&
        actual['manufacturer'] == expected.manufacturer &&
        actual['model'] == expected.model &&
        actual['serial_number'] == expected.serial_number &&
        actual['firmware_version'] == expected.firmware_version &&
        actual['manufacture_date'] == expected.manufacture_date &&
        actual['purchase_date'] == expected.purchase_date &&
        actual['warranty_date'] == expected.warranty_date &&
        actual['deployment_date'] == expected.deployment_date &&
        actual['last_state_change'] == expected.last_state_change &&
        actual['device_id'] == expected.device_id
  end
end

RSpec::Matchers.define :fiber_optic_node_eq do |expected|
  match do |actual|
    actual['id'] == expected.id &&
        actual['cable_distance_marker'] == expected.cable_distance_marker &&
        actual['levee_distance_marker'] == expected.levee_distance_marker &&
        actual['deployment_date'] == expected.deployment_date &&
        actual['last_state_change'] == expected.last_state_change &&
        actual['device_id'] == expected.device_id
  end
end

RSpec::Matchers.define :pump_eq do |expected|
  match do |actual|
    actual['id'] == expected.id
  end
end

RSpec::Matchers.define :parameter_eq do |expected|
  match do |actual|
    actual['id'] == expected.id &&
      actual['custom_id'] == expected.custom_id &&
      actual['measurement_type_name'] == expected.measurement_type.name.to_s &&
        actual['measurement_type_unit'] == expected.measurement_type.unit.to_s

  end
end

RSpec::Matchers.define :device_eq do |expected|
  match do |actual|
    actual['id'] == expected.id &&
      (expected.budokop_sensor.nil? || actual['budokop_sensor_id'] == expected.budokop_sensor.id) &&
        (expected.neosentio_sensor.nil? || actual['neosentio_sensor_id'] == expected.neosentio_sensor.id) &&
        (expected.pump.nil? || actual['pump_id'] == expected.pump_id) &&
        actual['custom_id'] == expected.custom_id &&
        actual['device_type'] == expected.device_type &&
        actual['profile_id'] == expected.profile_id

  end
end

RSpec::Matchers.define :device_aggregation_eq do |expected|
  match do |actual|
    actual['id'] == expected.id &&
        actual['parent_id'] == expected.parent_id &&
        (actual['device_ids'] - expected.device_ids).empty? &&
        (actual['children_ids'] - expected.children.ids).empty?
  end
end


RSpec::Matchers.define :section_eq do |expected|
  match do |actual|
    actual['id'] == expected.id &&
        actual['levee_id'] == expected.levee_id
  end
end

RSpec::Matchers.define :context_eq do |expected|
  match do |actual|
    actual['id'] == expected.id &&
        actual['name'] == expected.name &&
        actual['context_type'] == expected.context_type
  end
end

