namespace :data do
  desc "Imports fiber optic measurement node positions from geodesy data"
  task :import_fo => :environment do
    l = Levee.find_or_create_by(name: 'Obwałowanie eksperymentalne - Czernichów')
    c = Context.find(1)

    da1 = DeviceAggregation.find_or_create_by(custom_id: 'Światłowód górny - odczyty surowe', levee: l)

    devices_created = []

    File.open('db/fo_input.csv').each do |line|
      linedata = line.split(',')

      lon = linedata[0].strip
      lat = linedata[1].strip
      met = linedata[2].strip

      # Try to find a representation of this parameter
      metstr = met
      until metstr.length >= 3 do
        metstr = '0'+metstr
      end

      par_id = "ASP.GESO_RAW."+metstr
      par = Parameter.find_by(custom_id: par_id)

      if par.present?
        # Create a device for this parameter
        if par.device.device_type == 'parameter_discovery'
          puts "Parameter #{par_id} does not yet have a Device object registered. Creating..."
          d = Device.find_or_create_by(
            custom_id: par_id,
            placement: "POINT(#{lon} #{lat} 211.0)",
            device_type: 'fiber_optic_node',
            device_aggregation: da1,
            levee: l,
            label: par_id
          )
          d.save
          d.reload
          # Assign d to correct section
          Section.all.each do |s|
            if d.placement.within? s.shape.convex_hull
              puts "Device #{d.custom_id} belongs to section #{s.id.to_s}"
              d.section = s
            end
          end
          if d.section.nil?
            puts "Warning: device #{d.custom_id} does not belong to any existing section!"
          end
          d.save
          d.reload
          devices_created << d
          fon = FiberOpticNode.new(
            cable_distance_marker: met.to_f,
            levee_distance_marker: met.to_f,
            device: d
          )
          fon.save
          fon.reload
          par.device = d
          par.save
        else
          puts "Parameter #{par_id} already belongs to a Device object of type fiber_optic_node. Skipping..."
        end
      else
        puts "Parameter #{par_id} not found in DB. Skipping."
      end
    end
    puts "All done."
  end
end