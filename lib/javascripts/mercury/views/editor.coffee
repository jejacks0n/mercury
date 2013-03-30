#= require mercury/core/view

class Mercury.Editor extends Mercury.View

  logPrefix: 'Mercury.Editor:'
  className: 'mercury-editor'

  attributes:
    id: 'mercury'

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

    @addClass('loading')
    $('body').before(@el)
    @initialize()
    @buildInterface()
    @bindDefaultEvents()
    @el.removeClass('loading')


  initialize: ->
    @addAllRegions()
    Mercury.trigger('initialized')


  buildInterface: ->
    @buildToolbar()
    @buildStatusbar()
    @focusDefaultRegion()


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
    @delay(100, -> @regions[0]?.focus())


  addAllRegions: ->
    @addRegion(el) for el in @regionElements()
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
