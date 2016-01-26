class TimelineSerializer < ActiveModel::Serializer
  attributes :id, :label, :earliest_measurement_timestamp, :earliest_measurement_value
  attributes :context_id, :parameter_id, :experiment_id, :scenario_id
end
