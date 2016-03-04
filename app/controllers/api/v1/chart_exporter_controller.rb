require './lib/exporters/chart_exporter'
require './lib/exporters/stream_writer'

module Api
  module V1
    class ChartExporterController < Api::ApiController

      def index
        authorize! :read, :chart_exporter
        if params[:parameters]
          parameters = params[:parameters].split(',')
          time_from = Time.parse(params[:time_from]).utc.to_s unless params[:time_from].blank?
          time_to = Time.parse(params[:time_to]).utc.to_s unless params[:time_to].blank?
          writer = Exporters::StreamWriter.new(response, "chart.csv")
          writer.init_stream(heading(parameters, time_from, time_to))
          exporter = Exporters::ChartExporter.new(parameters, time_from, time_to)
          exporter.export_slices(writer, 5)
        else
          render nothing: true, status: 200
          return
        end

      end

      def heading(parameters, time_from, time_to)
        time_boundaries = "[" + (time_from.blank? ? "-inf" : time_from) + ", "
        time_boundaries += (time_to.blank? ? "inf" : time_to) + "]"
        "Parameters #{parameters.to_s} in time period #{time_boundaries}"
      end

    end
  end
end




