require './lib/exporters/experiment_exporter'
require './lib/exporters/stream_writer'

module Api
  module V1
    class ExperimentExporterController < Api::ApiController

      include ActionController::Live

      def show
        authorize! :read, :experiment_exporter
        experiment_id = params[:id]
        start_date = Date.parse(params[:start_date])
        end_date = Date.parse(params[:end_date])
        writer = Exporters::StreamWriter.new(response, "experiment_#{experiment_id}.csv")
        writer.init_stream("Experiment #{experiment_id} #{Time.now}")
        Exporters::ExperimentExporter.new(experiment_id, start_date, end_date).export_slices(writer)
      end

    end
  end
end
