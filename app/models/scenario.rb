class Scenario < ActiveRecord::Base

  validates_presence_of :file_name
  validates_presence_of :payload
  validates_presence_of :section_type
  validates :threat_level, inclusion: {in: ["none", "heightened", "severe"]}

  belongs_to :context
  belongs_to :section_type

end
