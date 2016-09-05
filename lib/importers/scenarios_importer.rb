require 'csv'

module Importers
  class ScenariosImporter
    TIME_0 = Time.at(0)

    def initialize(levee, context, csv_path)
      @levee = levee
      @context = context
      @csv_path = csv_path

      @valid_devices = Set.new
      @invalid_devices = Set.new
      @cache = {}
      @measurements = []
    end

    def import
      ActiveRecord::Base.transaction do
        CSV.foreach(csv_path, col_sep: ';') do |row|
          if $. == 1
            discover_columns(row)
            puts 'Loading scenarios data...'
          else
            next unless valid_device?(custom_id(row))
            @measurements.push(*create_new_measurements(row))
          end
        end
        Measurement.import(@measurements)
      end

      puts "Scenarios for following devices were imported #{@valid_devices.to_a}"
      puts "Scenarios for following devices were not imported " +
           "#{@invalid_devices.to_a}"
    end

    private

    attr_reader :levee, :context, :csv_path, :columns

    def discover_columns(row)
      puts 'Discovering column meanings...'
      missing_columns = ['ppres', 'temp', 'scen', 'simul', 'sensor_type',
                         'sensor_symbol', 'time_stamp', 'ystr'].to_set
      @columns = {}
      row.each_with_index do |item, index|
        columns[item] = index
        missing_columns.delete(item)
      end

      unless missing_columns.empty?
        fail "Following columns are missing in CSV file: #{missing_columns}"
      end
    end

    def custom_id(row)
      row[columns['sensor_symbol']]
    end

    def valid_device?(device_custom_id)
      if @valid_devices.include?(device_custom_id)
        true
      elsif @invalid_devices.include?(device_custom_id) ||
             !supported?(device_custom_id) ||
             !Device.exists?(custom_id: device_custom_id)
        @invalid_devices << device_custom_id
        false
      else
        @valid_devices << device_custom_id
        true
      end
    end

    def supported?(device_custom_id)
      device_custom_id.start_with?("UT") || device_custom_id.start_with?("SV")
    end

    def create_new_measurements(row)
      custom_id = custom_id(row)
      scenario = scenario(row)

      case custom_id
      when /UT\d+/
        new_ut_measurements(scenario, custom_id, row)
      when /SV\d+/
        new_sv_measurements(scenario, custom_id, row)
      end
    end

    def new_ut_measurements(scenario, custom_id, row)
      temperature = temperature_timeline(custom_id, scenario)
      pore_preasure = pore_preasure_timeline(custom_id, scenario)

      [new_measurement(temperature, row, 'temp'),
       new_measurement(pore_preasure, row, 'ppres')]
    end

    def new_sv_measurements(scenario, custom_id, row)
      temperature = temperature_timeline(custom_id, scenario)
      stress = stress_timeline(custom_id, scenario)

      [new_measurement(temperature, row, 'temp'),
       new_measurement(stress, row, 'ystr')]
    end

    def new_measurement(timeline, row, value_column_name)
      timestamp = Time.at(TIME_0.to_f + row[columns['time_stamp']].to_i)
      value = row[columns[value_column_name]]

      Measurement.new(timeline: timeline,
                      m_timestamp: timestamp,
                      value: value)
    end

    def temperature_timeline(custom_id, scenario)
      timeline(custom_id, scenario, temperature_measurement_type)
    end

    def pore_preasure_timeline(custom_id, scenario)
      timeline(custom_id, scenario, pore_preasure_measurement_type)
    end

    def stress_timeline(custom_id, scenario)
      timeline(custom_id, scenario, stress_measurement_type)
    end

    def timeline(custom_id, scenario, type)
      cache_fetch("timeline/#{custom_id}-#{scenario.id}-#{type.id}") do
        find_timeline(custom_id, scenario, type) ||
        create_timeline(custom_id, scenario, type)
      end
    end

    def find_timeline(custom_id, scenario, type)
      Timeline.joins(parameter: :device).
        find_by(parameters: { measurement_type_id: type.id },
                devices: { custom_id: custom_id },
                scenario: scenario,
                context: context)
    end

    def create_timeline(device_id, scenario, type)
      parameter = Parameter.joins(:device).
                  find_by!(measurement_type: type,
                           devices: {custom_id: device_id})

      Timeline.create!(parameter: parameter,
                       scenario: scenario, context: context)
    end

    def temperature_measurement_type
      @templerature_measurement_type ||= MeasurementType.
                                         find_by(name: 'Temperatura')
    end

    def pore_preasure_measurement_type
      @pore_preasure_measurement_type ||= MeasurementType.
                                          find_by(name: 'Ciśnienie porowe')
    end

    def stress_measurement_type
      @stress_measurement_type ||= MeasurementType.
                                   find_by(name: 'Naprężenie')
    end

    def scenario(row)
      scenario_name = row[columns['simul']]
      experiment = experiment(row)
      cache_fetch("scenario/#{scenario_name}-#{experiment.id}") do
        Scenario.joins(:experiments).
          find_by(experiments: { id: experiment.id }, name: scenario_name) ||
        Scenario.create!(experiments: [experiment], name: scenario_name)
      end
    end

    def experiment(row)
      experiment_num = row[columns['scen']]
      name = "Eksperyment #{experiment_num}"
      Experiment.find_by(name: name) || create_experiment(name)
    end

    def create_experiment(name)
      puts "Creating experiment with following name: #{name}"
      end_date = Time.now
      Experiment.create!(levee: levee, name: name,
                         end_date: end_date, start_date: end_date - 1.week)
    end

    def cache_fetch(key)
      unless @cache[key]
        @cache[key] = yield
      end

      @cache[key]
    end
  end
end
