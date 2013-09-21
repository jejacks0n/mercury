Mercury.Region.Modules.HtmlSelection =
  
  # TODO: Document 
  #
  elementFromValue: (val) ->
    if val.is then val.get(0) else $(val).get(0)
  
  
  # Get the current selection. We're scoping it to the @document here
  # so it uses the proper scope in all interfaces. 
  #
  getSelection: ->
    rangy.getSelection(@document)
  
  # Serialize the current selection for storage.
  # Passing false as the second arg fixes issues with 
  # hash mis-matches.
  #
  getSerializedSelection: ->
    rangy.serializeSelection(@getSelection(), false)
  
  # Get the parent node of the current selection
  #
  getSelectedNode: ->
    sel = @getSelection()
    return @document.body unless sel.rangeCount > 0
    range  = sel.getRangeAt(0)
    parent = range.commonAncestorContainer
    if parent.nodeType is 3 then parent.parentNode else parent
  
  
  # Wraps the current selection in css class.
  #
  toggleWrapSelectedWordsInClass: (className, options = {}) ->
    options = $.extend({}, normalize: true, options, applyToEditableOnly: true)
    classApplier = rangy.createCssClassApplier(className, options)
    classApplier.toggleSelection()
  

  # Replace the current selection
  #
  replaceSelection: (val) ->
    select = if @selection then @restoreSelection() else @getSelection()
    val = @elementFromValue(val) if typeof(val) == 'string' || val.is
    for range in selection.getAllRanges()
      range.deleteContents()
      range.insertNode(val)


  # Restore the saved selection
  #
  restoreSelection: ->
    @setSerializedSelection(@selection)
    @selection = null


  # Restores a selection from a serialized string. 
  # Passing null as the second arg fixes issues with hash mis-matches
  # The selection should also be scoped to the window in which the region lives.
  #
  # TODO: Is there a better way to handle finding the window here? We also need to fix/add .window for Shadow DOM. 
  #
  setSerializedSelection: (sel) ->
    if rangy.canDeserializeSelection(sel)
      rangy.deserializeSelection(sel, null, Mercury.interface.window)


  # Store the current selection
  #
  saveSelection: ->
    @selection = @getSerializedSelection()