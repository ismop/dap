namespace :experiment do
  task experiment4: :environment do
    d = Device.find_by(custom_id: 'Pomiar wysokości fali powodziowej')
    ctx = Context.find_by(context_type: 'scenarios')

    t = Timeline.create(label: 'Wysokość fali. Eksperyment 4',
                        parameter: d.parameters.first, context: ctx)

    start = Time.new(2016, 9, 13, 11, 35)
    Experiment.create(name: 'Eksperyment 4',
                      description: 'Zalewanie wału - eksperyment 4',
                      start_date: start,
                      end_date: start + 216.hours,
                      levee: Levee.first, timelines: [t])

    f = ->(x) { 3.88 / 96 * x + 0.12 }
    (0..96).each do |x|
      Measurement.create(value: f.call(x),
                         m_timestamp: start + x.hours,
                         timeline: t)
    end

    f = ->(x) { 4.0 / 120 * x }
    119.downto(0).each do |x|
      Measurement.create(value: f.call(x),
                         m_timestamp: start + (97 + 119 - x).hours,
                         timeline: t)
    end
  end

  task prepare_august_flooding: :environment do
    d = Device.find_by(custom_id: 'Pomiar wysokości fali powodziowej')
    ctx = Context.find_by(context_type: 'scenarios')

    t = Timeline.create(label: 'Wysokość fali. Eksperyment - sierpień',
                        parameter: d.parameters.first, context: ctx)

    start = Time.new(2016, 8, 26, 9, 30)
    Experiment.create(name: 'Eksperyment - sierpień',
                      description: 'Zalewanie wału - sierpień 2016',
                      start_date: start,
                      end_date: start + 60.hours,
                      levee: Levee.first, timelines: [t])

    f = ->(x) { 2.0 / 24 * x }
    (0..24).each do |x|
      Measurement.create(value: f.call(x),
                         m_timestamp: start + x.hours,
                         timeline: t)
    end

    f = ->(x) { 2.0 / 36 * x }
    35.downto(0).each do |x|
      Measurement.create(value: f.call(x),
                         m_timestamp: start + (25 + 35 - x).hours,
                         timeline: t)
    end
  end

  desc "Creates   entities for first flooding registered in dap platform"
  task prepare_first_flooding: :environment do

    d = Device.find_or_create_by(custom_id: 'Pomiar wysokości fali powodziowej')
    mt = MeasurementType.find_or_create_by(name: 'Wysokość fali', unit: 'cm')
    mt.save

    if d.parameters.blank?
      p = Parameter.find_or_create_by(measurement_type: mt, parameter_name: 'wysokość fali', custom_id: 'wave_height')
      p.save
      d.parameters << p
    end

    d.save
    d.reload

    ctx = Context.find_by(context_type: "scenarios")
    if ctx.nil?
      ctx = Context.new(name: "Scenariusze", context_type: "scenarios")
      ctx.save
    end

    t = Timeline.new(label: "wysokość fali. eksperyment zalewania - czerwiec", parameter: d.parameters.first, context: ctx)

    e = Experiment.new(name: "Eksperyment zalewania - czerwiec", description: 'Zalewanie wału - czerwiec 2016',
                       start_date: Time.at(0), end_date: Time.at(0) + 84.hours, levee: Levee.first, timelines: [t])
    e.save
    d.parameters.first.timelines << t

    # Create measurements for this experiment
    measurements = [0, 0.0833333333, 0.1666666667, 0.25, 0.3333333333, 0.4166666667, 0.5, 0.5833333333, 0.6666666667,
        0.75, 0.8333333333, 0.9166666667, 1, 1.0833333333, 1.1666666667, 1.25, 1.3333333333, 1.4166666667,
        1.5, 1.5833333333, 1.6666666667, 1.75, 1.8333333333, 1.9166666667, 2, 2.0833333333, 2.1666666667,
        2.25, 2.3333333333, 2.4166666667, 2.5, 2.5833333333, 2.6666666667, 2.75, 2.8333333333,
        2.9166666667, 3, 2.925, 2.85, 2.775, 2.7, 2.625, 2.55, 2.475, 2.4, 2.325, 2.25, 2.175, 2.1, 2.025,
        1.95, 1.875, 1.8, 1.725, 1.65, 1.575, 1.5, 1.425, 1.35, 1.275, 1.2, 1.125, 1.05, 0.975, 0.9, 0.825,
        0.75, 0.675, 0.6, 0.525, 0.45, 0.375, 0.3, 0.2833333333, 0.2666666667, 0.25, 0.2333333333,
        0.2166666667, 0.2, 0.1833333333, 0.1666666667, 0.15, 0.1333333333, 0.1166666667, 0.1]

    m_timestamp = e.start_date
    measurements.each do |m|
      ms = Measurement.new(value: m, m_timestamp: m_timestamp, timeline: t)
      ms.save
      m_timestamp += 1.hour
    end
  end

  desc "Removes experiments Experiment 01 to 99"
  task remove_test: :environment do
    (1..99).each do |n|
      e = Experiment.find_by(name: "Eksperyment #{format('%02d', n)}")
      unless e.nil?
        e.destroy
      else
        break;
      end
    end
  end

  desc "Creates a sample Experiment in the DB"
  task :create_sample => :environment do

    d = Device.find_or_create_by(custom_id: 'Pomiar wysokości fali powodziowej')
    mt = MeasurementType.find_or_create_by(name: 'Wysokość fali', unit: 'cm')
    mt.save

    if d.parameters.blank?
      p = Parameter.find_or_create_by(measurement_type: mt, parameter_name: 'wysokość fali', custom_id: 'wave_height')
      p.save
      d.parameters << p
    end

    d.save
    d.reload

    t = Timeline.new(label: "wysokość fali - eksperyment #{Experiment.count + 1}",
                     parameter: d.parameters.first)

    e = Experiment.new(name: "Eksperyment #{format('%02d', Experiment.count + 1)}", description: 'Eksperyment testowy',
                       start_date: Time.now, end_date: Time.now + 1.week, levee: Levee.first, timelines: [t])
    e.save
    d.parameters.first.timelines << t
    # Create some measurements for this experiment

    m_timestamp = e.start_date
    while m_timestamp < e.end_date do
      m = Measurement.new(value: rand(200)+500, m_timestamp: m_timestamp, timeline: t)
      m.save
      m_timestamp += 1.hour
    end
  end

end
