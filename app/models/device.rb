class Device < ActiveRecord::Base
  validates :custom_id, presence: true
  validates :custom_id, uniqueness: true

  validates :device_type, inclusion: { in: ['neosentio-sensor', 'budokop-sensor', 'pump',  'parameter_discovery', 'weather_station', 'fiber_optic_node', 'deprecated'] }

  belongs_to :device_aggregation
  belongs_to :profile
  belongs_to :section
  belongs_to :levee

  has_one :budokop_sensor, dependent: :destroy
  has_one :neosentio_sensor, dependent: :destroy
  has_one :pump, dependent: :destroy
  has_one :weather_station, dependent: :destroy
  has_one :fiber_optic_node, dependent: :destroy

  has_many :parameters, dependent: :destroy

  self.rgeo_factory_generator = RGeo::Geos.factory_generator

end
