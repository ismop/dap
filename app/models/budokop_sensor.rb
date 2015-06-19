class BudokopSensor < ActiveRecord::Base

  validates_numericality_of :battery_state
  validates_numericality_of :battery_capacity

  belongs_to :device
end
