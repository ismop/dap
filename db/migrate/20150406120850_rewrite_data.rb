class RewriteData < ActiveRecord::Migration
  # This migration adapts existing production data to suit the new model
  def change
    sensors = execute("SELECT * FROM sensors")
    # Assume all sensors are Budokop sensors
    sensors.each do |s|
      insert = "INSERT INTO device_aggregations(custom_id, placement, section_id) \
                VALUES ('#{s['custom_id']}_aggregation', '#{s['placement']}', #{s['section_id']}) RETURNING id"

      puts "INSERT: #{insert}"

      id = execute(insert)

      puts "ID: #{id.inspect}"
      puts "ID: #{id.first.inspect}"
      agg_id = id.first['id']

      insert = "INSERT INTO devices(custom_id, placement, device_type, section_id) \
                VALUES ('#{s['custom_id']}', '#{s['placement']}', 'budokop_sensor', '#{s['section_id']}') RETURNING id"

      id = execute(insert)
      dev_id = id.first['id']

      insert = "INSERT INTO parameters(parameter_name, device_id, measurement_type_id) \
                VALUES('parameter_1', #{dev_id.to_s}, #{s['measurement_type_id']}) RETURNING id"

      id = execute(insert)
      p_id = id.first['id']

      update = "UPDATE timelines SET parameter_id = #{p_id.to_s} WHERE sensor_id = #{s['id'].to_s}"
      execute(update)

    end
  end
end
