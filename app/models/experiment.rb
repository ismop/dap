class Experiment < ActiveRecord::Base

  belongs_to :levee

  has_many :timelines

end
