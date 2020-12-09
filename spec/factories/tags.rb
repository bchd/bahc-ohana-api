FactoryBot.define do
  factory :tag, class: Tag do
    id { 1 }
    name { 'Education' }
  end

  factory :tag_org, class: Tag do
    id { 2 }
    name { 'Organization_tag' }
  end

  factory :tag_service, class: Tag do
    id { 3 }
    name { 'Service_tag' }
  end
end
