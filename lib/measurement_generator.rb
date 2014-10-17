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

  def self.from_dir(dir)
    paths = []
    Dir.foreach(dir) do |name|
      path = File.join(dir,name)
      paths << path unless File.directory?(path)
    end
    MeasurementGenerator.new(Feed.new(paths))
  end

  attr_accessor :feed

  def initialize(feed)
    @feed = feed
  end

  def generate(levee, context, months = 6)
    time = Time.now

    ActiveRecord::Base.transaction do
      levee.profiles.each do |profile|

        data_row = @feed.next_row
        raise "wrong number of parameters in scenario" if profile.sensors.count != data_row.length

        timelines = []
        param_index = 0
        profile.sensors.each do |sensor|
          timelines[param_index] = Timeline.new do |t|
            t.sensor = sensor
            t.context = context
          end
          timelines[param_index].save
          param_index += 1
        end

        (1..months*30*24*60/15).each do |i|
          param_index = 0
          profile.sensors.each do
            m = Measurement.new do |m|
              m.value = data_row[param_index].to_f
              m.timestamp = time + (i*15).minutes
              m.timeline = timelines[param_index]
            end
            m.save
            param_index += 1
          end
        end
      end
      true
    end
  end
end
