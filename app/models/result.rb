class Result < ActiveRecord::Base

  validates_numericality_of :similarity

  belongs_to :threat_assessment
  belongs_to :section
  belongs_to :scenario

  delegate :threat_level, to: :scenario, :allow_nil => true

end
