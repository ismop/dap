# This groups scenarios and profiles of the same type
class ProfileType < ActiveRecord::Base

  has_many :scenarios
  has_many :profiles

end
