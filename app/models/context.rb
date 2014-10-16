class Context < ActiveRecord::Base
  validates :type, inclusion: {in: ["measurements", "tests"]}
  validates_presence_of :name
  has_many :timelines, dependent: :destroy
  has_many :scenarios, dependent: :destroy
end
