class AddContextIdToScenarios < ActiveRecord::Migration
  def change
    add_reference :scenarios, :context, index: true
  end
end
