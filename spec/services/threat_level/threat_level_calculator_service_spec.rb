require 'rails_helper'

describe ThreatLevel::CalculatorService do
  context 'result with similarity less than 0.3' do
    let(:result) { create(:result, similarity: 0.25) }
    it 'returns 0' do
      expect(ThreatLevel::CalculatorService.get(result)).to eq 0
    end
  end

  context 'result with similarity between 0.3 and 0.6' do
    let(:result) { create(:result, similarity: 0.35) }
    it 'returns 1' do
      expect(ThreatLevel::CalculatorService.get(result)).to eq 1
    end
  end

  context 'result with similarity larger than 0.6' do
    let(:result) { create(:result, similarity: 0.65) }
    it 'returns 1' do
      expect(ThreatLevel::CalculatorService.get(result)).to eq 2
    end
  end
end

