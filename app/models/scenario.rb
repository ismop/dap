class Scenario < ActiveRecord::Base

  validates_presence_of :file_name
  validates_presence_of :payload
  validates_presence_of :profile_type
  validates :threat_level, inclusion: {in: ["none", "heightened", "severe"]}

  belongs_to :context
  belongs_to :profile_type

end
