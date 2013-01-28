class @Mercury.Region

  constructor: (@element, @window, @options = {}) ->
    Mercury.log("building #{@type()}", @element, @options)
    @document = @window.document
    @name = @element.attr(Mercury.config.regions.identifier)
    @history = new Mercury.HistoryBuffer()
    @build()
    @bindEvents()
    @pushHistory()
    @element.data('region', @)


  type: -> 'unknown'


  build: ->


  focus: ->


  bindEvents: ->
    Mercury.on 'mode', (event, options) => @togglePreview() if options.mode == 'preview'

    Mercury.on 'focus:frame', =>
      return if @previewing || Mercury.region != @
      @focus()

    Mercury.on 'action', (event, options) =>
      return if @previewing || Mercury.region != @ || event.isDefaultPrevented()
      @execCommand(options.action, options) if options.action

    @element.on 'mousemove', (event) =>
      return if @previewing || Mercury.region != @
      snippet = jQuery(event.target).closest('[data-snippet]')
      if snippet.length
        @snippet = snippet
        Mercury.trigger('show:toolbar', {type: 'snippet', snippet: @snippet}) if @snippet.data('snippet')

    @element.on 'mouseout', =>
      return if @previewing
      Mercury.trigger('hide:toolbar', {type: 'snippet', immediately: false})


  content: (value = null, filterSnippets = false) ->
    if value != null
      @element.html(value)
    else
      # sanitize the html before we return it
      # create the element without jQuery since $el.html() executes <script> tags
      container = document.createElement('div')
      container.innerHTML = @element.html().replace(/^\s+|\s+$/g, '')
      container = $(container)

      # replace snippet contents to be an identifier
      if filterSnippets then for snippet in container.find('[data-snippet]')
        snippet = jQuery(snippet)
        snippet.attr({contenteditable: null, 'data-version': null})
        snippet.html("[#{snippet.data('snippet')}]")

      return container.html()


  togglePreview: ->
    if @previewing
      @previewing = false
      @element.attr(Mercury.config.regions.attribute, @type())
      @focus() if Mercury.region == @
    else
      @previewing = true
      @element.removeAttr(Mercury.config.regions.attribute)
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
      continue unless snippet
      snippets[snippet.identity] = snippet.serialize()
    return snippets


  dataAttributes: ->
    data = {}
    data[attr] = (@container || @element).attr('data-' + attr) for attr in Mercury.config.regions.dataAttributes
    return data


  serialize: ->
    return {
      type: @type()
      data: @dataAttributes()
      value: @content(null, true)
      snippets: @snippets()
    }
