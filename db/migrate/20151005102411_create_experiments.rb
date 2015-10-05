class CreateExperiments < ActiveRecord::Migration
  def change
    create_table :experiments do |t|

      t.datetime  :start_date
      t.datetime  :end_date

      t.string    :name
      t.text      :description

      t.belongs_to :levee

    end

    add_reference :timelines, :experiment, index: true
  end
end
