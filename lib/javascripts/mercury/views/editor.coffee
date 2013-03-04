#= require mercury/core/view
#= require mercury/templates/editor

class Mercury.Editor extends Mercury.View

  logPrefix: 'Mercury.Editor:'

  template: 'editor'

  attributes:
    id: 'mercury'

  events:
    'mousedown': 'keepRegionFocused'
    'click [data-action]': 'handleAction'

  constructor: (@options = {}) ->
    super
    @regions ||= []
    @addRegion(el) for el in @regionElements()
    @regions[0]?.focus()


  regionElements: ->
    $("[#{@config('regions:attribute')}]")


  addRegion: (el) ->
    region = Mercury.Region.create(el)
    region.on('focus', => @region = region)
    @regions.push(region)


  keepRegionFocused: (e) ->
    e.preventDefault()
    @region.focus()


  handleAction: (e) ->
    action = $(e.target).data('action')
    switch action
      when 'preview' then Mercury.trigger('mode', 'preview')
      else Mercury.trigger('action', action)


  save: ->
    data = {}
    for region in @regions
      data[region.name] = region.toJSON()
    data
