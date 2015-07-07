class CreateSection < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.spatial :shape
    end
    add_reference :sections, :levee, references: :levees, index: true
  end
end
