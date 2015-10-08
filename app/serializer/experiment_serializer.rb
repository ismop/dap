class ExperimentSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :start_date, :end_date, :levee_id
end

