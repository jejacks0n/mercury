#= require mercury/core/view
#= require mercury/views/modules/developer_toolbar

class Mercury.BaseInterface extends Mercury.View
  @include Mercury.View.Modules.DeveloperToolbar

  logPrefix: 'Mercury.BaseInterface:'
  tag: 'mercury'

  events:
    'mousedown': 'focusActiveRegion'
    'focusout': 'focusActiveRegion'
    'region:focus': 'onRegionFocus'

  constructor: ->
    if parent != window && parent.Mercury
      @log(@t('is already defined in parent frame'))
      return

    super

    @regions ||= []
    $(window).on('beforeunload', => @onUnload())

    @initialize()
    @buildInterface()
    @bindDefaultEvents()
    @el.removeClass('loading')
    Mercury.trigger('initialized')


  build: ->
    @el = document.createElement(@tag) unless @el
    @el = $(@el)
    @$el = @el
    @attr(@attributes)
    @addClass(@className)


  init: ->
    $('body').before(@el)
    @makeShadowed()
    @html(@renderTemplate(@template)) if @template
    @addClass('loading')


  initialize: ->
    @addAllRegions()


  buildInterface: ->
    @buildToolbar()
    @buildStatusbar()
    @focusDefaultRegion()


  makeShadowed: ->
    return unless @config('interface:shadowed') && @el.get(0).webkitCreateShadowRoot
    @shadow = $(@el.get(0).webkitCreateShadowRoot())
    # todo: this is a problem in that it allows css to bleed, which isn't exactly what we want here, but getting css
    #       to load internally isn't viable. ??
    @shadow.get(0).applyAuthorStyles = true
    @shadow.append(@el = $(document.createElement(@tag)))
    @$el = @el


  buildToolbar: ->
    return unless klass = @config('interface:toolbar')
    @append(@toolbar = new Mercury[klass]())
    @toolbar.hide() unless @config('interface:enabled')


  buildStatusbar: ->
    return unless klass = @config('interface:statusbar')
    @append(@statusbar = new Mercury[klass]())
    @statusbar.hide() unless @config('interface:enabled')


  bindDefaultEvents: ->
    Mercury.on 'mode', => @focusActiveRegion()
    Mercury.on 'action', => @focusActiveRegion()


  focusDefaultRegion: ->
    @delay(100, @focusActiveRegion)


  addAllRegions: ->
    @addRegion(el) for el in @regionElements()
    @region = @regions[0]
    Mercury.trigger('mode', 'preview') unless @config('interface:enabled')


  regionElements: ->
    $("[#{@config('regions:attribute')}]", @document)


  addRegion: (el) ->
    region = Mercury.Region.create(el)
    @regions.push(region)


  focusActiveRegion: (e) ->
    e?.preventDefault?()
    @region.focus()


  onRegionFocus: (region) ->
    @region = region


  onUnload: ->
    return null if @config('interface:silent') || !@hasChanges()
    return @t('You have unsaved changes.  Are you sure you want to leave without saving them first?')


  hasChanges: ->
    (return true if region.hasChanges()) for region in @regions
    false


  save: ->
    data = {}
    for region in @regions
      data[region.name] = region.toJSON()
    data
