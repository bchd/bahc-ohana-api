require "shrine"

# By default use S3 for production and local file for other environments
case Rails.configuration.upload_server
when :s3_multipart
  require "shrine/storage/s3"

  s3_options = {
    bucket:            ENV['BUCKETEER_BUCKET_NAME'], # required
    region:            ENV['BUCKETEER_AWS_REGION'], # required
    access_key_id:     ENV['BUCKETEER_AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['BUCKETEER_AWS_SECRET_ACCESS_KEY'],
  }

  # both `cache` and `store` storages are needed
  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: "#{ENV['BUCKETEER_PREFIX']}-cache", **s3_options),
    store: Shrine::Storage::S3.new(prefix: ENV['BUCKETEER_PREFIX'], **s3_options),
  }
when :app
  require "shrine/storage/file_system"

  # both `cache` and `store` storages are needed
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads"),
  }
end

Shrine.plugin :activerecord
Shrine.plugin :instrumentation
Shrine.plugin :determine_mime_type, analyzer: :marcel, log_subscriber: nil
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
Shrine.plugin :derivatives          # up front processing
Shrine.plugin :derivation_endpoint, # on-the-fly processing
  secret_key: Rails.application.config.secret_key_base

case Rails.configuration.upload_server
when :s3_multipart
  Shrine.plugin :uppy_s3_multipart
when :app
  Shrine.plugin :upload_endpoint
end

# delay promoting and deleting files to a background job (`backgrounding` plugin)
Shrine.plugin :backgrounding
Shrine::Attacher.promote_block { Attachment::PromoteJob.perform_later(record, name, file_data) }
Shrine::Attacher.destroy_block { Attachment::DestroyJob.perform_later(data) }