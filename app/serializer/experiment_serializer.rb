class ExperimentSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :status, :start_date, :end_date, :selection, :profile_ids, :result_ids

  def selection
    RGeo::GeoJSON.encode(object.selection).as_json
  end

  def profile_ids
    object.profiles.collect {|p| p.id}
  end

end