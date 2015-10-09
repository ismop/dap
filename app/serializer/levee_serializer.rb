class LeveeSerializer < ActiveModel::Serializer
  attributes :id, :name, :emergency_level, :threat_level, :threat_level_updated_at
end
