module ThreatLevel
  class ThreatAssessmentRunsForProfileService
    def self.get(profile)
      ThreatAssessmentRun.joins(threat_assessments: :profiles).
          where("profiles.id = #{profile.id}")
    end
  end
end
