class Profile < ActiveRecord::Base

  validates_presence_of :name

  has_many :sensors
  has_many :results
  has_many :profile_sets

  has_and_belongs_to_many :experiments, join_table: 'profile_sets'

end
