namespace :data do
  task fix_timelines: :environment do
    allps = Parameter.all
    zerops = Parameter.all.select{|p| p.timelines.length == 0}
    lowps = Parameter.all.select{|p| p.timelines.length == 1}
    ps = Parameter.all.select{|p| p.timelines.length > 1}
    puts "Total parameter count: #{allps.length}"
    puts "#{zerops.length} parameters have no timelines"
    puts "#{lowps.length} parameters have 1 timeline and will be skipped"
    puts "Processing #{ps.length} parameters"
    cntr = 1
    ps.each do |p|
      puts "Processing parameter #{cntr} of #{ps.length}..."
      cntr+=1

      tt = p.timelines.select {|t| t.context_id == 1}

      if tt.length == 0
        puts "No target timeline could be found for parameter with ID #{p.id}. Skipping."
        next
      else
        tt = tt.first
      end

      puts "Target timeline: #{tt.id}"

      tts = p.timelines.select {|t| t.context_id > 1}
      puts "There are #{tts.length} timelines registered for this parameter"

      tts.each do |t|
        mss = t.measurements
        mss_s = mss.select {|m| m.timestamp > Date.parse("2015-11-01")}
        if mss_s.length > 0
          puts "Reassigning #{mss_s.length} of #{mss.length} measurements from timeline #{t.id} to timeline #{tt.id}"
          mss_s.each do |m|
            m.timeline = tt
            m.save
          end
        end
      end
    end
  end
end

# Parameter.find(1569) - wave height