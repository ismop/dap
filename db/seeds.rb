# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#User.create(login: 'admin', full_name: 'Root Admiński z Superuserów', email: 'admin@localhost.pl', password: 'airtraffic123', password_confirmation: 'airtraffic123', authentication_token: 'secret', roles: [:admin, :developer])

# ISMOP: Initial points describing sample levee sections
# MOS1, MOS2, MOS3, MOS4, MOS6, MOS5, (MOS1)
Levee.create(name: 'Real section', shape: 'MULTIPOINT(49.981348 19.678777 211.21, 49.98191 19.678662 211.14, 49.981919 19.678856 215.70, 49.981928 19.679069 211.10, 49.981371 19.679169 210.84, 49.981357 19.678973 215.84)')
# MOS2, TG1, TG2, TG3, MOS4, MOS3, (MOS2)
Levee.create(name: 'Fictional section', shape: 'MULTIPOINT(49.98191 19.678662 211.14, 49.982779 19.678487 211.02, 49.982803 19.678659 215.58, 49.98283 19.678898 211.35, 49.981928 19.679069 211.10, 49.981919 19.678856 215.70)')


#mtypes = MeasurementType.create([])