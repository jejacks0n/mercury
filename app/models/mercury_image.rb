class MercuryImage < ActiveRecord::Base

  attr_accessible :image, :name, :image_url, :width, :height

  mount_uploader :image, MercuryImageUploader

  def serializable_hash(options = nil)
    options ||= {}
    options[:methods] ||= []
    options[:methods] << :url
    super(options)
  end

  def dimensions_as_array
    [width, height]
  end

  def dimensions_as_string
    "#{width}x#{height}"
  end

end
