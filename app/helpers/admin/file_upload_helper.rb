class Admin
  module FileUploadHelper
    def get_upload_url(file_id)
     host = ENV['ASSET_HOST']
     if Rails.env.development?
      "#{host}uploads/cache/#{file_id}"
    elsif Rails.env.production?
      "#{host}/s3/multipart/#{file_id}"
     end
    end
  end
end