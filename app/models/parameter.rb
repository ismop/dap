class Parameter < ActiveRecord::Base
  extend Enumerize

  belongs_to :device
  belongs_to :measurement_type

  has_many :timelines, dependent: :destroy

  validates :measurement_type_id, presence: true
  validates :custom_id, presence: true
  validates :custom_id, uniqueness: true

  enumerize :monitoring_status, in: { unknown: 0, up: 1, down: 2 }

  # enum monitoring_status: [ :unknown, :up, :down ]

  scope :monitorable, -> do
    where(monitored: true)
  end

  scope :up, -> do
    where(monitoring_status: 1)
  end

  scope :down, -> do
    where(monitoring_status: 2)
  end
end
