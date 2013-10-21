class Mercury::Image < ActiveRecord::Base

  self.table_name = :mercury_images
  <% unless Gem::Version.new(::Rails::VERSION::STRING) >= Gem::Version.new("4.0.0") %>
    attr_accessible :image
  <% end %>

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" },
        :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
        :url => "/system/:attachment/:id/:style/:filename"

  delegate :url, :to => :image

  def serializable_hash(options = nil)
    options ||= {}
    options[:methods] ||= []
    options[:methods] << :url
    super(options)
  end

end
