#= require mercury/core/view
#= require mercury/views/toolbar_item

class Mercury.Toolbar extends Mercury.View

  @logPrefix: 'Mercury.Toolbar:'
  @className: 'mercury-toolbar'

  @elements:
    toolbar: '.mercury-toolbar-secondary-container'

  @events:
    'mercury:interface:hide': 'hide'
    'mercury:interface:show': 'show'
    'mercury:region:focus': 'onRegionFocus'
    'mousedown': 'onMousedown'
    'mouseup': 'preventStop'
    'click': 'preventStop'

  build: ->
    @append(new Mercury.ToolbarItem('primary', 'container', @config('toolbars:primary'), true))
    @append(new Mercury.ToolbarItem('secondary', 'container', {}))


  buildToolbar: (name) ->
    @appendView(@$toolbar, new Mercury.ToolbarItem(name, 'collection', @config("toolbars:#{name}")))


  show: ->
    clearTimeout(@visibilityTimeout)
    @visible = true
    @$el.show()
    @visibilityTimeout = @delay(50, => @css(top: 0))


  hide: ->
    clearTimeout(@visibilityTimeout)
    @visible = false
    @css(top: -@$el.height())
    @visibilityTimeout = @delay(250, => @$el.hide())


  height: ->
    @$el.outerHeight()


  onMousedown: (e) ->
    @prevent(e)
    Mercury.trigger('dialogs:hide')
    Mercury.trigger('focus')


  onRegionFocus: (region) ->
    return if @region == region
    @region = region
    @$('.mercury-toolbar-collection').remove()
    @releaseSubviews()
    @buildToolbar(name) for name in region.toolbars || []
    Mercury.trigger('region:update', region)


  @icons:
    # primary
    save:          'A'
    preview:       'B'
    undo:          'C'
    redo:          'D'
    link:          'J'
    file:          'K'
    table:         'L'
    character:     'M'
    snippets:      'N'
    history:       'O'
    notes:         'P'
    upload:        'X'
    search:        'Y'
    # markup (html/markdown)
    bold:          'b'
    italic:        'c'
    strike:        'd'
    underline:     'e'
    subscript:     'f'
    superscript:   'g'
    justifyLeft:   'h'
    justifyCenter: 'i'
    justifyRight:  'j'
    justifyFull:   'k'
    unorderedList: 'l'
    orderedList:   'm'
    outdent:       'n'
    indent:        'o'
    rule:          'p'
    h1:            'q'
    h2:            'r'
    h3:            's'
    h4:            't'
    h5:            'u'
    h6:            'v'
    removeHeading: 'w'
    blockquote:    'x'
    clean:         'y'
    edit:          'z'
    pre:           'z'
    rowBefore:     '0'
    rowAfter:      '1'
    rowDelete:     '2'
    colBefore:     '3'
    colAfter:      '4'
    colDelete:     '5'
    colIncrease:   '6'
    colDecrease:   '7'
    rowIncrease:   '8'
    rowDecrease:   '9'
    # image
    alignLeft:     '"'
    alignRight:    "'"
    alignTop:      '?'
    alignMiddle:   '!'
    alignBottom:   '@'
    alignNone:     '_'
    crop:          '*'
    resize:        '#'
    # gallery
    prev:          '$'
    next:          '%'
    remove:        'y'
    togglePlay:    '&'
    # extra
    fav:           '^'
    softWrap:      '`'
    direction:     '{'
    calculate:     '|'
    user:          '}'
    brightness:    '~'
