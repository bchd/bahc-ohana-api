module TagHelper
  def tag_select_options(tags)
    tags.map {|tag| [ tag.name, tag.id ]}
  end
end
