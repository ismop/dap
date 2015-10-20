require 'influxdb'

namespace :influxdb do
  desc "Populate InfluxDB database with sample data"
  task :populate_parameters => :environment do

    influxdb = InfluxDB::Client.new 'dap', host: "127.0.0.1"

    for i in 1..1000 do

      data = []
      for j in 1..1000 do

        data << {
          series: "UT#{i}_T",
          tags: { measurement: 'temperature' },
          values: { temperature: rand(20) },
          timestamp: (Time.now-j.minutes).to_i
        }

      end

      puts "Writing batch #{i} of 1000"
      influxdb.write_points(data)

    end

    puts "All done. Enjoy!"

  end

  task :populate_devices => :environment do

    influxdb = InfluxDB::Client.new 'dap', host: "127.0.0.1"

    for i in 1..1000 do

      data = []
      for j in 1..1000 do

        timestamp = (Time.now-j.minutes).to_i

        data << {
            series: "UT#{i}",
            tags: { measurement: 'temperature' },
            values: { temperature: rand(20) },
            timestamp: timestamp
        }

        data << {
            series: "UT#{i}",
            tags: { measurement: 'pore_pressure' },
            values: { pore_pressure: rand(1000) },
            timestamp: timestamp
        }

      end

      puts "Writing batch #{i} of 1000"
      influxdb.write_points(data)

    end

    puts "All done. Enjoy!"

  end

  task :populate_levee => :environment do

    influxdb = InfluxDB::Client.new 'dap', host: "127.0.0.1"

    for i in 1..1000 do

      data = []
      for j in 1..1000 do

        timestamp = (Time.now-j.minutes).to_i

        data << {
            series: "levee1",
            tags: { device: "UT#{i}", measurement: 'temperature' },
            values: { temperature: rand(20) },
            timestamp: timestamp
        }

        data << {
            series: "levee1",
            tags: { device: "UT#{i}", measurement: 'pore_pressure' },
            values: { pore_pressure: rand(1000) },
            timestamp: timestamp
        }

      end

      puts "Writing batch #{i} of 1000"
      influxdb.write_points(data)

    end

    puts "All done. Enjoy!"

  end

  task :populate_levee_big => :environment do

    influxdb = InfluxDB::Client.new 'dap', host: "127.0.0.1"

    for i in 1001..2000 do

      data = []
      for j in 1..10000 do

        timestamp = (Time.now-j.minutes).to_i

        data << {
            series: "levee1",
            tags: { device: "UT#{i}", measurement: 'temperature' },
            values: { temperature: rand(20) },
            timestamp: timestamp
        }

        data << {
            series: "levee1",
            tags: { device: "UT#{i}", measurement: 'pore_pressure' },
            values: { pore_pressure: rand(1000) },
            timestamp: timestamp
        }

      end

      puts "Writing batch #{i} of 1000"
      influxdb.write_points(data)

    end

    puts "All done. Enjoy!"

  end

  task :populate_levee_three => :environment do

    influxdb = InfluxDB::Client.new 'dap', host: "127.0.0.1"

    for i in 1..9 do

      data = []
      for j in 1..1000 do

        timestamp = (Time.now-j.minutes).to_i

        data << {
            series: "leveeA1",
            tags: { device: "UT#{i}", measurement: 'temperature' },
            values: { temperature: rand(20) },
            timestamp: timestamp
        }

        data << {
            series: "leveeA1",
            tags: { device: "UT#{i}", measurement: 'pore_pressure' },
            values: { pore_pressure: rand(1000) },
            timestamp: timestamp
        }

        data << {
            series: "leveeA2",
            tags: { device: "UT#{i*10}", measurement: 'temperature' },
            values: { temperature: rand(20) },
            timestamp: timestamp
        }

        data << {
            series: "leveeA2",
            tags: { device: "UT#{i*10}", measurement: 'pore_pressure' },
            values: { pore_pressure: rand(1000) },
            timestamp: timestamp
        }

        data << {
            series: "leveeA3",
            tags: { device: "UT#{i*100}", measurement: 'temperature' },
            values: { temperature: rand(20) },
            timestamp: timestamp
        }

        data << {
            series: "leveeA3",
            tags: { device: "UT#{i*100}", measurement: 'pore_pressure' },
            values: { pore_pressure: rand(1000) },
            timestamp: timestamp
        }
      end

      puts "Writing batch #{i} of 1000"
      influxdb.write_points(data)

    end

    puts "All done. Enjoy!"

    #SELECT FIRST(temperature) FROM /^levee/ WHERE time > '2015-10-12 18:22:00' GROUP BY device

  end

  #SELECT LAST(pore_pressure) FROM levee1 WHERE time > '2015-10-10 08:00:00' AND time < '2015-10-10 08:03:00' GROUP BY device, time(3m)
  #SELECT LAST(pore_pressure) FROM levee1 WHERE time > '2015-10-10 08:00:00' AND time < '2015-10-10 08:03:00' GROUP BY device

  task :copy_production_data => :environment do

    influxdb = InfluxDB::Client.new 'dap_test_2', host: "127.0.0.1"

    puts '====== INFLUXDB PRODUCTION DATA IMPORT ======'

    puts 'Dropping influxdb database...'
    influxdb.delete_database('dap_test_2')

    puts 'Recreating influxdb database...'
    influxdb.create_database('dap_test_2')

    STEP = 10000

    for batch in 1..10000 do

      puts "Dumping measurements #{(batch-1)*STEP} to #{(batch*STEP)-1}..."

      ms = Measurement.joins(timeline: {parameter: [:device, :measurement_type]}).where("measurements.id > #{(batch-1)*STEP} AND measurements.id < #{(batch*STEP)-1}").all

      data = []

      ms.each do |m|
        ts_label = "#{m.timeline.parameter.device.label}:#{m.timeline.parameter.measurement_type.label}"
        tag_timeline_id = "#{m.timeline.id}"
        tag_timeline_label = "#{m.timeline.label}"
        m_timestamp = m.timestamp.to_i

        item = {
            series: ts_label,
            tags:  { tid: tag_timeline_id, tl: tag_timeline_label },
            values: { m: m.value },
            timestamp: m_timestamp
        }

        data << item

      end

      #puts data.inspect

      puts "Pushing data object..."
      influxdb.write_points(data)
    end

    puts "All done. Enjoy!"

    #SELECT FIRST(temperature) FROM /^levee/ WHERE time > '2015-10-12 18:22:00' GROUP BY device

  end

  task :copy_production_data_3 => :environment do

    Rails.logger.silence do

      influxdb = InfluxDB::Client.new 'dap_test_3', host: "127.0.0.1"

      puts '====== INFLUXDB PRODUCTION DATA IMPORT ======'

      puts 'Dropping influxdb database...'
      influxdb.delete_database('dap_test_3')

      puts 'Recreating influxdb database...'
      influxdb.create_database('dap_test_3')

      STEP = 1000
      OFFSET = 0

      for batch in 1..100000 do

        puts "Dumping measurements #{(batch-1)*STEP} to #{(batch*STEP)-1}..."

        ms = Measurement.includes(timeline: [{parameter: [{device: [:device_aggregation, :profile, :levee]}, :measurement_type]}, :context]).where("measurements.id > #{OFFSET+((batch-1)*STEP)} AND measurements.id < #{OFFSET+((batch*STEP)-1)}")

        data = []

        ms.each do |m|

          dlabel = m.timeline.parameter.device.present? ? m.timeline.parameter.device.label : 'UNK'
          mtlabel = m.timeline.parameter.measurement_type.present? ? m.timeline.parameter.measurement_type.label : 'UNK'

          # Construct time series label for this measurement
          ts_label = "#{dlabel}:#{mtlabel}"

          # Construct device aggregation tag for this measurement
          if m.timeline.parameter.device.device_aggregation.present?
            tag_aggregation_label = m.timeline.parameter.device.device_aggregation.id.to_s
          else
            tag_aggregation_label = 'none'
          end

          # Construct profile tag for this measurement
          if m.timeline.parameter.device.profile.present?
            tag_profile_label = m.timeline.parameter.device.profile.id.to_s
          else
            tag_profile_label = ''
          end

          # Construct levee tag for this measurement
          if m.timeline.parameter.device.levee.present?
            tag_levee_label = m.timeline.parameter.device.levee.id.to_s
          else
            tag_levee_label = 'none'
          end

          # Construct timeline ID tag for this measurement
          tag_timeline_id = "#{m.timeline.id}"

          # Construct timeline label tag for this measurement
          tag_timeline_label = "#{m.timeline.label}"

          # Construct timestamp for this measurement
          m_timestamp = m.timestamp.to_i

          item = {
              series: ts_label,
              tags:  { tid: tag_timeline_id, tl: tag_timeline_label, da: tag_aggregation_label, p: tag_profile_label, l: tag_levee_label },
              values: { m: m.value },
              timestamp: m_timestamp
          }

          data << item

        end

        #puts data.inspect

        puts "Pushing data object..."
        influxdb.write_points(data)
      end

      puts "All done. Enjoy!"


      #SELECT FIRST(temperature) FROM /^levee/ WHERE time > '2015-10-12 18:22:00' GROUP BY device
    end

  end

  task :run_test_queries => :environment do

    influxdb = InfluxDB::Client.new 'dap_test_3', host: "127.0.0.1"

    puts '====== INFLUXDB PERFORMANCE TEST ======'

    # 1. ostatni odczyt rzeczywisty dla zdefniowanego czasu dla wszystkich devicow nalezacych do danego device aggregation (przyklad z fibre view)

    puts 'Latest real reading in defined time window (assuming until October 2015) for all devices belonging to specified DA...'

    da1 = DeviceAggregation.find(1)
    da2 = DeviceAggregation.find(53)
    start_t = '2015-10-01 00:00:00'
    end_t = '2015-10-05 23:59:59'
    puts "Using device aggregations #{da1.custom_id} and #{da2.custom_id} with IDs #{da1.id.to_s} and #{da2.id.to_s}..."

    query = "SELECT LAST(m) FROM /.*/ WHERE time > '#{start_t}' AND time < '#{end_t}' AND (da = '#{da1.id.to_s}' OR da = '#{da2.id.to_s}')"
    puts "Executing query: #{query}..."

    run_query(influxdb, query)
    puts "-------------------------------------------"
    #2. wartosci measurements dla zadanego zakresu czasowego (wszystkie)
    puts 'All measurements from a specified interval (using 29 August 2015)...'

    start_t = '2015-08-29 00:00:00'
    end_t = '2015-08-29 23:59:59'

    query = "SELECT * FROM /.*/ WHERE time > '#{start_t}' AND time < '#{end_t}'"
    puts "Executing query: #{query}..."

    run_query(influxdb, query)
    puts "-------------------------------------------"
    #3. tak samo jak wyzej ale ze zdefiniowanym limitem (np. 1000 odczytow z ostatniego miesiaca)
    puts 'Last 1000 measurements per timeline from a specified interval (using 27-28 August 2015)...'

    start_t = '2015-08-27 00:00:00'
    end_t = '2015-08-27 23:59:59'
    qty = 1000

    start_t_parsed = DateTime.parse(start_t)
    end_t_parsed = DateTime.parse(end_t)
    elapsed_seconds = ((end_t_parsed - start_t_parsed) * 24 * 60 * 60).to_i
    grouping_interval = (elapsed_seconds/qty).floor

    puts "Specified interval spans #{elapsed_seconds.inspect} seconds; using group window of #{grouping_interval} seconds..."


    #query = "SELECT * FROM /.*/ WHERE time > '#{start_t}' AND time < '#{end_t}' LIMIT #{cutoff}"
    query = "SELECT MEDIAN(m) FROM /.*/ WHERE time > '#{start_t}' AND time < '#{end_t}' GROUP BY time(#{grouping_interval}s)"
    puts "Executing query: #{query}..."

    run_query(influxdb, query)
    puts "-------------------------------------------"
    #4. Ostatnie odczyty danego typu (np. temperatury) dla zdefiniowanej daty dla sensorow nalezacych do danego przekroju (przyklad z widoku poprzecznego)
    puts "Latest measurements for devices of a specified type, for a specified date and belonging to a specific profile"

    p = Profile.find(5)
    puts "Using profile #{p.id} which contains #{p.devices.length} devices."
    puts "Assuming interval of 10-15 October 2015 and looking for temperature measurements."

    start_t = '2015-10-10 00:00:00'
    end_t = '2015-10-15 23:59:59'

    query = "SELECT LAST(m) FROM /.*:T/ WHERE time < '#{end_t}' AND p = '#{p.id}'"
    puts "Executing query: #{query}..."

    run_query(influxdb, query)
    puts "-------------------------------------------"
    #5. Ostatnie odczyty danego typu (np. temperatury) dla zdefiniowanego levee (widok przekroju walu z gory)
    puts "Latest measurements for sensors of a specified type, for a specified date and belonging to a specific levee"

    l = Levee.first
    puts "Using levee #{l.name} which contains #{l.devices.length} devices."
    puts "Assuming measurement type == temperature and cutoff date == 31 August 2015."

    end_t = '2015-08-31 23:59:59'

    query = "SELECT LAST(m) FROM /.*:T/ WHERE time < '#{end_t}' AND l = '#{l.id}'"
    puts "Executing query: #{query}..."

    run_query(influxdb, query)
    puts "-------------------------------------------"
    #6. Ostatni odczyt ze zdefiniowanych sensorow (stacja pogodowa)
    puts "Latest measurement for a specific device (weather station/temperature)"

    query = "SELECT LAST(m) FROM /.*WEATHER:T/"
    puts "Executing query: #{query}..."

    run_query(influxdb, query)

    puts "This is Cave Johnson. We're done here."
  end

  def run_query(connector, query)
    t1 = Time.now
    result = connector.query(query)
    t2 = Time.now

    if result.present?
      total_m = 0
      result.each do |m|
        total_m+=m['values'].length
      end

      puts "#{result.length} timelines with #{total_m.to_s} measurements received in #{t2-t1} seconds. Showing first result..."
      puts "#{result.first['values'].first.inspect}"
    end
  end

end