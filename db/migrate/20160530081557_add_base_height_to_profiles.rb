class AddBaseHeightToProfiles< ActiveRecord::Migration
  def change
    change_table :profiles do |t|

      t.float :base_height

    end
  end
end
