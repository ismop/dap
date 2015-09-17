class FiberOpticNodeSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :cable_distance_marker, :levee_distance_marker, :deployment_date, :last_state_change, :device_id
end
