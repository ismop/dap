module ThreatLevel
  class CalculatorService
    def self.get(result)
      return 0 if result.similarity <= 0.3
      return 1 if (0.3...0.6) === result.similarity
      return 2
    end
  end
end