class CategorySerializer < ActiveModel::Serializer
  attributes :id, :depth, :taxonomy_id, :name, :parent_id, :type, :filter, :filter_parent, :filter_priority
end
