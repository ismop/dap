class CreateContext < ActiveRecord::Migration
  def change
    create_table :contexts do |t|
      t.string "name", null: false
      t.string "type", default: "measurements", null: false
    end
  end
end
