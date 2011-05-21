class Carmenta.Regions.Snippetable.Toolbar extends Carmenta.Toolbar

  constructor: (@region, @document, @options = {}) ->
    super(@options)


  build: ->
    @element = $('<div>', {class: 'carmenta-toolbar carmenta-snippetable-toolbar', style: 'display:none'})
    @element.appendTo($(@options.appendTo).get(0) ? 'body')

    for buttonName, options of Carmenta.config.toolbars.snippetable
      @buildButton(buttonName, options).appendTo(@element)


  bindEvents: ->
    $(@document).scroll => @position() if @visible

    @element.mousemove => clearInterval(@hideTimeout)
    @element.mouseout => @hide()


  show: (@snippet) ->
    @position()
    @appear()


  position: ->
    offset = @snippet.offset()

    top = offset.top + Carmenta.displayRect.top - $(@document).scrollTop() - @height() + 5
    left = offset.left - $(@document).scrollLeft()

    @element.css {
      top: top,
      left: left
    }


  appear: ->
    clearInterval(@hideTimeout)
    return if @visible
    @visible = true
    @element.css({display: 'block', opacity: 0})
    @element.stop().animate({opacity: 1}, 200, 'easeInOutSine')


  hide: (immediately = false) ->
    clearInterval(@hideTimeout)
    if immediately
      @element.hide()
      @visible = false
    else
      @hideTimeout = setTimeout((=>
        @visible = false
        @element.stop().animate({opacity: 0}, 300, 'easeInOutSine')
      ), 500)

