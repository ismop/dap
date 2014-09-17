require 'csv'

class ScenarioUploader

  def self.from_dir(dir)
    Dir.foreach(dir) do |name|
      path = File.join(dir,name)
      self.from_file(path) unless File.directory?(path)
    end
  end

  def self.from_file(name)
    puts "Uploading #{File.absolute_path(name)}"
    payload = File.read(name)
    raise "Invalid scenario" unless payload.size>0
    Scenario.new do |s|
      s.file_name = File.basename(name)
      s.payload = payload
    end.save
  end

end
