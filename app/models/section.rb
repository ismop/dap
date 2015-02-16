class Section < ActiveRecord::Base

  validates_presence_of :section_type

  has_many :sensors, dependent: :destroy
  has_many :results, dependent: :destroy

  belongs_to :levee
  belongs_to :section_type

  has_and_belongs_to_many :threat_assessments, join_table: 'section_selections'

  def profile_shape
    if sensors.count < 2
      return nil
    end
    if sensors.count == 2
      return RGeo::Cartesian.factory.line(sensors.first.placement, sensors.second.placement)
    end
    multipoint = RGeo::Cartesian.factory.multi_point(sensors.map(&:placement))
    points = multipoint.convex_hull.exterior_ring.points
    distance = 0
    diagonal = nil
    points.each do |point1|
      points.each do |point2|
        if point1 != point2
          if (d = point1.distance(point2))>distance
            distance = d
            diagonal = [point1, point2]
          end
        end
      end
    end
    RGeo::Cartesian.factory.line(diagonal.first, diagonal.second)
  end

end
