class ProfileSet < ActiveRecord::Base

  has_many :experiments
  has_many :profiles

end
