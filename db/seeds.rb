# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(login: 'admin', email: 'admin@localhost.pl', password: 'airtraffic123', password_confirmation: 'airtraffic123', authentication_token: 'secret')

# Dictionary bootstrap: measurement types
MeasurementType.create(name: 'Temperatura', unit: 'C')
MeasurementType.create(name: 'Ciśnienie porowe', unit: 'bar')
MeasurementType.create(name: 'Naprężenie', unit: 'Pa')
MeasurementType.create(name: 'Przemieszczenie X', unit: 'mm')
MeasurementType.create(name: 'Przemieszczenie Y', unit: 'mm')
MeasurementType.create(name: 'Przemieszczenie Z', unit: 'mm')
MeasurementType.create(name: 'Opady', unit: 'mm/h')
MeasurementType.create(name: 'Wilgotność', unit: 'g/m3')
MeasurementType.create(name: 'Ciśnienie atmosferyczne', unit: 'Pa')
MeasurementType.create(name: 'Kierunek wiatru', unit: 'º')
MeasurementType.create(name: 'Siła wiatru', unit: 'm/s')

#Dictionary bootstrap: power types
PowerType.create(name: 'bateryjne')
PowerType.create(name: 'akumulatorowe')
PowerType.create(name: 'akumulatorowe+harvesting')
PowerType.create(name: 'sieciowe')

#Dictionary bootstrap: activity_states
ActivityState.create(name: 'aktywny')
ActivityState.create(name: 'nieaktywny')
ActivityState.create(name: 'wyłączony')
ActivityState.create(name: 'uszkodzony')
ActivityState.create(name: 'konserwacja')

#Dictionary bootstrap: interface types
InterfaceType.create(name: 'I2C')
InterfaceType.create(name: '1-wire')
InterfaceType.create(name: 'analog 2-pin')
InterfaceType.create(name: 'analog 4-pin')
InterfaceType.create(name: 'RF1')
InterfaceType.create(name: 'RF2')

# Initial points describing sample levee sections
# MOS1, MOS2, MOS3, MOS4, MOS6, MOS5, (MOS1)
Levee.create(name: 'Real section', shape: 'MULTIPOINT(49.981348 19.678777 211.21, 49.98191 19.678662 211.14, 49.981919 19.678856 215.70, 49.981928 19.679069 211.10, 49.981371 19.679169 210.84, 49.981357 19.678973 215.84)')
# MOS2, TG1, TG2, TG3, MOS4, MOS3, (MOS2)
Levee.create(name: 'Fictional section', shape: 'MULTIPOINT(49.98191 19.678662 211.14, 49.982779 19.678487 211.02, 49.982803 19.678659 215.58, 49.98283 19.678898 211.35, 49.981928 19.679069 211.10, 49.981919 19.678856 215.70)')

# Edge nodes
EdgeNode.create(custom_id: 'WB001', placement: 'POINT(49.97221 19.6751)', manufacturer: 'Siemens AG', model: 'ABC1', serial_number: '00001', firmware_version: '20140617', manufacture_date: '2014-03-12', purchase_date: '2014-06-08', warranty_date: '2016-12-31', deployment_date: '2014-06-01', last_state_change: '2014-06-01 12:00', energy_consumption: 5, activity_state: ActivityState.first, interface_type: InterfaceType.first)

# Measurement nodes
MeasurementNode.create(custom_id: 'MN001', placement: 'POINT(49.971 19.67 211.20)', battery_state: 75, battery_capacity: 100, manufacturer: 'Siemens AG', model: 'MNXA05', serial_number: '00001', firmware_version: '20140610', manufacture_date: '2014-03-12', purchase_date: '2014-06-08', warranty_date: '2016-12-31', deployment_date: '2014-06-01', last_state_change: '2014-06-01 12:00', energy_consumption: 7, edge_node: EdgeNode.first, activity_state: ActivityState.first, power_type: PowerType.first, interface_type: InterfaceType.second)

# Sensors
s1 = Sensor.create(custom_id: 'sensor_1', placement: 'POINT(49.981348 19.678777 211.21)', x_orientation: 90, y_orientation: 0, z_orientation: 180, battery_state: 90, battery_capacity: 100, manufacturer: 'Siemens AG', model: 'Mark I temperature sensor', serial_number: 'TS-32482349', firmware_version: '20140610', manufacture_date: '2014-03-12', purchase_date: '2014-06-08', warranty_date: '2016-12-31', deployment_date: '2014-06-01', last_state_change: '2014-06-01 12:00', energy_consumption: 2, precision: 0.1, measurement_node: MeasurementNode.first, activity_state: ActivityState.first, power_type: PowerType.second, interface_type: InterfaceType.third, measurement_type: MeasurementType.first)
s2 = Sensor.create(custom_id: 'sensor_2', placement: 'POINT(49.981665 19.678662 211.14)', x_orientation: 90, y_orientation: 0, z_orientation: 180, battery_state: 55, battery_capacity: 100, manufacturer: 'Siemens AG', model: 'Mark I temperature sensor', serial_number: 'TS-32482362', firmware_version: '20140610', manufacture_date: '2014-03-12', purchase_date: '2014-06-08', warranty_date: '2016-12-31', deployment_date: '2014-06-01', last_state_change: '2014-06-01 12:00', energy_consumption: 2, precision: 0.1, measurement_node: MeasurementNode.first, activity_state: ActivityState.first, power_type: PowerType.second, interface_type: InterfaceType.third, measurement_type: MeasurementType.first)
s3 = Sensor.create(custom_id: 'sensor_3', placement: 'POINT(49.981919 19.678856 212.70)', x_orientation: 90, y_orientation: 0, z_orientation: 180, battery_state: 67, battery_capacity: 100, manufacturer: 'Siemens AG', model: 'Mark I temperature sensor', serial_number: 'TS-32482380', firmware_version: '20140610', manufacture_date: '2014-03-12', purchase_date: '2014-06-08', warranty_date: '2016-12-31', deployment_date: '2014-06-01', last_state_change: '2014-06-01 12:00', energy_consumption: 2, precision: 0.1, measurement_node: MeasurementNode.first, activity_state: ActivityState.first, power_type: PowerType.second, interface_type: InterfaceType.third, measurement_type: MeasurementType.first)
s4 = Sensor.create(custom_id: 'sensor_4', placement: 'POINT(49.981500 19.678866 215.70)', x_orientation: 90, y_orientation: 0, z_orientation: 180, battery_state: 67, battery_capacity: 100, manufacturer: 'Siemens AG', model: 'Mark I temperature sensor', serial_number: 'TS-32482381', firmware_version: '20140610', manufacture_date: '2014-03-12', purchase_date: '2014-06-08', warranty_date: '2016-12-31', deployment_date: '2014-06-01', last_state_change: '2014-06-01 12:00', energy_consumption: 2, precision: 0.1, measurement_node: MeasurementNode.first, activity_state: ActivityState.first, power_type: PowerType.second, interface_type: InterfaceType.third, measurement_type: MeasurementType.first)

# Timelines
Timeline.create(name: 'Sensor 1 timeline', measurement_type: 'actual', sensor: s1)
Timeline.create(name: 'Sensor 2 timeline', measurement_type: 'actual', sensor: s2)
Timeline.create(name: 'Sensor 3 timeline', measurement_type: 'actual', sensor: s3)
Timeline.create(name: 'Sensor 4 timeline', measurement_type: 'actual', sensor: s4)


#mtypes = MeasurementType.create([])