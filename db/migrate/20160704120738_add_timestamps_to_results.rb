class AddTimestampsToResults < ActiveRecord::Migration
  def change
    change_table :results do |t|
      t.timestamps
    end
  end
end
