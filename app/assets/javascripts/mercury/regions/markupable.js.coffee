class Mercury.Regions.Markupable extends Mercury.Region
  type = 'markupable'

  constructor: (@element, @window, @options = {}) ->
    @type = 'markupable'
    super
    @converter = new Showdown.converter()


  build: ->
    width = @element.get(0).style.width
    width = '100%' unless width
    height = @element.height()

    value = @element.html().replace(/^\s+|\s+$/g, '')
    @textarea = $('<textarea>', @document).val(value)
    @textarea.addClass('mercury-textarea')
    @textarea.css({border: 0, background: 'transparent', display: 'block', width: width, height: height, fontFamily: '"Courier New", Courier, monospace', fontSize: '14px'})
    @element.after(@textarea)
    @element.hide()
    @resize()


  focus: ->
    @textarea.focus()


  bindEvents: ->
    Mercury.bind 'mode', (event, options) =>
      @togglePreview() if options.mode == 'preview'

    Mercury.bind 'focus:frame', =>
      return if @previewing
      return unless Mercury.region == @
      @focus()

    Mercury.bind 'action', (event, options) =>
      return if @previewing
      return unless Mercury.region == @
      @execCommand(options.action, options) if options.action

    @textarea.focus =>
      return if @previewing
      Mercury.region = @
      @textarea.addClass('focus')
      Mercury.trigger('region:focused', {region: @})

    @textarea.blur =>
      return if @previewing
      @textarea.removeClass('focus')
      Mercury.trigger('region:blurred', {region: @})

    @textarea.mouseup =>
      return if @previewing
      @pushHistory()
      Mercury.trigger('region:update', {region: @})

    @textarea.keydown (event) =>
      return if @previewing
      Mercury.changes = true
      @resize()
      switch event.keyCode

        when 90 # undo / redo
          return unless event.metaKey
          event.preventDefault()
          if event.shiftKey then @execCommand('redo') else @execCommand('undo')
          return

      if event.metaKey
        switch event.keyCode

          when 66 # b
            @execCommand('bold')
            event.preventDefault()

          when 73 # i
            @execCommand('italic')
            event.preventDefault()

          when 85 # u
            @execCommand('underline')
            event.preventDefault()

      @pushHistory(event.keyCode)

    @textarea.keyup =>
      return if @previewing
      Mercury.trigger('region:update', {region: @})

    @element.click (event) =>
      $(event.target).closest('a').attr('target', '_top') if @previewing


  html: (value = null, filterSnippets = true, includeMarker = false) ->
    if value != null
      @textarea.val(value)

      # create a selection if there's markers
      @selection().removeMarker()
    else
      # place markers for the selection
      if includeMarker
        selection = @selection()
        selection.placeMarker()

      # get the html before removing the markers
      val = @textarea.val()

      # remove the markers
      selection.removeMarker() if includeMarker

      return val


  togglePreview: ->
    if @previewing
      @element.hide()
      @textarea.show()
    else
      value = @converter.makeHtml(@textarea.val())
      console.debug(value)
      @element.html(value)
      @element.show()
      @textarea.hide()
    super


  execCommand: (action, options = {}) ->
    super

    handler.call(@, @selection(), options) if handler = Mercury.Regions.Markupable.actions[action]
    @resize()


  pushHistory: (keyCode) ->
    # when pressing return, delete or backspace it should push to the history
    # all other times it should store if there's a 1 second pause
    keyCodes = [13, 46, 8]
    waitTime = 2.5
    knownKeyCode = keyCodes.indexOf(keyCode) if keyCode

    # clear any pushes to the history
    clearTimeout(@historyTimeout)

    # if the key code was return, delete, or backspace store now -- unless it was the same as last time
    if knownKeyCode >= 0 && knownKeyCode != @lastKnownKeyCode # || !keyCode
      @history.push(@html(null, false, true))
    else if keyCode
      # set a timeout for pushing to the history
      @historyTimeout = setTimeout((=> @history.push(@html(null, false, true))), waitTime * 1000)
    else
      # push to the history immediately
      @history.push(@html(null, false, true))

    @lastKnownKeyCode = knownKeyCode


  selection: ->
    return new Mercury.Regions.Markupable.Selection(@textarea)


  resize: ->
    adjustedHeight = Math.max(@textarea.get(0).scrollHeight, @textarea.get(0).clientHeight)
    @textarea.height(adjustedHeight) if adjustedHeight >= @textarea.get(0).clientHeight


  snippets: ->


  # Actions
  @actions: {

    undo: -> @html(@history.undo())

    redo: -> @html(@history.redo())

    formatblock: (selection, options) ->
      # todo: wrap the line, not the selection
      # todo: remove any of the other block format elements before wrapping
      selection.wrap('## ', ' ##')

    # todo: things that are wrapped should not wrap empty or strings that just contain line feeds
    # todo: if it's an empty string that we're wrapping, put the cursor inside it
    # todo: do we unwrap things if it's already wrapped?
    bold: (selection) -> selection.wrap('**', '**')

    italic: (selection) -> selection.wrap('_', '_')

    subscript: (selection) -> selection.wrap('<sub>', '</sub>')

    superscript: (selection) -> selection.wrap('<sup>', '</sup>')

    horizontalrule: (selection) ->
      # todo: on a blank line don't insert line feeds
      # todo: at the start of a line, don't insert the first line feed
      # todo: at the end of a line don't insert the last line feed
      selection.replace('\n- - -\n')


  }


# Helper class for managing selection and getting information from it
class Mercury.Regions.Markupable.Selection

  constructor: (@element) ->
    @el = @element.get(0)
    @getDetails()


  getDetails: ->
    @length = @el.selectionEnd - @el.selectionStart
    @start = @el.selectionStart
    @end = @el.selectionEnd
    @text = @element.val().substr(@start, @length)


  replace: (text, select = false) ->
    @getDetails()
    val = @element.val()
    @element.val(val.substr(0, @start) + text + val.substr(@end, val.length))
    @select(@start, @start + text.length) if select


  select: (@start, @end) ->
    @element.focus()
    @el.selectionStart = @start
    @el.selectionEnd = @end
    @getDetails()


  wrap: (left, right) ->
    @getDetails()
    @replace(left + @text + right, true)


  placeMarker: ->
    @wrap('[mercury-marker]', '[mercury-marker]')


  removeMarker: ->
    val = @element.val()
    start = val.indexOf('[mercury-marker]')
    return unless start > -1
    end = val.indexOf('[mercury-marker]', start + 1) - '[mercury-marker]'.length
    @element.val(@element.val().replace(/\[mercury-marker\]/g, ''))
    @select(start, end)


