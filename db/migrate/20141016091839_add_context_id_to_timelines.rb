class AddContextIdToTimelines < ActiveRecord::Migration
  def change
    add_reference :timelines, :context, index: true
  end
end
