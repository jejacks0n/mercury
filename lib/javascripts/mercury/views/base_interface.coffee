#= require mercury/core/view
#= require mercury/models/page

class Mercury.BaseInterface extends Mercury.View

  @logPrefix: 'Mercury.BaseInterface:'
  @template: 'interface'
  @tag: 'mercury'

  @elements:
    mask: '.mercury-interface-mask'

  @events:
    'mercury:save': 'save'
    'mercury:focus': 'focusActiveRegion'
    'mercury:action': 'focusActiveRegion'
    'mercury:blur': 'blurActiveRegion'
    'mercury:region:focus': 'onRegionFocus'
    'mercury:region:release': 'onRegionRelease'
    'mercury:reinitialize': 'reinitialize'
    'mercury:interface:mask': 'mask'
    'mercury:interface:unmask': 'unmask'
    'mousedown .mercury-interface-mask': (e) -> @prevent(e)
    'mouseup .mercury-interface-mask': (e) -> @prevent(e)
    'click .mercury-interface-mask': (e) -> @prevent(e, true); Mercury.trigger('dialogs:hide')

  constructor: ->
    if parent != window && parent.Mercury
      @log(@t('is already defined in parent frame'))
      return

    Mercury.interface = @
    @floating ||= @config('interface:floating')

    super

    @page = new Mercury.Model.Page()
    @regions ||= []
    $(window).on('beforeunload', @onUnload)
    $(window).on('resize', @onResize)

    @initialize()
    @buildInterface()
    @bindDefaultEvents()
    @removeClass('loading')
    Mercury.trigger('initialized')


  build: ->
    @$el = @el = $(@tag) unless @el
    @attr(@attributes)
    @addClass(@className)
    @addClass(@config('interface:style') || 'standard')
    @addClass('mercury-floating') if @floating


  init: ->
    @addLocaleClass()
    $('body').before(@$el)
    @makeShadowed()
    @html(@renderTemplate(@template)) if @template
    @addClass('loading')


  initialize: ->
    @addAllRegions()
    @bindDocumentEvents()


  reinitialize: ->
    @initialize()
    @focusActiveRegion()


  buildInterface: ->
    @buildToolbar()
    @buildStatusbar()
    @focusDefaultRegion()
    @onResize()


  addLocaleClass: ->
    @addClass("locale-#{Mercury.I18n.detectLocale().join('-').toLowerCase()}")


  makeShadowed: ->
    return unless @config('interface:shadowed') && @el.webkitCreateShadowRoot
    @shadow = $(@el.webkitCreateShadowRoot())
    # todo: this is a problem in that it allows css to bleed, which isn't exactly what we want here, but getting css
    #       to load internally isn't viable. ??
    @shadow.get(0).applyAuthorStyles = true
    @shadow.append(@$el = @el = $(document.createElement(@tag)))


  buildToolbar: ->
    return unless klass = @config('interface:toolbar')
    @toolbar = @appendView(new Mercury[klass]())
    @toolbar.hide() unless @config('interface:enabled')


  buildStatusbar: ->
    return unless klass = @config('interface:statusbar')
    @statusbar = @appendView(new Mercury[klass]())
    @statusbar.hide() unless @config('interface:enabled')


  bindDefaultEvents: ->
    @delegateEvents
     'mercury:mode': (mode) -> @setMode(mode)
     'mercury:action': -> @focusActiveRegion()


  bindDocumentEvents: ->
    $('body', @document).on('mousedown', -> Mercury.trigger('dialogs:hide')) unless @config('interface:mask')


  focusDefaultRegion: ->
    @delay(100, @focusActiveRegion)


  addAllRegions: ->
    @addRegion(el) for el in @regionElements()
    @region ||= @regions[0]
    Mercury.trigger('mode', 'preview') unless @config('interface:enabled')


  regionElements: ->
    $("[#{@config('regions:attribute')}]", @document)


  addRegion: (el) ->
    return if $(el).data('region')
    region = Mercury.Region.create(el)
    @regions.push(region)


  focusActiveRegion: (e) ->
    @prevent(e)
    @region?.focus()


  blurActiveRegion: ->
    @region?.blur()


  setMode: (mode) ->
    @["#{mode}Mode"] = !@["#{mode}Mode"]
    @focusActiveRegion()


  toggleInterface: ->
    @interfaceHidden ?= @config('interface:enabled')
    @interfaceHidden = !@interfaceHidden
    if @interfaceHidden
      Mercury.trigger('interface:show')
      Mercury.trigger('mode', 'preview') if @previewMode
    else
      Mercury.trigger('interface:hide')
      Mercury.trigger('mode', 'preview') unless @previewMode


  mask: ->
    return unless @config('interface:maskable')
    @$mask.show()


  unmask: ->
    @$mask.hide()


  dimensions: ->
    if @floating
      toolbarHeight = 0
      statusbarHeight = 0
    else
      toolbarHeight = @toolbar?.height()
      statusbarHeight = @statusbar?.height()
    top: toolbarHeight
    left: 0
    right: 0
    bottom: statusbarHeight
    width: $(window).width()
    height: $(window).height() - toolbarHeight - statusbarHeight


  onRegionFocus: (region) ->
    @region = region
    @delay(50, -> @position(true)) if @floating


  onRegionRelease: (region) ->
    @region = @regions[0] if region == @region
    index = @regions.indexOf(region)
    @regions.splice(index, 1) if index > -1


  onResize: =>
    Mercury.trigger('interface:resize', @dimensions())
    @position()


  onUnload: =>
    return null if @config('interface:silent') || !@hasChanges()
    return @t('You have unsaved changes.  Are you sure you want to leave without saving them first?')


  hasChanges: ->
    (return true if region.hasChanges()) for region in @regions
    false


  release: ->
    $(window).off('resize', @resize)
    @regions.shift().release() while @regions.length
    super


  serialize: ->
    data = {}
    for region in @regions
      data[region.name] = region.toJSON(true)
    data


  save: ->
    @page.set(content: @serialize(), location: location.pathname)
    @page.on('error', (xhr, options) => alert(@t('Mercury was unable to save to the url: %s', options.url)))
    @page.save().always = => @delay(250, -> Mercury.trigger('save:complete'))


  heightForWidth: (width) ->
    oldWidth = @$el.outerWidth()
    @css(width: width, visibility: 'hidden', height: 'auto')
    height = @$el.outerHeight()
    @css(width: oldWidth, visibility: 'visible')
    return height


  position: (animate = false) ->
    return unless @floating
    return unless @region
    @addClass('mercury-no-animation')
    pos = @region.$el.offset()
    width = Math.max(@config('interface:floatWidth') || @region.$el.width(), 300)
    height = @heightForWidth(width)
    callback = =>
      @removeClass('mercury-no-animation') if animate
      @css(top: pos.top - height, left: pos.left, width: width)
    if animate
      @delay(50, callback)
      @delay(300, -> Mercury.trigger('interface:resize', @dimensions()))
    else
      callback()
