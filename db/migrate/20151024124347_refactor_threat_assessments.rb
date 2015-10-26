class RefactorThreatAssessments < ActiveRecord::Migration
  def change
    drop_table :threat_assessments

    remove_column :results, :profile_id

    create_table :threat_assessment_runs do |t|
      t.string :name,                    null:false, default: "Unnamed threat assessment run"
      t.string :status,                  null:false, default: "unknown"
      t.timestamp :start_date,           null:false
      t.timestamp :end_date,             null:true

      t.references :experiment

      t.timestamps
    end

    add_index :threat_assessment_runs, :start_date, unique: false
    add_index :threat_assessment_runs, :end_date, unique: false

    create_table :threat_assessments do |t|

      t.references :threat_assessment_run
      t.references :profile

      t.timestamps
    end

    add_column :results, :rank, :integer
    add_column :results, :payload, :string

  end
end
