require 'json'

class Importer

  def initialize(file_name)
    file = File.read(file_name)
    @json = JSON.parse(file)
  end

  def levee
    levees = []
    @json.each_value do |levee|
      polygon = levee["polygon"].map do |point|
        RGeo::Cartesian.factory.point(point[0], point[1])
      end
      points =[]
      levee["points"].each do |point|
        points << RGeo::Cartesian.factory.point(point[0], point[1])
      end
      shape = RGeo::Cartesian.factory.multi_point(polygon)
      levees << [shape, points]
    end
    levees
  end


  def build_sensor(sensor, placement, profile)

    @date ||= Time.parse("2014-06-01 12:00:00")
    id = Random.rand(10000000).to_s

    sensor.custom_id = id
    sensor.placement = placement
    sensor.x_orientation = 90.0
    sensor.y_orientation = 0.0
    sensor.z_orientation = 180.0
    sensor.battery_state = 90
    sensor.battery_capacity = 100
    sensor.manufacturer = "Sample manufacturer"
    sensor.model = "Sample model"
    sensor.serial_number = "12345678"
    sensor.firmware_version = "12345678"
    sensor.manufacture_date = @date - 1.year
    sensor.purchase_date = @date
    sensor.warranty_date = @date + 3.years
    sensor.deployment_date = @date
    sensor.last_state_change = @date
    sensor.energy_consumption = 2
    sensor.precision = 0.1
    sensor.measurement_node_id = 1
    sensor.activity_state_id = 1
    sensor.power_type_id = 2
    sensor.interface_type_id = 3
    sensor.measurement_type_id = 1
    sensor.profile_id = profile.id

  end

end 
