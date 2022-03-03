module LocationPdfHelper
  # Get file name
  # @param file_data is "image_data" string of a
  # file upload
  #
  # This is tightly coupled to the format of the "file_upload"
  # on location this will break if file_upload returns
  # different meta data
  def get_pdf_filename(file_data)
    file_json = decode_json(file_data)
    file_json["metadata"]["filename"]
  end

  def get_pdf_file_link(file_id)
    host = ENV['OHANA_API_ENDPOINT']
     if Rails.env.development?
      "#{host}/uploads/cache/#{file_id}"
    elsif Rails.env.production?
      "#{host}/s3/multipart/#{file_id}"
     end
  end
end