class ThreatAssessmentSerializer < ActiveModel::Serializer

  attributes :id, :threat_assessment_run_id, :profile_ids

  has_many :results

end