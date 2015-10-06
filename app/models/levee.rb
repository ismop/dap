class Levee < ActiveRecord::Base
  validates_presence_of :name
  validates :emergency_level, inclusion: {in: ["none", "heightened", "severe"]}
  validates :threat_level, inclusion: {in: ["none", "heightened", "severe"]}

  before_update :update_threat_date

  self.rgeo_factory_generator = RGeo::Geos.factory_generator

  has_many :sensors, through: :profiles

  has_many :profiles, dependent: :destroy
  has_many :sections, dependent: :destroy
  has_many :devices, dependent: :destroy
  has_many :device_aggregations, dependent: :destroy
  has_many :experiments, dependent: :nullify

  private

  def update_threat_date
    #if threat_level_changed?
      self.threat_level_updated_at = Time.now
    #end
  end
end
