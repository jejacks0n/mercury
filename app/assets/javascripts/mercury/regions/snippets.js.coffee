class @Mercury.Regions.Snippets extends Mercury.Region
  @supported: document.getElementById
  @supportedText: "Chrome 10+, Firefox 4+, IE 7+, Safari 5+, Opera 8+"
  type = 'snippets'
  type: -> type

  constructor: (@element, @window, @options = {}) ->
    Mercury.log("building #{type}", @element, @options)
    super
    @makeSortable()


  build: ->
    jQuery(snippet).attr('data-version', 0) for snippet in @element.find('[data-snippet]')
    @element.css({minHeight: 20}) if @element.css('minHeight') == '0px'


  bindEvents: ->
    super

    Mercury.on 'unfocus:regions', (event) =>
      return if @previewing
      if Mercury.region == @
        @element.removeClass('focus')
        @disableSortable()
        Mercury.trigger('region:blurred', {region: @})

    Mercury.on 'focus:window', (event) =>
      return if @previewing
      if Mercury.region == @
        @element.removeClass('focus')
        @disableSortable()
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
      Mercury.Snippet.displayOptionsFor(Mercury.snippet.name, {}, Mercury.snippet.hasOptions)

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
      @disableSortable()
      @element.removeClass('focus')
    super


  execCommand: (action, options = {}) ->
    super
    handler.call(@, options) if handler = Mercury.Regions.Snippets.actions[action]

  disableSortable: ->
    @element.sortable('disable') if @element.hasClass('ui-sortable')
    
  makeSortable: ->
    if @element.hasClass('ui-sortable')
      @element.sortable('enable')
    else
      @element.sortable {
        document: @document,
        scroll: false, #scrolling is buggy
        containment: 'parent',
        items: '[data-snippet]',
        opacity: 0.4,
        revert: 100,
        tolerance: 'pointer',
        beforeStop: =>
          Mercury.trigger('hide:toolbar', {type: 'snippet', immediately: true})
          return true
        stop: =>
          setTimeout((=> @pushHistory()), 100)
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
