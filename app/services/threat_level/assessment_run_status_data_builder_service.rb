module ThreatLevel
  class AssessmentRunStatusDataBuilderService
    def self.get(run)
      AssessmentRunStatusDataBuilderService.new(run).get
    end

    def initialize(run)
      @run = run
      @newest_result = results.sort_by {|r| r.created_at }.last
    end

    def get
      {
        start_date: @run.start_date
      }.merge status_and_explanation
    end
    private
    def status_and_explanation
      case
      when finished?
        finished_status_and_explanation
      when started?
        started_status_and_explanation
      when running?
        running_status_and_explanation
      when warning?
        warning_status_and_explanation
      else
        error_status_and_explanation
      end
    end

    def finished?
      @run.status == 'finished'
    end

    def finished_status_and_explanation
      {
        status: :finished,
        explanation: 'Assessment run finished'
      }
    end

    def started?
      @run.start_date > (Time.now - Rails.configuration.assessment_run_startup_time.hour) && @newest_result.nil?
    end

    def results
      @run.threat_assessments.collect{|a| a.results}.flatten
    end

    def started_status_and_explanation
      {
        status: :started,
        explanation: 'Assessment run started less than one hour ago'\
                 'and has not produced any results'
      }
    end

    def running?
      @newest_result ? @newest_result.created_at > (Time.now - (startup_time + 1).hours) : false
    end

    def startup_time
      Rails.configuration.assessment_run_startup_time
    end

    def running_status_and_explanation
      {
        status: :running,
        explanation: 'Assessment run has results produced less than two hours ago'
      }
    end

    def warning?
      @run.start_date < (Time.now - startup_time.hour) &&
        ((@newest_result.nil? && @run.start_date > (Time.now - error_time.hour)) ||
          newest_result_created_in_warning_period)
    end

    def error_time
      Rails.configuration.assessment_run_error_time
    end

    def newest_result_created_in_warning_period
      return false unless @newest_result
      @newest_result.created_at < (Time.now - (startup_time + 1).hours) &&
        @newest_result.created_at > (Time.now - error_time.hours)
    end

    def warning_status_and_explanation
      {
        status: :warning,
        explanation: 'Assessment run has not produced result in the past two hours'
      }
    end

    def error_status_and_explanation
      {
        status: :error,
        explanation: 'Assessment run has not produced result in the past five hours'
      }
    end
  end
end