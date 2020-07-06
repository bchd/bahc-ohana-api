FactoryBot.define do
  factory :tag_resource, class: TagResource do
    tag_id { 1 }
    resource_id { 1 }
    resource_type { 'Service' }
  end
end
