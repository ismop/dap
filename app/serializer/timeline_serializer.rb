class TimelineSerializer < ActiveModel::Serializer
  attributes :id, :label, :context_id, :parameter_id, :experiment_id, :scenario_id
end
