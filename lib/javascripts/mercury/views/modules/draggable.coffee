Mercury.View.Modules.Draggable =

  startDrag: (e) ->
    return if e.button > 1
    @prevent(e)

    @viewportSize = width: $(window).width(), height: $(window).height()
    position = @$el.position()
    @dragPosition = {x: position.left * -1, y: position.top * -1}
    @potentialDragStart(e.pageX, e.pageY)


  potentialDragStart: (x, y) ->
    @startPosition = {x: @dragPosition.x, y: @dragPosition.y}
    @initialPosition = {x: x, y: y}
    @potentiallyDragging = true
    @bindDocumentDragEvents(document)
    @bindDocumentDragEvents(Mercury.interface.document) if Mercury.interface.document && Mercury.interface.document != document


  onStartDragging: (x, y) ->
    @addClass('mercury-no-animation')
    @dragging = true
    @initialPosition = {x: x, y: y}
    @onDragStart?()


  onDrag: (e) ->
    @prevent(e)
    x = e.pageX
    y = e.pageY

    return @onStartDragging(x, y) if !@dragging && (Math.abs(@initialPosition.x - x) > 5 || Math.abs(@initialPosition.y - y) > 5)
    @lastPosition = @dragPosition
    currentX = (@startPosition.x - x + @initialPosition.x) * -1
    currentY = (@startPosition.y - y + @initialPosition.y) * -1
    @dragPosition = {x: currentX, y: currentY}
    @setPositionOnDrag(currentX, currentY)


  onEndDragging: (e) ->
    @onDragEnd?(e) if @dragging == true
    @dragging = false
    @potentiallyDragging = false
    @unbindDocumentDragEvents(document)
    @unbindDocumentDragEvents(Mercury.interface.document) if Mercury.interface.document && Mercury.interface.document != document
    @delay(250, -> @removeClass('mercury-no-animation'))


  bindDocumentDragEvents: (el) ->
    $(el)
      .on('mousemove', @onDragHandler = (e) => @onDrag(e))
      .on('mouseup', @onEndDraggingHandler = (e) => @onEndDragging(e))


  unbindDocumentDragEvents: (el) ->
    $(el).off('mousemove', @onDragHandler).off('mouseup', @onEndDraggingHandler)


  setPositionOnDrag: (x, y) ->
    @css(top: y, left: x)
