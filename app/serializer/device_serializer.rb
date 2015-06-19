class DeviceSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :custom_id, :placement, :device_type, :profile_id, :device_aggregation_id
  attributes :neosentio_sensor_id, :budokop_sensor_id, :pump_id
  attributes :parameter_ids

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

  def parameter_ids
    if object.parameters.blank?
      []
    else
      object.parameters.collect{|p| p.id}
    end
  end

end
