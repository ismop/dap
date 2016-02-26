require './lib/exporters/experiment_exporter'

module Api
  module V1
    class ExperimentExporterController < Api::ApiController

      include ActionController::Live

      def show
        authorize! :read, :experiment_exporter
        experiment_id = params[:id]
        writer = StreamWriter.new(response, "experiment_#{experiment_id}.csv")
        writer.init_stream("Experiment #{experiment_id} #{Time.now}")
        Exporters::ExperimentExporter.new(experiment_id).export_slices(writer)
      ensure
        writer.close
      end

      class StreamWriter

        def initialize(response, filename)
          @response = response
          @filename = filename
        end

        def init_stream(content_header = nil)
          @response.headers['Content-Type'] = 'text/event-stream'
          @response.headers['Content-Disposition'] = 'attachment; filename="' + @filename + '"'
          @response.headers['X-Accel-Buffering'] = 'no'
          @response.stream.write(content_header + "\n") unless content_header.blank?
        end

        def write(data)
          @response.stream.write data
        end

        def close
          @response.stream.close
        end

      end
    end
  end
end
