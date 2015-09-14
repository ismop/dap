class CreateWeatherStations < ActiveRecord::Migration
  def change
    create_table :weather_stations do |t|

      t.belongs_to :device
    end
  end
end
