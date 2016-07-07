module ThreatLevel
  class CalculatorService
    def self.get(result)
      return 0 if result.similarity <= 0.3
      return 1 if result.similarity > 0.3 && result.similarity <= 0.6
      return 2
    end
  end
end