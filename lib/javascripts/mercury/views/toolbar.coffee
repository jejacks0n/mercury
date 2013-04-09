#= require mercury/core/view

class Mercury.Toolbar extends Mercury.View

  logPrefix: 'Mercury.Toolbar:'
  className: 'mercury-toolbar'

  events:
    'mousedown': 'dialogs:hide'
    'interface:hide': 'hide'
    'interface:show': 'show'
    'region:focus': 'onRegionFocus'

  elements:
    toolbar: '.mercury-toolbar-secondary-container'

  build: ->
    @append(new Mercury.ToolbarItem('primary', 'container', @config("toolbars:primary")))
    @append(new Mercury.ToolbarItem('secondary', 'container', {}))


  hide: ->
    clearTimeout(@visibilityTimeout)
    @visible = false
    @el.css(top: -@el.height())
    @visibilityTimeout = @delay(250, => @el.hide())


  show: ->
    clearTimeout(@visibilityTimeout)
    @visible = true
    @el.show()
    @visibilityTimeout = @delay(1, => @el.css(top: 0))


  onRegionFocus: (region) ->
    return if @region == region
    @region = region
    @$('.mercury-toolbar-collection').remove()
    @buildToolbar(name) for name in region.toolbars || []
    Mercury.trigger('region:update', region)


  buildToolbar: (name) ->
    toolbar = new Mercury.ToolbarItem(name, 'collection', @config("toolbars:#{name}"))
    toolbar.appendTo(@toolbar)
    toolbar


  @icons:
    # mercury.ttf
    # primary
    save:          '!'
    preview:       '"'
    undo:          '#'
    redo:          '$'
    link:          '%'
    file:          '&'
    table:         "'"
    character:     '('
    snippets:      ')'
    history:       '*'
    notes:         '+'
    upload:        ','
    search:        '-'

    # toolbars.ttf
    # markup (html/markdown)
    bold:          'C'
    italic:        'D'
    strike:        'E'
    underline:     'F'
    subscript:     'G'
    superscript:   'H'
    justifyLeft:   'I'
    justifyCenter: 'J'
    justifyRight:  'K'
    justifyFull:   'L'
    unorderedList: 'M'
    orderedList:   'N'
    indent:        'P'
    outdent:       'O'
    rule:          'Q'
    clean:         'R'
    edit:          'S'
    rowBefore:     'T'
    rowAfter:      'U'
    rowDelete:     'V'
    colBefore:     'W'
    colAfter:      'X'
    colDelete:     'Y'
    colIncrease:   'Z'
    colDecrease:   'a'
    rowIncrease:   'b'
    rowDecrease:   'c'
    h1:            'q'
    h2:            'r'
    h3:            's'
    h4:            't'
    h5:            'u'
    h6:            'v'
    removeHeading: 'w'
    blockquote:    'm'
    pre:           'S'
    # image
    crop:          'e'
    resize:        'f'
    alignLeft:     'g'
    alignRight:    'h'
    alignTop:      'i'
    alignMiddle:   'j'
    alignBottom:   'k'
    alignNone:     'l'
    # gallery
    prev:          'n'
    next:          'o'
    remove:        'R'
    togglePlay:    'p'
