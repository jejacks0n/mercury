class Mercury.Snippet

  constructor: (@name, @identity, options) ->
    @version = 0
    @data = ''
    @history = new Mercury.HistoryBuffer()
    @setOptions(options)


  getHTML: (context, callback) ->
    element = $('<div class="mercury-snippet" contenteditable="false">', context)
    element.attr({'data-snippet': @identity})
    element.attr({'data-version': @version})
    element.html("[#{@identity}]")
    @loadPreview(element, callback)
    return element


  getText: (callback) ->
    return "[--#{@identity}--]"


  loadPreview: (element, callback) ->
    $.ajax "/mercury/snippets/#{@name}/preview", {
      type: 'POST'
      data: @options
      success: (data) =>
        @data = data
        element.html(data)
        callback() if callback
      error: =>
        alert("Error rendering preview for the #{@name} snippet.")
    }


  displayOptions: ->
    Mercury.snippet = @
    Mercury.modal "/mercury/snippets/#{@name}/options", {
      title: 'Snippet Options',
      handler: 'insertsnippet',
      loadType: 'post',
      loadData: @options
    }


  setOptions: (@options) ->
    @version += 1
    @history.push(@options)


  setVersion: (version) ->
    version = parseInt(version)
    if version && @history.stack[version - 1]
      @version = version - 1
      @options = @history.stack[@version]
      return true
    return false


  serialize: ->
    return {
      name: @name,
      options: @options
    }



$.extend Mercury.Snippet, {

  all: []

  displayOptionsFor: (name) ->
    Mercury.modal("/mercury/snippets/#{name}/options", {title: 'Snippet Options', handler: 'insertsnippet'})
    Mercury.snippet = null


  create: (name, options) ->
    identity = "snippet_#{@all.length}"
    instance = new Mercury.Snippet(name, identity, options)
    @all.push(instance)
    return instance


  find: (identity) ->
    for snippet in @all
      return snippet if snippet.identity == identity
    return null

}
