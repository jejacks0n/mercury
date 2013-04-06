Mercury.Region.Modules.SelectionValue =

  toStack: ->
    val: @toJSON()
    sel: @getSerializedSelection?()


  fromStack: (val) ->
    @fromJSON(val.val)
    @setSerializedSelection?(val.sel) if val.sel
