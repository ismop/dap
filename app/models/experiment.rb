class Experiment < ActiveRecord::Base

  belongs_to :levee
  has_many :timelines

  validates :start_date, presence: true
  validates :end_date, presence: true

end
