class PowerType < ActiveRecord::Base
  validates_presence_of :name

  has_many :sensors, dependent: :destroy
  has_many :measurement_nodes, dependent: :destroy

end
