class Timeline < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :sensor
  validates :measurement_type, inclusion: {in: ["actual", "simulated", "forecast"]}

  has_many :measurements, dependent: :destroy
  has_many :results, dependent: :nullify
  belongs_to :sensor

end
