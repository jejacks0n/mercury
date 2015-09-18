class MercuryContent < ActiveRecord::Base
  include FriendlyId

  self.inheritance_column = nil # to use :data as column_name

  attr_accessible :name, :type, :value, :data, :settings, :width, :height #, :snippets
  before_validation :default_values

  validates_presence_of :value, unless: -> (mc) { mc.type == 'image' }
  validates_presence_of :type, :name
  validates_uniqueness_of :name, :scope => :type

  # serialize :snippets, Hash
  serialize :data, Hash
  serialize :settings, Hash

  def extract_params
    value.gsub!(/\[snippet_\d+\/?\d*\]/).with_index do |txt, idx|
      snippets[txt]
    end
  end

  def parse_snippets(content)
    snippet_regex = /\[snippet_\d+\/*\d*\]/
    if content.value =~ snippet_regex
      content.value.gsub(snippet_regex) do |txt|
        cleaned_snippet = txt.delete "[]" # delete brackets
        snippet = content.snippets[txt]
        if snippet
          render(:file => "mercury/snippets/#{snippet[:name]}/preview.html", locals: {options: snippet})
        end
      end
    else
      content.value.html_safe
    end
  end

  private

  def default_values
    self.value ||= " "
  end

  def image_url
    settings[:src]
  end

end
