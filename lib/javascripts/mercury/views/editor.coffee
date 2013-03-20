#= require mercury/core/view

class Mercury.Editor extends Mercury.View

  logPrefix: 'Mercury.Editor:'
  className: 'mercury-editor'

  attributes:
    id: 'mercury'

  events:
    'mousedown': 'focusActiveRegion'

  constructor: ->
    if parent != window && parent.Mercury
      @log(@t('is already defined in outer frame'))
      return

    super

    @regions ||= []

    @addClass('loading')
    @appendTo(@document ||= $('body'))
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
    @toolbar.hide() if @config('interface:hidden')


  buildStatusbar: ->
    return unless klass = @config('interface:statusbar')
    @append(@statusbar = new Mercury[klass]())
    @statusbar.hide() if @config('interface:hidden')


  bindDefaultEvents: ->
    Mercury.on 'mode', => @focusActiveRegion()
    Mercury.on 'action', => @focusActiveRegion()


  addAllRegions: ->
    @addRegion(el) for el in @regionElements()
    @regions[0]?.focus()
    Mercury.trigger('mode', 'preview') if @config('interface:hidden')


  regionElements: ->
    $("[#{@config('regions:attribute')}]", @document)


  addRegion: (el) ->
    region = Mercury.Region.create(el)
    region.on('focus', => @region = region)
    @regions.push(region)


  focusActiveRegion: (e) ->
    e?.preventDefault?()
    @region.focus()


  save: ->
    data = {}
    for region in @regions
      data[region.name] = region.toJSON()
    data
