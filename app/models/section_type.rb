# This entity groups scenarios and sections of the same type
class SectionType < ActiveRecord::Base

  has_many :scenarios
  has_many :sections

end
