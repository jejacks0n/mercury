#= require mercury/core/view
#= require mercury/templates/editor

class Mercury.Editor extends Mercury.View

  logPrefix: 'Mercury.Editor:'

  template: 'editor'

  attributes:
    id: 'mercury'

  events:
    'mousedown': 'keepRegionFocused'
    'click [data-action]': 'processAction'

  constructor: ->
    if parent != window && parent.Mercury
      @log(@t('is already defined in outer frame'))
      return

    super

    @regions ||= []
    @document ||= $('body')

    @appendTo(document.body)
    @setupFrame() if @frame = $(@frame).get(0)
    @initialize()


  setupFrame: ->
    @frame = $(@frame).addClass('mercury-editor-frame').attr(seamless: 'seamless')
    Mercury.on 'initialize', => @initialize()
    @frame.on 'load', =>
      @document = $(@frame.get(0).contentWindow.document)
      @initialize()


  initialize: ->
    @addAllRegions()


  addAllRegions: ->
    @addRegion(el) for el in @regionElements()
    @regions[0]?.focus()


  regionElements: ->
    $("[#{@config('regions:attribute')}]", @document)


  addRegion: (el) ->
    region = Mercury.Region.create(el)
    region.on('focus', => @region = region)
    @regions.push(region)


  keepRegionFocused: (e) ->
    e?.preventDefault()
    @region.focus()


  save: ->
    data = {}
    for region in @regions
      data[region.name] = region.toJSON()
    data


  processAction: (e) ->
    target = $(e.target)
    action = target.data('action')
    value = target.data('value')
    switch action
      when 'preview'
        Mercury.trigger('mode', 'preview')
        @keepRegionFocused()
      when 'html'
        value = switch value
          when 'html' then '<table>\n  <tr>\n    <td>1</td>\n    <td>2</td>\n  </tr>\n</table>'
          when 'el' then $('<section class="foo"><h1>testing</h1></section>').get(0)
          when 'jquery' then $('<section class="foo"><h1>testing</h1></section>')
        Mercury.trigger('action', action, value)
      else Mercury.trigger('action', action, value)

