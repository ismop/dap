namespace :data do
  desc "Creates Profiles for neosentio sensors and makes neccessary assignments"
  task :assign_profiles => :environment do

    devices_updated = []
    device_aggregations_updated = []

    profiles = {}

    File.open('db/neosentio1.csv').each do |line|
      linedata = line.split(',')
      profile_id=linedata[4][2..3].to_i.to_s
      uid = "neosentio.#{linedata[4][1].to_i.to_s}_#{profile_id}_#{linedata[4][4..5].to_i.to_s}_4"

      # attempt to find parameter
      d = Device.find_by(custom_id: uid)

      p = profiles[profile_id]
      if (p.nil?)
        p = Profile.create(profile_type: ProfileType.find_or_create_by(id: 1), section: d.section)
        profiles[profile_id] = p
      end

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
    
    puts "Devices updated: #{devices_updated.map(&:id)}"
    puts "DeviceAggregations updated: #{device_aggregations_updated.map(&:id)}"
    puts "Profiles created: #{profiles.map { |k,v| v.id }}"

    puts "All done."
  end
end