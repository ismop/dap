class BudokopSensor < ActiveRecord::Base

  validates_numericality_of :battery_state
  validates_numericality_of :battery_capacity

  validates_presence_of :placement
  validates_presence_of :manufacturer
  validates_presence_of :model
  validates_presence_of :serial_number
  validates_presence_of :firmware_version

  validates_presence_of :energy_consumption
  validates_numericality_of :energy_consumption

  belongs_to :device
end
