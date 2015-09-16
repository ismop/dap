module Api
  module V1
    class MeasurementsController < Api::ApiController
      load_and_authorize_resource :measurement
      respond_to :json

      def index
        query = @measurements

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

        query = query.where(timestamp: time_from..time_to)

        if params.keys.include? "sensor_id"
          query = query.includes(:timeline).references(:timelines).where(:timelines => { sensor_id: params[:sensor_id].to_s.split(',') })
          params[:sensor_id] = nil
        end

        if params.keys.include? "context_id"
          query = query.includes(:timeline).references(:timelines).where(:timelines => { context_id: params[:context_id].to_s.split(',') })
          params[:context_id] = nil
        end

        if params.keys.include? "limit"
          case params[:limit]
            when 'first'
              query = query.where(filter).order(:timestamp)
              respond_with [query.first]
            when 'last'
              query = query.where(filter).order(:timestamp)
              respond_with [query.last]
            when 'each_timeline_last'
              map = Hash.new
              query.where(filter).order(:timeline_id).each do |x|
                existing = map[x.timeline_id]
                if existing.nil? || (x.timestamp - existing.try(:timestamp)) > 0
                  map[x.timeline_id] = x
                end
              end
              respond_with map.sort.map{ |k,v| v }
          end
        else
          respond_with query.where(filter).order(:id)
        end
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