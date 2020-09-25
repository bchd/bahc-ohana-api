# This is a subclass of Shrine base that will be further configured for it's requirements.
# This will be included in the model to manage the file.

class ImageUploader < Shrine
  ALLOWED_TYPES  = %w[image/jpeg image/png image/webp application/pdf]
  MAX_SIZE       = 10*1024*1024 # 10 MB

  plugin :remove_attachment
  plugin :pretty_location
  plugin :validation_helpers
  plugin :store_dimensions, log_subscriber: nil
  plugin :derivation_endpoint, prefix: "derivations/image"

  # File validations (requires `validation_helpers` plugin)
  Attacher.validate do
    validate_size 0..MAX_SIZE
  end
end