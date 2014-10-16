class Profile < ActiveRecord::Base

  has_many :sensors, dependent: :destroy
  has_many :results, dependent: :destroy

  belongs_to :levee

  belongs_to :profile_set
  has_and_belongs_to_many :experiments, join_table: 'profile_sets'

end
