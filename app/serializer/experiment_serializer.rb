class ExperimentSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :description, :start_date, :end_date, :levee_id
end

