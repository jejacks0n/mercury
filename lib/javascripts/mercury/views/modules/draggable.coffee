Mercury.View.Modules.Draggable =

  startDrag: (e) ->
    return if e.button > 1
    @viewportSize = width: $(window).width(), height: $(window).height()
    position = @$el.position()
    @dragPosition = {x: position.left * -1, y: position.top * -1}
    x = e.pageX
    y = e.pageY

    e.preventDefault()
    @potentialDragStart(x, y)


  potentialDragStart: (x, y) ->
    @startPosition = {x: @dragPosition.x, y: @dragPosition.y}
    @initialPosition = {x: x, y: y}
    @potentiallyDragging = true
    @bindDocumentDragEvents()


  startDragging: (x, y) ->
    @addClass('mercury-no-animation')
    @dragging = true
    @initialPosition = {x: x, y: y}
    @onDragStart?()


  drag: (e) ->
    e.preventDefault()
    x = e.pageX
    y = e.pageY

    if !@dragging
      @startDragging(x, y) if Math.abs(@initialPosition.x - x) >= 6 || Math.abs(@initialPosition.y - y) >= 6
    else
      @lastPosition = @dragPosition
      currentX = (@startPosition.x - x + @initialPosition.x) * -1
      currentY = (@startPosition.y - y + @initialPosition.y) * -1
      @dragPosition = {x: currentX, y: currentY}
      @setPositionOnDrag(currentX, currentY)


  endDragging: (e) ->
    @onDragEnd?(e) if @dragging == true
    @dragging = false
    @potentiallyDragging = false
    @unbindDocumentDragEvents()
    @delay(250, -> @removeClass('mercury-no-animation'))


  unbindDocumentDragEvents: ->
    $(document).off('mousemove', @dragHandler).off('mouseup', @endDraggingHandler)
    if @document && @document != document
      $(@document).off('mousemove', @otherDragHandler).off('mouseup', @otherEndDraggingHandler)


  bindDocumentDragEvents: ->
    $(document).on('mousemove', @dragHandler = (e) => @drag(e)).on('mouseup', @endDraggingHandler = (e) => @endDragging(e))
    if @document && @document != document
      $(@document).on('mousemove', @otherDragHandler = (e) => @drag(e)).on('mouseup', @otherEndDraggingHandler = (e) => @endDragging(e))


  setPositionOnDrag: (x, y) ->
    @css(top: y, left: x)
