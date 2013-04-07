Mercury.Region.Modules.SelectionValue =

  toStack: ->
    val: @toJSON()
    sel: @getSerializedSelection?()


  fromStack: (val) ->
    return unless val
    @fromJSON(val.val)
    @setSerializedSelection?(val.sel) if val.sel
