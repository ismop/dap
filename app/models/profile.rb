class Profile < ActiveRecord::Base

  belongs_to :section
  belongs_to :profile_type

  has_and_belongs_to_many :threat_assessments, join_table: 'profile_selections'

  has_many :devices, dependent: :destroy
  has_many :device_aggregations, dependent: :destroy

  has_one :levee, through: :section

  validates_presence_of :profile_type

  def profile_shape
    if devices.count < 2
      return nil
    end
    if devices.count == 2
      return RGeo::Cartesian.factory.line(devices.first.placement, devices.second.placement)
    end
    multipoint = RGeo::Cartesian.factory.multi_point(devices.map(&:placement))
    convex_hull = multipoint.convex_hull
    if (convex_hull.class == RGeo::Geos::CAPILineStringImpl)
      return convex_hull
    end
    points = convex_hull.exterior_ring.points
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
