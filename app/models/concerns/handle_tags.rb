# frozen_string_literal: true
require "active_support/concern"

module HandleTags
  extend ActiveSupport::Concern

  included do
    attr_accessor :tag_list

    before_validation :handle_tags
  end

  def handle_tags
    new_tags = tag_list.first.split(",") if tag_list.is_a? Array
    return if new_tags.blank?

    existing_tag_list = self.tags.pluck(:name)
    removable_tags = existing_tag_list - new_tags

    new_tags.each do |t|
      tag = Tag.find_or_create_by(name: t)
      self.tag_resources.find_or_initialize_by(tag_id: tag.id)
    end

    removable_tags.each do |removable_tag|
      existing_tag_object = Tag.find_by(name: removable_tag)
      self.tag_resources.where(tag_id: existing_tag_object.id).destroy_all
    end
  end
end
