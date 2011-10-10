module MercuryContentsHelpers
  def contents_for(name)
    case name
      when 'simple content' then "this is <span>simple</span> <b>content</b>"
      when 'justifiable content' then "<div>first line</div><br/>this is <span>justifiable</span> <b>content</b>"
      when 'wrapped content' then "<span>this <a href='http://google.com'>is</a> <i>wrapped</i> <b>content</b></span>"
      else name
    end
  end

end

World(MercuryContentsHelpers)