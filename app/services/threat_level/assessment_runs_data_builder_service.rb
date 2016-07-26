module ThreatLevel
  class AssessmentRunsDataBuilderService
    def self.get(profile)
      AssessmentRunsDataBuilderService.new(profile).get
    end

    def initialize(profile)
      @profile = profile
    end

    def get
      runs = ThreatLevel::ThreatAssessmentRunsForProfileService.get(@profile)
      runs.collect do |run|
        ThreatLevel::AssessmentRunStatusDataBuilderService.get(run)
      end
    end
  end
end
