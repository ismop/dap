namespace :data do
  desc "Imports real sensor coords from Budokop specs"
  task :register_sensors => :environment do

    l = Levee.find_or_create_by(name: 'Obwałowanie eksperymentalne - Czernichów')
    c = Context.find_or_create_by(name: 'Obwałowanie eksperymentalne - sensory Budokop', context_type: 'measurements')
    mt_t = MeasurementType.find_or_create_by(name: 'Temperatura', unit: 'C')
    mt_p = MeasurementType.find_or_create_by(name: 'Ciśnienie porowe', unit: 'Pa')

    # Register missing sections
    ["MULTIPOINT ((19.676711668088107 49.98081463734371), (19.676881418896894 49.98084983960727), (19.676904358903105 49.980676438192745), (19.6768603319119 49.98066936265629), (19.676711668088107 49.98081463734371))",
      "MULTIPOINT ((19.676881418896894 49.98084983960727), (19.677096010276113 49.98084429841542), (19.676991989723884 49.980683701584574), (19.676904358903105 49.980676438192745), (19.676881418896894 49.98084983960727))",
      "MULTIPOINT ((19.677096010276113 49.98084429841542), (19.677288977514767 49.980664265713195), (19.677020966885237 49.98064317868681), (19.676991989723884 49.980683701584574), (19.677096010276113 49.98084429841542))",
      "MULTIPOINT ((19.677288977514767 49.980664265713195), (19.677276827152003 49.97996035430139), (19.677006895048 49.97996425689861), (19.677020966885237 49.98064317868681), (19.677288977514767 49.980664265713195))",
      "MULTIPOINT ((19.677276827152003 49.97996035430139), (19.67725954773322 49.97931450320214), (19.676990674466776 49.979330385597855), (19.677006895048 49.97996425689861), (19.677276827152003 49.97996035430139))",
      "MULTIPOINT ((19.67725954773322 49.97931450320214), (19.677154212254614 49.97913098066064), (19.67698978774538 49.979269019339355), (19.676990674466776 49.979330385597855), (19.67725954773322 49.97931450320214))",
      "MULTIPOINT ((19.677154212254614 49.97913098066064), (19.676894861100003 49.97905865135466), (19.6768948611 49.97923268204534), (19.67698978774538 49.979269019339355), (19.677154212254614 49.97913098066064))",
      "MULTIPOINT ((19.676894861100003 49.97905865135466), (19.67666442940782 49.97913433015512), (19.676841570592188 49.979265669844885), (19.6768948611 49.97923268204534), (19.676894861100003 49.97905865135466))",
      "MULTIPOINT ((19.67666442940782 49.97913433015512), (19.676568216826468 49.979308917990934), (19.67683800537353 49.97931580420906), (19.676841570592188 49.979265669844885), (19.67666442940782 49.97913433015512))",
      "MULTIPOINT ((19.676568216826468 49.979308917990934), (19.67658753864402 49.97997060288568), (19.676857516955973 49.979968397114334), (19.67683800537353 49.97931580420906), (19.676568216826468 49.979308917990934))",
      "MULTIPOINT ((19.67658753864402 49.97997060288568), (19.67658550900022 49.98065626447425), (19.676854602199786 49.98064201332575), (19.676857516955973 49.979968397114334), (19.67658753864402 49.97997060288568))",
      "MULTIPOINT ((19.67658550900022 49.98065626447425), (19.676711668088107 49.98081463734371), (19.6768603319119 49.98066936265629), (19.676854602199786 49.98064201332575), (19.67658550900022 49.98065626447425))"].each do |coords|
      s = Section.find_or_create_by(shape: coords)
      s.save
    end


    # Register aggregations for fiber optic cables
    fo1 = DeviceAggregation.find_or_create_by(custom_id: 'Światłowód 1', levee: l)
    fo2 = DeviceAggregation.find_or_create_by(custom_id: 'Światłowód 2', levee: l)
    fo1.save
    fo2.save

    File.open('db/sensor_coords_wgs84.csv').each do |line|
      arr = line.split(',')
      d = Device.find_or_create_by(custom_id: arr[0])
      d.placement = "POINT(#{arr[2]} #{arr[3]} #{arr[4]})"
      d.device_type = 'budokop-sensor'
      d.levee = l

      if d.budokop_sensor.blank?
        bs = BudokopSensor.new(battery_state: 0, battery_capacity: 0)
        bs.save
        d.budokop_sensor = bs
      end

      # Assign d to correct section
      Section.all.each do |s|
        if d.placement.within? s.shape.convex_hull
          puts "Device #{d.custom_id} belongs to section #{s.id.to_s}"
          d.section = s
        end
      end

      # Assign correct device_aggregation, if applicable
      if d.custom_id[0..6] == 'swiatlo'
        d.device_aggregation = fo2
      elsif d.custom_id[0..1] == 'sw' and d.custom_id.length == 5
        d.device_aggregation = fo1
      end

      d.save

      unless arr[1] == 'u' or d.reload.parameters.count > 0
        puts "Creating parameter for device #{d.custom_id} which has #{d.parameters.count} parameters."

        p = Parameter.find_or_create_by(parameter_name: "Odczyt sensora #{d.custom_id}", device: d)
        p.custom_id = d.custom_id
        case arr[1]
        when 't'
          p.measurement_type = mt_t
        when 'p'
          p.measurement_type = mt_p
        end

        p.save

        if p.reload.timelines.blank?
          t = Timeline.new
          t.parameter = p
          t.context = c
          t.save
        end
      end
    end
  end
end
