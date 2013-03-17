Mercury.Region.Modules.HtmlSelection =

  getSerializedSelection: ->
    rangy.serializeSelection()


  setSerializedSelection: (sel) ->
    rangy.deserializeSelection(sel)


  toggleWrapSelectedWordsInClass: (className, options = {}) ->
    options = $.extend({}, normalize: true, options, applyToEditableOnly: true)
    classApplier = rangy.createCssClassApplier(className, options)
    classApplier.toggleSelection()
