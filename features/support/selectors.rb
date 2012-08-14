module HtmlSelectorsHelpers
  # Maps a name to a selector. Used primarily by the
  #
  #   When /^(.+) within (.+)$/ do |step, scope|
  #
  # step definitions in web_steps.rb
  #
  def selector_for(locator)

    # add in for mercury support
    result = mercury_selector_for(locator)
    return result if result.present?

    case locator

      when /the page/
        "html > body"

      # Add more mappings here.
      # Here is an example that pulls values out of the Regexp:
      #
      #  when /the (notice|error|info) flash/
      #    ".flash.#{$1}"

      # You can also return an array to use a different selector
      # type, like:
      #
      #  when /the header/
      #    [:xpath, "//header"]

      # This allows you to provide a quoted selector as the scope
      # for "within" steps as was previously the default for the
      # web steps:
      when /"(.+)"/
        $1

      else
        raise "Can't find mapping from \"#{locator}\" to a selector.\n" +
                      "Now, go and add a mapping in #{__FILE__}"
    end
  end

  def region_selector_for(locator)
    return '#full_1' if locator.blank? || locator == 'the region'
    case locator.downcase

      when 'the first full region', 'the full region' then '#full_1'
      when 'the first markdown region', 'the markdown region' then '#markdown_1'
      when 'the first snippets region', 'the first snippet region', 'the snippets region', 'the snippet region' then '#snippets_1'

      else locator
    end
  end

  def snippet_name_for(locator)
    case locator.downcase

      when 'the example snippet' then 'example'
      when 'the snippet with no options' then 'no_options'

      else locator
    end
  end

end

World(HtmlSelectorsHelpers)
