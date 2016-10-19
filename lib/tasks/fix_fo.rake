namespace :data do
  desc "Updates fiber optic measurement node positions from geodesy data"
  task :fix_fo => :environment do
    l = Levee.find_or_create_by(name: 'Obwałowanie eksperymentalne - Czernichów')
    c = Context.find(1)
    mt = MeasurementType.find_by(name: 'Temperatura')

    da1 = DeviceAggregation.find_or_create_by(custom_id: 'Światłowód dolny - odczyty surowe', levee: l, device_aggregation_type: 'fiber')
    da2 = DeviceAggregation.find_or_create_by(custom_id: 'Światłowód górny - odczyty surowe', levee: l, device_aggregation_type: 'fiber')

    # Set all devices as invisible
    da1.devices.each do |d|
      d.visible = false; d.save;
    end

    da2.devices.each do |d|
      d.visible = false; d.save;
    end

    File.open('db/points.csv').each do |line|
      linedata = line.split(',')

      next if linedata.length != 4

      lon = linedata[0].strip
      lat = linedata[1].strip
      name = linedata[2].strip
      marker = linedata[3].strip.to_f

      name_id = name.split('-')[1]

      puts "Processing name_id: #{name_id}"

      name_id = ((name_id.to_i)+42).to_s

      if name_id.length == 1
        name_id = '00'+name_id
      elsif name_id.length == 2
        name_id = '0'+name_id
      end

      puts "Searching for ID #{name_id}"
      fo_node = Device.where("custom_id LIKE 'ASP.GESO_RAW.#{name_id}'").first
      puts "Found FO node: #{fo_node.inspect}"

      new_placement = "POINT(#{lon} #{lat} 211.0)"

      fo_node.placement = new_placement
      unless (name_id.to_i > 447) and (name_id.to_i < 528)
        fo_node.visible = true
      end

      fo_node.save
      fon = fo_node.fiber_optic_node

      fon.levee_distance_marker = marker
      fon.save
    end

    Device.where("custom_id LIKE 'ASP.GESO_RAW%'").all.each do |d|
      # Assign d to correct section
      Section.all.each do |s|
        if d.placement.within? s.shape.convex_hull
          puts "Device #{d.custom_id} belongs to section #{s.id.to_s}"
          d.section = s
          d.save
        end
      end
    end

    puts "All done."
  end
end