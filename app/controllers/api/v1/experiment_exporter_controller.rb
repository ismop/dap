require './lib/exporters/experiment_exporter'

module Api
  module V1
    class ExperimentExporterController < Api::ApiController

      def show
        authorize! :read, :experiment_exporter
        experiment_id = params[:id]
        exporter = Exporters::ExperimentExporter.new(experiment_id)
        file = exporter.export
        send_file(file,
                  :filename => "experiment.csv",
                  :type => "text/csv")
      end

    end
  end
end




