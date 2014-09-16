require 'csv'

class ScenarioUploader

  def self.from_file(name)
    payload = File.read(name)
    unless payload.size>0 raise "Invalid scenario"
    Scenario.new do |s|
      s.file_name = name
      s.payload = payload
    end.save
  end

end
