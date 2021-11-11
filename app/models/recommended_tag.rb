class RecommendedTag < ApplicationRecord
  include HandleTags

  def self.active
    where(active: true)
  end

  def as_json(opts = {})
    {
      name: name,
      tags: tags.map(&:name)
    }
  end
end
