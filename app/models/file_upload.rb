class FileUpload < ActiveRecord::Base
  include ImageUploader::Attachment(:image)

  validates_presence_of :image
  belongs_to :location, touch: true
end
