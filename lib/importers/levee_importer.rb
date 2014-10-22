require 'json'

class LeveeImporter

  def initialize(file_name)
    file = File.read(file_name)
    @json = JSON.parse(file)
  end

  def import(profile_type = nil, levee_name = "Unnamed Levee #{Time.now}")
    ActiveRecord::Base.transaction do
      profile_type ||= ProfileType.create
      levee = Levee.create { |l| l.name = levee_name }
      levees = []
      @json.each_value do |profile|
        polygon = profile["polygon"].map do |point|
          RGeo::Cartesian.factory.point(point[0], point[1])
        end
        prof = Profile.create do |profile|
          profile.shape = RGeo::Cartesian.factory.multi_point(polygon)
          profile.levee = levee
          profile.profile_type = profile_type
        end
        sensors =[]
        profile["points"].each do |point|
          sensors << build_sensor(RGeo::Cartesian.factory.point(point[0], point[1]), prof).tap {|s| s.save}
        end
        levees << [prof, sensors]
      end
      levees
    end
  end

  private

  def build_sensor(placement, profile)

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
      sensor.measurement_type_id = 1
      sensor.profile_id = profile.id
    end
  end

end 
