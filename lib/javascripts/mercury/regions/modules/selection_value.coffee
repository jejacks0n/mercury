Mercury.Region.Modules.SelectionValue =

  getSerializedSelection: ->
  setSerializedSelection: ->

  value: (value = null) ->
    return @html() if value == null || typeof(value) == 'undefined'
    @html(value.val ? value)
    @setSerializedSelection(value.sel) if value.sel


  valueForStack: ->
    val: @value()
    sel: @getSerializedSelection()
