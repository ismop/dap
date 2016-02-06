class PartitionMeasurements < ActiveRecord::Migration
  def up
    # Caution: everything done here is PGSQL-specific

    execute <<-SQL
      ALTER TABLE measurements RENAME timestamp TO m_timestamp
    SQL

    # DB2-style range partitioning
    puts "Creating new master table..."
    execute <<-SQL
      CREATE TABLE IF NOT EXISTS measurements_new(
        id SERIAL,
        "value" DOUBLE PRECISION NOT NULL,
        m_timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
        source_address CHARACTER VARYING(255),
        timeline_id INTEGER)
     SQL

    # Create child tables for each month
    puts "Spawning partitions..."

    # Special partition for simulation data
    execute <<-SQL
      CREATE TABLE IF NOT EXISTS measurements_child_1970_01_01 (
        CONSTRAINT pk_1970_01_01 PRIMARY KEY(id),
        CONSTRAINT ck_1970_01_01 CHECK ( m_timestamp >= '1970-01-01' AND m_timestamp < '2015-01-01' )
        ) INHERITS (measurements_new);
      CREATE INDEX idx_timestamp_1970_01_01 ON measurements_child_1970_01_01 (m_timestamp);
      CREATE INDEX idx_timeline_1970_01_01 ON measurements_child_1970_01_01 (timeline_id);
    SQL

    base_date = Date.parse('2015-01-01')
    for i in 0..60 do
      not_before = base_date.to_s
      not_before_name = not_before.gsub('-','_')
      before = (base_date+1.month).to_s
      puts "Creating partition for timestamps between #{not_before} and #{before}"
      execute <<-SQL
        CREATE TABLE IF NOT EXISTS measurements_child_#{not_before_name} (
          CONSTRAINT pk_#{not_before_name} PRIMARY KEY(id),
          CONSTRAINT ck_#{not_before_name} CHECK ( m_timestamp >= '#{not_before}' AND m_timestamp < '#{before}' )
        ) INHERITS (measurements_new);
        CREATE INDEX idx_timestamp_#{not_before_name} ON measurements_child_#{not_before_name} (m_timestamp);
        CREATE INDEX idx_timeline_#{not_before_name} ON measurements_child_#{not_before_name} (timeline_id);
      SQL
      base_date+=1.month
    end

    #CONSTRAINT ck_#{not_before_name} CHECK ( m_timestamp >= DATE '#{not_before}' AND m_timestamp < DATE '#{before}' )


    # Swap in new master for old master
    puts "Swapping in new master for old master..."
    execute <<-SQL
      ALTER TABLE measurements RENAME TO measurements_old;
      ALTER TABLE measurements_new RENAME TO measurements;
    SQL

    puts "Setting up insert trigger..."
    trigger_clause = <<-SQL
      IF ( NEW.m_timestamp < '2015-01-01' ) THEN
      INSERT INTO measurements_child_1970_01_01 VALUES (NEW.*);
    SQL

    base_date = Date.parse('2015-01-01')

    for i in 0..60 do
      not_before = base_date.to_s
      not_before_name = not_before.gsub('-','_')
      before = (base_date+1.month).to_s
      trigger_clause << <<-SQL
        ELSIF ( NEW.m_timestamp >= '#{not_before}' AND
        NEW.m_timestamp < '#{before}' ) THEN
        INSERT INTO measurements_child_#{not_before_name} VALUES (NEW.*);
      SQL
      base_date+=1.month
    end

    execute <<-SQL
      CREATE OR REPLACE FUNCTION fn_insert()
      RETURNS TRIGGER AS $$
        BEGIN
          #{trigger_clause}
          ELSE
            RAISE EXCEPTION 'Date out of range.  Fix the fn_insert() trigger function!';
          END IF;
        RETURN NULL;
      END;
      $$
      LANGUAGE plpgsql;
    SQL

    puts "Binding trigger to new master..."
    execute <<-SQL
      CREATE TRIGGER tr_insert BEFORE INSERT ON measurements
      FOR EACH ROW EXECUTE PROCEDURE fn_insert();
    SQL

    puts "Enabling constraint exclusion..."
    execute <<-SQL
      SET constraint_exclusion = on;
    SQL

    # Copy all data into new master table
    # Do it in batches of 10,000 records
    puts "Copying existing data to new structure..."
    for batch in 0..9999
      execute <<-SQL
        INSERT INTO measurements(value, m_timestamp, source_address, timeline_id)
          SELECT value, m_timestamp, source_address, timeline_id FROM measurements_old
          where id>=#{batch*10000} AND id < #{(batch+1)*10000}
      SQL
      puts "...#{(batch+1)*10000} records processed"
    end
  end

    # puts "Spawning partitions..."
    # for i in 0..999 do
    #   execute <<-SQL
    #     CREATE TABLE IF NOT EXISTS measurements_child_#{i.to_s} (
    #       CONSTRAINT pk_#{i.to_s} PRIMARY KEY(id),
    #       CONSTRAINT ck_#{i.to_s} CHECK ( timeline_id % 1000 = #{i} )
    #     ) INHERITS (measurements_new);
    #     CREATE INDEX idx_timestamp_#{i.to_s} ON measurements_child_#{i.to_s} (timestamp);
    #   SQL
    # end


    # # Swap in new master for old master
    # puts "Swapping in new master for old master..."
    # execute <<-SQL
    #   ALTER TABLE measurements RENAME TO measurements_old;
    #   ALTER TABLE measurements_new RENAME TO measurements;
    # SQL
    #
    # puts "Copying existing data to new structure..."
    #   for batch in 0..9999
    #     execute <<-SQL
    #       INSERT INTO measurements(value, timestamp, source_address, timeline_id)
    #         SELECT value, timestamp, source_address, timeline_id FROM measurements_old
    #         where id>=#{batch*10000} AND id < #{(batch+1)*10000}
    #     SQL
    #     puts "...#{(batch+1)*10000} records processed"
    #   end
    # end



    # # Start by creating a new master table
    # puts "Creating new master table..."
    # execute <<-SQL
    #   CREATE TABLE IF NOT EXISTS measurements_new (
    #     id SERIAL,
    #     "value" DOUBLE PRECISION NOT NULL,
    #     "timestamp" TIMESTAMP WITH TIME ZONE NOT NULL,
    #     source_address CHARACTER VARYING(255),
    #     timeline_id INTEGER)
    # SQL
    #
    # # Create 1000 child tables
    # puts "Spawning partitions..."
    # for i in 0..999 do
    #   execute <<-SQL
    #     CREATE TABLE IF NOT EXISTS measurements_child_#{i.to_s} (
    #       CONSTRAINT pk_#{i.to_s} PRIMARY KEY(id),
    #       CONSTRAINT ck_#{i.to_s} CHECK ( timeline_id % 1000 = #{i} )
    #     ) INHERITS (measurements_new);
    #     CREATE INDEX idx_timestamp_#{i.to_s} ON measurements_child_#{i.to_s} (timestamp);
    #   SQL
    # end
    #
    # # Swap in new master for old master
    # puts "Swapping in new master for old master..."
    # execute <<-SQL
    #   ALTER TABLE measurements RENAME TO measurements_old;
    #   ALTER TABLE measurements_new RENAME TO measurements;
    # SQL
    #
    # puts "Setting up insert trigger..."
    # execute <<-SQL
    #   CREATE OR REPLACE FUNCTION fn_insert()
    #   RETURNS TRIGGER AS $$
    #   DECLARE
    #     partition_no INTEGER;
    #     partition_name TEXT;
    #   BEGIN
    #     partition_no := NEW.timeline_id%1000;
    #     partition_name := 'measurements_child_' || partition_no;
    #     EXECUTE format('INSERT INTO %I VALUES (%L, %L, %L, %L, %L);', partition_name, NEW.id, NEW.value, NEW.timestamp, NEW.source_address, NEW.timeline_id);
    # 	  RETURN NULL;
    #   END;
    #   $$
    #   LANGUAGE plpgsql;
    # SQL
    #
    # puts "Binding trigger to new master..."
    # execute <<-SQL
    #   CREATE TRIGGER tr_insert BEFORE INSERT ON measurements
    #   FOR EACH ROW EXECUTE PROCEDURE fn_insert();
    # SQL
    #
    # puts "Enabling constraint exclusion..."
    # execute <<-SQL
    #   SET constraint_exclusion = on;
    # SQL

    # Copy all data into new master table
    # Do it in batches of 10,000 records
  #   puts "Copying existing data to new structure..."
  #   for batch in 0..9999
  #     execute <<-SQL
  #       INSERT INTO measurements(value, timestamp, source_address, timeline_id)
  #         SELECT value, timestamp, source_address, timeline_id FROM measurements_old
  #         where id>=#{batch*10000} AND id < #{(batch+1)*10000}
  #     SQL
  #     puts "...#{(batch+1)*10000} records processed"
  #   end
  # end

  def down
    #raise ActiveRecord::IrreversibleMigration, "Cannot (easily) unpartition the measurements table. If you really need this reverted, contact PN for support."
  end

end
