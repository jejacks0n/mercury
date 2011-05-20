class Carmenta.Regions.Snippetable.Toolbar

  constructor: (@region, @document, @options = {}) ->
    @build()

  build: ->
    @element = $('<div>', {class: 'carmenta-toolbar carmenta-snippet-toolbar', style: 'display:none'})
    @element.appendTo($(@options.appendTo).get(0) ? 'body')


  show: (snippet) ->
    @position(snippet, !@visible)
    @appear()


  position: (snippet, instant = false) ->
    height = @element.height()
    width = @element.width()
    offset = snippet.offset()

    top = offset.top + Carmenta.displayRect.top - $(@document).scrollTop() - height - 5
    left = offset.left - $(@document).scrollLeft()

    @element.css {
      top: top,
      left: left
    }

  appear: ->
    return if @visible
    @visible = true
    @element.css({display: 'block', opacity: 0})
    @element.stop().animate({opacity: 1}, 200, 'easeInOutSine')


  hide: ->
    clearInterval(@hideTimeout)
    @hideTimeout = setTimeout((=>
      @visible = false
      @element.stop().animate({opacity: 0}, 300, 'easeInOutSine')
    ), 500)

