class ScenarioSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :experiment_ids

  def experiment_ids
    object.experiments.nil? ? nil : object.experiments.collect {|e| e.id}
  end
end

