class AddMoreLabels < ActiveRecord::Migration
  def up
    add_column :measurement_types, :label, :string
    execute("UPDATE measurement_types SET label ='T' WHERE name LIKE '%emperatu%'")
    execute("UPDATE measurement_types SET label ='P' WHERE name LIKE '%orowe%'")
    execute("UPDATE measurement_types SET label ='R' WHERE name LIKE '%pady%'")
    execute("UPDATE measurement_types SET label ='D' WHERE name LIKE '%erunek%'")
    execute("UPDATE measurement_types SET label ='H' WHERE name LIKE '%ilgotn%'")
    execute("UPDATE measurement_types SET label ='S' WHERE name LIKE '%dko%'")
    execute("UPDATE measurement_types SET label ='W' WHERE name LIKE '%ysoko%'")

    add_column :devices, :label, :string
    Device.all.each do |d|
      if d.custom_id[1] == ' '
        d.label = d.id.to_s+'_'+d.custom_id[2..-1]
      elsif d.custom_id.include? 'POMIARY_GESO'
        d.label = d.id.to_s+'_'+'GESO'+d.custom_id[17]+'_'+d.custom_id[24..27]
      elsif d.custom_id.include? 'swiatlo'
        d.label = d.id.to_s+'_'+'SW1'+'_'+d.custom_id[7..-1]
      elsif d.custom_id.include? 'sw'
        d.label = d.id.to_s+'_'+'SW2'+'_'+d.custom_id[2..-1]
      elsif d.custom_id.include? 'ogod'
        d.label = d.id.to_s+'_'+'WEATHER'
      else
        d.label = d.id.to_s+'_'+'UNK'
      end
      d.save
    end
  end

  def down
    remove_column :measurement_types, :label
    remove_column :devices, :label
  end
end
