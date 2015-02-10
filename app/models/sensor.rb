class Sensor < ActiveRecord::Base
  validates_presence_of :custom_id
  validates_uniqueness_of :custom_id

  validates_numericality_of :x_orientation
  validates_numericality_of :y_orientation
  validates_numericality_of :z_orientation

  validates_numericality_of :battery_state
  validates_numericality_of :battery_capacity

  validates_presence_of :placement
  validates_presence_of :manufacturer
  validates_presence_of :model
  validates_presence_of :serial_number
  validates_presence_of :firmware_version

  validates_presence_of :energy_consumption
  validates_numericality_of :energy_consumption

  belongs_to :measurement_node
  belongs_to :profile
  belongs_to :measurement_type
  belongs_to :activity_state
  belongs_to :interface_type
  belongs_to :power_type

  has_many :timelines, dependent: :destroy

  self.rgeo_factory_generator = RGeo::Geos.factory_generator

end
