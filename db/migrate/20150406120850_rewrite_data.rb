class RewriteData < ActiveRecord::Migration
  # This migration adapts existing production data to suit the new model
  def change
    sensors = execute("SELECT * FROM sensors")
    # Assume all sensors are Budokop sensors
    sensors.each do |s|

      # Give up if no measurement type is defined
      if s['measurement_type_id'].blank?
        puts "!!WARNING: Sensor #{s['custom_id']} has no measurement type. Skipping."
        next
      end

      if s['section_id'].blank?
        insert = "INSERT INTO device_aggregations(custom_id, placement, section_id) \
                VALUES ('#{s['custom_id']}_aggregation', '#{s['placement']}', NULL) RETURNING id"
      else
        insert = "INSERT INTO device_aggregations(custom_id, placement, section_id) \
                VALUES ('#{s['custom_id']}_aggregation', '#{s['placement']}', #{s['section_id']}) RETURNING id"
      end

      puts "INSERT: #{insert}"

      id = execute(insert)

      puts "ID: #{id.inspect}"
      puts "ID: #{id.first.inspect}"
      agg_id = id.first['id']

      if s['section_id'].blank?
        insert = "INSERT INTO devices(custom_id, placement, device_type, section_id, device_aggregation_id) \
                VALUES ('#{s['custom_id']}', '#{s['placement']}', 'budokop_sensor', \
                NULL, #{agg_id}) RETURNING id"
      else
        insert = "INSERT INTO devices(custom_id, placement, device_type, section_id, device_aggregation_id) \
                VALUES ('#{s['custom_id']}', '#{s['placement']}', 'budokop_sensor', \
                #{s['section_id']}, #{agg_id}) RETURNING id"
      end

      id = execute(insert)
      dev_id = id.first['id']

      insert = "INSERT INTO budokop_sensors(battery_state, battery_capacity, manufacturer, model, serial_number, \
                firmware_version, manufacture_date, purchase_date, warranty_date, deployment_date, \
                last_state_change, device_id) \
                VALUES('#{s['battery_state']}', '#{s['battery_capacity']}', '#{s['manufacturer']}', \
                '#{s['model']}', '#{s['serial_number']}', '#{s['firmware_version']}', '#{s['manufacture_date']}', \
                '#{s['purchase_date']}', '#{s['warranty_date']}', '#{s['deployment_date']}', \
                '#{s['last_state_change']}', #{dev_id}) RETURNING id"

      id = execute(insert)
      b_s_id = id.first['id']

      insert = "INSERT INTO parameters(parameter_name, device_id, measurement_type_id) \
                VALUES('parameter_1', #{dev_id.to_s}, #{s['measurement_type_id']}) RETURNING id"

      id = execute(insert)
      p_id = id.first['id']

      update = "UPDATE timelines SET parameter_id = #{p_id.to_s} WHERE sensor_id = #{s['id'].to_s}"
      execute(update)

    end
  end
end
