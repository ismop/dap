require 'csv'

class MeasurementGenerator

  class Feed

    def initialize(paths)
      @paths = paths
      @path_index = 0
      @data_index = 1
      @current_data = CSV.read(next_path)
    end

    def next_row
      @data_index +=1
      if @data_index == @current_data.length
        @current_data = CSV.read(next_path)
        @data_index = 1
      end
      @current_data[@data_index]
    end

    def next_path
      current_path = @paths[@path_index]
      @path_index +=1
      @path_index = 0 if @path_index == @paths.length
      current_path
    end

  end

  def initialize(dir)
    paths = []
    Dir.foreach(dir) do |name|
      path = File.join(dir,name)
      paths << path unless File.directory?(path)
    end
    @feed = Feed.new(paths)
  end

  # Used in order to generate measurements for all sensors of the given Levee
  # based on scenarios loaded from files.Please note that number of columns
  # in scenario file has to be equal to number of sensors per profile.
  def generate(levee, context = nil, months = 1)
    start_time = Time.now - 2.weeks

    ActiveRecord::Base.transaction do
      context ||= Context.create { |c| c.name = "Generated data #{Time.now}" }

      levee.profiles.each do |profile|

        data_row = @feed.next_row
        raise "wrong number of parameters in scenario" if profile.sensors.count != data_row.length

        timelines = []
        param_index = 0
        profile.sensors.each do |sensor|
          timelines[param_index] = Timeline.create do |t|
            t.sensor = sensor
            t.context = context
          end
          param_index += 1
        end

        measurements = []
        (1..months*30*24*60/15).each do |i|
          param_index = 0
          profile.sensors.each do
            measurements << Measurement.new do |m|
              m.value = data_row[param_index].to_f
              m.timestamp = start_time + (i*15).minutes
              m.timeline = timelines[param_index]
            end
            param_index += 1
          end
        end
        Measurement.import measurements

      end
      true
    end
  end
end
