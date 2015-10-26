class ThreatAssessmentRunSerializer < ActiveModel::Serializer

  attributes :id, :name, :status, :start_date, :end_date, :threat_assessment_ids

  def threat_assessment_ids
    if object.threat_assessments.blank?
      []
    else
      object.threat_assessments.collect{|ta| ta.id}
    end
  end
end