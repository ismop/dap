# TODO This may be an array in Experiment instead of the separate table
class ProfileSelection < ActiveRecord::Base

  has_many :profiles
  has_many :experiments

end