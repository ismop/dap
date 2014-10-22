class AddDefaultToContextType < ActiveRecord::Migration
  def change
    change_column :contexts, :context_type, :string, default: "tests", null: false
  end
end
