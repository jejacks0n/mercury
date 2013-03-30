#= require mercury/core/view

class Mercury.ToolbarButton extends Mercury.View

  logPrefix: 'Mercury.ToolbarButton:'
  className: 'mercury-toolbar-button'

  events:
    'mousedown': -> @addClass('active')
    'mouseup': -> @el.removeClass('active')
    'mouseout': -> @el.removeClass('active')
    'click': 'triggerAction'
    'region:focus': 'onRegionFocus'

  constructor: (@name, @label, @options = {}) ->
    super(@options)


  build: ->
    @action = @determineAction()
    @actionName = @determineActionName()
    @type = @determineType()

    @attr('data-action', @action) if @action
    @attr('data-type', @type)
    @attr('data-icon', @constructor.icons[@icon || @name] || @icon)
    @addClass("mercury-toolbar-#{@name.toDash()}-button")
    @html("<em>#{@label}</em>")


  determineActionName: ->
    @determineAction()?[0]


  determineAction: ->
    action = @options.action || @name
    return [action] if typeof(action) == 'string'
    action


  determineType: ->
    return 'select' if @options.select
    return 'palette' if @options.palette
    return 'mode' if @options.mode


  triggerAction: ->
    Mercury.trigger('action', @action...)


  onRegionFocus: (region) ->
    @updateForRegion(region)


  updateForRegion: (region) ->
    if region.actions[@actionName]
      @el.removeClass('disabled')
    else
      @el.addClass('disabled')


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
    # image
    crop:          'e'
    resize:        'f'
    alignLeft:     'g'
    alignRight:    'h'
    alignTop:      'i'
    alignMiddle:   'j'
    alignBottom:   'k'
    # gallery
    prev:          'n'
    next:          'o'
    delete:        'R'
    togglePlay:    'p'
