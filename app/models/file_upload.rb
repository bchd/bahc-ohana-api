class FileUpload < ActiveRecord::Base
  include ImageUploader::Attachment(:image)

  validates_presence_of :image
end