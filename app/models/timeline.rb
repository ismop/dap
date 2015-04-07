class Timeline < ActiveRecord::Base
  belongs_to :sensor
  belongs_to :parameter
  belongs_to :context

  has_many :measurements, dependent: :destroy
end
