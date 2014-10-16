class Scenario < ActiveRecord::Base

  validates_presence_of :file_name
  validates_presence_of :payload

  belongs_to :context
  belongs_to :profile_set

end
