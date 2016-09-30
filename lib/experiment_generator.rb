class WaveFunction
  attr_reader :interval

  def initialize(from:, to:, interval:)
    @from = from.to_f
    @to = to.to_f
    @interval = interval / 3600
  end

  def call(hour)
    (@to - @from) / @interval * hour + @from
  end
end

class ExperimentGenerator
  attr_writer :debug

  def initialize(name:, from:, to:, steps:)
    @name = name
    @from = from
    @to = to
    @steps = steps
  end

  def call
    @debug ? debug_call : real_call
  end

  private

  def debug_call
    puts "1. Creating experiment with name: #{@name}"
    puts '2. Generating experiment water wave:'
    generate_wave(lambda do |time, value|
      puts "  - measurement: #{time} -> #{value}"
    end)
  end

  def real_call
    timeline = initialize_experiment
    generate_wave(lambda do |time, value|
      Measurement.create(value: value, m_timestamp: time, timeline: timeline)
    end)
  end

  def initialize_experiment
    d = Device.find_by(custom_id: 'Pomiar wysokości fali powodziowej')
    ctx = Context.find_by(context_type: 'scenarios')
    t = Timeline.find_or_create_by(label: "Wysokość fali. #{@name}",
                                   parameter: d.parameters.first, context: ctx)

    t.measurements.destroy_all

    e = Experiment.find_or_create_by(name: @name)
    e.update_attributes(description: "Zalewanie wału - #{@name}",
                        start_date: @from, end_date: @to,
                        levee: Levee.first, timelines: [t])

    t
  end

  def generate_wave(func)
    time = @from
    @steps.each_with_index do |step, index|
      start_hour(index).upto(step.interval).each do |hour|
        func.call(time, step.call(hour))
        time += 1.hour
      end
    end
  end

  def start_hour(index)
    index.zero? ? 0 : 1
  end
end
