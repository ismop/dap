class AddLeveeIdToProfile < ActiveRecord::Migration
  def change
    change_table :profiles do |p|
      p.references :levee, index: true
    end
  end
end
