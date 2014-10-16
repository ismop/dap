class CreateProfileType < ActiveRecord::Migration
  def change
    create_table :profile_types do |t|
    end
    add_reference :scenarios, :profile_type, references: :profile_types, index: true
    add_reference :profiles, :profile_type, references: :profile_types, index: true

  end
end
