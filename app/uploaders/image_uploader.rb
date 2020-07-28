# This is a subclass of Shrine base that will be further configured for it's requirements.
# This will be included in the model to manage the file.

class ImageUploader < Shrine
  ALLOWED_TYPES  = %w[image/jpeg image/png image/webp application/pdf]
  MAX_SIZE       = 10*1024*1024 # 10 MB
  MAX_DIMENSIONS = [5000, 5000] # 5000x5000

  THUMBNAILS = {
    small:  [300, 300],
    medium: [600, 600],
    large:  [800, 800],
  }

  plugin :processing
  plugin :versions
  plugin :remove_attachment
  plugin :pretty_location
  plugin :validation_helpers
  plugin :store_dimensions, log_subscriber: nil
  plugin :derivation_endpoint, prefix: "derivations/image"

  process(:upload) do |io, context|
    if Shrine.determin_mime_type(io)==="application/pdf"
      preview = Tempfile.new(["shrine-pdf-preview", "pdf"], binmode: true)
      begin
        IO.popen *%W[mutoolk draw -F png -o - #{io.path} 1], "rb" do |command|
          IO.copy_stream(command, preview)
        end
      rescue Errno::ENOENT
        fail "mutool is not installed"
      end
      preview.open
    end

    versions = { original: io }
    versions[:preview] = preview if preview && preview.size > 0
    versions
  end

  process(:store) do |io, context|
    original = io[:original].download

    versions = io.dup
    versions[:small] = small
    versions[:medium] = medium
    versions
  end

  # File validations (requires `validation_helpers` plugin)
  Attacher.validate do
    validate_size 0..MAX_SIZE

    # if validate_mime_type ALLOWED_TYPES
    #   validate_max_dimensions MAX_DIMENSIONS
    # end
  end

  # Thumbnails processor (requires `derivatives` plugin)
  Attacher.derivatives do |original|
    THUMBNAILS.transform_values do |(width, height)|
      GenerateThumbnail.call(original, width, height) # lib/generate_thumbnail.rb
    end
  end

  # Default to dynamic thumbnail URL (requires `default_url` plugin)
  Attacher.default_url do |derivative: nil, **|
    file&.derivation_url(:thumbnail, *THUMBNAILS.fetch(derivative)) if derivative
  end

  # Dynamic thumbnail definition (requires `derivation_endpoint` plugin)
  derivation :thumbnail do |file, width, height|
    GenerateThumbnail.call(file, width.to_i, height.to_i) # lib/generate_thumbnail.rb
  end
end