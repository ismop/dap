namespace :data do
  desc "Imports fiber optic measurement node positions from geodesy data"
  task :import_neosentio => :environment do

    # Grab some fundamental objects from the DB (or create new ones as necessary)
    l = Levee.find_or_create_by(name: 'Obwałowanie eksperymentalne - Czernichów')
    c = Context.find(1)
    mt = MeasurementType.find_by(name: 'Temperatura')
    pt = ProfileType.find_or_create_by(label: 'Neosentio profile')

    # Spawn some empty tables which we will use to collect data about changes in DB
    devices_created = []
    device_aggregations_created = []
    profiles_touched = []

    File.open('db/neosentio3.csv').each do |line|
      linedata = line.split(',')

      # Parse linedata
      section = linedata[1].strip
      side = linedata[3].strip
      uid = "neosentio.#{linedata[7][1].to_i.to_s}_#{linedata[7][2..3].to_i.to_s}_#{linedata[7][4..5].to_i.to_s}_4"
      realid = linedata[6].strip
      placement = "POINT(#{linedata[9].strip} #{linedata[8].strip} #{linedata[10].strip})"
      borehole_placement = "POINT(#{linedata[9].strip} #{linedata[8].strip})"
      cableid = linedata[10].strip
      profileid = "neosentio_profile_#{linedata[2].strip.to_s}"

      # attempt to find the corresponding parameter
      p = Parameter.find_by(custom_id: uid)

      if p.blank?
        puts "Caution: parameter not found in DAP: #{uid}. A new parameter will be created."
      else
        # Do nothing
      end

      # Create DA if it does not exist
      da = DeviceAggregation.find_or_create_by(shape: borehole_placement) do |agg|
        puts "Caution: a new aggregation had to be created for #{borehole_placement}"
        agg.custom_id = "Neosentio borehole at #{linedata[9].strip},#{linedata[8].strip}"
        agg.save
        device_aggregations_created << agg
      end

      # Create profile if it does not exist
      #profile = Profile.find_or_create_by(profile_type: pt, custom_id: profileid) do |prof|
      #  puts "Caution: a new profile had to be created for #{profileid}"
      #end
      #profiles_touched << profile

      # Create device if it does not exist
      d = Device.find_or_create_by(custom_id: realid) do |dev|
        puts "Caution: a new device had to be created for #{placement}"
        devices_created << dev
      end
      d.placement = placement
      d.device_type = 'neosentio-sensor'
      d.device_aggregation = da
      d.levee = l
      d.label = uid
      d.vendor = 'neosentio'

      # Make sure d has an assigned NeosentioSensor
      if d.neosentio_sensor.blank?
        puts "Caution: device #{d.custom_id} has no assigned NeosentioSensor object - we will create one."
        ns = NeosentioSensor.new(battery_state: 100, battery_capacity: 100)
        ns.save
        d.neosentio_sensor = ns
        d.save
      end

      if !d.valid?
        puts "Device #{uid} not created due to the following errors: #{d.errors.inspect}"
      else
        d.save
      end

      # Reassign parameter to this device, or create one if necessary
      if p.blank?
        puts "Caution: device #{placement} has no matching parameter - we will create one."
          par = Parameter.new(custom_id: uid, measurement_type: mt, device: d, parameter_name: 'Pomiar temperatury', monitored: true)
          par.save
          # Also create a real timeline for this parameter
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

    # Now assign profiles
    devices_updated = []
    device_aggregations_updated = []

    profiles = {}

    File.open('db/neosentio3.csv').each do |line|
      linedata = line.split(',')
      profile_id=linedata[7][2..3].to_i.to_s
      uid = "neosentio.#{linedata[7][1].to_i.to_s}_#{profile_id}_#{linedata[7][4..5].to_i.to_s}_4"
      realid = linedata[6].strip

      # attempt to find parameter
      d = Device.find_by(custom_id: realid)

      p = profiles[profile_id]
      if (p.nil?)
        p = Profile.create(profile_type: pt, section: d.section, custom_id: "neosentio_profile_#{linedata[2].strip.to_s}")
        profiles[profile_id] = p
      end

      profiles_touched << p

      d.profile=p
      d.save
      devices_updated << d

      da = d.device_aggregation
      unless da.nil?
        da.profile = p
        da.save
        device_aggregations_updated << da
      end

    end

    puts "Profile assignment - Devices updated: #{devices_updated.map(&:id)}"
    puts "Profile assignment - DeviceAggregations updated: #{device_aggregations_updated.map(&:id)}"
    puts "Profile assignment - Profiles created: #{profiles.map { |k,v| v.id }}"

    # Purge all empty devices of type neosentio_sensor (could be leftovers from multiple import attempts)
    ds = Device.where(device_type: 'neosentio-sensor').all.select {|d| d.parameters.blank? }
    puts "#{ds.length} empty Device objects found - purging."
    ds.each {|d| d.destroy}

    # Purge all empty device aggregations (could be leftovers from multiple import attempts}
    das = DeviceAggregation.all.select{|da| da.devices.blank? }
    puts "#{das.length} empty DeviceAggregation objects found - purging."
    das.each {|da| da.destroy}

    # Purge all empty profiles
    ps = Profile.all.select{|p| p.devices.blank? }
    puts "#{ps.length} empty Profile objects found - purging."
    ps.each {|p| p.destroy}

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

    # Try to determine correct coordinates for profiles
    profiles_touched.uniq.each do |profile|
      # Naive method - grab the leftmost and rightmost latitude for each DA belonging to the profile
      das = profile.devices.collect{|d| d.device_aggregation}.uniq
      left_x = 90.0
      left_y = 0
      right_x = -90.0
      right_y = 0
      das.each do |da|
        if da.shape.x < left_x
          left_x = da.shape.x
          left_y = da.shape.y
        end
        if da.shape.y > right_x
          right_x = da.shape.x
          right_y = da.shape.y
        end
      end

      profile.shape = "LINESTRING (#{left_x} #{left_y}, #{right_x} #{right_y})"

      puts "Determined profile shape: #{profile.shape}"

      # Try to assign the profile to the correct section
      Section.all.each do |s|
        if profile.devices
          if profile.devices.first.placement.within? s.shape.convex_hull
            puts "Profile #{profile.custom_id} likely belongs to section #{s.id.to_s}"
            profile.section = s
          end
        else
          puts "Warning: profile #{profile.custom_id} is empty."
        end
      end

      profile.save

      unless profile.errors.empty?
        puts "PROFILE HAS ERRORS: #{profile.errors.inspect}"
      end
    end

    # Now do your best to adjust the width of Neosentio profiles...
    s_8_east = 19.676834436224 + ((19.676855536861 - 19.676834436224)/2)
    s_8_west = 19.676540371639 + ((19.676561496258 - 19.676540371639)/2)

    s_1_east = 19.677287702201 + ((19.677290098686 - 19.677287702201)/2)
    s_1_west = 19.676964697757 + ((19.676967093213 - 19.676964697757)/2)

    s_2_east = 19.677285235243 + ((19.677287702201 - 19.677285235243)/2)
    s_2_west = 19.676962231857 + ((19.676964697757 - 19.676962231857)/2)

    s_3_east = 19.676957440998 + ((19.676962231857 - 19.676957440998)/2)
    s_3_west = 19.677280442326 + ((19.677285235243 - 19.677280442326)/2)

    s_4_east = 19.677277693466 + ((19.677280442326 - 19.677277693466)/2)
    s_4_west = 19.676954693317 + ((19.676957440998 - 19.676954693317)/2)

    s_5_east = 19.677268953591 + ((19.677277693466 - 19.677268953591)/2)
    s_5_west = 19.676945924945 + ((19.676954693317 - 19.676945924945)/2)

    ps = Profile.where("custom_id LIKE '%eosentio%'").all
    ps.each do |p|

      lon_east = 0
      lon_west = 0

      case p.section_id
        when 8
          lon_east = s_8_east
          lon_west = s_8_west
        when 1
          lon_east = s_1_east
          lon_west = s_1_west
        when 2
          lon_east = s_2_east
          lon_west = s_2_west
        when 3
          lon_east = s_3_east
          lon_west = s_3_west
        when 4
          lon_east = s_4_east
          lon_west = s_4_west
        when 5
          lon_east = s_5_east
          lon_west = s_5_west
        else
          puts "Profile #{p.custom_id} is not recognized as belonging to a straight section of the levee. Skipping."
          next
      end

      lat = p.devices.first.device_aggregation.shape.y

      p.shape = "LINESTRING (#{lon_west} #{lat}, #{lon_east} #{lat})"
      p.save
    end

    puts "All done."
  end
end