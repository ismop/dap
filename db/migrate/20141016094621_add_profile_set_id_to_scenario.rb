class AddProfileSetIdToScenario < ActiveRecord::Migration
  def change
    add_reference :scenarios, :profile_set, index: true
  end
end
