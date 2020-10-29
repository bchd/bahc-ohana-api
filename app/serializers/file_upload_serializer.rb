class FileUploadSerializer < ActiveModel::Serializer
  attributes :url, :filename

  def url
    object.image_url
  end

  def filename
    data = JSON.parse(object.image_data)
    data['metadata']['filename']
  end
end
