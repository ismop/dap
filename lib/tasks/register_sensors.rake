namespace :data do
  desc "Imports real sensor coords from Budokop specs"
  task :register_sensors => :environment do

    l = Levee.find_or_create_by(name: 'Obwałowanie eksperymentalne - Czernichów')
    c = Context.find_or_create_by(name: 'Obwałowanie eksperymentalne - sensory Budokop', context_type: 'measurements')
    disc = Device.find_or_create_by(custom_id: 'Odczyty nieznanych sensorów', device_type: 'parameter_discovery')
    mt_t = MeasurementType.find_or_create_by(name: 'Temperatura', unit: 'C')
    mt_p = MeasurementType.find_or_create_by(name: 'Ciśnienie porowe', unit: 'Pa')
    mt_dir = MeasurementType.find_or_create_by(name: 'Kierunek wiatru', unit: 'stopnie')
    mt_hum = MeasurementType.find_or_create_by(name: 'Wilgotność powietrza', unit: '%')
    mt_rainfall = MeasurementType.find_or_create_by(name: 'Opady', unit: 'mm')
    mt_spd = MeasurementType.find_or_create_by(name: 'Prędkość wiatru', unit: 'm/s')

    # Register missing sections
    ["MULTIPOINT((19.676967093213 49.980661636809), (19.676964697757 49.980508748114), (19.677287702201 49.980506641268), (19.677290098686 49.980659529960), (19.676967093213 49.980661636809))",
      "MULTIPOINT((19.676964697757 49.980508748114), (19.676962231857 49.980351362692), (19.677285235243 49.980349255847), (19.677287702201 49.980506641268), (19.676964697757 49.980508748114))",
      "MULTIPOINT((19.676962231857 49.980351362692), (19.676957440998 49.980045585294), (19.677280442326 49.980043478454), (19.677285235243 49.980349255847), (19.676962231857 49.980351362692))",
      "MULTIPOINT((19.676957440998 49.980045585294), (19.676954693317 49.979870212959), (19.677277693466 49.979868106122), (19.677280442326 49.980043478454), (19.676957440998 49.980045585294))",
      "MULTIPOINT((19.676954693317 49.979870212959), (19.676945924945 49.979312619066), (19.677268953591 49.979310512027), (19.677277693466 49.979868106122), (19.676954693317 49.979870212959))",
      "MULTIPOINT((19.677290098686 49.980659529960), (19.677271924345 49.980735228088), (19.677217248210 49.980802889263), (19.677132583147 49.980855354971), (19.677027633740 49.980887505617),\
      (19.676913787453 49.980896744400), (19.676802577891 49.980883025544), (19.676704428906 49.980848523445), (19.676627832867 49.980797109313), (19.676578949396 49.980733799281),\
      (19.676561496262 49.980664281093), (19.676855536861 49.980662364241), (19.676857807054 49.980673346983), (19.676865239657 49.980683483880), (19.676877324227 49.980691739110),\
      (19.676892989006 49.980697198123), (19.676910692500 49.980699196917), (19.676928574755 49.980697437766), (19.676944687862 49.980692059488), (19.676957264695 49.980683637885),\
      (19.676964967564 49.980673109929), (19.676967093213 49.980661636809), (19.677290098686 49.980659529960))",
      "MULTIPOINT((19.676540371639 49.979315263114), (19.676555643718 49.979245531620), (19.676556447823 49.979160457611), (19.676255374871 49.978845113788), (19.676285998685 49.978826731709),\
      (19.676750295317 49.979046889484), (19.676885298041 49.979078254411), (19.676999406242 49.979086006634), (19.677105337809 49.979116781865), (19.677191626876 49.979168132432),\
      (19.677248410763 49.979235066483), (19.677268953591 49.979310512027), (19.676945924945 49.979312619066), (19.676942338708 49.979301421614), (19.676933619985 49.979291622340),\
      (19.676920802789 49.979284127895), (19.676905238813 49.979279562235), (19.676888431175 49.979278248131), (19.676871897781 49.979280221779), (19.676857071455 49.979285262433),\
      (19.676845227942 49.979292923249), (19.676837424925 49.979302557851), (19.676834436224 49.979313346071), (19.676540371639 49.979315263114))",
      "MULTIPOINT((19.676855536861 49.980662364241), (19.676848492476 49.980212691603), (19.676554454632 49.980214608448), (19.676561496269 49.980664281481), (19.676855536861 49.980662364241))",
      "MULTIPOINT((19.676848492476 49.980212691603), (19.676841448181 49.979763018949), (19.676547413091 49.979764935788), (19.676554454632 49.980214608448), (19.676848492476 49.980212691603))",
      "MULTIPOINT((19.676841448181 49.979763018949), (19.676834436224 49.979313346071), (19.676540371639 49.979315263114), (19.676547413091 49.979764935788), (19.676841448181 49.979763018949))"]. each do |coords|
      s = Section.find_or_create_by(shape: coords)
      s.save
    end

    # Register aggregations for fiber optic cables
    fo1 = DeviceAggregation.find_or_create_by(custom_id: 'Światłowód 1', levee: l)
    fo2 = DeviceAggregation.find_or_create_by(custom_id: 'Światłowód 2', levee: l)
    other = DeviceAggregation.find_or_create_by(custom_id: 'Pozostałe czujniki', levee: l)
    ws1 = DeviceAggregation.find_or_create_by(custom_id: 'Stacja pogodowa Budokop', \
      device_aggregation_type: 'weather_station', levee: l)
    ws2 = DeviceAggregation.find_or_create_by(custom_id: 'Stacja pogodowa KI', \
      device_aggregation_type: 'weather_station', levee: l)
    fo1.save
    fo2.save
    other.save
    ws1.save
    ws2.save

    File.open('db/sensor_coords_wgs84.csv').each do |line|
      arr = line.split(',')

      if arr[0][2..3] == 'UT'

        ut_da = DeviceAggregation.find_or_create_by(custom_id: "czujniki #{arr[0]}", levee: l)
        ut_da.save
        d1 = Device.find_or_create_by(custom_id: arr[0]+'_T')
        d2 = Device.find_or_create_by(custom_id: arr[0]+'_P')
        d1.placement = "POINT(#{arr[2]} #{arr[3]} #{arr[4]})"
        d2.placement = "POINT(#{arr[2]} #{arr[3]} #{arr[4]})"
        d1.device_type = 'budokop-sensor'
        d2.device_type = 'budokop-sensor'
        d1.levee = l
        d2.levee = l
        d1.device_aggregation = ut_da
        d2.device_aggregation = ut_da
        ut_da.placement = d1.placement
        ut_da.save

        if d1.budokop_sensor.blank?
          bs1 = BudokopSensor.new(battery_state: 0, battery_capacity: 0)
          bs1.save
          d1.budokop_sensor = bs1
        end
        if d2.budokop_sensor.blank?
          bs2 = BudokopSensor.new(battery_state: 0, battery_capacity: 0)
          bs2.save
          d2.budokop_sensor = bs2
        end

        # Assign d1 and d2 to correct section
        Section.all.each do |s|
          if d1.placement.within? s.shape.convex_hull
            puts "Device #{d1.custom_id} belongs to section #{s.id.to_s}"
            d1.section = s
          end
          if d2.placement.within? s.shape.convex_hull
            puts "Device #{d2.custom_id} belongs to section #{s.id.to_s}"
            d2.section = s
          end
        end

        d1.save
        d2.save

        unless d1.reload.parameters.count > 0
          puts "Creating parameter for device #{d1.custom_id} which has #{d1.parameters.count} parameters."

          p1 = Parameter.find_or_create_by(parameter_name: "Odczyt sensora #{d1.custom_id}", device: d1)
          p1.custom_id = 'ASP.UT_'+d1.custom_id[-1]+'_'+d1.custom_id[4..-3]+'.F_CV'
          p1.measurement_type = mt_t
          p2 = Parameter.find_or_create_by(parameter_name: "Odczyt sensora #{d2.custom_id}", device: d2)
          p2.custom_id = 'ASP.UT_'+d2.custom_id[-1]+'_'+d2.custom_id[4..-3]+'.F_CV'
          p2.measurement_type = mt_p

          p1.save
          p2.save

          if p1.valid?
            if p1.reload.timelines.blank?
              t1 = Timeline.new
              t1.parameter = p1
              t1.context = c
              t1.save
            end
          end

          if p2.valid?
            if p2.reload.timelines.blank?
              t2 = Timeline.new
              t2.parameter = p2
              t2.context = c
              t2.save
            end
          end
        end
      elsif arr[0][2..3] == 'SV'
        sv_da = DeviceAggregation.find_or_create_by(custom_id: "czujniki #{arr[0]}", levee: l)
        sv_da.save
        d1 = Device.find_or_create_by(custom_id: arr[0]+'_T')
        d2 = Device.find_or_create_by(custom_id: arr[0]+'_S')
        d1.placement = "POINT(#{arr[2]} #{arr[3]} #{arr[4]})"
        d2.placement = "POINT(#{arr[2]} #{arr[3]} #{arr[4]})"
        d1.device_type = 'budokop-sensor'
        d2.device_type = 'budokop-sensor'
        d1.levee = l
        d2.levee = l
        d1.device_aggregation = sv_da
        d2.device_aggregation = sv_da
        sv_da.placement = d1.placement
        sv_da.save

        if d1.budokop_sensor.blank?
          bs1 = BudokopSensor.new(battery_state: 0, battery_capacity: 0)
          bs1.save
          d1.budokop_sensor = bs1
        end
        if d2.budokop_sensor.blank?
          bs2 = BudokopSensor.new(battery_state: 0, battery_capacity: 0)
          bs2.save
          d2.budokop_sensor = bs2
        end

        # Assign d1 and d2 to correct section
        Section.all.each do |s|
          if d1.placement.within? s.shape.convex_hull
            puts "Device #{d1.custom_id} belongs to section #{s.id.to_s}"
            d1.section = s
          end
          if d2.placement.within? s.shape.convex_hull
            puts "Device #{d2.custom_id} belongs to section #{s.id.to_s}"
            d2.section = s
          end
        end

        d1.save
        d2.save

        unless d1.reload.parameters.count > 0
          puts "Creating parameter for device #{d1.custom_id} which has #{d1.parameters.count} parameters."

          p1 = Parameter.find_or_create_by(parameter_name: "Odczyt sensora #{d1.custom_id}", device: d1)
          p1.custom_id = 'ASP.SV_'+d1.custom_id[-1]+'_'+d1.custom_id[4..-3]+'.F_CV'
          p1.measurement_type = mt_t
          p2 = Parameter.find_or_create_by(parameter_name: "Odczyt sensora #{d2.custom_id}", device: d2)
          p2.custom_id = 'ASP.SV_'+d2.custom_id[-1]+'_'+d2.custom_id[4..-3]+'.F_CV'
          p2.measurement_type = mt_p

          p1.save
          p2.save

          if p1.valid?
            if p1.reload.timelines.blank?
              t1 = Timeline.new
              t1.parameter = p1
              t1.context = c
              t1.save
            end
          end

          if p2.valid?
            if p2.reload.timelines.blank?
              t2 = Timeline.new
              t2.parameter = p2
              t2.context = c
              t2.save
            end
          end
        end
      else
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
        elsif d.custom_id[2..3] == 'UT'
          d.device_aggregation = uta
        elsif d.custom_id[2..3] == 'SV'
          d.device_aggregation = sva
        else
          d.device_aggregation = other
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

    pt = ProfileType.find_or_create_by(id: 1)

    Section.all.each do |s|
      p = Profile.find_or_create_by(section: s, profile_type: pt)
      p.devices = s.devices

      p.device_aggregations = s.devices.select { |d|
        d.custom_id[2..3] == 'SV' or d.custom_id[2..3] == 'UT'
      }.collect { |d|
        d.device_aggregation
      }.flatten.uniq

      p.save
    end

    d_ws_ki = Device.find_or_create_by(custom_id: 'Stacja pogodowa KI')
    d_ws_ki.device_type = 'weather_station'
    d_ws_ki.levee = l
    d_ws_ki.device_aggregation = ws2
    d_ws_ki.save
    if d_ws_ki.weather_station.blank?
      ws = WeatherStation.new
      ws.save
      d_ws_ki.weather_station = ws
    end

    p_dir = Parameter.find_or_create_by(parameter_name: "Stacja KI - kierunek wiatru", device: d_ws_ki, custom_id: 'weatherStation.direction')
    p_dir.measurement_type = mt_dir
    p_dir.save
    if p_dir.reload.timelines.blank?
      t = Timeline.new
      t.parameter = p_dir
      t.context = c
      t.save
    end
    p_hum = Parameter.find_or_create_by(parameter_name: "Stacja KI - wilgotnośc powietrza", device: d_ws_ki, custom_id: 'weatherStation.humidity')
    p_hum.measurement_type = mt_hum
    p_hum.save
    if p_hum.reload.timelines.blank?
      t = Timeline.new
      t.parameter = p_hum
      t.context = c
      t.save
    end
    p_curr = Parameter.find_or_create_by(parameter_name: "Stacja KI - opad bieżący", device: d_ws_ki, custom_id: 'weatherStation.rainfallCurrent')
    p_curr.measurement_type = mt_rainfall
    p_curr.save
    if p_curr.reload.timelines.blank?
      t = Timeline.new
      t.parameter = p_curr
      t.context = c
      t.save
    end
    p_hr = Parameter.find_or_create_by(parameter_name: "Stacja KI - opad godzinny", device: d_ws_ki, custom_id: 'weatherStation.rainfallHour')
    p_hr.measurement_type = mt_rainfall
    p_hr.save
    if p_hr.reload.timelines.blank?
      t = Timeline.new
      t.parameter = p_hr
      t.context = c
      t.save
    end
    p_spd = Parameter.find_or_create_by(parameter_name: "Stacja KI - prędkość wiatru", device: d_ws_ki, custom_id: 'weatherStation.speed')
    p_spd.measurement_type = mt_spd
    p_spd.save
    if p_spd.reload.timelines.blank?
      t = Timeline.new
      t.parameter = p_spd
      t.context = c
      t.save
    end
    p_t = Parameter.find_or_create_by(parameter_name: "Stacja KI - temperatura powietrza", device: d_ws_ki, custom_id: 'weatherStation.temperature')
    p_t.measurement_type = mt_t
    p_t.save
    if p_t.reload.timelines.blank?
      t = Timeline.new
      t.parameter = p_t
      t.context = c
      t.save
    end

    d_ws_bud = Device.find_or_create_by(custom_id: 'Stacja pogodowa Budokop')
    d_ws_bud.device_type = 'weather_station'
    d_ws_bud.levee = l
    d_ws_bud.device_aggregation = ws1
    d_ws_bud.save
    if d_ws_bud.weather_station.blank?
      ws = WeatherStation.new
      ws.save
      d_ws_bud.weather_station = ws
    end

    p_rain = Parameter.find_or_create_by(parameter_name: "Stacja Budokop - opady atmosferyczne", device: d_ws_bud, custom_id: 'ASP.OP.F_CV')
    p_rain.measurement_type = mt_rainfall
    p_rain.save
    if p_rain.reload.timelines.blank?
      t = Timeline.new
      t.parameter = p_rain
      t.context = c
      t.save
    end
    p_hum = Parameter.find_or_create_by(parameter_name: "Stacja Budokop - wilgotnośc powietrza", device: d_ws_bud, custom_id: 'ASP.WW.F_CV')
    p_hum.measurement_type = mt_hum
    p_hum.save
    if p_hum.reload.timelines.blank?
      t = Timeline.new
      t.parameter = p_hum
      t.context = c
      t.save
    end
    p_t = Parameter.find_or_create_by(parameter_name: "Stacja Budokop - temperatura powietrza", device: d_ws_bud, custom_id: 'ASP.TZ.F_CV')
    p_t.measurement_type = mt_t
    p_t.save
    if p_t.reload.timelines.blank?
      t = Timeline.new
      t.parameter = p_t
      t.context = c
      t.save
    end
    p_pres = Parameter.find_or_create_by(parameter_name: "Stacja Budokop - ciśnienie atmosferyczne", device: d_ws_bud, custom_id: 'ASP.PATM.F_CV')
    p_pres.measurement_type = mt_p
    p_pres.save
    if p_pres.reload.timelines.blank?
      t = Timeline.new
      t.parameter = p_pres
      t.context = c
      t.save
    end
    p_spd = Parameter.find_or_create_by(parameter_name: "Stacja Budokop - prędkość wiatru", device: d_ws_bud, custom_id: 'ASP.VW.F_CV')
    p_spd.measurement_type = mt_spd
    p_spd.save
    if p_spd.reload.timelines.blank?
      t = Timeline.new
      t.parameter = p_spd
      t.context = c
      t.save
    end
    p_dir = Parameter.find_or_create_by(parameter_name: "Stacja Budokop - kierunek wiatru", device: d_ws_bud, custom_id: 'ASP.KW.F_CV')
    p_dir.measurement_type = mt_dir
    p_dir.save
    if p_dir.reload.timelines.blank?
      t = Timeline.new
      t.parameter = p_dir
      t.context = c
      t.save
    end




  end
end
