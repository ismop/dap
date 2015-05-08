class Device < ActiveRecord::Base
  validates :custom_id, presence: true
  validates :custom_id, uniqueness: true

  validates :device_type, inclusion: { in: %w(neosentio_sensor budokop_sensor pump) }

  belongs_to :device_aggregation
  belongs_to :section

  has_one :budokop_sensor, dependent: :destroy
  has_one :neosentio_sensor, dependent: :destroy
  has_one :pump, dependent: :destroy

  has_many :parameters, dependent: :destroy

  self.rgeo_factory_generator = RGeo::Geos.factory_generator

end
