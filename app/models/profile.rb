class Profile < ActiveRecord::Base

  validates_presence_of :profile_type

  has_many :sensors, dependent: :destroy
  has_many :results, dependent: :destroy

  belongs_to :levee
  belongs_to :profile_type

  has_and_belongs_to_many :experiments, join_table: 'profile_selections'


end
