Mercury.Region.Modules.ContentEditable =

  included: ->
    @on('build', @buildContentEditable)
    @on('preview', @toggleContentEditable)
    @on('release', @releaseContentEditable)


  buildContentEditable: ->
    @editableDropBehavior ?= true
    @document ||= @el.get(0).ownerDocument

    @makeContentEditable()
    @forceContentEditableDisplay()
    @setContentEditablePreferences()


  toggleContentEditable: ->
    if @previewing
      @makeNotContentEditable()
    else
      @makeContentEditable()


  releaseContentEditable: ->
    @makeNotContentEditable()
    @el.css(display: @originalDisplay) if @originalDisplay


  makeContentEditable: ->
    @el.get(0).contentEditable = true


  makeNotContentEditable: ->
    @el.get(0).contentEditable = false


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
    if @stackPosition == 0 && @stack[@stackPosition]
      return JSON.stringify(@stack[@stackPosition].val) == JSON.stringify(value.val)
    JSON.stringify(@stack[@stackPosition]) == JSON.stringify(value)
