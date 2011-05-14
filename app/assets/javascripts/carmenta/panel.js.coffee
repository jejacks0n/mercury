class Carmenta.Panel extends Carmenta.Dialog

  constructor: (@url, @name, @options) ->
    super


  build: ->
    @element = $('<div>', {class: 'carmenta-panel loading', style: 'display:none;'})
    @titleElement = $("<h1>#{@options.title}</h1>").appendTo(@element)
    @paneElement = $('<div>', {class: 'carmenta-panel-pane'}).appendTo(@element)

    @element.appendTo(@options.appendTo || 'body');


  bindEvents: ->
    Carmenta.bind 'resize', => @position(@visible)
    Carmenta.bind 'hide:panels', (event, panel) =>
      unless panel == @
        @button.removeClass('pressed')
        @hide()

    @element.mousedown (event) -> event.stopPropagation()

    super


  show: ->
    Carmenta.trigger('hide:panels', @)
    super


  resize: ->
    @paneElement.css({display: 'none'})
    preWidth = @element.width()

    @paneElement.css({visibility: 'hidden', width: 'auto', display: 'block'})
    postWidth = @element.width()

    @paneElement.css({visibility: 'visible', display: 'none'})
    position = @element.offset()
    @element.animate {left: position.left - (postWidth - preWidth), width: postWidth}, 200, 'easeInOutSine', =>
      @paneElement.css({display: 'block', width: postWidth})
      @makeDraggable()

    @hide() unless @visible


  position: (keepVisible) ->
    @element.css({display: 'block', visibility: 'hidden'})
    offset = @element.offset()
    elementWidth = @element.width()
    height = Carmenta.displayRect.height - 16

    paneHeight = height - @titleElement.outerHeight()
    @paneElement.css({height: paneHeight, overflowY: if paneHeight < 30 then 'hidden' else 'auto'})

    left = Carmenta.displayRect.width - elementWidth - 20 unless @moved
    left = 8 if left <= 8

    if @pinned || elementWidth + offset.left > Carmenta.displayRect.width - 20
      left = Carmenta.displayRect.width - elementWidth - 20

    @element.css {
      top: Carmenta.displayRect.top + 8,
      left: left,
      height: height,
      display: if keepVisible then 'block' else 'none',
      visibility: 'visible'
    }

    @makeDraggable()
    @element.hide() unless keepVisible


  loadContent: (data) ->
    @loaded = true
    @element.removeClass('loading')
    @paneElement.css({visibility: 'hidden'})
    @paneElement.html(data)


  makeDraggable: ->
    elementWidth = @element.width()
    @draggable = @element.draggable {
      handle: 'h1',
      axis: 'x',
      opacity: 0.70
      scroll: false,
      addClasses: false,
      iframeFix: true,
      containment: [8, 0, Carmenta.displayRect.width - elementWidth - 20, 0]  #[x1, y1, x2, y2]
      stop: =>
        left = @element.offset().left
        @moved = true
        @pinned = if left > Carmenta.displayRect.width - elementWidth - 30 then true else false
        return true
    }
