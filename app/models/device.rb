class Device < ActiveRecord::Base
  validates :custom_id, presence: true
  validates :custom_id, uniqueness: true

  validates :device_type, inclusion: { in: %w(neosentio-sensor, budokop-sensor, pump) }

  belongs_to :device_aggregation
  belongs_to :section

  has_one :budokop_sensor
  has_one :neosentio_sensor
  has_one :pump

  has_many :parameters

  self.rgeo_factory_generator = RGeo::Geos.factory_generator

end
