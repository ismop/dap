module Api
  module V1
    class MeasurementsController < Api::ApiController
      load_and_authorize_resource :measurement
      respond_to :json

      def index

        if params.keys.include? 'quantity'
          sql = "SELECT m.* FROM (SELECT *, row_number() OVER(ORDER BY id ASC) AS row FROM measurements) m "
        else
          sql = "SELECT m.* FROM measurements m "
        end

        sql += "JOIN timelines t ON m.timeline_id = t.id "

        result = []

        if params.keys.include? "time_from"
          time_from = Time.parse(params[:time_from]).utc.to_s
          params[:time_from] = nil
        else
          time_from = '1980-01-01'
        end
        if params.keys.include? "time_to"
          time_to = Time.parse(params[:time_to]).utc.to_s
          params[:time_to] = nil
        else
          time_to = '2100-01-01'
        end

        sql += "WHERE m.timestamp BETWEEN '#{time_from}' AND '#{time_to}' "

        if params.keys.include? "id"
          sql += " AND m.id IN (#{params[:id].to_s})"
          params[:id] = nil
        end

        if params.keys.include? "sensor_id"
          sql += " AND t.sensor_id IN (#{params[:sensor_id].to_s})"
          params[:sensor_id] = nil
        end

        if params.keys.include? "context_id"
          sql += " AND t.context_id IN (#{params[:context_id].to_s})"
          params[:context_id] = nil
        end

        if params.keys.include? 'quantity'

          # Run a preliminary query to determine how many results will be retrieved
          count_measurements = sql.sub 'SELECT m.*', 'SELECT COUNT(m.*)'
          count_timelines = sql.sub('SELECT m.*', 'SELECT COUNT(DISTINCT m.timeline_id)')

          @connection = ActiveRecord::Base.connection
          m_r = @connection.exec_query(count_measurements)
          t_r = @connection.exec_query(count_timelines)
          m_qty = m_r.first['count'].to_i
          t_qty = t_r.first['count'].to_i
          sql += " AND m.row % #{((m_qty/(params[:quantity].to_i))/t_qty).to_i} = 0 "
        end

        if params.keys.include? 'limit'
          result = []
          timelines = []
          if params[:limit] == 'first'
            sql += " ORDER BY m.timeline_id, m.timestamp ASC"
          else
            sql += " ORDER BY m.timeline_id, m.timestamp DESC"
          end

          Measurement.find_by_sql(sql).each.each do |m|
            if timelines.include? m.timeline
              # Do nothing
            else
              result << m
              timelines << m.timeline
            end
          end
        else
          sql += " ORDER BY m.timeline_id"
          ms = Measurement.find_by_sql(sql)
          if ms.blank?
            result = []
          else
            result = ms
          end
        end

        respond_with result
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
        params.require(:measurement).permit(:value, :timestamp, :source_address)
      end
    end
  end
end