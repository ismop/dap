namespace :experiment do
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

    e = Experiment.new(name: "Eksperyment #{Experiment.count + 1}", description: 'Eksperyment testowy',
                       start_date: Time.now, end_date: Time.now + 1.week, levee: Levee.first, timelines: [t])
    e.save
    d.parameters.first.timelines << t
    # Create some measurements for this experiment

    m_timestamp = e.start_date
    while m_timestamp < e.end_date do
      m = Measurement.new(value: rand(200)+500, timestamp: m_timestamp, timeline: t)
      m.save
      m_timestamp += 1.hour
    end
  end
end
