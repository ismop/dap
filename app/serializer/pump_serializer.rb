class PumpSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :manufacturer, :model, :manufacture_date, :purchase_date, :deployment_date, :last_state_change, :device_id
end
