require 'csv'

module Exporters
  class CSVExporter

    attr_accessor :file

    def measurements
      # implement this method
    end

    def serializer
      # implement this method
    end

    # may be used several times once exported
    def export(temp_path = nil)
      unless @file.nil?
        return @file
      end
      @file = Tempfile.create('export_', temp_path)
      CSV.open(@file.path, "w+") do |csv|
        measurements.each do |m|
          csv << serializer.serialize(m)
        end
      end
      @file
    end

    def cleanup
      @file.close
      File.delete(@file)
      @file = nil
    end

  end
end
