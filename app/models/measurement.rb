class Measurement < ActiveRecord::Base
  validates_presence_of :custom_id
  validates_numericality_of :value

  validates_uniqueness_of :name, scope: :sensor
  validates :type, inclusion: {in: ["actual", "simulated", "forecast"]}

  belongs_to :timeline
  belongs_to :sensor

end
