module MercuryContentsHelpers
  def contents_for(name)
    case name
      when 'simple content' then "this is <span>simple</span> <b>content</b>"
      when 'justifiable content' then "<div>first line</div><br/>this is <span>justifiable</span> <b>content</b>"
      when 'wrapped content' then "<span>this <a href='http://google.com'>is</a> <i>wrapped</i> <b>content</b></span>"
      when 'an image' then "this is <img src='/assets/mercury/temp-logo.png'> <b>content</b>"
      when 'a table' then "this is a <table><tr><td><span>1</span></td><td><span>2</span></td></tr><tr><td><span>3</span></td><td><span>4</span></td></tr></table> <b>content</b>"
      when 'the snippet', 'that snippet' then "<div class='mercury-snippet' data-snippet='#{@snippet_id || 'snippet_42'}'>#{@snippet_id || 'snippet_42'}</div> <b>content</b>"

      else name
    end
  end

  def parse_snippet_options_from(options_string)
    json = []
    options_string.scan(/(?:,\s)?([^:]*): ("[^"]*")/).each do |pair|
      json << %Q{'options[#{pair[0]}]': #{pair[1]}}
    end

    "{#{json.join(', ')}}"
  end
end

World(MercuryContentsHelpers)