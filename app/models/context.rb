# This class is used to group timelines and scenarios in order to switch between different system perspectives.
class Context < ActiveRecord::Base
  validates :context_type, inclusion: {in: ["measurements", "tests"]}
  validates_presence_of :name
  has_many :timelines, dependent: :destroy
  has_many :scenarios, dependent: :destroy
end
