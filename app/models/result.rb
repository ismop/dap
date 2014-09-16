class Result < ActiveRecord::Base

  validates_numericality_of :similarity

  belongs_to :experiment
  belongs_to :profile
  belongs_to :scenario

end
