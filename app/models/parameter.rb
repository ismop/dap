class Parameter < ActiveRecord::Base

  validates :custom_id, presence: true

  belongs_to :device
  belongs_to :measurement_type

  has_many :timelines, dependent: :destroy

  validates :measurement_type, presence: true

end
