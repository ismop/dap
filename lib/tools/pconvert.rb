#!/usr/bin/env ruby

require 'proj4'
include Proj4

INPUT = 'sensor_coords.csv'
OUTPUT = 'sensor_coords_wgs84.csv'

of = File.open(OUTPUT, 'w')

File.open(INPUT, 'r').each do |line|
  arr = line.split(',')

  s1 = {}
  s2 = {}
  s1[:name] = arr[0]
  s1[:lon] = arr[1]
  s1[:lat] = arr[2]
  s1[:elev] = arr[3]

  proja = Projection.new(['init=epsg:2178']) #http://www.spatialreference.org/ref/epsg/etrs89-poland-cs2000-zone-7/
  point = Point.new(s1[:lat].to_f, s1[:lon].to_f)
  lonlat_point = proja.inverse(point)
  s1[:lon] = lonlat_point.lon*RAD_TO_DEG
  s1[:lat] = lonlat_point.lat*RAD_TO_DEG

#  puts lonlat_point.lon*RAD_TO_DEG, lonlat_point.lat*RAD_TO_DEG

  case s1[:name][0..1]
  when 'sw'
    s1[:measurements] = 't'
  when 'UT'
    s1[:measurements] = 't'
  when 'SV'
    s1[:measurements] = 'p'
  else
    s1[:measurements] = 'u'
  end

  unless s1[:name] == 'Nr' or s1[:name] == ''
    of.write("#{s1[:name]},#{s1[:measurements]},#{s1[:lon]},#{s1[:lat]},#{s1[:elev]}\n")
  end

  unless arr[5] == ''
    s2[:name] = arr[5]
    s2[:lon] = arr[6]
    s2[:lat] = arr[7]
    s2[:elev] = arr[8]

    point = Point.new(s2[:lat].to_f, s2[:lon].to_f)
    lonlat_point = proja.inverse(point)
    s2[:lon] = lonlat_point.lon*RAD_TO_DEG
    s2[:lat] = lonlat_point.lat*RAD_TO_DEG


    case s2[:name][2..3]
    when 'sw'
      s2[:measurements] = 't'
    when 'UT'
      s2[:measurements] = 't'
    when 'SV'
      s2[:measurements] = 'p'
    else
      s2[:measurements] = 'u'
    end
  
    unless s2[:name] == 'Nr' or s2[:name][0..2] == 'Poz'
      of.write("#{s2[:name]},#{s2[:measurements]},#{s2[:lon]},#{s2[:lat]},#{s2[:elev]}\n")
    end
  end

end

#x = 5539042.28
#y = 7405086.09
#
#proja = Projection.new(['init=epsg:2178']) #http://www.spatialreference.org/ref/epsg/etrs89-poland-cs2000-zone-7/
#point = Point.new(y, x)
#lonlat_point = proja.inverse(point)
#puts lonlat_point.lon*RAD_TO_DEG, lonlat_point.lat*RAD_TO_DEG
