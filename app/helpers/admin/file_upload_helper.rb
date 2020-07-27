class Admin
  module FileUploadHelper
    def get_upload_url(file_id)
     if Rails.env.development?
      "/uploads/cache/#{file_id}"
    elsif Rails.env.production?
      "/s3/multipart/#{file_id}"
     end
    end
  end
end