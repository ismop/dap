class Measurement < ActiveRecord::Base
  validates_numericality_of :value

  belongs_to :timeline
  belongs_to :sensor

end
