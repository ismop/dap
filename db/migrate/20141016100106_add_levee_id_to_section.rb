class AddLeveeIdToSection < ActiveRecord::Migration
  def change
    change_table :sections do |p|
      p.references :levee, index: true
    end
  end
end
