module Api
  module V1
    class MeasurementsController < Api::ApiController
      load_and_authorize_resource :measurement
      respond_to :json

      def index

        if params.keys.include? 'quantity'
          sql = "SELECT m.* FROM (SELECT m.*, row_number() OVER(ORDER BY m.timeline_id, m.m_timestamp ASC) AS row FROM measurements m JOIN timelines t ON m.timeline_id = t.id "
        else
          sql = "SELECT m.* FROM measurements m JOIN timelines t ON m.timeline_id = t.id "
        end

        result = []
        partition_clause = ''

        if params.keys.include? "time_from"
          if params[:time_from].blank?
            render nothing: true, status: 400
            return
          end
          time_from = Time.parse(params[:time_from]).utc.to_s
          params[:time_from] = nil
        else
          time_from = '1970-01-01'
        end
        if params.keys.include? "time_to"
          if params[:time_to].blank?
            render nothing: true, status: 400
            return
          end
          time_to = Time.parse(params[:time_to]).utc.to_s
          params[:time_to] = nil
        else
          time_to = '2100-01-01'
        end

        sql += "WHERE m.m_timestamp BETWEEN '#{time_from}' AND '#{time_to}' "

        if params.keys.include? "id"
          if params[:id].blank?
            render nothing: true, status: 400
            return
          end
          sql += " AND m.id IN (#{params[:id].to_s})"
          params[:id] = nil
        end

        if params.keys.include? "timeline_id"
          if params[:timeline_id].blank?
            render nothing: true, status: 400
            return
          end
          sql += " AND m.timeline_id IN (#{params[:timeline_id].to_s})"

          # # Render special WHERE clause for partitioner
          # # This looks very weird but it is necessary for PGSQL to optimize the query correctly
          # # (the pgsql partition manager does not perform 'smart' matching of CHECK constraints
          # # and instead requires the WHERE clause to contain a literal copy of the target constraint).
          #
          # tl_ids = params[:timeline_id].split(',')
          # tl_remainders = []
          # tl_ids.each do |tl_id|
          #   tl_id_i = tl_id.to_i
          #   unless tl_id_i.blank?
          #     tl_remainders << tl_id_i % 1000
          #   end
          # end
          #
          # # Update (2015-01-05): Amazingly, the optimizer fails when the IN clause contains more than 100 entries
          # # (yes, it fails on exactly the 101th entry and instead runs a scan on the entire data structure,
          # # which is super slow). This does not occur when the IN values are fed in batches of 100. Hence...
          #
          # partition_clause = ' AND ('
          # tl_remainders_chunked = tl_remainders.each_slice(99).to_a
          # sql_chunks = []
          #
          # tl_remainders_chunked.each do |chunk|
          #   sql_chunks << "m.timeline_id%1000 IN (#{chunk.join(',')})"
          # end
          #
          # partition_clause << sql_chunks.join(' OR ')
          # partition_clause << ')'

          params[:timeline_id] = nil
        end

        if params.keys.include? "sensor_id"
          if params[:sensor_id].blank?
            render nothing: true, status: 400
            return
          end
          sql += " AND t.sensor_id IN (#{params[:sensor_id].to_s})"
          params[:sensor_id] = nil
        end

        if params.keys.include? "context_id"
          if params[:context_id].blank?
            render nothing: true, status: 400
            return
          end
          sql += " AND t.context_id IN (#{params[:context_id].to_s})"
          params[:context_id] = nil
        end

        # sql+= partition_clause

        if params[:limit] == 'first'
          sql += ' ORDER BY m.timeline_id, m.m_timestamp ASC '
        elsif params[:limit] == 'last'
          sql += ' ORDER BY m.timeline_id, m.m_timestamp DESC '
        else
          sql += ' ORDER BY m.timeline_id, m.m_timestamp ASC '
        end

        if params.keys.include? 'quantity'
          if params[:quantity].blank?
            render nothing: true, status: 400
            return
          end

          # Finalize inner SQL
          sql += ') m '

          # Run a preliminary query to determine how many results will be retrieved
          count_measurements = sql.sub 'SELECT m.*', 'SELECT COUNT(m.*)'
          count_timelines = sql.sub('SELECT m.*', 'SELECT COUNT(DISTINCT m.timeline_id)')

          @connection = ActiveRecord::Base.connection

          get_max_ids = sql.sub('(SELECT m.*', '(SELECT MAX(m.id)').
              sub('ORDER BY m.timeline_id, m.m_timestamp ASC )', 'GROUP BY m.timeline_id )').
              sub('OVER(ORDER BY m.timeline_id, m.m_timestamp ASC)', '').
              sub(', row_number()  AS row', '')
          max_ids = @connection.exec_query(get_max_ids).collect{|m| m['max'].to_i}

          m_r = @connection.exec_query(count_measurements)
          t_r = @connection.exec_query(count_timelines)
          m_qty = m_r.first['count'].to_i
          t_qty = t_r.first['count'].to_i
          divisor = 1
          if params[:quantity].to_i > 0
            divisor = m_qty/(params[:quantity].to_i)
            if t_qty > 0
              divisor = (divisor/t_qty).to_i
            end
          end
          divisor = divisor + 1
          sql += " WHERE m.row % #{divisor} = 0 "
          if max_ids.present?
            sql+= " OR m.id IN (#{max_ids.join(',')}) "
          end
        end

        if params.keys.include? 'limit'
          result = []
          timeline_ids = []

          Measurement.find_by_sql(sql).each.each do |m|
            if timeline_ids.include? m.timeline_id
              # Do nothing
            else
              result << m
              timeline_ids << m.timeline_id
            end
          end
        else
          ms = Measurement.find_by_sql(sql)
          if ms.blank?
            result = []
          else
            result = ms
          end
        end

        # Purge excess measurements when quantity is requested
        if params.keys.include? 'quantity'
          # Grab all timeline ids
          timelines = result.collect{|m| m.timeline_id}.uniq
          timelines.each do |tl|
            tl_m = result.select{|m| m.timeline_id == tl}
            excess = tl_m.length - params[:quantity].to_i
            excess.times do
              result.delete(tl_m.first)
            end
          end

        end


        respond_with result, root: 'measurements'
      end

      def show
        respond_with @measurement
      end

      def update
        @measurement.update_attributes!(measurement_params)
        render json: @measurement, serializer: MeasurementSerializer
      end

      private

      def measurement_params
        params.require(:measurement).permit(:value, :m_timestamp, :source_address)
      end
    end
  end
end
