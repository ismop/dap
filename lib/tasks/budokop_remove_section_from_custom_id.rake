namespace :budokop do
  task remove_section_from_custom_id: :environment do
    budokop_devices =
      Device.where("device_type='budokop-sensor' AND custom_id LIKE '_ %'")
    ActiveRecord::Base.transaction do
      budokop_devices.find_each do |device|
        device.update_attribute(:custom_id, device.custom_id[2..-1])
      end
    end
  end
end
