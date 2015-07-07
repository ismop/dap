class DeviceAggregation < ActiveRecord::Base
  validates :custom_id, presence: true
  validates :custom_id, uniqueness: true

  belongs_to :profile
  belongs_to :section
  belongs_to :levee

  belongs_to :levee

  belongs_to :parent, :class_name => 'DeviceAggregation'
  has_many :children, :class_name => 'DeviceAggregation', :foreign_key => 'parent_id'

  has_many :devices

  self.rgeo_factory_generator = RGeo::Geos.factory_generator
end
