class ThreatAssessmentRun < ActiveRecord::Base

  validates_presence_of :name
  validates :status, inclusion: {in: ["unknown", "started", "finished", "error"]}
  validates :start_date, date: true, allow_nil: true
  validates :end_date, date: {after: :start_date, message: "end_date must not precede start_date"}, allow_nil: true

  has_many :threat_assessments, dependent: :destroy

end
