class @Mercury.Region
  type = 'region'

  constructor: (@element, @window, @options = {}) ->
    @type = 'region' unless @type
    Mercury.log("building #{@type}", @element, @options)

    @document = @window.document
    @name = @element.attr('id')
    @collectDataAttributes()
    @history = new Mercury.HistoryBuffer()
    @build()
    @bindEvents()
    @pushHistory()
    @element.data('region', @)


  build: ->


  focus: ->


  collectDataAttributes: ->
    @data = {}
    $(Mercury.config.regionDataAttributes).each (index, item) =>
      @data[item] = @element.attr('data-' + item)

  bindEvents: ->
    Mercury.on 'mode', (event, options) => @togglePreview() if options.mode == 'preview'

    Mercury.on 'focus:frame', =>
      return if @previewing || Mercury.region != @
      @focus()

    Mercury.on 'action', (event, options) =>
      return if @previewing || Mercury.region != @
      @execCommand(options.action, options) if options.action

    @element.on 'mousemove', (event) =>
      return if @previewing || Mercury.region != @
      snippet = jQuery(event.target).closest('.mercury-snippet')
      if snippet.length
        @snippet = snippet
        Mercury.trigger('show:toolbar', {type: 'snippet', snippet: @snippet})

    @element.on 'mouseout', =>
      return if @previewing
      Mercury.trigger('hide:toolbar', {type: 'snippet', immediately: false})


  content: (value = null, filterSnippets = false) ->
    if value != null
      @element.html(value)
    else
      # sanitize the html before we return it
      container = jQuery('<div>').appendTo(@document.createDocumentFragment())
      container.html(@element.html().replace(/^\s+|\s+$/g, ''))

      # replace snippet contents to be an identifier
      if filterSnippets then for snippet in container.find('.mercury-snippet')
        snippet = jQuery(snippet)
        snippet.attr({contenteditable: null, 'data-version': null})
        snippet.html("[#{snippet.data('snippet')}]")

      return container.html()


  togglePreview: ->
    if @previewing
      @previewing = false
      @element.addClass(Mercury.config.regionClass).removeClass("#{Mercury.config.regionClass}-preview")
      @focus() if Mercury.region == @
    else
      @previewing = true
      @element.addClass("#{Mercury.config.regionClass}-preview").removeClass(Mercury.config.regionClass)
      Mercury.trigger('region:blurred', {region: @})


  execCommand: (action, options = {}) ->
    @focus()
    @pushHistory() unless action == 'redo'

    Mercury.log('execCommand', action, options.value)
    Mercury.changes = true


  pushHistory: ->
    @history.push(@content())


  snippets: ->
    snippets = {}
    for element in @element.find('[data-snippet]')
      snippet = Mercury.Snippet.find(jQuery(element).data('snippet'))
      snippet.setVersion(jQuery(element).data('version'))
      snippets[snippet.identity] = snippet.serialize()
    return snippets


  serialize: ->
    return {
      type: @type
      data: @data
      value: @content(null, true)
      snippets: @snippets()
    }
