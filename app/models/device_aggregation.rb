class DeviceAggregation < ActiveRecord::Base
  validates :custom_id, presence: true
  validates :custom_id, uniqueness: true

  belongs_to :profile
  belongs_to :section
  belongs_to :levee

  has_many :devices

  self.rgeo_factory_generator = RGeo::Geos.factory_generator
end
