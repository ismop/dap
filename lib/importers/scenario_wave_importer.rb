require 'csv'

module Importers
  class ScenarioWaveImporter
    def initialize(context, experiment, water_wave_parameter, csv_path)
      @context = context
      @experiment = experiment
      @water_wave_parameter = water_wave_parameter
      @csv_path = csv_path
    end

    def import
      @measurements = [new_measurement(0, 0)]

      puts 'Loading water wave...'
      ActiveRecord::Base.transaction do
        CSV.foreach(@csv_path, col_sep: ';') do |row|
          @measurements << new_measurement(row[0].to_i, row[1])
        end
        puts 'Importing water wave...'
        Measurement.import(@measurements)
        puts 'Updating experiment start date...'
        update_start_date(@measurements.last.m_timestamp.to_i)
      end
    end

    private

    def update_start_date(experiment_length)
      start_date = @experiment.end_date - experiment_length.seconds
      @experiment.update_attribute(:start_date, start_date)
    end

    def new_measurement(timestamp, value)
      Measurement.new(timeline: timeline,
                      m_timestamp: Time.at(timestamp),
                      value: value)
    end

    def timeline
      @timeline ||= Timeline.find_or_create_by(parameter: @water_wave_parameter,
                                               experiment: @experiment,
                                               context: @context)
    end
  end
end
