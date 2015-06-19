require 'json'

# Sample .json input
#{
#    "0" :
#    {
#        "points" : [
#                [19.676720673092085, 49.98081091778548],
#                [19.676816878716938, 49.98078045862425],
#                [19.676873225014816, 49.98071523098691],
#                [19.676815860340383, 49.98079169372087],
#                [19.676778027592466, 49.98082696668519],
#                [19.67677935335192, 49.980762286623204],
#                [19.676804391106796, 49.980789375508216],
#                [19.67687165699161, 49.980689517109475],
#                [19.67680305537413, 49.98074587481998],
#                [19.676863212937082, 49.98076362831299]
#        ],
#        "polygon" : [
#                [19.676711668088107, 49.98081463734371],
#                [19.676881418896894, 49.98084983960727],
#                [19.676904358903105, 49.980676438192745],
#                [19.6768603319119, 49.98066936265629],
#                [19.676711668088107, 49.98081463734371]
#        ]
#    }
#}

class LeveeImporter

  def initialize(file_name)
    file = File.read(file_name)
    @json = JSON.parse(file)
  end

  def import(section_type = nil, levee_name = "Unnamed Levee #{Time.now}")
    ActiveRecord::Base.transaction do
      section_type ||= ProfileType.create
      measurement_type = MeasurementType.create(name: "Temperature", unit: "C")
      levee = Levee.create { |l| l.name = levee_name }
      levees = []
      @json.each_value do |section|
        polygon = section["polygon"].map do |point|
          RGeo::Cartesian.factory.point(point[0], point[1])
        end
        new_section = Profile.create do |section|
          section.shape = RGeo::Cartesian.factory.multi_point(polygon)
          section.levee = levee
          section.section_type = section_type
        end
        sensors =[]
        section["points"].each do |point|
          sensors << build_sensor(RGeo::Cartesian.factory.point(point[0], point[1]), new_section, measurement_type).tap {|s| s.save}
        end
        levees << [new_section, sensors]
      end
      levees
    end
  end

  private

  def build_sensor(placement, section, measurement_type)

    @date ||= Time.parse("2014-06-01 12:00:00")
    id = Random.rand(10000000).to_s

    Sensor.new do |sensor|
      sensor.custom_id = id
      sensor.placement = placement
      sensor.x_orientation = 90.0
      sensor.y_orientation = 0.0
      sensor.z_orientation = 180.0
      sensor.battery_state = 90
      sensor.battery_capacity = 100
      sensor.manufacturer = "Sample manufacturer"
      sensor.model = "Sample model"
      sensor.serial_number = id
      sensor.firmware_version = id
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
      sensor.measurement_type_id = measurement_type.id
      sensor.section_id = section.id
    end
  end

end


