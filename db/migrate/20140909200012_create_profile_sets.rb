class CreateProfileSets < ActiveRecord::Migration
  def change
    create_table :profile_sets, id: false do |t|
      t.references :experiment
      t.references :profile
    end

    add_index :profile_sets, [:experiment_id, :profile_id]
    add_index :profile_sets, :experiment_id
    add_index :profile_sets, :profile_id
  end
end
