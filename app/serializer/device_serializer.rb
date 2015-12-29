class DeviceSerializer < ActiveModel::Serializer
  attributes :id, :custom_id, :label, :placement, :device_type, :device_aggregation_id
  attributes :profile_id, :section_id, :levee_id
  attributes :neosentio_sensor_id, :budokop_sensor_id, :pump_id, :weather_station_id
  attributes :parameter_ids
  attributes :nonfunctioning_parameter_ids
  attributes :metadata

  def placement
    RGeo::GeoJSON.encode(object.placement).as_json
  end

  def neosentio_sensor_id
    if object.neosentio_sensor.blank?
      nil
    else
      object.neosentio_sensor.id
    end
  end

  def budokop_sensor_id
    if object.budokop_sensor.blank?
      nil
    else
      object.budokop_sensor.id
    end
  end

  def pump_id
    if object.pump.blank?
      nil
    else
      object.pump.id
    end
  end

  def weather_station_id
    if object.weather_station.blank?
      nil
    else
      object.weather_station.id
    end
  end

  def parameter_ids
    if object.parameters.blank?
      []
    else
      object.parameters.collect{|p| p.id}
    end
  end

  def nonfunctioning_parameter_ids
    if object.parameters.blank?
      []
    else
      object.parameters.monitorable.down.collect{|p| p.id}
    end
  end

  def metadata
    metadata = {}
    case object.device_type
      when 'neosentio-sensor'
        md = object.neosentio_sensor
        metadata['x_orientation'] = md.x_orientation
        metadata['y_orientation'] = md.y_orientation
        metadata['z_orientation'] = md.z_orientation

        metadata['battery_state'] = md.battery_state
        metadata['battery_capacity'] = md.battery_capacity

        metadata['manufacturer'] = md.manufacturer
        metadata['model'] = md.model
        metadata['serial_number'] = md.serial_number
        metadata['firmware_version'] = md.firmware_version

        metadata['manufacture_date'] = md.manufacture_date
        metadata['purchase_date'] = md.purchase_date
        metadata['warranty_date'] = md.warranty_date
        metadata['deployment_date'] = md.deployment_date

        metadata['last_state_change'] = md.last_state_change

        metadata['energy_consumption'] = md.energy_consumption
        metadata['precision'] = md.precision

        metadata['measurement_node_id'] = md.measurement_node_id

      when 'budokop-sensor'
        md = object.budokop_sensor

        metadata['battery_state'] = md.battery_state
        metadata['battery_capacity'] = md.battery_capacity

        metadata['manufacturer'] = md.manufacturer
        metadata['model'] = md.model
        metadata['serial_number'] = md.serial_number
        metadata['firmware_version'] = md.firmware_version

        metadata['manufacture_date'] = md.manufacture_date
        metadata['purchase_date'] = md.purchase_date
        metadata['warranty_date'] = md.warranty_date
        metadata['deployment_date'] = md.deployment_date

        metadata['last_state_change'] = md.last_state_change

      when 'pump'
        md = object.pump

        metadata['manufacturer'] = md.manufacturer
        metadata['model'] = md.model

        metadata['manufacture_date'] = md.manufacture_date
        metadata['purchase_date'] = md.purchase_date
        metadata['deployment_date'] = md.deployment_date

        metadata['last_state_change'] = md.last_state_change

      when 'parameter_discovery'

      when 'weather_station'

      when 'fiber_optic_node'
        md = object.fiber_optic_node

        metadata['cable_distance_marker'] = md.cable_distance_marker
        metadata['levee_distance_marker'] = md.levee_distance_marker

        metadata['deployment_date'] = md.deployment_date

        metadata['last_state_change'] = md.last_state_change
    end

    metadata
  end
end
