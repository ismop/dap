# This entity groups scenarios and profiles of the same type
class ProfileType < ActiveRecord::Base

  has_many :profiles

end
