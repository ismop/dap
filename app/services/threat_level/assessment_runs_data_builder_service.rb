module ThreatLevel
  class AssessmentRunsDataBuilderService
    def self.get(profile_id)
      AssessmentRunsDataBuilderService.new(profile_id).get
    end

    def initialize(profile_id)
      @profile_id = profile_id
    end

    def get
      runs = ThreatLevel::ThreatAssessmentRunsForProfileService.get(@profile_id)
      runs.collect do |run|
        ThreatLevel::AssessmentRunStatusDataBuilderService.get(run)
      end
    end
  end
end
