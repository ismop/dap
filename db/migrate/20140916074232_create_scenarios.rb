class CreateScenarios < ActiveRecord::Migration
  def change
    create_table :scenarios do |t|

      t.string :file_name
      t.binary :payload, null: false, limit: 2.megabytes

    end
  end
end
