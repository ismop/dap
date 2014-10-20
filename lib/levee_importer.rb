require 'json'

class LeveeImporter

  class ModelAdapter

    def build_levee(levee_name)
      Levee.new do |levee|
        levee.name = levee_name
      end.tap { |l| l.save }
    end

    def build_profile(shape, levee, profile_type)
      Profile.new do |profile|
        profile.shape = shape
        profile.levee = levee
        profile.profile_type = profile_type
      end.tap { |p| p.save }
    end

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
      end.tap { |s| s.save }
    end

  end

  def initialize(file_name, model_adapter = ModelAdapter.new)
    file = File.read(file_name)
    @json = JSON.parse(file)
    @model_adapter = model_adapter
  end

  def import(profile_type, levee_name = "Unnamed Levee #{Time.now}")
    ActiveRecord::Base.transaction do
      levee = @model_adapter.build_levee(levee_name)
      levees = []
      @json.each_value do |profile|
        polygon = profile["polygon"].map do |point|
          RGeo::Cartesian.factory.point(point[0], point[1])
        end
        new_profile = @model_adapter.build_profile(RGeo::Cartesian.factory.multi_point(polygon), levee, profile_type)
        sensors =[]
        profile["points"].each do |point|
          sensors << @model_adapter.build_sensor(RGeo::Cartesian.factory.point(point[0], point[1]), new_profile)
        end
        levees << [new_profile, sensors]
      end
      levees
    end
  end


end 
