class CreateThreatAssessments < ActiveRecord::Migration
  def change
    create_table :threat_assessments do |t|
      t.string :name,                    null:false, default: "Unnamed threat assessment"
      t.timestamp :start_date,           null:false
      t.timestamp :end_date,             null:true
      t.string :status,                  null:false, default: "unknown"
      t.string :status_message,          null:true, default: ""

      t.polygon :selection,              geographic: true, srid: 4326

      t.timestamps
    end

    add_index :threat_assessments, :start_date, unique: false
    add_index :threat_assessments, :end_date, unique: false

  end
end
