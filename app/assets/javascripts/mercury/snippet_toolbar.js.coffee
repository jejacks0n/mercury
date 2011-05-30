class Mercury.SnippetToolbar extends Mercury.Toolbar

  constructor: (@document, @options = {}) ->
    super(@options)


  build: ->
    @element = $('<div>', {class: 'mercury-toolbar mercury-snippet-toolbar', style: 'display:none'})
    @element.appendTo($(@options.appendTo).get(0) ? 'body')

    for buttonName, options of Mercury.config.toolbars.snippetable
      @buildButton(buttonName, options).appendTo(@element)


  bindEvents: ->
    Mercury.bind 'show:toolbar', (event, options) =>
      return unless options.snippet
      options.snippet.mouseout => @hide()
      @show(options.snippet)

    Mercury.bind 'hide:toolbar', (event, options) =>
      return unless options.type && options.type == 'snippet'
      @hide(options.immediately)

    $(@document).scroll => @position() if @visible

    @element.mousemove => clearTimeout(@hideTimeout)
    @element.mouseout => @hide()


  show: (@snippet) ->
    @position()
    @appear()


  position: ->
    offset = @snippet.offset()

    top = offset.top + Mercury.displayRect.top - $(@document).scrollTop() - @height() + 5
    left = offset.left - $(@document).scrollLeft()

    @element.css {
      top: top,
      left: left
    }


  appear: ->
    clearTimeout(@hideTimeout)
    return if @visible
    @visible = true
    @element.css({display: 'block', opacity: 0})
    @element.stop().animate({opacity: 1}, 200, 'easeInOutSine')


  hide: (immediately = false) ->
    clearTimeout(@hideTimeout)
    if immediately
      @element.hide()
      @visible = false
    else
      @hideTimeout = setTimeout((=>
        @element.stop().animate {opacity: 0}, 300, 'easeInOutSine', =>
          @element.hide()
        @visible = false
      ), 500)

