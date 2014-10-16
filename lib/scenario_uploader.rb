require 'csv'

class ScenarioUploader

  def initialize(scenarios)
    @scenarios = scenarios
  end

  def self.from_dir(dir)
    scenarios = []
    Dir.foreach(dir) do |name|
      path = File.join(dir,name)
      scenarios << self.from_file(path) unless File.directory?(path)
    end
    ScenarioUploader.new(scenarios)
  end

  def self.from_file(name)
    payload = File.read(name)
    raise "Invalid scenario" unless payload.size>0
    Scenario.new do |s|
      s.file_name = File.basename(name)
      s.payload = payload
    end
  end

  def save
    Scenario.transaction do
      context = Context.new do |c|
        c.context_type = "tests"
        c.name = "Test context #{Time.now}"
      end
      context.save
      @scenarios.each do |s|
        s.context = context
        s.save
      end
    end if @scenarios
  end

end
