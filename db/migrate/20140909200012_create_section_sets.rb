class CreateSectionSets < ActiveRecord::Migration
  def change
    create_table :section_sets, id: false do |t|
      t.references :threat_assessment
      t.references :profile
    end

    add_index :section_sets, [:threat_assessment_id, :section_id]
    add_index :section_sets, :threat_assessment_id
    add_index :section_sets, :section_id
  end
end
