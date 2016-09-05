module ThreatLevel
  class ThreatAssessmentRunsForProfileService
    def self.get(profile_id)
      ThreatAssessmentRun.joins(threat_assessments: :profiles).
          where("profiles.id = #{profile_id}").order(created_at: :desc).limit(5)
    end
  end
end
