#= require_self
#= require ./snippetable.snippet
#= require ./snippetable.toolbar

class Mercury.Regions.Snippetable
  type = 'snippetable'

  constructor: (@element, @options = {}) ->
    Mercury.log('building snippetable', @element)

    @window = @options.window
    @document = @window.document
    @type = @element.data('type')
    @history = new Mercury.HistoryBuffer()
    @toolbar = new Mercury.Regions.Snippetable.Toolbar(@element, @document)
    @build()
    @bindEvents()
    @pushHistory()
    @makeSortable()


  build: ->
    @element.css({minHeight: 20}) if @element.css('minHeight') == '0px'


  bindEvents: ->
    Mercury.bind 'mode', (event, options) =>
      @togglePreview() if options.mode == 'preview'

    Mercury.bind 'unfocus:regions', (event) =>
      if Mercury.region == @
        @element.removeClass('focus')
        @element.sortable('destroy')
        Mercury.trigger('region:blurred', {region: @})

    Mercury.bind 'focus:window', (event) =>
      if Mercury.region == @
        @element.removeClass('focus')
        @element.sortable('destroy')
        Mercury.trigger('region:blurred', {region: @})

    Mercury.bind 'focus:frame', =>
      return if @previewing
      return unless Mercury.region == @
      @focus()

    Mercury.bind 'action', (event, options) =>
      return if @previewing
      return unless Mercury.region == @
      @execCommand(options.action, options) if options.action

    $(@document).keydown (event) =>
      return if @previewing
      return unless Mercury.region == @
      Mercury.changes = true
      switch event.keyCode

        when 90 # undo / redo
          return unless event.metaKey
          event.preventDefault()
          if event.shiftKey
            @execCommand('redo')
          else
            @execCommand('undo')

          return

    @element.mouseup =>
      return if @previewing
      @focus()
      Mercury.trigger('region:focused', {region: @})

    @element.mousemove (event) =>
      return if @previewing
      return unless Mercury.region == @
      @snippet = $(event.target).closest('.mercury-snippet')
      if @snippet.length
        @snippet.mouseout => @toolbar.hide()
        @toolbar.show(@snippet)

    @element.mouseout (event) =>
      @toolbar.hide()


  makeSortable: ->
    @element.sortable('destroy').sortable {
      document: @document,
      scroll: false, #scrolling is buggy
      containment: 'parent',
      items: '.mercury-snippet',
      opacity: .4,
      revert: 100,
      tolerance: 'pointer',
      connectWith: '.mercury-region[data-type=snippetable]',
      beforeStop: =>
        @toolbar.hide(true)
        return true
      stop: =>
        setTimeout((=> @pushHistory()), 100)
        return true
    }


  togglePreview: ->
    if @previewing
      @previewing = false
      @makeSortable()
      @element.addClass('mercury-region').removeClass('mercury-region-preview')
      @element.focus() if Mercury.region == @
    else
      @previewing = true
      @element.sortable('destroy')
      @element.addClass('mercury-region-preview').removeClass('mercury-region')
      @element.blur()
      Mercury.trigger('region:blurred', {region: @})


  html: (value = null) ->
    if value != null
      @element.html(value)
    else
      # sanitizes the html before we return it
      container = $('<div>').appendTo(@document.createDocumentFragment())
      container.html(@element.html().replace(/^\s+|\s+$/g, ''))
      html = container.html()

      return html


  focus: ->
    Mercury.region = @
    @makeSortable()
    @element.addClass('focus')


  pushHistory: ->
    @history.push(@html())


  execCommand: (action, options = {}) ->
    @focus()
    Mercury.log('execCommand', action, options.value)

    if handler = Mercury.Regions.Snippetable.actions[action]
      Mercury.changes = true
      handler.call(@, options)
      @pushHistory() unless action == 'undo' || action == 'redo'



Mercury.Regions.Snippetable.actions =

  undo: -> @html(@history.undo())

  redo: -> @html(@history.redo())

  removesnippet: ->
    @snippet.remove() if @snippet
    @toolbar.hide(true)