#= require mercury/core/view

class Mercury.Editor extends Mercury.View

  logPrefix: 'Mercury.Editor:'
  className: 'mercury-editor'

  attributes:
    id: 'mercury'

  events:
    'mousedown': 'focusActiveRegion'
    'focusout': 'focusActiveRegion'

  constructor: ->
    if parent != window && parent.Mercury
      @log(@t('is already defined in parent frame'))
      return

    super

    @regions ||= []

    $(window).on('beforeunload', => @beforeUnload())

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


  addAllRegions: ->
    @addRegion(el) for el in @regionElements()
    @regions[0]?.focus()
    Mercury.trigger('mode', 'preview') unless @config('interface:enabled')


  regionElements: ->
    $("[#{@config('regions:attribute')}]", @document)


  addRegion: (el) ->
    region = Mercury.Region.create(el)
    region.on('focus', => @region = region)
    @regions.push(region)


  focusActiveRegion: (e) ->
    e?.preventDefault?()
    @region.focus()


  beforeUnload: ->
    return null if @config('interface:silent') || !@hasChanges()
    return @t('You have unsaved changes.  Are you sure you want to leave without saving them first?')


  hasChanges: ->
    for region in @regions
      return true if region.hasChanges()
    false


  save: ->
    data = {}
    for region in @regions
      data[region.name] = region.toJSON()
    data
