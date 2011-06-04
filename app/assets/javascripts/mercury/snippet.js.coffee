class Mercury.Snippet

  constructor: (@name, @identifier, @options) ->
    @text = "[--#{@identifier}--]"


  getHTML: (context, callback) ->
    element = $('<div class="mercury-snippet" contenteditable="false">', context)
    element.attr({'data-snippet': @identifier})
    element.html("[#{@identifier}]")
    @loadPreview(element, callback)
    return element


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
    Mercury.modal "/mercury/snippets/#{@name}/options", {
      title: 'Snippet Options',
      handler: 'insertsnippet',
      loadType: 'post',
      loadData: @options
    }



$.extend Mercury.Snippet, {

  all: []

  displayOptionsFor: (name) ->
    Mercury.modal("/mercury/snippets/#{name}/options", {title: 'Snippet Options', handler: 'insertsnippet'})


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
