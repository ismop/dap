# TODO This may be an array in ThreatAssesment instead of the separate table
class SectionSelection < ActiveRecord::Base

  has_many :sections
  has_many :threat_assessments

end