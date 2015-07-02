class AddReferences < ActiveRecord::Migration
  def change

    add_reference :profiles, :section, references: :sections, index: true, null: true

    Profile.all.each do |p|

      if p.shape.blank?
        puts "!!WARNING: Profile  #{p.id} has no shape. Skipping."
        next
      end

      section = Section.create do |s|
        s.shape = p.shape
        s.levee = p.levee
      end

      p.section = s
      p.save

    end

    remove_reference :profiles, :levee

    add_reference :devices, :section, references: :sections, index: true, null: true
    add_reference :devices, :levee, references: :levees, index: true, null: true
    add_reference :device_aggregations, :section, references: :sections, index: true, null: true
    add_reference :device_aggregations, :levee, references: :levees, index: true, null: true
  end
end
