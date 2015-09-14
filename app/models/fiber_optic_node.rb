class FiberOpticNode < ActiveRecord::Base

  validates_numericality_of :cable_distance_marker, allow_nil: true
  validates_numericality_of :levee_distance_marker, allow_nil: true

  belongs_to :device
end
