require './lib/exporters/chart_exporter'

module Api
  module V1
    class ChartExporterController < Api::ApiController

      def index
        authorize! :read, :chart_exporter
        if params[:parameters]
          parameters = params[:parameters].split(',')
          time_from = Time.parse(params[:time_from]).utc.to_s unless params[:time_from].blank?
          time_to = Time.parse(params[:time_to]).utc.to_s unless params[:time_to].blank?
          exporter = Exporters::ChartExporter.new(parameters, time_from, time_to)
          file = exporter.export
          send_file(file,
                    :filename => "chart.csv",
                    :type => "text/csv")
        else
          render nothing: true, status: 200
          return
        end

      end

    end
  end
end




