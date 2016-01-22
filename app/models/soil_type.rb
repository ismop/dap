class SoilType < ActiveRecord::Base

  has_many :sections

  validates_presence_of :code
  validates_presence_of :name

end
