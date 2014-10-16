class MeasurementGenerator

  def self.from_data(data, scenario_name = "undefined")

    upload_time = Time.now

    ActiveRecord::Base.transaction do

      timeline_length = data.size
      timelines = data[0].size

      (0..timelines-1).each do |i|

        sensor_id = data[0][i]
        sensor = Sensor.find(sensor_id) rescue raise("No such sensor '#{sensor_id}'")

        timeline = Timeline.new do |t|
          t.sensor = sensor
          t.name = "fake measurement"
          t.measurement_type = "simulated"
        end
        timeline.save

        (1..timeline_length-1).each do |j|
          value = data[j][i]
          Measurement.new do |m|
            m.value = value
            m.timeline = timeline
            m.sensor = sensor
            m.timestamp = upload_time + (15 * (j-1)).minutes.to_i
          end.save
        end

      end
    end
  end

  def self.from_file(file_name)
    self.from_data(Load.file(file_name), File.basename(file_name))
  end

end

class Load

  def self.file(name)
    matrix = []
    i = 0
    CSV.foreach(name) do |row|
      matrix << row.map { |cell| (i>0 ? cell.to_f : cell) }
      i+=1
    end
    matrix
  end

end
