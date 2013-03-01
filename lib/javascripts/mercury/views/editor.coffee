#= require mercury/core/view

class Mercury.Editor extends Mercury.View

  logPrefix: 'Mercury.Editor:'

  attributes:
    id: 'mercury'

  constructor: (@options = {}) ->
    super
    @regions = for region in @regionElements()
      Mercury.Region.create(region)


  regionElements: ->
    $("[#{@config('regions:attribute')}]")


  save: ->
    data = {}
    for region in @regions
      data[region.name] = region.toJSON()
    data
