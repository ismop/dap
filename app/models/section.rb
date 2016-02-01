class Section < ActiveRecord::Base

  has_many :profiles, dependent: :destroy
  has_many :devices, dependent: :destroy
  has_many :device_aggregations, dependent: :destroy

  belongs_to :levee
  belongs_to :soil_type

end
