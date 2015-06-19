# TODO This may be an array in ThreatAssesment instead of the separate table
class ProfileSelection < ActiveRecord::Base

  has_many :profiles
  has_many :threat_assessments

end