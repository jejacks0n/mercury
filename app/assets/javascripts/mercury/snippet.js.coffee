class Mercury.Snippet

  constructor: (@name, @identifier, options) ->
    @version = 0
    @history = new Mercury.HistoryBuffer()
    @setOptions(options)


  getHTML: (context, callback) ->
    element = $('<div class="mercury-snippet" contenteditable="false">', context)
    element.attr({'data-snippet': @identifier})
    element.attr({'data-version': @version})
    element.html("[#{@identifier}]")
    @loadPreview(element, callback)
    return element


  getText: (callback) ->
    return "[--#{@identity()}--]"


  loadPreview: (element, callback) ->
    $.ajax "/mercury/snippets/#{@name}/preview", {
      type: 'POST'
      data: @options
      success: (data) =>
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



$.extend Mercury.Snippet, {

  all: []

  displayOptionsFor: (name) ->
    Mercury.modal("/mercury/snippets/#{name}/options", {title: 'Snippet Options', handler: 'insertsnippet'})
    Mercury.snippet = null


  create: (name, options) ->
    identifier = "snippet_#{@all.length}"
    instance = new Mercury.Snippet(name, identifier, options)
    @all.push(instance)
    return instance


  find: (identifier) ->
    for snippet in @all
      return snippet if snippet.identifier == identifier
    return null

}
