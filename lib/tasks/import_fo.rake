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
          # puts "Parameter #{par_id} already belongs to a Device object of type fiber_optic_node. Skipping..."

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
    puts "Recomputing DeviceAggregation shapes..."
    shape = 'LINESTRING ('
    origin = ''
    da1.devices.order(:custom_id).each do |d|
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
    da2.devices.order(:custom_id).each do |d|
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

    # Exclude devices not bound to any sections...
    puts "Excluding devices not bound to any sections..."

    da1_out = DeviceAggregation.find_or_create_by(custom_id: 'Światłowód dolny - czujniki poza obwałowaniem', levee: l, device_aggregation_type: 'fiber_external')
    da2_out = DeviceAggregation.find_or_create_by(custom_id: 'Światłowód górny- czujniki poza obwałowaniem', levee: l, device_aggregation_type: 'fiber_external')

    da1.devices.each do |d|
      if d.section.blank?
        puts "Device with id #{d.custom_id} does not belong to any section. Reassigning."
        d.device_aggregation = da1_out
        d.save
      end
    end

    da2.devices.each do |d|
      if d.section.blank?
        puts "Device with id #{d.custom_id} does not belong to any section. Reassigning."
        d.device_aggregation = da2_out
        d.save
      end
    end

    # Recompute da1 levee distance markers
    da1.reload
    da2.reload
    puts "Recomputing upper FO levee distance markers..."
    Section.all.each do |section|
      puts "Processing section #{section.id}"

      lower_sensors = da1.devices.where(section_id: section.id).order(:custom_id)
      upper_sensors = da2.devices.where(section_id: section.id).order(:custom_id)

      puts "This section has #{lower_sensors.count} lower FO sensors and #{upper_sensors.count} upper FO sensors."

      reference_marker = lower_sensors.first.fiber_optic_node.levee_distance_marker
      puts "Reference distance marker for this section is #{reference_marker}."

      last_target = 0.0

      case(section.id)

        when 8
          # Special case - calculate offset by hand
          # origin is at levee_distance_marker 31
          lower_sensors.each do |s|
            # Determine this sensor's original distance marker
            source = s.custom_id.split('.').last.to_i
            target = source - 31
            last_target = target
            puts "Original distance marker for sensor #{s.custom_id} is #{source}; target is #{target}."
            s.fiber_optic_node.levee_distance_marker = target
            s.fiber_optic_node.save
          end

        # First UPPER sensor in this section is 550

          upper_sensors.each do |s|
            source = s.custom_id.split('.').last.to_i
            target = source
            if source <= 567
              target = source - 548
            else
              target = source - 532
            end
            puts "Original distance marker for sensor #{s.custom_id} is #{source}; target is #{target}."
            if target < 0
              target = 0
            end
            s.fiber_optic_node.levee_distance_marker = target
            s.fiber_optic_node.save
          end

        when 7
          # Special case - rounded section
          # Use lower sensors as reference
          first_source = lower_sensors.first.custom_id.split('.').last.to_i
          last_source = lower_sensors.last.custom_id.split('.').last.to_i

          first_upper_source = upper_sensors.first.custom_id.split('.').last.to_i
          last_upper_source = upper_sensors.last.custom_id.split('.').last.to_i

          puts "First original distance marker for section 7 is: #{first_source}; last is #{last_source}."
          section_length = last_source - first_source
          puts "Section 7 has length #{section_length}, housing #{lower_sensors.count} lower sensors and #{upper_sensors.count} upper sensors."

          upper_offset = section_length.to_f/((upper_sensors.count-1).to_f)
          puts "Upper sensor offset for this section is #{upper_offset}"

          lower_sensors.each do |s|
            # Determine this sensor's original distance marker
            source = s.custom_id.split('.').last.to_i
            target = source - 31
            last_target = target
            puts "Original distance marker for sensor #{s.custom_id} is #{source}; target is #{target}."
            s.fiber_optic_node.levee_distance_marker = target
            s.fiber_optic_node.save
          end

          upper_sensors_processed = 0

          upper_sensors.each do |s|
            source = s.custom_id.split('.').last.to_i
            target = (source - (548+upper_sensors_processed))+(upper_sensors_processed*upper_offset)
            puts "Original distance marker for sensor #{s.custom_id} is #{source}; target is #{target}."
            upper_sensors_processed += 1
            s.fiber_optic_node.levee_distance_marker = target
            s.fiber_optic_node.save
          end

        when 6
          # Special case - rounded section
          # Use lower sensors as reference
          first_source = lower_sensors.first.custom_id.split('.').last.to_i
          last_source = lower_sensors.last.custom_id.split('.').last.to_i

          first_upper_source = upper_sensors.first.custom_id.split('.').last.to_i
          last_upper_source = upper_sensors.last.custom_id.split('.').last.to_i

          puts "First original distance marker for section 6 is: #{first_source}; last is #{last_source}."
          section_length = last_source - first_source
          puts "Section 6 has length #{section_length}, housing #{lower_sensors.count} lower sensors and #{upper_sensors.count} upper sensors."

          upper_offset = section_length.to_f/((upper_sensors.count-1).to_f)
          puts "Upper sensor offset for this section is #{upper_offset}"

          lower_sensors.each do |s|
            # Determine this sensor's original distance marker
            source = s.custom_id.split('.').last.to_i
            target = source - 31
            last_target = target
            puts "Original distance marker for sensor #{s.custom_id} is #{source}; target is #{target}."
            s.fiber_optic_node.levee_distance_marker = target
            s.fiber_optic_node.save
          end

          upper_sensors_processed = 0

          upper_sensors.each do |s|
            source = s.custom_id.split('.').last.to_i
            target = (source - (539+upper_sensors_processed))+(upper_sensors_processed*upper_offset)
            puts "Original distance marker for sensor #{s.custom_id} is #{source}; target is #{target}."
            upper_sensors_processed += 1
            s.fiber_optic_node.levee_distance_marker = target
            s.fiber_optic_node.save
          end

        else
          lower_sensors.each do |s|
            # Determine this sensor's original distance marker
            source = s.custom_id.split('.').last.to_i
            target = source - 31
            last_target = target
            puts "Original distance marker for sensor #{s.custom_id} is #{source}; target is #{target}."
            s.fiber_optic_node.levee_distance_marker = target
            s.fiber_optic_node.save
          end

          upper_sensors.each do |s|
            source = s.custom_id.split('.').last.to_i
            target = source - 539
            puts "Original distance marker for sensor #{s.custom_id} is #{source}; target is #{target}."
            s.fiber_optic_node.levee_distance_marker = target
            s.fiber_optic_node.save
          end

      end

    end

    # Flag only properly defined FO nodes as visible
    puts "Flagging old FO nodes as invisible..."
    visible_nodes = (da1.devices + da2.devices).flatten
    puts "...#{visible_nodes.length} total nodes registered for raw FO DAs."
    visible_nodes.reject! do |node|
      [
        '031',
        '032',
        '481',
        '482',
        '483',
        '544',
        '545',
        '546',
        '547',
        '983',
        '984'
      ].include? node.custom_id.split('.').last
    end
    puts "...#{visible_nodes.length} meet inclusion criteria."
    puts "...#{Device.where(device_type: 'fiber_optic_node').all.length} total FO nodes."
    invisible_nodes = Device.where(device_type: 'fiber_optic_node').all.reject do |node|
      visible_nodes.include? node
    end
    puts "...#{invisible_nodes.length} nodes to be tagged as invisible."
    invisible_nodes.each do |node|
      node.visible = false
      node.save
    end

    puts "All done."
  end
end