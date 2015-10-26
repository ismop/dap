class ThreatAssessment < ActiveRecord::Base

  belongs_to :threat_assessment_run

  has_and_belongs_to_many :profiles, join_table: 'profile_selections'

  has_many :results, dependent: :destroy

end
