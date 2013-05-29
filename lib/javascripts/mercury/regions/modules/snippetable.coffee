Mercury.Region.Modules.Snippetable =

  included: ->
    @on('action', @restoreSnippets)


  restoreSnippets: ->
    for el in @$("[data-mercury-snippet]")
      $el = $(el)
      Mercury.Snippet.find($el.data('mercury-snippet')).replaceWithView($el) unless $el.data('snippet')
    @onLoadSnippet?()


  snippets: ->
    snippets = {}
    for el in @$('[data-mercury-snippet]')
      snippet = Mercury.Snippet.find($(el).data('mercury-snippet'))
      snippets[snippet.cid] = snippet.toJSON()
    snippets


  loadSnippets: (json = {}) ->
    @clearStack()
    @loadSnippet(cid, data) for cid, data of json


  loadSnippet: (cid, data) ->
    Mercury.Snippet.fromSerializedJSON(data).renderAndReplaceWithView @$("[data-mercury-snippet=#{cid}]"), => try
      @initialValue = JSON.stringify(@toJSON())
      @pushHistory()
      @onLoadSnippet?()
