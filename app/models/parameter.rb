class Parameter < ActiveRecord::Base

  validates :custom_id, presence: true
  validates :custom_id, uniqueness: true

  belongs_to :device
  belongs_to :measurement_type

  has_many :timelines, dependent: :destroy

  validates :measurement_type, presence: true

end
