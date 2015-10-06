class AddLabelToTimelines < ActiveRecord::Migration
  def change
    change_table :timelines do |t|
      t.string :label
    end
  end
end
