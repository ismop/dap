class ChangeResultTimelineReferenceToScenarioReference < ActiveRecord::Migration
  def change
    remove_reference :results, :timeline
    add_reference :results, :scenario, index: true
  end
end
