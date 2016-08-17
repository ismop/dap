class AddOffsetToResult < ActiveRecord::Migration
  def up
    add_column :results, :offset, :integer, null: true
  end

  def down
    remove_column :results, :offset
  end
end
