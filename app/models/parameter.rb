class Parameter < ActiveRecord::Base

  belongs_to :device
  belongs_to :measurement_type

  has_many :timelines, dependent: :destroy

  validates :measurement_type, presence: true

end
