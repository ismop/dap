class UpdateScenarioModel < ActiveRecord::Migration
  def up
    add_column :scenarios, :name, :string
    add_column :scenarios, :description, :text

    remove_column :scenarios, :file_name
    remove_column :scenarios, :payload
    remove_column :scenarios, :context_id
    remove_column :scenarios, :profile_type_id
    remove_column :scenarios, :threat_level
  end

  def down

    add_column :scenarios, :file_name, :string
    add_column :scenarios, :payload, :binary, limit: 2.megabytes
    add_column :scenarios, :threat_level, :string, default:'none' # Allowed values: none, heightened, severe

    add_reference :scenarios, :context, index: true
    add_reference :scenarios, :profile_type, index: true

    remove_column :scenarios, :name
    remove_column :scenarios, :description
  end

end
