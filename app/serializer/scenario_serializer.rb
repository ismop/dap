class ScenarioSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :experiment_ids, :timeline_ids

  def experiment_ids
    object.experiments.nil? ? nil : object.experiments.collect {|e| e.id}
  end

  def timeline_ids
    object.timelines.nil? ? nil : object.timelines.collect {|t| t.id}
  end
end

