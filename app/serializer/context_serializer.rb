class ContextSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :context_type

end