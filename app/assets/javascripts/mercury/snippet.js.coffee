class @Mercury.Snippet

  @all: []

  @displayOptionsFor: (name, options = {}, displayOptions = true) ->
    if displayOptions
      Mercury.modal @optionsUrl(name), jQuery.extend({
        title: 'Snippet Options'
        handler: 'insertSnippet'
        snippetName: name
        loadType: Mercury.config.snippets.method
      }, options)
    else
      snippet = Mercury.Snippet.create(name)
      Mercury.trigger('action', {action: 'insertSnippet', value: snippet})
    Mercury.snippet = null


  @optionsUrl: (name) ->
    url = Mercury.config.snippets.optionsUrl
    url = url() if typeof(url) == 'function'
    return url.replace(':name', name)


  @previewUrl: (name) ->
    url = Mercury.config.snippets.previewUrl
    url = url() if typeof(url) == 'function'
    return url.replace(':name', name)


  @create: (name, options) ->
    instance = new Mercury.Snippet(name, @uniqueId(), options)
    @all.push(instance)
    return instance

  @uniqueId: ->
    [i, identity] = [0, "snippet_0"]
    identities = (snippet.identity for snippet in @all)

    while identities.indexOf(identity) isnt -1
      i += 1
      identity = "snippet_#{i}"

    return identity


  @find: (identity) ->
    for snippet in @all
      return snippet if snippet.identity == identity
    return null


  @load: (snippets) ->
    for own identity, details of snippets
      instance = new Mercury.Snippet(details.name, identity, details)
      @all.push(instance)


  @clearAll = ->
    delete @all
    @all = []


  constructor: (@name, @identity, options = {}) ->
    @version = 0
    @data = ''
    @wrapperTag = 'div'
    @history = new Mercury.HistoryBuffer()
    @setOptions(options)


  getHTML: (context, callback = null) ->
    element = jQuery("<#{@wrapperTag}>", {
      class: "#{@name}-snippet"
      contenteditable: "false"
      'data-snippet': @identity
      'data-version': @version
    }, context)
    element.html("[#{@identity}]")
    @loadPreview(element, callback)
    return element


  getText: (callback) ->
    return "[--#{@identity}--]"


  loadPreview: (element, callback = null) ->
    jQuery.ajax Snippet.previewUrl(@name), {
      headers: Mercury.ajaxHeaders()
      type: Mercury.config.snippets.method
      data: @options
      success: (data) =>
        @data = data
        element.html(data)
        callback() if callback
      error: =>
        Mercury.notify('Error loading the preview for the \"%s\" snippet.', @name)
    }


  displayOptions: ->
    Mercury.snippet = @
    Mercury.modal Snippet.optionsUrl(@name), {
      title: 'Snippet Options',
      handler: 'insertSnippet',
      loadType: Mercury.config.snippets.method,
      loadData: @options
    }


  setOptions: (@options) ->
    delete(@options['authenticity_token'])
    delete(@options['utf8'])
    @wrapperTag = @options.wrapperTag if @options.wrapperTag
    @version += 1
    @history.push(@options)


  setVersion: (version = null) ->
    version = parseInt(version)
    if version && @history.stack[version - 1]
      @version = version
      @options = @history.stack[version - 1]
      return true
    return false


  serialize: ->
    return $.extend({name: @name}, @options )


