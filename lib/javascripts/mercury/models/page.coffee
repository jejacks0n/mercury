#= require mercury/core/model
#= require mercury/core/region

class Mercury.Model.Page extends Mercury.Model

  @define 'Mercury.Model.Page'

  constructor: ->
    super
    @regions = []


  createRegions: (elements) ->
    @createRegion(el) for el in elements
    @region ||= @regions[0]


  createRegion: (el) ->
    return if $(el).data('region')
    @regions.push(Mercury.Region.create(el))


  loadRegionContent: (json) ->
    @findRegionByName(name)?.load(data) for name, data of json.contents || json


  findRegionByName: (name) ->
    for region in @regions || []
      return region if region.name == name
    null


  hasChanges: ->
    (return true if region.hasChanges()) for region in @regions
    false


  serialize: ->
    data = {}
    data[region.name] = region.toJSON(true) for region in @regions
    data


  isValid: ->
    @set(content: @serialize(), location: location.pathname)
    super


  save: (options = {}) ->
    super($.extend(@config('saving'), options))


  release: ->
    @regions.shift().release() while @regions.length


  releaseRegion: (region) ->
    @region = @regions[0] if region == @region
    region.release()
    index = @regions.indexOf(region)
    @regions.splice(index, 1) if index > -1
