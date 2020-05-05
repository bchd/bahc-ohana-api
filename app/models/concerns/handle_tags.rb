# frozen_string_literal: true
require "active_support/concern"

module HandleTags
  extend ActiveSupport::Concern

  included do
    has_many :tag_resources, as: :resource, autosave: true
    has_many :tags, through: :tag_resources, source: :tag
    accepts_nested_attributes_for :tag_resources,
                                  allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :tags,
                                  allow_destroy: true, reject_if: :all_blank

    attr_accessor :tag_list

    before_validation :handle_tags
  end

  def handle_tags
    self.tag_list = tag_list.first.split(",") if tag_list.is_a? Array
    return if tag_list.blank?

    existing_tag_list = self.tags.pluck(:name)
    removable_tags = existing_tag_list - tag_list

    tag_list.each do |t|
      tag = Tag.find_or_create_by(name: t)
      self.tag_resources.find_or_initialize_by(tag_id: tag.id)
    end

    removable_tags.each do |removable_tag|
      existing_tag_object = Tag.find_by(name: removable_tag)
      # NOTE: Instead of using `delete_all` here, it would be good if we mark these records
      # as `mark_for_destruction` so Rails will take care of it.
      self.tag_resources.where(tag_id: existing_tag_object.id).delete_all
    end
  end
end
