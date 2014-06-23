def rand_str(l = 4)
  SecureRandom.hex(l)
end

def rand_point(z = false)
  pt = "POINT("+rand(0.0..89.99).to_s+" "+rand(-179.99..179.99).to_s
  if z
    pt += (" "+rand(-500..500).to_s)
  end
  pt += ")"
  pt
end

FactoryGirl.define do
  factory :levee do
    name { rand_str }
    shape { 'MULTIPOINT(49.981348 19.678777 211.21, 49.98191 19.678662 211.14, 49.981919 19.678856 215.70, 49.981928 19.679069 211.10, 49.981371 19.679169 210.84, 49.981357 19.678973 215.84)' }
  end

  factory :user do
    email { Faker::Internet.email }
    login { rand_str }
    password '12345678'
    password_confirmation { password }
    authentication_token { rand_str }
  end

  factory :activity_state do
    name { [:active, :inactive, :off, :damaged, :maintenance].sample }
  end

  factory :power_type do
    name { [:cell, :battery, :battery_harvesting, :mains].sample }
  end

  factory :interface_type do
    name { rand_str(10) }
  end

  factory :measurement_type do
    name { [:type1, :type2, :type3, :type4, :type5].sample }
    unit { [:mm, :deg, :Pa].sample }
  end

  factory :edge_node do
    custom_id { rand_str }
    placement { rand_point }
    manufacturer 'Siemens AG'
    model { rand_str }
    serial_number { rand_str(10) }
    firmware_version { rand_str(10) }
    manufacture_date { rand(21..100).days.ago }
    purchase_date { rand(11..20).days.ago }
    warranty_date { rand(1..100).days.from_now }
    deployment_date { rand(1..10).days.ago }
    last_state_change { rand(1..100).minutes.ago }
    energy_consumption { rand(10) }

    activity_state
    interface_type
  end

  factory :measurement_node do
    custom_id { rand_str(10) }
    placement { rand_point(true) }
    battery_state { rand(0..100) }
    battery_capacity 100
    manufacturer 'Siemens AG'
    model { rand_str }
    serial_number { rand_str(10) }
    firmware_version { rand_str(10) }
    manufacture_date { rand(21..100).days.ago }
    purchase_date { rand(11..20).days.ago }
    warranty_date { rand(1..100).days.from_now }
    deployment_date { rand(1..10).days.ago }
    last_state_change { rand(1..100).minutes.ago }
    energy_consumption { rand(10) }

    edge_node
    activity_state
    power_type
    interface_type
  end

  factory :sensor do
    custom_id { rand_str(10) }
    placement { rand_point(true) }
    x_orientation { rand(0.0..89.99) }
    y_orientation { rand(0.0..89.99) }
    z_orientation { rand(0.0..89.99) }
    battery_state { rand(0..100) }
    battery_capacity 100
    manufacturer 'Siemens AG'
    model { rand_str }
    serial_number { rand_str(10) }
    firmware_version { rand_str(10) }

    manufacture_date { rand(21..100).days.ago }
    purchase_date { rand(11..20).days.ago }
    warranty_date { rand(1..100).days.from_now }
    deployment_date { rand(3..10).days.ago }
    last_state_change { rand(1..100).minutes.ago }

    energy_consumption { rand(10) }
    precision { rand(0.0..99.99) }

    measurement_node
    activity_state
    power_type
    interface_type
    measurement_type
    timelines { [create(:timeline)] }
  end

  factory :timeline do
    name { Faker::Lorem.words(3).join(' ') }
    measurement_type 'actual'
  end

  factory :measurement do
    value { rand(-99.99..99.99) }
    timestamp { rand(1..24).hours.ago }
    source_address { rand_str(10) }

    sensor
    timeline { sensor.timelines.first }
  end



end