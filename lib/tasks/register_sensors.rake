namespace :data do
  desc "Imports real sensor coords from Budokop specs"
  task :register_sensors => :environment do

    l = Levee.find_or_create_by(name: 'Obwałowanie eksperymentalne - Czernichów')
    c = Context.find_or_create_by(name: 'Obwałowanie eksperymentalne - sensory Budokop', context_type: 'measurements')
    mt_t = MeasurementType.find_or_create_by(name: 'Temperatura', unit: 'C')
    mt_p = MeasurementType.find_or_create_by(name: 'Ciśnienie porowe', unit: 'Pa')

    # Register missing sections
    ["MULTIPOINT((49.980661636809 19.676967093213), (49.980508748114 19.676964697757), (49.980506641268 19.677287702201), (49.980659529960 19.677290098686), (49.980661636809 19.676967093213))",
      "MULTIPOINT((49.980508748114 19.676964697757), (49.980351362692 19.676962231857), (49.980349255847 19.677285235243), (49.980506641268 19.677287702201), (49.980508748114 19.676964697757))",
      "MULTIPOINT((49.980351362692 19.676962231857), (49.980045585294 19.676957440998), (49.980043478454 19.677280442326), (49.980349255847 19.677285235243), (49.980351362692 19.676962231857))",
      "MULTIPOINT((49.980045585294 19.676957440998), (49.979870212959 19.676954693317), (49.979868106122 19.677277693466), (49.980043478454 19.677280442326), (49.980045585294 19.676957440998))",
      "MULTIPOINT((49.979870212959 19.676954693317), (49.979312619066 19.676945924945), (49.979310512027 19.677268953591), (49.979868106122 19.677277693466), (49.979870212959 19.676954693317))",
      "MULTIPOINT((49.980659529960 19.677290098686), (49.980735228088 19.677271924345), (49.980802889263 19.677217248210), (49.980855354971 19.677132583147), (49.980887505617 19.677027633740),\
      (49.980896744400 19.676913787453), (49.980883025544 19.676802577891), (49.980848523445 19.676704428906), (49.980797109313 19.676627832867), (49.980733799281 19.676578949396),\
      (49.980664281093 19.676561496262), (49.980662364241 19.676855536861), (49.980673346983 19.676857807054), (49.980683483880 19.676865239657), (49.980691739110 19.676877324227),\
      (49.980697198123 19.676892989006), (49.980699196917 19.676910692500), (49.980697437766 19.676928574755), (49.980692059488 19.676944687862), (49.980683637885 19.676957264695),\
      (49.980673109929 19.676964967564), (49.980661636809 19.676967093213), (49.980659529960 19.677290098686))",
      "MULTIPOINT((49.979315263114 19.676540371639), (49.979245531620 19.676555643718), (49.979160457611 19.676556447823), (49.978845113788 19.676255374871), (49.978826731709 19.676285998685),\
      (49.979046889484 19.676750295317), (49.979078254411 19.676885298041), (49.979086006634 19.676999406242), (49.979116781865 19.677105337809), (49.979168132432 19.677191626876),\
      (49.979235066483 19.677248410763), (49.979310512027 19.677268953591), (49.979312619066 19.676945924945), (49.979301421614 19.676942338708), (49.979291622340 19.676933619985),\
      (49.979284127895 19.676920802789), (49.979279562235 19.676905238813), (49.979278248131 19.676888431175), (49.979280221779 19.676871897781), (49.979285262433 19.676857071455),\
      (49.979292923249 19.676845227942), (49.979302557851 19.676837424925), (49.979313346071 19.676834436224), (49.979315263114 19.676540371639))",
      "MULTIPOINT((49.980662364241 19.676855536861), (49.980212691603 19.676848492476), (49.980214608448 19.676554454632), (49.980664281481 19.676561496269), (49.980662364241 19.676855536861))",
      "MULTIPOINT((49.980212691603 19.676848492476), (49.979763018949 19.676841448181), (49.979764935788 19.676547413091), (49.980214608448 19.676554454632), (49.980212691603 19.676848492476))",
      "MULTIPOINT((49.979763018949 19.676841448181), (49.979313346071 19.676834436224), (49.979315263114 19.676540371639), (49.979764935788 19.676547413091), (49.979763018949 19.676841448181))"]. each do |coords|
      s = Section.find_or_create_by(shape: coords)
      s.save
    end


    # ["MULTIPOINT ((19.676711668088107 49.98081463734371), (19.676881418896894 49.98084983960727), (19.676904358903105 49.980676438192745), (19.6768603319119 49.98066936265629), (19.676711668088107 49.98081463734371))",
    #   "MULTIPOINT ((19.676881418896894 49.98084983960727), (19.677096010276113 49.98084429841542), (19.676991989723884 49.980683701584574), (19.676904358903105 49.980676438192745), (19.676881418896894 49.98084983960727))",
    #   "MULTIPOINT ((19.677096010276113 49.98084429841542), (19.677288977514767 49.980664265713195), (19.677020966885237 49.98064317868681), (19.676991989723884 49.980683701584574), (19.677096010276113 49.98084429841542))",
    #   "MULTIPOINT ((19.677288977514767 49.980664265713195), (19.677276827152003 49.97996035430139), (19.677006895048 49.97996425689861), (19.677020966885237 49.98064317868681), (19.677288977514767 49.980664265713195))",
    #   "MULTIPOINT ((19.677276827152003 49.97996035430139), (19.67725954773322 49.97931450320214), (19.676990674466776 49.979330385597855), (19.677006895048 49.97996425689861), (19.677276827152003 49.97996035430139))",
    #   "MULTIPOINT ((19.67725954773322 49.97931450320214), (19.677154212254614 49.97913098066064), (19.67698978774538 49.979269019339355), (19.676990674466776 49.979330385597855), (19.67725954773322 49.97931450320214))",
    #   "MULTIPOINT ((19.677154212254614 49.97913098066064), (19.676894861100003 49.97905865135466), (19.6768948611 49.97923268204534), (19.67698978774538 49.979269019339355), (19.677154212254614 49.97913098066064))",
    #   "MULTIPOINT ((19.676894861100003 49.97905865135466), (19.67666442940782 49.97913433015512), (19.676841570592188 49.979265669844885), (19.6768948611 49.97923268204534), (19.676894861100003 49.97905865135466))",
    #   "MULTIPOINT ((19.67666442940782 49.97913433015512), (19.676568216826468 49.979308917990934), (19.67683800537353 49.97931580420906), (19.676841570592188 49.979265669844885), (19.67666442940782 49.97913433015512))",
    #   "MULTIPOINT ((19.676568216826468 49.979308917990934), (19.67658753864402 49.97997060288568), (19.676857516955973 49.979968397114334), (19.67683800537353 49.97931580420906), (19.676568216826468 49.979308917990934))",
    #   "MULTIPOINT ((19.67658753864402 49.97997060288568), (19.67658550900022 49.98065626447425), (19.676854602199786 49.98064201332575), (19.676857516955973 49.979968397114334), (19.67658753864402 49.97997060288568))",
    #   "MULTIPOINT ((19.67658550900022 49.98065626447425), (19.676711668088107 49.98081463734371), (19.6768603319119 49.98066936265629), (19.676854602199786 49.98064201332575), (19.67658550900022 49.98065626447425))"].each do |coords|


    # Register aggregations for fiber optic cables
    fo1 = DeviceAggregation.find_or_create_by(custom_id: 'Światłowód 1', levee: l)
    fo2 = DeviceAggregation.find_or_create_by(custom_id: 'Światłowód 2', levee: l)
    uta = DeviceAggregation.find_or_create_by(custom_id: 'Czujniki UT', levee: l)
    sva = DeviceAggregation.find_or_create_by(custom_id: 'Czujniki SV', levee: l)
    other = DeviceAggregation.find_or_create_by(custom_id: 'Pozostałe czujniki', levee: l)
    ws = DeviceAggregation.find_or_create_by(custom_id: 'Stacja pogodowa', \
      device_aggregation_type: 'weather_station', levee: l)
    fo1.save
    fo2.save
    uta.save
    sva.save
    other.save
    ws.save

    File.open('db/sensor_coords_wgs84.csv').each do |line|
      arr = line.split(',')

      if arr[0][2..3] == 'UT'
        d1 = Device.find_or_create_by(custom_id: arr[0]+'_T')
        d2 = Device.find_or_create_by(custom_id: arr[0]+'_P')
        d1.placement = "POINT(#{arr[2]} #{arr[3]} #{arr[4]})"
        d2.placement = "POINT(#{arr[2]} #{arr[3]} #{arr[4]})"
        d1.device_type = 'budokop-sensor'
        d2.device_type = 'budokop-sensor'
        d1.levee = l
        d2.levee = l

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

        # Assign correct device_aggregation, if applicable
        d1.device_aggregation = uta
        d2.device_aggregation = uta

        d1.save
        d2.save

        unless d1.reload.parameters.count > 0
          puts "Creating parameter for device #{d1.custom_id} which has #{d1.parameters.count} parameters."

          p1 = Parameter.find_or_create_by(parameter_name: "Odczyt sensora #{d1.custom_id}", device: d1)
          p1.custom_id = d1.custom_id
          p1.measurement_type = mt_t
          p2 = Parameter.find_or_create_by(parameter_name: "Odczyt sensora #{d2.custom_id}", device: d2)
          p2.custom_id = d2.custom_id
          p2.measurement_type = mt_p

          p1.save
          p2.save

          if p1.reload.timelines.blank?
            t1 = Timeline.new
            t1.parameter = p1
            t1.context = c
            t1.save
          end
          if p2.reload.timelines.blank?
            t2 = Timeline.new
            t2.parameter = p2
            t2.context = c
            t2.save
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
      p.save
    end
  end
end
