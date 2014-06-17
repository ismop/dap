class CreateActivityStates < ActiveRecord::Migration
  def change
    create_table :activity_states do |t|
      t.string :name,               null:false, default:"unnamed activity"
      t.timestamps
    end

  end
end
