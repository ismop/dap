require './lib/exporters/experiment_exporter'

module Api
  module V1
    class ExperimentExporterController < Api::ApiController

      def show
        authorize! :read, :experiment_exporter
        experiment_id = params[:id]
        exporter = Exporters::ExperimentExporter.new(experiment_id)
        writer = StreamWriter.new(response, "experiment.csv")
        exporter.export2(writer)
        # send_file(file,
        #           :filename => "experiment.csv",
        #           :type => "text/csv")
      ensure
        response.stream.close
      end

      class StreamWriter

        def initialize(response, filename)
          @response = response
          @filename = filename
          @first_write = true
        end

        def write(data)
          if @first_write
            @response.headers['Content-Type'] = 'Application/octet-stream'
            @response.headers['Content-Disposition'] = 'attachment; filename="' + @filename + '"'
            @response.headers['X-Accel-Buffering'] = 'no'
            @first_read = false
          end
          @response.stream.write data
        end

      end

    end
  end
end




