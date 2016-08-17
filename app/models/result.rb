class Result < ActiveRecord::Base

  validates_numericality_of :similarity
  validates :rank, numericality: { greater_than: 0 }
  validates :scenario, presence: true

  belongs_to :threat_assessment
  belongs_to :scenario

end
