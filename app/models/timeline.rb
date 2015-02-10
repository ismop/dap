class Timeline < ActiveRecord::Base
  has_many :measurements, dependent: :destroy
  belongs_to :sensor
  belongs_to :context
end
