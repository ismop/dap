class LeveeSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :emergency_level, :threat_level, :threat_level_updated_at
end