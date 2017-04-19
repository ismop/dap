module Anomaly
  class DataProvider
    def self.get(lon1:, lat1:, lon2:, lat2:, dist1:, dist2:, h1:, h2:, from:, to:, section_ids:)
      Device.where(
        'section_id IN (:section_ids)' \
        ' AND ST_Z(ST_GeomFromEWKT(placement::geometry)) > :h1' \
        ' AND ST_Z(ST_GeomFromEWKT(placement::geometry)) < :h2' \
        ' AND NOT ST_DWithin(placement,ST_GeomFromEWKT(\'SRID=4326;LINESTRING(:lon1 :lat1, :lon2 :lat2)\'),:dist1)' \
        ' AND ST_DWithin(placement,ST_GeomFromEWKT(\'SRID=4326;LINESTRING(:lon1 :lat1, :lon2 :lat2)\'),:dist2)',
        { section_ids: section_ids.join(','),h1: h1, h2: h2, lon1: lon1, lat1: lat1, lon2: lon2, lat2: lat2, dist1: dist1, dist2: dist2 }
      ).
      order(:custom_id).
      eager_load(parameters: { timelines: :measurements }).
      where(parameters:{ measurement_type_id:1, monitoring_status: 1 }, timelines:{ context_id:1 }).
      where(
        'measurements.m_timestamp BETWEEN :from AND :to',
        { from: from, to: to }
      )
    end
  end
end
