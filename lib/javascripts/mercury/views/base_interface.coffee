#= require mercury/core/view

class Mercury.BaseInterface extends Mercury.View

  @logPrefix: 'Mercury.BaseInterface:'
  @tag: 'mercury'

  @events:
    'mousedown': 'focusActiveRegion'
    'focusout': 'focusActiveRegion'
    'mercury:focus': 'focusActiveRegion'
    'mercury:region:focus': 'onRegionFocus'
    'mercury:region:release': 'onRegionRelease'
    'mercury:reinitialize': 'reinitialize'

  constructor: ->
    if parent != window && parent.Mercury
      @log(@t('is already defined in parent frame'))
      return

    Mercury.interface = @

    super

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


  init: ->
    @addLocaleClass()
    $('body').before(@$el)
    @makeShadowed()
    @html(@renderTemplate(@template)) if @template
    @addClass('loading')


  initialize: ->
    @addAllRegions()


  reinitialize: ->
    @initialize()
    @focusActiveRegion()


  buildInterface: ->
    @buildToolbar()
    @buildStatusbar()
    @focusDefaultRegion()


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
    @append(@toolbar = new Mercury[klass]())
    @toolbar.hide() unless @config('interface:enabled')


  buildStatusbar: ->
    return unless klass = @config('interface:statusbar')
    @append(@statusbar = new Mercury[klass]())
    @statusbar.hide() unless @config('interface:enabled')


  bindDefaultEvents: ->
    @delegateEvents
     'mercury:mode': (mode) -> @setMode(mode)
     'mercury:action': -> @focusActiveRegion()


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
    e?.preventDefault?()
    @region?.focus()


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


  dimensions: ->
    toolbarHeight = @toolbar.height()
    statusbarHeight = @statusbar.height()
    top: toolbarHeight
    left: 0
    right: 0
    bottom: statusbarHeight
    width: $(window).width()
    height: $(window).height() - toolbarHeight - statusbarHeight


  onRegionFocus: (region) ->
    @region = region


  onRegionRelease: (region) ->
    @region = @regions[0] if region == @region
    index = @regions.indexOf(region)
    @regions.splice(index, 1) if index > -1


  onResize: =>
    Mercury.trigger('interface:resize', @dimensions())


  onUnload: =>
    return null if @config('interface:silent') || !@hasChanges()
    return @t('You have unsaved changes.  Are you sure you want to leave without saving them first?')


  hasChanges: ->
    (return true if region.hasChanges()) for region in @regions
    false


  release: ->
    @toolbar.release()
    @statusbar.release()
    $(window).off('resize', @resize)
    while @regions.length
      @regions.shift().release()
    super



  save: ->
    data = {}
    for region in @regions
      data[region.name] = region.toJSON(true)
    data
