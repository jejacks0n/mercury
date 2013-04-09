#= require mercury/core/view

class Mercury.ToolbarItem extends Mercury.View

  logPrefix: 'Mercury.ToolbarItem:'

  constructor: (@name, @type, @value) ->
    @items = []
    super()


  build: ->
    @addClasses()
    return unless typeof(@value) == 'object'
    for name, value of @value
      item = switch (if $.isArray(value) then 'array' else typeof(value))
        when 'object' then new Mercury.ToolbarItem(name, 'group', value)
        when 'string' then new Mercury.ToolbarItem(name, 'separator', value)
        when 'array'  then new Mercury.ToolbarButton(name, value...)
      @items.push(item)
      @append(item) if item
    @append(new Mercury.ToolbarItem('sep_final', 'separator', '-')) if @type == 'group'


  addClasses: ->
    extraClass = "mercury-toolbar-#{@type.toDash()}"
    extraClass = "mercury-toolbar-line-#{@type.toDash()}" if @value == '-'
    @addClass(["mercury-toolbar-#{@name.toDash()}-#{@type.toDash()}", extraClass].join(' '))


  updateForRegion: (region) ->
    item.updateForRegion(region) for item in @items
