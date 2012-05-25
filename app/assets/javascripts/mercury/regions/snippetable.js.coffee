class @Mercury.Regions.Snippetable extends Mercury.Region
  @supported: document.getElementById
  @supportedText: "IE 7+, Chrome 10+, Firefox 4+, Safari 5+, Opera 8+"

  type = 'snippetable'

  constructor: (@element, @window, @options = {}) ->
    @type = 'snippetable'
    super
    @makeSortable()


  build: ->
    @element.css({minHeight: 20}) if @element.css('minHeight') == '0px'


  bindEvents: ->
    super

    Mercury.on 'unfocus:regions', (event) =>
      return if @previewing
      if Mercury.region == @
        @element.removeClass('focus')
        @element.sortable('destroy')
        Mercury.trigger('region:blurred', {region: @})

    Mercury.on 'focus:window', (event) =>
      return if @previewing
      if Mercury.region == @
        @element.removeClass('focus')
        @element.sortable('destroy')
        Mercury.trigger('region:blurred', {region: @})

    @element.on 'mouseup', =>
      return if @previewing
      @focus()
      Mercury.trigger('region:focused', {region: @})

    @element.on 'dragover', (event) =>
      return if @previewing
      event.preventDefault()
      event.originalEvent.dataTransfer.dropEffect = 'copy'

    @element.on 'drop', (event) =>
      return if @previewing || ! Mercury.snippet
      @focus()
      event.preventDefault()
      Mercury.Snippet.displayOptionsFor(Mercury.snippet)

    jQuery(@document).on 'keydown', (event) =>
      return if @previewing || Mercury.region != @
      switch event.keyCode
        when 90 # undo / redo
          return unless event.metaKey
          event.preventDefault()
          if event.shiftKey then @execCommand('redo') else @execCommand('undo')

    jQuery(@document).on 'keyup', =>
      return if @previewing || Mercury.region != @
      Mercury.changes = true


  focus: ->
    Mercury.region = @
    @makeSortable()
    @element.addClass('focus')


  togglePreview: ->
    if @previewing
      @makeSortable()
    else
      @element.sortable('destroy')
      @element.removeClass('focus')
    super


  execCommand: (action, options = {}) ->
    super
    handler.call(@, options) if handler = Mercury.Regions.Snippetable.actions[action]


  makeSortable: ->
    @element.sortable('destroy').sortable {
      document: @document,
      scroll: false, #scrolling is buggy
      containment: 'parent',
      items: '.mercury-snippet',
      opacity: 0.4,
      revert: 100,
      tolerance: 'pointer',
      beforeStop: =>
        Mercury.trigger('hide:toolbar', {type: 'snippet', immediately: true})
        return true
      stop: =>
        setTimeout(100, => @pushHistory())
        return true
    }


  # Actions
  @actions: {

    undo: -> @content(@history.undo())

    redo: -> @content(@history.redo())

    insertSnippet: (options) ->
      snippet = options.value
      if (existing = @element.find("[data-snippet=#{snippet.identity}]")).length
        existing.replaceWith(snippet.getHTML(@document, => @pushHistory()))
      else
        @element.append(snippet.getHTML(@document, => @pushHistory()))

    editSnippet: ->
      return unless @snippet
      snippet = Mercury.Snippet.find(@snippet.data('snippet'))
      snippet.displayOptions()

    removeSnippet: ->
      @snippet.remove() if @snippet
      Mercury.trigger('hide:toolbar', {type: 'snippet', immediately: true})

  }
