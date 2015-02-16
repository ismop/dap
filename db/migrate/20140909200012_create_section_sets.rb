class CreateSectionSets < ActiveRecord::Migration
  def change
    create_table :section_sets, id: false do |t|
      t.references :experiment
      t.references :section
    end

    add_index :section_sets, [:experiment_id, :section_id]
    add_index :section_sets, :experiment_id
    add_index :section_sets, :section_id
  end
end
