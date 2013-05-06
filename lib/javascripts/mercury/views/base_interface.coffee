#= require mercury/core/view
#= require mercury/models/page
#= require mercury/views/modules/interface_maskable
#= require mercury/views/modules/interface_shadowed

class Mercury.BaseInterface extends Mercury.View
  @include Mercury.Module

  @logPrefix: 'Mercury.BaseInterface:'
  @tag: 'mercury'

  @events:
    'mercury:save': 'save'
    'mercury:focus': 'focusActiveRegion'
    'mercury:blur': 'blurActiveRegion'
    'mercury:action': 'focusActiveRegion'
    'mercury:region:focus': 'onRegionFocus'
    'mercury:region:release': 'onRegionRelease'
    'mercury:reinitialize': 'reinitialize'

  constructor: ->
    if parent != window && parent.Mercury
      @log(@t('is already defined in parent frame'))
      return

    @extend Mercury.View.Modules.InterfaceMaskable if @config('interface:maskable')
    @extend Mercury.View.Modules.InterfaceShadowed if @config('interface:shadowed')

    Mercury.interface = @
    @floating = @config('interface:floating')
    @visible = true

    super

    @page = new Mercury.Model.Page()
    @regions ||= []
    $(window).on('beforeunload', @onUnload)
    $(window).on('resize', @onResize)

    @initialize()
    @buildInterface()
    @bindDefaultEvents()
    Mercury.trigger('initialized')


  build: ->
    @el = document.createElement(@tag || @constructor.tag) unless @el
    @$el = $(@el)
    @attr(@attributes)


  init: ->
    $('body').before(@$el)


  initialize: ->
    @addAllRegions()
    @bindDocumentEvents()


  addAllRegions: ->
    @addRegion(el) for el in @regionElements()
    @region ||= @regions[0]


  bindDocumentEvents: ->
    $('body', @document).on('mousedown', -> Mercury.trigger('dialogs:hide')) unless @config('interface:mask')


  buildInterface: ->
    @addClasses()
    for subview in ['toolbar', 'statusbar']
      continue unless klass = @config("interface:#{subview}")
      @[subview] = @appendView(new Mercury[klass]())
    unless @config('interface:enabled')
      @previewMode = true
      @hide()
      Mercury.trigger('mode', 'preview')
    @focusDefaultRegion()
    @onResize()
    @delay(500, -> @removeClass('loading'))


  addClasses: ->
    @addClass(@className)
    @addClass('loading')
    @addClass(@config('interface:style') || 'standard')
    @addClass('mercury-floating') if @floating
    @addClass("locale-#{Mercury.I18n.detectLocale().join('-').toLowerCase()}")


  bindDefaultEvents: ->
    @delegateEvents
      'mercury:mode': (mode) -> @setMode(mode)
      'mercury:action': -> @focusActiveRegion()


  reinitialize: ->
    @addAllRegions()
    @delay(100, @focusActiveRegion)


  focusDefaultRegion: ->
    @delay(100, @focusActiveRegion)


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
    @delay(50, -> @position(false)) if mode == 'preview'


  toggle: ->
    if @visible then @hide() else @show()


  show: ->
    return if @visible
    Mercury.trigger('interface:show')
    Mercury.trigger('mode', 'preview') if @previewMode
    @$el.show()
    @visible = true
    @$el.stop().animate({opacity: 1}, duration: 250)
    @position()


  hide: ->
    return unless @visible
    @hiding = true
    Mercury.trigger('interface:hide')
    Mercury.trigger('mode', 'preview') unless @previewMode
    @visible = false
    @position()
    @$el.stop().animate {opacity: 0}, duration: 250, complete: =>
      @$el.hide()
      @hiding = false


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
    return if @hiding
    @addClass('mercury-no-animation')
    pos = @region.$el.offset()
    width = Math.max(@config('interface:floatWidth') || @region.$el.width(), 300)
    height = @heightForWidth(width)
    callback = ->
      @removeClass('mercury-no-animation') if animate
      @css(top: pos.top - height, left: pos.left, width: width)
    if animate
      @delay(20, callback)
      Mercury.trigger('interface:resize', @dimensions())
    else
      callback.call(@)


  onRegionFocus: (region) ->
    @region = region
    @delay(50, -> @position(true)) if @floating


  onRegionRelease: (region) ->
    @region = @regions[0] if region == @region
    index = @regions.indexOf(region)
    @regions.splice(index, 1) if index > -1


  onResize: =>
    Mercury.trigger('interface:resize', @dimensions()) if @visible
    @position()


  onUnload: =>
    return null if @config('interface:silent') || !@hasChanges()
    return @t('You have unsaved changes.  Are you sure you want to leave without saving them first?')

