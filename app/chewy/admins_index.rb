class AdminsIndex < Chewy::Index
  index_scope Admin

  field :name, type: 'text'
  field :email, type: 'keyword'
  field :super_admin, type: 'boolean'
  field :domain, type: 'keyword'
end
