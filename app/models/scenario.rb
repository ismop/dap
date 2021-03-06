class Scenario < ActiveRecord::Base

  has_and_belongs_to_many :experiments

  has_many :timelines, dependent: :destroy
  has_many :results, dependent: :destroy

  validates :threat_level, presence: true, numericality: true
  
end
