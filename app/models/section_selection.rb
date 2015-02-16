# TODO This may be an array in Experiment instead of the separate table
class SectionSelection < ActiveRecord::Base

  has_many :sections
  has_many :experiments

end