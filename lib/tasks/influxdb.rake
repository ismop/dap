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
        ts_label = "#{m.timeline.parameter.device.id}:#{m.timeline.parameter.device.custom_id}:#{m.timeline.parameter.measurement_type.name}"
        tag_timeline_id = "#{m.timeline.id}"
        tag_timeline_label = "#{m.timeline.label}"
        m_timestamp = m.timestamp.to_i

        data << {
            series: ts_label,
            tags:  { timeline_id: tag_timeline_id, timeline_label: tag_timeline_label },
            values: { measurement: m.value },
            timestamp: m_timestamp
        }

      end

      puts "Pushing data object..."
      influxdb.write_points(data)
    end



    # for i in 1..9 do
    #
    #   data = []
    #   for j in 1..1000 do
    #
    #     timestamp = (Time.now-j.minutes).to_i
    #
    #     data << {
    #         series: "leveeA1",
    #         tags: { device: "UT#{i}", measurement: 'temperature' },
    #         values: { temperature: rand(20) },
    #         timestamp: timestamp
    #     }
    #
    #     data << {
    #         series: "leveeA1",
    #         tags: { device: "UT#{i}", measurement: 'pore_pressure' },
    #         values: { pore_pressure: rand(1000) },
    #         timestamp: timestamp
    #     }
    #
    #     data << {
    #         series: "leveeA2",
    #         tags: { device: "UT#{i*10}", measurement: 'temperature' },
    #         values: { temperature: rand(20) },
    #         timestamp: timestamp
    #     }
    #
    #     data << {
    #         series: "leveeA2",
    #         tags: { device: "UT#{i*10}", measurement: 'pore_pressure' },
    #         values: { pore_pressure: rand(1000) },
    #         timestamp: timestamp
    #     }
    #
    #     data << {
    #         series: "leveeA3",
    #         tags: { device: "UT#{i*100}", measurement: 'temperature' },
    #         values: { temperature: rand(20) },
    #         timestamp: timestamp
    #     }
    #
    #     data << {
    #         series: "leveeA3",
    #         tags: { device: "UT#{i*100}", measurement: 'pore_pressure' },
    #         values: { pore_pressure: rand(1000) },
    #         timestamp: timestamp
    #     }
    #   end
    #
    #   puts "Writing batch #{i} of 1000"
    #   influxdb.write_points(data)
    #
    # end

    puts "All done. Enjoy!"

    #SELECT FIRST(temperature) FROM /^levee/ WHERE time > '2015-10-12 18:22:00' GROUP BY device



  end

end