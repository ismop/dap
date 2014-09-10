class ProfileSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :experiment_ids

  def experiment_ids
    object.experiments.collect {|e| e.id}
  end

end