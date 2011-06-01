class Mercury.Region
  type = 'region'

  constructor: (@element, @window, @options = {}) ->
    @type = 'region' unless @type
    Mercury.log("building #{@type}", @element, @options)

    @document = @window.document
    @name = @element.attr('id')
    @history = new Mercury.HistoryBuffer()
    @build()
    @bindEvents()
    @pushHistory()


  build: ->


  focus: ->


  bindEvents: ->
    Mercury.bind 'mode', (event, options) =>
      @togglePreview() if options.mode == 'preview'

    Mercury.bind 'focus:frame', =>
      return if @previewing
      return unless Mercury.region == @
      @focus()

    Mercury.bind 'action', (event, options) =>
      return if @previewing
      return unless Mercury.region == @
      @execCommand(options.action, options) if options.action

    @element.mousemove (event) =>
      return if @previewing
      return unless Mercury.region == @
      snippet = $(event.target).closest('.mercury-snippet')
      if snippet.length
        @snippet = snippet
        Mercury.trigger('show:toolbar', {type: 'snippet', snippet: @snippet})

    @element.mouseout (event) =>
      return if @previewing
      Mercury.trigger('hide:toolbar', {type: 'snippet', immediately: false})


  html: (value = null, filterSnippets = false) ->
    if value != null
      @element.html(value)
    else
      # sanitize the html before we return it
      container = $('<div>').appendTo(@document.createDocumentFragment())
      container.html(@element.html().replace(/^\s+|\s+$/g, ''))

      # replace snippet contents to be an identifier
      if filterSnippets then for snippet, index in container.find('.mercury-snippet')
        snippet = $(snippet)
        snippet.attr({contenteditable: null}).html("[snippet#{index}]")

      return container.html()


  togglePreview: ->
    if @previewing
      @previewing = false
      @element.addClass('mercury-region').removeClass('mercury-region-preview')
      @focus() if Mercury.region == @
    else
      @previewing = true
      @element.addClass('mercury-region-preview').removeClass('mercury-region')
      Mercury.trigger('region:blurred', {region: @})


  execCommand: (action, options = {}) ->
    @focus()
    @pushHistory() unless action == 'redo'

    Mercury.log('execCommand', action, options.value)
    Mercury.changes = true


  pushHistory: ->
    @history.push(@html())


  snippets: ->
    return {}


  serialize: ->
    return {
      type: @type,
      value: @html(null, true)
      snippets: @snippets()
    }


