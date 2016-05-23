class Experiment < ActiveRecord::Base

  belongs_to :levee

  has_and_belongs_to_many :scenarios

  has_many :timelines, dependent: :destroy

  validates :start_date, presence: true
  validates :end_date, presence: true

end
