class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.float :similarity,                    null:true

      t.references :threat_assessment
      t.references :profile
      t.references :timeline

    end
  end
end
