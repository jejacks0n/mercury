class Carmenta.Regions.Editable.Selection

  constructor: (@selection, @context) ->
    return unless @selection.rangeCount >= 1
    @range = @selection.getRangeAt(0)
    @fragment = @range.cloneContents()
    @clone = @range.cloneRange()


  commonAncestor: ->
    return $(@range.commonAncestorContainer)


  wrap: (element, replace = false) ->
    element = $(element, @context).html(@fragment)
    @replace(element) if replace
    return element


  textContent: ->
    return @range.extractContents().textContent


  insertTextNode: (string) ->
    node = @context.createTextNode(string)
    @range.insertNode(node)
    @range.selectNodeContents(node)
    @selection.addRange(@range)


  replace: (element) ->
    element = element.get(0) if element.get
    element = $(element, @context).get(0) if $.type(element) == 'string'

    @range.deleteContents()
    @range.insertNode(element)
    @range.selectNodeContents(element)
    @selection.addRange(@range)
