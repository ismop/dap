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

    for i in 1..1000 do

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

  #SELECT LAST(pore_pressure) FROM levee1 WHERE time > '2015-10-10 08:00:00' AND time < '2015-10-10 08:03:00' GROUP BY device, time(3m)
  #SELECT LAST(pore_pressure) FROM levee1 WHERE time > '2015-10-10 08:00:00' AND time < '2015-10-10 08:03:00' GROUP BY device

end
