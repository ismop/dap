class CreateSectionType < ActiveRecord::Migration
  def change
    create_table :section_types do |t|
    end
    add_reference :scenarios, :section_type, references: :section_types, index: true
    add_reference :sections, :section_type, references: :section_types, index: true

  end
end
