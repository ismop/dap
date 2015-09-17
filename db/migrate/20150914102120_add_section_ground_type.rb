class AddSectionGroundType < ActiveRecord::Migration
  def change
    create_table :ground_types do |t|
      t.string :label,             null: false, default: 'unknown ground type'
      t.string :description
    end

    add_reference :sections, :ground_type, references: :ground_types, index: true, null: true

  end
end
