class AddDeviceAggregationTypeToDeviceAggregation < ActiveRecord::Migration
  def change
    add_column :device_aggregations, :device_aggregation_type, :string
  end
end
