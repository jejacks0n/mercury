#= require mercury/core/view

class Mercury.ToolbarItem extends Mercury.View

  logPrefix: 'Mercury.ToolbarItem:'

  constructor: (@name, @type, @value) ->
    super


  build: ->
    @addClasses()
    return unless typeof(@value) == 'object'
    for name, value of @value
      item = switch (if $.isArray(value) then 'array' else typeof(value))
        when 'object' then new Mercury.ToolbarItem(name, 'group', value)
        when 'string' then new Mercury.ToolbarItem(name, 'separator', value)
        when 'array'  then new Mercury.ToolbarButton(name, value)
      @append(item) if item


  addClasses: ->
    if @value == '-'
      @addClass("mercury-toolbar-line-#{@type.toDash()}")
    else
      @addClass("mercury-toolbar-#{@type.toDash()}")
    @addClass("mercury-toolbar-#{@name.toDash()}-#{@type.toDash()}")
