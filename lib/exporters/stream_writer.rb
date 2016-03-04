module Exporters
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