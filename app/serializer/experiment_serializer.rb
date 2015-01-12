class ExperimentSerializer < ActiveModel::Serializer
  attributes :id, :name, :status, :start_date, :end_date, :selection, :profile_ids

  has_many :results

  def selection
    RGeo::GeoJSON.encode(object.selection).as_json
  end

end