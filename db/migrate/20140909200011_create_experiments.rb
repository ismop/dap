class CreateExperiments < ActiveRecord::Migration
  def change
    create_table :experiments do |t|
      t.string :name,                    null:false, default: "Unnamed experiment"
      t.timestamp :start_date,           null:false
      t.timestamp :end_date,             null:true
      t.string :status,                  null:false, default: "unknown"
      t.string :status_message,          null:true, default: ""

      t.polygon :selection,              geographic: true, srid: 4326

      t.timestamps
    end

    add_index :experiments, :start_date, unique: false
    add_index :experiments, :end_date, unique: false

  end
end
