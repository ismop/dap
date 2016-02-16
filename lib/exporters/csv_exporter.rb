require 'csv'

module Exporters
  class CSVExporter

    attr_accessor :file

    cattr_accessor :temp_dir
    @@temp_dir ||=  Rails.application.config.csv_export_dir

    def measurements
      # implement this method
    end

    def serializer
      # implement this method
    end

    # may be used several times once exported
    def export(temp_dir = nil)
      unless @file.nil?
        return @file
      end
      @file = Tempfile.create('export_', (temp_dir || @@temp_dir))
      CSV.open(@file.path, "w+") do |csv|
        measurements.each do |m|
          csv << serializer.serialize(m)
        end
      end
      @file
    end

  end
end