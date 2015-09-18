# encoding: utf-8

class MercuryImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage ENV['IMAGE_STORAGE_ENGINE'].downcase.to_sym

  before :store, :remember_cache_id
  after :store, :delete_tmp_dir

  version :mercury do
    process :custom_resize_to_fill
  end

  def custom_mercury
    manipulate! do |img|
      unless model.width.nil? && model.height.nil?
        img.resize "#{model.height}x#{model.width}"
      end
      img = yield(img) if block_given?
      img
    end
  end

  # Resize to fill (new method, with '^' flag)
  # http://www.imagemagick.org/Usage/resize/#fill
  #
  # works both with ImageMagick and GraphicsMagick as expected
  def custom_resize_to_fill
    manipulate! do |img|
      unless model.width.nil? && model.height.nil?
        img.combine_options do |cmd|
          cmd.resize "#{model.width}x#{model.height}^"
          cmd.gravity 'center'
          cmd.extent "#{model.width}x#{model.height}"
        end
      end
      img = yield(img) if block_given?
      img
    end
  end


  # store! nil's the cache_id after it finishes so we need to remember it for deletion
  def remember_cache_id(new_file)
    @cache_id_was = cache_id
  end

  def delete_tmp_dir(new_file)
    # make sure we don't delete other things accidentally by checking the name pattern
    if @cache_id_was.present? && @cache_id_was =~ /\A[\d]{8}\-[\d]{4}\-[\d]+\-[\d]{4}\z/
      FileUtils.rm_rf(File.join(root, cache_dir, @cache_id_was))
    end
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end


  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
