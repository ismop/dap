namespace :data do
  desc "Imports fiber optic measurement node positions from geodesy data"
  task :import_fo => :environment do
    l = Levee.find_or_create_by(name: 'Obwałowanie eksperymentalne - Czernichów')
    c = Context.find(1)
    mt = MeasurementType.find_by(name: 'Temperatura')

    DA1_CUTOFF = 513

    da1 = DeviceAggregation.find_or_create_by(custom_id: 'Światłowód dolny - odczyty surowe', levee: l, device_aggregation_type: 'fiber')
    da2 = DeviceAggregation.find_or_create_by(custom_id: 'Światłowód górny - odczyty surowe', levee: l, device_aggregation_type: 'fiber')

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
            levee: l,
            label: par_id
          )
          if met.to_i <= DA1_CUTOFF
            d.device_aggregation = da1
          else
            d.device_aggregation = da2
          end
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
          fon = FiberOpticNode.find_or_create_by(
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

          # Adjust the MeasurementType of par...
          if par.measurement_type != mt
            par.measurement_type = mt
            par.save
          end
        end
      else
        puts "Parameter #{par_id} not found in DB. Skipping."
      end
    end

    # Recompute DA shape
    shape = 'LINESTRING ('
    origin = ''
    da1.devices.each do |d|
      component = "#{d.placement.x} #{d.placement.y}, "
      if origin == ''
        origin = component
      end
      shape += component
    end
    shape += origin
    shape = shape.chomp(', ')
    shape += ')'
    da1.shape = shape
    da1.save

    shape = 'LINESTRING ('
    origin = ''
    da2.devices.each do |d|
      component = "#{d.placement.x} #{d.placement.y}, "
      if origin == ''
        origin = component
      end
      shape += component
    end
    shape += origin
    shape = shape.chomp(', ')
    shape += ')'
    da2.shape = shape
    da2.save

    puts "All done."
  end
end