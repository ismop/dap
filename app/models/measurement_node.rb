class MeasurementNode < ActiveRecord::Base
  validates_presence_of :custom_id
  validates_uniqueness_of :custom_id

  validates_numericality_of :battery_state
  validates_numericality_of :battery_capacity

  validates_presence_of :placement
  validates_presence_of :manufacturer
  validates_presence_of :model
  validates_presence_of :serial_number
  validates_presence_of :firmware_version

  validates_presence_of :energy_consumption
  validates_numericality_of :energy_consumption

  belongs_to :edge_node

  belongs_to :activity_state
  belongs_to :interface_type
  belongs_to :power_type

  self.rgeo_factory_generator = RGeo::Geos.factory_generator

end
