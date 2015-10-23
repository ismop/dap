class Timeline < ActiveRecord::Base
  belongs_to :parameter
  belongs_to :context
  belongs_to :experiment
  belongs_to :scenario

  has_many :measurements, dependent: :destroy
end
