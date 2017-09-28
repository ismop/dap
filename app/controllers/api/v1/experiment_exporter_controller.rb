require './lib/exporters/experiment_exporter'
require './lib/exporters/stream_writer'

module Api
  module V1
    class ExperimentExporterController < Api::ApiController

      include ActionController::Live

      def show
        authorize! :read, :experiment_exporter
        experiment_id = params[:id]
        levee_id = params[:levee_id]
        start_date = Date.parse(params[:start_date]) if params[:start_date]
        end_date = Date.parse(params[:end_date]) if params[:start_date]
        if experiment_id.present?
          writer_name = "experiment_#{experiment_id}.csv"
          stream_name = "Experiment #{experiment_id} #{Time.now}"
        else
          writer_name = "levee_#{levee_id}.csv"
          stream_name = "Levee #{levee_id} #{Time.now}"
        end
        writer = Exporters::StreamWriter.new(response, writer_name)
        writer.init_stream(stream_name)
        Exporters::ExperimentExporter.new(experiment_id, levee_id, start_date, end_date).export_slices(writer)
      end

    end
  end
end
