class Scenario < ActiveRecord::Base

  validates_presence_of :file_name
  validates_presence_of :payload
  validates_presence_of :profile_type

  belongs_to :context
  belongs_to :profile_type
  has_and_belongs_to_many :profiles, join_table: 'profile_types'

end
