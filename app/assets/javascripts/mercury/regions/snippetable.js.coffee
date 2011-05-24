#= require_self
#= require ./snippetable.toolbar

class Mercury.Regions.Snippetable extends Mercury.Region
  type = 'snippetable'

  constructor: (@element, @window, @options = {}) ->
    @type = 'snippetable'
    super
    @toolbar = new Mercury.Regions.Snippetable.Toolbar(@element, @document)
    @makeSortable()


  build: ->
    @element.css({minHeight: 20}) if @element.css('minHeight') == '0px'


  bindEvents: ->
    super

    Mercury.bind 'unfocus:regions', (event) =>
      return if @previewing
      if Mercury.region == @
        @element.removeClass('focus')
        @element.sortable('destroy')
        Mercury.trigger('region:blurred', {region: @})

    Mercury.bind 'focus:window', (event) =>
      return if @previewing
      if Mercury.region == @
        @element.removeClass('focus')
        @element.sortable('destroy')
        Mercury.trigger('region:blurred', {region: @})

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



Mercury.Regions.Snippetable.actions =

  undo: -> @html(@history.undo())

  redo: -> @html(@history.redo())

  removesnippet: ->
    @snippet.remove() if @snippet
    @toolbar.hide(true)