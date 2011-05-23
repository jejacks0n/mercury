class Mercury.Regions.Editable.Selection

  constructor: (@selection, @context) ->
    return unless @selection.rangeCount >= 1
    @range = @selection.getRangeAt(0)
    @fragment = @range.cloneContents()
    @clone = @range.cloneRange()


  commonAncestor: (onlyTag = false) ->
    return null unless @range
    ancestor = @range.commonAncestorContainer
    ancestor = ancestor.parentNode if ancestor.nodeType == 3 && onlyTag
    return $(ancestor)


  wrap: (element, replace = false) ->
    element = $(element, @context).html(@fragment)
    @replace(element) if replace
    return element


  textContent: ->
    return @range.cloneContents().textContent


  content: ->
    return @range.cloneContents()


#  forceSelection: (element) ->
#    range = @context.createRange()
#    element.lastChild.textContent = '\00' if element.lastChild && element.lastChild.textContent.replace(/^[\s+|\n+]|[\s+|\n+]$/, '') == ''
#
#    range.setStartBefore(element.lastChild)
#    range.setEndBefore(element.lastChild)
#
#    @selection.addRange(range)


  selectMarker: (context) ->
    markers = context.find('em.mercury-marker')
    return unless markers.length

    range = @context.createRange()
    range.setStartBefore(markers.get(0))
    range.setEndBefore(markers.get(1)) if markers.length >= 2

    markers.remove()

    @selection.removeAllRanges()
    @selection.addRange(range)


  placeMarker: ->
    return unless @range

    @startMarker = $('<em class="mercury-marker"/>', @context).get(0)
    @endMarker = $('<em class="mercury-marker"/>', @context).get(0)

    # put a single marker (the end)
    rangeEnd = @range.cloneRange()
    rangeEnd.collapse(false)
    rangeEnd.insertNode(@endMarker)

    unless @range.collapsed
      # put a start marker
      rangeStart = @range.cloneRange()
      rangeStart.collapse(true)
      rangeStart.insertNode(@startMarker)

    @selection.removeAllRanges()
    @selection.addRange(@range)


  removeMarker: ->
    $(@startMarker).remove()
    $(@endMarker).remove()


  insertTextNode: (string) ->
    node = @context.createTextNode(string)
    @range.extractContents()
    @range.insertNode(node)
    @range.selectNodeContents(node)
    @selection.addRange(@range)


  insertNode: (element) ->
    element = element.get(0) if element.get
    element = $(element, @context).get(0) if $.type(element) == 'string'

    @range.deleteContents()
    @range.insertNode(element)
    @range.selectNodeContents(element)
    @selection.addRange(@range)


  selectNode: (node) ->
    @range.selectNode(node)
    @selection.addRange(@range)


  replace: (element) ->
    element = element.get(0) if element.get
    element = $(element, @context).get(0) if $.type(element) == 'string'

    @range.deleteContents()
    @range.insertNode(element)
    @range.selectNodeContents(element)
    @selection.addRange(@range)

