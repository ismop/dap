def rand_str(l = 4)
  SecureRandom.hex(l)
end

def rand_point(z = false)
  pt = "POINT("+rand(0.0..89.99).to_s+" "+rand(0.0..89.99).to_s.to_s
  if z
    pt += (" "+rand(-500..500).to_s)
  end
  pt += ")"
  pt
end

FactoryGirl.define do
  factory :levee do
    name { rand_str }
  end

  factory :threat_assessment_run do
    name { rand_str }
    start_date { rand(2..5).hours.ago }
    end_date { rand(0..1).hours.ago }
    status { ["unknown", "started", "finished", "error"].sample }
  end

  factory :threat_assessment do
    #results { [create(:result), create(:result)] }
    profiles { [create(:profile), create(:profile)] }

    threat_assessment_run
  end

  factory :result do
    similarity { rand(0.0..100.0) }
    rank { rand(1..20) }
    offset { rand(1..20) }
    payload { Faker::Lorem.words(10).join(' ') }

    threat_assessment
    scenario
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

  factory :profile do
    section { create(:section) }
    levee { create(:levee) }
    profile_type {  create(:profile_type) }
    name { Faker::Lorem.words(2).join(' ') }
  end

  factory :section do
    levee { create(:levee) }
    shape { 'MULTIPOINT(49.981348 19.678777, 49.98191 19.678662, 49.981919 19.678856, 49.981928 19.679069, 49.981348 19.678777)' }
    soil_type { SoilType.all.first }
  end

  factory :profile_type do

  end

  factory :context do
    context_type { 'tests' }
    name { Faker::Lorem.words(3).join(' ') }
  end

  factory :timeline do
    context { create(:context) }
  end

  factory :scenario do
    name { Faker::Lorem.words(3).join('_') }
    description { Faker::Lorem.words(20).join(' ') }
  end

  factory :measurement do
    value { rand(-99.99..99.99) }
    m_timestamp { rand(1..24).hours.ago }
    source_address { rand_str(10) }
    timeline { }
  end

  factory :device do
    custom_id { rand_str(10) }
    vendor { Faker::Lorem.word }
    placement { rand_point(true) }
    visible { true }
  end

  factory :device_aggregation do
    shape { 'MULTIPOINT(49.981348 19.678777, 49.981919 19.678856, 49.981928 19.679069, 49.981348 19.678777)' }
    custom_id { rand_str(10) }
  end

  factory :budokop_sensor do
    battery_state { rand(0.0..89.99) }
    battery_capacity { rand(0.0..89.99) }
    manufacturer { rand_str(10) }
    model { rand_str(10) }
    serial_number { rand_str(10) }
    firmware_version { rand_str(10) }
  end

  factory :neosentio_sensor do
    battery_state { rand(0.0..89.99) }
    battery_capacity { rand(0.0..89.99) }
  end

  factory :parameter do
    custom_id { rand_str(10) }
    monitored { false }
    monitoring_status { :unknown }
    measurement_type
  end

  factory :pump do
  end

  factory :fiber_optic_node do
    cable_distance_marker { rand(1..450) }
    levee_distance_marker { rand(1..450) }
  end

  factory :experiment do
    name { rand_str(10) }
    description { Faker::Lorem.words(10).join(' ') }
    start_date { rand(21..100).days.ago }
    end_date { rand(1..19).days.ago }
  end

end