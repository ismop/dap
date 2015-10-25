namespace :data do
  desc "Aggregate UT and SV devices from Budokop specs"
  task :aggregate_devices => :environment do

    uts = Device.where("custom_id LIKE '%UT%'").all
    svs = Device.where("custom_id LIKE '%SV%'").all

    uts.each do |ut|
      puts ut.custom_id

      new_ut = Device.find_or_create_by(custom_id: ut.custom_id[0..-3])
      new_ut.device_aggregation = ut.device_aggregation
      new_ut.placement = ut.placement
      new_ut.device_type = ut.device_type
      new_ut.profile = ut.profile
      new_ut.section = ut.section
      new_ut.levee = ut.levee
      new_ut.label = ut.label

      new_ut.save

      ut.budokop_sensor.device = new_ut.reload
      ut.budokop_sensor.save

      ut.parameters.each do |p|
        p.device = new_ut.reload
        p.save
      end

      ut.reload.destroy
    end

    svs.each do |sv|
      puts sv.custom_id

      new_sv = Device.find_or_create_by(custom_id: sv.custom_id[0..-3])
      new_sv.device_aggregation = sv.device_aggregation
      new_sv.placement = sv.placement
      new_sv.device_type = sv.device_type
      new_sv.profile = sv.profile
      new_sv.section = sv.section
      new_sv.levee = sv.levee
      new_sv.label = sv.label

      new_sv.save
      sv.budokop_sensor.device = new_sv.reload
      sv.budokop_sensor.save

      sv.parameters.each do |p|
        p.device = new_sv.reload
        p.save
      end

      sv.reload.destroy
    end

  end

end
