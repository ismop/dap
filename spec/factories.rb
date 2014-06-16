def rand_str(l = 4)
  SecureRandom.hex(l)
end

FactoryGirl.define do
  factory :levee do
    name { rand_str }
    shape { 'MULTIPOINT(49.981348 19.678777 211.21, 49.98191 19.678662 211.14, 49.981919 19.678856 215.70, 49.981928 19.679069 211.10, 49.981371 19.679169 210.84, 49.981357 19.678973 215.84)' }
  end

  factory :user do
    email { Faker::Internet.email }
    password '12345678'
    password_confirmation { password }
    authentication_token { rand_str }

  end


end