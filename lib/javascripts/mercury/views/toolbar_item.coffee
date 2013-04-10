#= require mercury/core/view
#= require mercury/views/toolbar_button

class Mercury.ToolbarItem extends Mercury.View

  logPrefix: 'Mercury.ToolbarItem:'

  constructor: (@name = 'unknown', @type = 'unknown', @value = null) ->
    super()


  build: ->
    @addClasses()
    return unless typeof(@value) == 'object'
    @buildSubview(name, value) for name, value of @value
    @buildSubview('sep-final', '-') if @type == 'group'


  buildSubview: (name, value) ->
    item = switch (if $.isArray(value) then 'array' else typeof(value))
      when 'object' then new Mercury.ToolbarItem(name, 'group', value)
      when 'string' then new Mercury.ToolbarItem(name, 'separator', value)
      when 'array'  then Mercury.ToolbarButton.create(name, value...)
    @append(item) if item


  addClasses: ->
    extraClass = "mercury-toolbar-#{@type.toDash()}"
    extraClass = "mercury-toolbar-line-#{@type.toDash()}" if @value == '-'
    @addClass(["mercury-toolbar-#{@name.toDash()}-#{@type.toDash()}", extraClass].join(' '))
