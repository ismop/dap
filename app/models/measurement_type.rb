class MeasurementType < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :unit

  has_many :sensors, dependent: :nullify
  has_many :parameters, dependent: :nullify

end
