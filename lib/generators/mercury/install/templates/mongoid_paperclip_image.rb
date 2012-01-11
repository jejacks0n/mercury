class Mercury::Image
  include Mongoid::Document
  include Mongoid::Paperclip

  has_mongoid_attached_file :image

  validates_presence_of :image

  delegate :url, :to => :image

  def serializable_hash(options = nil)
    options ||= {}
    options[:methods] ||= []
    options[:methods] << :url
    super(options)
  end
end
