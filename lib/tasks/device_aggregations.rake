namespace :device_aggregations do
  task generate_name: :environment do
    DeviceAggregation.eager_load(:devices).all.find_each do |aggregat|
      name = aggregat.devices.each_with_object([]) do |device, names|
        names << device.custom_id
      end.join(', ')

      name =  (name.empty? ? 'Empty' : name).truncate(255, separator: ', ')
      aggregat.update_attribute(:custom_id, name)
    end
  end
end
