# frozen_string_literal: true

require 'active_support/concern'

module HandleTags
  extend ActiveSupport::Concern

  included do
    attr_accessor :tag_list

    has_many :tag_resources, as: :resource, autosave: true
    has_many :tags, through: :tag_resources, source: :tag
    accepts_nested_attributes_for :tag_resources,
                                  allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :tags,
                                  allow_destroy: true, reject_if: :all_blank

    before_validation :handle_tags
  end

  def tag_list_to_str
    tags.pluck(:name).join(',')
  end

  private

  def handle_tags
    return if tag_list.blank?

    tag_list.each do |t|
      tag = Tag.find_or_create_by(name: t)
      tag_resources.find_or_initialize_by(tag_id: tag.id)
    end

    removable_tags.each do |removable_tag|
      existing_tag = Tag.find_by(name: removable_tag)
      tag_resources.where(tag_id: existing_tag.id).delete_all
    end
  end

  def removable_tags
    return @removable_tags if @removable_tags.present?

    existing_tag_list = tags.pluck(:name)
    @removable_tags = existing_tag_list - tag_list
  end
end
