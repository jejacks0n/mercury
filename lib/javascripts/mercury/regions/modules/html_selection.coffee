Mercury.Region.Modules.HtmlSelection =

  getSelection: ->
    rangy.getSelection()


  getSerializedSelection: ->
    rangy.serializeSelection()


  setSerializedSelection: (sel) ->
    rangy.deserializeSelection(sel)


  toggleWrapSelectedWordsInClass: (className, options = {}) ->
    options = $.extend({}, normalize: true, options, applyToEditableOnly: true)
    classApplier = rangy.createCssClassApplier(className, options)
    classApplier.toggleSelection()


  replaceSelection: (val) ->
    val = @elementFromValue(val) if typeof(val) == 'string' || val.is
    for range in @getSelection().getAllRanges()
      range.deleteContents()
      range.insertNode(val)


  elementFromValue: (val) ->
    if val.is then val.get(0) else $(val).get(0)
