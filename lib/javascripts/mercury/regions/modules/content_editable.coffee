Mercury.Region.Modules.ContentEditable =

  included: ->
    @on('build', @buildContentEditable)
    @on('release', @releaseContentEditable)


  buildContentEditable: ->
    @editableDropBehavior ?= true
    @document ||= @el.get(0).ownerDocument

    @makeContentEditable()
    @forceContentEditableDisplay()
    @setContentEditablePreferences()


  releaseContentEditable: ->
    @el.get(0).contentEditable = false
    @el.css(display: @originalDisplay) if @originalDisplay


  makeContentEditable: ->
    @el.get(0).contentEditable = true


  forceContentEditableDisplay: ->
    if @el.css('display') == 'inline'
      @originalDisplay = 'inline'
      @el.css(display: 'inline-block')


  setContentEditablePreferences: -> try
    @document.execCommand('styleWithCSS', false, false)
    @document.execCommand('insertBROnReturn', false, true)
    @document.execCommand('enableInlineTableEditing', false, false)
    @document.execCommand('enableObjectResizing', false, false)


  stackEquality: (value) ->
    return @stack[@stackPosition].val == value.val if @stackPosition == 0 && @stack[@stackPosition]
    JSON.stringify(@stack[@stackPosition]) == JSON.stringify(value)
