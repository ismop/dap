class Experiment < ActiveRecord::Base

  validates_presence_of :name
  validates :status, inclusion: {in: ["unknown", "started", "finished", "error"]}
  validates :start_date, date: true, allow_nil: true
  validates :end_date, date: {after: :start_date, message: "end_date must not precede start_date"}, allow_nil: true

  self.rgeo_factory_generator = RGeo::Geos.factory_generator

  has_many :results
  has_many :profile_sets
  has_and_belongs_to_many :profiles, join_table: 'profile_sets'

end