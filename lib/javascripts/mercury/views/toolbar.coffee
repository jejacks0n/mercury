#= require mercury/core/view
#= require mercury/views/toolbar_item

class Mercury.Toolbar extends Mercury.View

  @logPrefix: 'Mercury.Toolbar:'
  @className: 'mercury-toolbar'

  @elements:
    toolbar: '.mercury-toolbar-secondary-container'

  @events:
    'mercury:interface:hide': 'hide'
    'mercury:interface:show': 'show'
    'mercury:region:focus': 'onRegionFocus'
    'mousedown': 'onMousedown'
    'click': 'preventStop'

  build: ->
    @append(new Mercury.ToolbarItem('primary', 'container', @config('toolbars:primary'), true))
    @append(new Mercury.ToolbarItem('secondary', 'container', {}))


  buildToolbar: (name) ->
    if @config("toolbars:#{name}")
      @appendView(@$toolbar.show(), new Mercury.ToolbarItem(name, 'collection', @config("toolbars:#{name}")))
    else
      @$toolbar.hide()


  show: ->
    return if Mercury.interface.floating && @visible
    clearTimeout(@visibilityTimeout)
    @visible = true
    @$el.show()
    @visibilityTimeout = @delay(50, => @css(top: 0))


  hide: ->
    return if Mercury.interface.floating
    clearTimeout(@visibilityTimeout)
    @visible = false
    @css(top: -@$el.height())
    @visibilityTimeout = @delay(250, => @$el.hide())


  height: ->
    if Mercury.interface.visible then @$el.outerHeight() else 0


  onMousedown: (e) ->
    @prevent(e)
    Mercury.trigger('dialogs:hide')
    Mercury.trigger('focus')


  onRegionFocus: (region) ->
    return if @region == region
    @region = region
    @$('.mercury-toolbar-collection').remove()
    @releaseSubviews()
    @buildToolbar(name) for name in region.toolbars || []
    Mercury.trigger('region:update', region)
