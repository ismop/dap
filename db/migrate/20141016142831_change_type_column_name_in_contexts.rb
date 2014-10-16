class ChangeTypeColumnNameInContexts < ActiveRecord::Migration
  def change
    rename_column :contexts, :type, :context_type
  end
end
