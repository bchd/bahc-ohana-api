FactoryBot.define do
  factory :tag, class: Tag do
    name { 'Education' }
  end

  factory :tag_org, class: Tag do
    name { 'Organization_tag' }
  end

  factory :tag_service, class: Tag do
    name { 'Service_tag' }
  end

  factory :recommended_tag, class: RecommendedTag do
    name { 'Recommended Search' }
  end
end
