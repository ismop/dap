class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.float :similarity,                    null:true

      t.references :experiment
      t.references :profile
      t.references :timeline

    end
  end
end
