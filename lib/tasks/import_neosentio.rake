namespace :data do
  desc "Imports fiber optic measurement node positions from geodesy data"
  task :import_neosentio => :environment do
    l = Levee.find_or_create_by(name: 'Obwałowanie eksperymentalne - Czernichów')
    c = Context.find(1)
    mt = MeasurementType.find_by(name: 'Temperatura')

    devices_created = []
    device_aggregations_created = []

    File.open('db/neosentio1.csv').each do |line|
      linedata = line.split(',')

      section = linedata[0].strip
      side = linedata[1].strip
      uid = "neosentio.#{linedata[4][1].to_i.to_s}_#{linedata[4][2..3].to_i.to_s}_#{linedata[4][4..5].to_i.to_s}_4"
      realid = linedata[6].strip
      placement = "POINT(#{linedata[8].strip} #{linedata[7].strip} #{linedata[9].strip})"
      borehole_placement = "POINT(#{linedata[8].strip} #{linedata[7].strip})"

      # attempt to find parameter
      p = Parameter.find_by(custom_id: uid)

      if p.blank?
        puts "Caution: parameter not found in parameter_discovery: #{uid}. A new parameter will be created."
      else
        puts "Parameter #{p.id} found in parameter_discovery. Reassigning to new device object."
      end

      # Create DA if it does not exist
      da = DeviceAggregation.find_or_create_by(shape: borehole_placement) do |agg|
        puts "Caution: a new aggregation had to be created for #{borehole_placement}"
        agg.custom_id = "Neosentio borehole at #{linedata[8].strip},#{linedata[7].strip}"
        agg.save
        device_aggregations_created << agg
      end

      # Create device for these parameters
      d = Device.find_or_create_by(
        custom_id: uid,
        placement: placement,
        device_type: 'neosentio-sensor',
        device_aggregation: da,
        levee: l,
        label: realid,
        vendor: 'Neosentio'
      ) do |dev|
        puts "Caution: a new device had to be created for #{placement}"
        devices_created << dev
      end

      # Make sure d has an assigned NeosentioSensor
      if d.neosentio_sensor.blank?
        ns = NeosentioSensor.new(battery_state: 100, battery_capacity: 100)
        ns.save
        d.neosentio_sensor = ns
        d.save
      end

      if !d.valid?
        puts "Device #{uid} not created due to the following errors: #{d.errors.inspect}"
      end

      # Reassign parameter to this device
      if p.blank?
        puts "Caution: device #{placement} has no matching parameter - we will create one."
          par = Parameter.new(custom_id: uid, measurement_type: mt, device: d, parameter_name: 'Pomiar temperatury', monitored: true)
          par.save
          tl = Timeline.new(context: c, parameter: par, label: 'Temperatura')
          tl.save
      else
        p.device = d
        # Adjust this parameter's measurement_type
        p.measurement_type = mt
        p.parameter_name = 'Pomiar temperatury'
        p.monitored = true
        p.save
      end
    end

    # Assign devices to correct sections
    devices_created.each do |d|
      Section.all.each do |s|
        if d.placement.within? s.shape.convex_hull
          puts "Device #{d.custom_id} belongs to section #{s.id.to_s}"
          d.section = s
          d.save
        end
      end
      if d.section.nil?
        puts "Warning: device #{d.custom_id} does not belong to any existing section!"
      end
    end

    # Assign device aggregations to correct sections
    device_aggregations_created.each do |d|
      Section.all.each do |s|
        if d.shape.within? s.shape.convex_hull
          puts "Device aggregation #{d.custom_id} belongs to section #{s.id.to_s}"
          d.section = s
          d.save
        end
      end
      if d.section.nil?
        puts "Warning: device aggregation #{d.custom_id} does not belong to any existing section!"
      end
    end

    puts "All done."
  end
end