#= require_self
#= require ./snippetable.snippet

class Carmenta.Regions.Snippetable
  type = 'snippetable'

  constructor: (@element, @options = {}) ->
    Carmenta.log('building snippetable', @element)

    @window = @options.window
    @document = @window.document
    @type = @element.data('type')
    @history = new Carmenta.HistoryBuffer()
    @toolbar = new Carmenta.Regions.Snippetable.Toolbar(@element, @document)
    @build()
    @bindEvents()
    @pushHistory()


  build: ->


  bindEvents: ->
    Carmenta.bind 'mode', (event, options) =>
      @togglePreview() if options.mode == 'preview'

    Carmenta.bind 'unfocus:regions', (event) =>
      @element.removeClass('focus')

    Carmenta.bind 'action', (event, options) =>
      return if @previewing
      return unless Carmenta.region == @
      @execCommand(options.action, options) if options.action

    @element.mouseup =>
      Carmenta.trigger('region:focused', {region: @})
      @focus()

    @element.mousemove (event) =>
      snippet = $(event.target).closest('.carmenta-snippet')
      @toolbar.show(snippet) if snippet.length

    @element.mouseout (event) =>


  togglePreview: ->
    if @previewing
      @previewing = false
      @element.addClass('carmenta-region').removeClass('carmenta-region-preview')
      @element.focus() if Carmenta.region == @
    else
      @previewing = true
      @element.addClass('carmenta-region-preview').removeClass('carmenta-region')
      @element.blur()
      Carmenta.trigger('region:blurred', {region: @})


  html: (value = null) ->
    if value
      @element.html(value)
    else
      return @element.html()


  focus: ->
    Carmenta.region = @
    @element.addClass('focus')


  pushHistory: ->
    @history.push('frist!!!!') # !remove
    @history.push(@html())


  execCommand: (action, options) ->
    @focus()
    @pushHistory() unless action == 'undo' || action == 'redo'

    Carmenta.log('execCommand', action, options.value)

    handler.call(@, options) if handler = Carmenta.Regions.Snippetable.actions[action]



Carmenta.Regions.Snippetable.actions =

  undo: -> @html(@history.undo())

  redo: -> @html(@history.redo())
