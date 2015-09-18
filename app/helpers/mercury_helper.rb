module MercuryHelper

  # Renders a mercury dynamic content
  # type can be :full, :simple, :markdown, :snippets, :image
  # by default i18n: false, wrapper: :div
  # images are by default 100px height and have a width of auto.
  # make_mercury(html_id, :full, wrapper: :div, ,i18n: true)
  # make_mercury('jumbotron-image', :image, height: '200', width: '400', data: {height: '200', width: '400'}, class: "my-class")
  # The very first implementation creates the db entry and can be filled in the editor

  def make_mercury(*args)

    options = args.extract_options!
    tag_id = options[:i18n] ? localize_id(args.first) : args.first
    options[:type] ||= args.second || :simple
    content = MercuryContent.find_or_create_by_name_and_type(tag_id, options[:type])

    if options[:type] == :image
      mercury_image_tag(content, options)
    else
      render_mercury_tag(content, tag_id, options)
    end
  end

  # renders a mercury image tag
  # use make_mercury for creation
  def mercury_image_tag(mercury_image, options)
    assign_dimensions(mercury_image, options)
    mercury_image(mercury_image, options)
  end

  def mercury_image(mercury_image, options=nil)

    image_settings = mercury_image.settings[:src]
    image_source = image_settings.blank? ? 'mercury/no_image_defined.png' : image_settings

    # set default image tag size
    if options[:width].nil? && options[:height].nil?
      options[:width], options[:height] = "100%", "auto"
    end

    # set default image size
    if options && options[:data] && options[:data][:width] && options[:data][:height]
      options[:data][:width], options[:data][:height] = 800, 600
    end

    image_tag image_source, id: mercury_image.name,
              data: {mercury: mercury_image.type, contenteditable: 'true', width: options[:data][:width], height: options[:data][:height]},
              alt: "#{mercury_image.name}",
              width: options[:width],
              height: options[:height],
              onDrop: "addImageSizeToUrl($(this).attr('data-width'), $(this).attr('data-height'));resetUrlWhenSaved();"

  end

  # renders a mercury tag
  # use make_mercury for creation
  def render_mercury_tag(content, id, options)
    wrapper = options[:wrapper] ? options[:wrapper] : :div
    type = options[:type] ? options[:type] : :simple
    class_name = options[:class] ? options[:class] : ""
    content_tag(wrapper, class: class_name, id: id, data: {mercury: type.to_s, contenteditable: 'true'}) do
      parse_snippets(content).html_safe
    end.html_safe
  end

  # returns id-language
  def localize_id(id)
    id + "-" + I18n.locale.to_s
  end

  # parses snippets and replace it in text
  def parse_snippets(content)
    snippet_regex = /\[snippet_\d+\/*\d*\]/
    if content.value =~ snippet_regex
      content.value.gsub(snippet_regex) do |txt|
        cleaned_snippet = txt.delete "[]" # delete brackets
        snippet = MercurySnippet.find_by_name(cleaned_snippet)
        if snippet
          name = snippet.snippet[1]['name']
          render(:file => "mercury/snippets/#{name}/preview.html", locals: {params: snippet.snippet[1]})
        end
      end
    else
      content.value.html_safe
    end
  end

  # this helper links to the editor for the current page
  def mercury_edit_path(path = nil)
    mercury_editor_path(path.nil? ? request.path.gsub(/^\/\/?(editor)?/, '') : path)
  end

  private

  def assign_dimensions(content, options)
    return unless options[:data][:width] && options[:data][:height]
    content.update_attributes(width: options[:data][:width], height: options[:data][:height])
  end
end