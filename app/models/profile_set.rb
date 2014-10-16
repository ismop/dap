class ProfileSet < ActiveRecord::Base

  has_many :scenarios
  has_many :profiles
  has_many :experiments, dependent: :destroy

end
