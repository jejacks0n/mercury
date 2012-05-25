# todo:
# context for the toolbar buttons and groups needs to change so we can do the following:
# how to handle context for buttons?  if the cursor is within a bold area (**bo|ld**), or selecting it -- it would be
# nice if we could activate the bold button for instance.

class @Mercury.Regions.Simple extends Mercury.Region
  @supported: document.getElementById
  @supportedText: "IE 7+, Chrome 10+, Firefox 4+, Safari 5+, Opera 8+"

  type = 'simple'

  constructor: (@element, @window, @options = {}) ->
    @type = 'simple'
    super


  build: ->
    if @element.css('display') == 'block'
      width = '100%'
      height = @element.height()
    else
      width = @element.width()
      height = @element.height() # 'auto'

    value = @element.text()
    @element.removeClass(Mercury.config.regions.className)
    @textarea = jQuery('<textarea>', @document).val(value)
    @textarea.attr('class', @element.attr('class')).addClass('mercury-textarea')
    @textarea.css
      border: 0
      background: 'transparent'
      'overflow-y': 'hidden'
      width: width
      height: height
      fontFamily: 'inherit'
      fontSize: 'inherit'
      fontWeight: 'inherit'
      fontStyle: 'inherit'
      color: 'inherit'
      'min-height': 0
      padding: '0'
      margin: 0
      'border-radius': 0
      display: 'inherit'
      lineHeight: 'inherit'
      textAlign: 'inherit'
    @element.addClass(Mercury.config.regions.className)
    @element.empty().append(@textarea)

    @container = @element
    @container.data('region', @)
    @element = @textarea
    @resize()


  bindEvents: ->
    Mercury.on 'mode', (event, options) => @togglePreview() if options.mode == 'preview'
    Mercury.on 'focus:frame', => @focus() if !@previewing && Mercury.region == @

    Mercury.on 'action', (event, options) =>
      return if @previewing || Mercury.region != @
      @execCommand(options.action, options) if options.action

    Mercury.on 'unfocus:regions', =>
      return if @previewing || Mercury.region != @
      @element.blur()
      @container.removeClass('focus')
      Mercury.trigger('region:blurred', {region: @})

    @element.on 'dragenter', (event) =>
      return if @previewing
      event.preventDefault()
      event.originalEvent.dataTransfer.dropEffect = 'copy'

    @element.on 'dragover', (event) =>
      return if @previewing
      event.preventDefault()
      event.originalEvent.dataTransfer.dropEffect = 'copy'

    @element.on 'drop', (event) =>
      return if @previewing

      # handle dropping snippets
      if Mercury.snippet
        event.preventDefault()
        @focus()
        Mercury.Snippet.displayOptionsFor(Mercury.snippet)

      # handle any files that were dropped
      if event.originalEvent.dataTransfer.files.length
        event.preventDefault()
        @focus()
        Mercury.uploader(event.originalEvent.dataTransfer.files[0])

    @element.on 'focus', =>
      return if @previewing
      Mercury.region = @
      @container.addClass('focus')
      Mercury.trigger('region:focused', {region: @})

    @element.on 'keydown', (event) =>
      return if @previewing
      @resize()
      switch event.keyCode
        when 90 # undo / redo
          return unless event.metaKey
          event.preventDefault()
          if event.shiftKey then @execCommand('redo') else @execCommand('undo')
          return

        when 13 # enter or return
          selection = @selection()
          text = @element.val()
          start = text.lastIndexOf('\n', selection.start)
          end = text.indexOf('\n', selection.end)
          end = text.length if end < start
          start = text.lastIndexOf('\n', selection.start - 1) if text[start] == '\n'
          if text[start + 1] == '-'
            selection.replace('\n- ', false, true)
          if /\d/.test(text[start + 1])
            lineText = text.substring(start, end)
            if /(\d+)\./.test(lineText)
              number = parseInt(RegExp.$1)
              selection.replace("\n#{number += 1}. ", false, true)
          # Never allow return. Newlines won't survive the 
          # change-over to HTML, so just don't encourage their
          # use.
          event.preventDefault()

        when 9 # tab
          event.preventDefault()
          @execCommand('insertHTML', {value: '  '})

      @pushHistory(event.keyCode)

    @element.on 'keyup', =>
      return if @previewing
      Mercury.changes = true
      @resize()
      Mercury.trigger('region:update', {region: @})

    @element.on 'mouseup', =>
      return if @previewing
      @focus()
      Mercury.trigger('region:focused', {region: @})

    @element.on 'paste', (event) =>
      return if @previewing || Mercury.region != @
      if @specialContainer
        event.preventDefault()
        return
      return if @pasting
      Mercury.changes = true
      @handlePaste(event.originalEvent)


  handlePaste: (event) ->
    # get the text content from the clipboard and fall back to using the sanitizer if unavailable
    @execCommand('insertHTML', {value: event.clipboardData.getData('text/plain').replace(/\n/g, ' ')})
    event.preventDefault()
    return


  path: ->
    [@container.get(0)]


  focus: ->
    @element.focus()


  content: (value = null, filterSnippets = true) ->
    if value != null
      if jQuery.type(value) == 'string'
        @element.val(value)
      else
        @element.val(value.html)
        @selection().select(value.selection.start, value.selection.end)
    else
      return @element.val()


  contentAndSelection: ->
    return {html: @content(null, false), selection: @selection().serialize()}


  togglePreview: ->
    if @previewing
      @previewing = false
      @element = @container
      @build()
      @focus() if Mercury.region == @
      # @container.addClass(Mercury.config.regions.className).removeClass("#{Mercury.config.regions.className}-preview")
      # @previewElement.hide()
      # @element.show()
    else
      @previewing = true
      @container.addClass("#{Mercury.config.regions.className}-preview").removeClass(Mercury.config.regions.className)
      value = jQuery('<div></div>').text(@element.val()).html()
      @container.html(value)
      Mercury.trigger('region:blurred', {region: @})


  execCommand: (action, options = {}) ->
    super

    handler.call(@, @selection(), options) if handler = Mercury.Regions.Simple.actions[action]
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
      @history.push(@contentAndSelection())
    else if keyCode
      # set a timeout for pushing to the history
      @historyTimeout = setTimeout(waitTime * 1000, => @history.push(@contentAndSelection()))
    else
      # push to the history immediately
      @history.push(@contentAndSelection())

    @lastKnownKeyCode = knownKeyCode


  selection: ->
    return new Mercury.Regions.Simple.Selection(@element)


  resize: ->
    @element.css({height: @element.get(0).scrollHeight - 100})
    @element.css({height: @element.get(0).scrollHeight});


  snippets: ->


  # Actions
  @actions: {

    undo: -> @content(@history.undo())

    redo: -> @content(@history.redo())

    insertHTML: (selection, options) ->
      if options.value.get && element = options.value.get(0)
        options.value = jQuery('<div>').html(element).html()
      selection.replace(options.value, false, true)

  }


# Helper class for managing selection and getting information from it
class Mercury.Regions.Simple.Selection

  constructor: (@element) ->
    @el = @element.get(0)
    @getDetails()


  serialize: ->
    return {start: @start, end: @end}


  getDetails: ->
    @length = @el.selectionEnd - @el.selectionStart
    @start = @el.selectionStart
    @end = @el.selectionEnd
    @text = @element.val().substr(@start, @length)


  replace: (text, select = false, placeCursor = false) ->
    @getDetails()
    val = @element.val()
    savedVal = @element.val()
    @element.val(val.substr(0, @start) + text + val.substr(@end, val.length))
    changed = @element.val() != savedVal
    @select(@start, @start + text.length) if select
    @select(@start + text.length, @start + text.length) if placeCursor
    return changed


  select: (@start, @end) ->
    @element.focus()
    @el.selectionStart = @start
    @el.selectionEnd = @end
    @getDetails()


  wrap: (left, right) ->
    @getDetails()
    @deselectNewLines()
    @replace(left + @text + right, @text != '')
    @select(@start + left.length, @start + left.length) if @text == ''


  deselectNewLines: ->
    text = @text
    length = text.replace(/\n+$/g, '').length
    @select(@start, @start + length)


  placeMarker: ->
    @wrap('[mercury-marker]', '[mercury-marker]')


  removeMarker: ->
    val = @element.val()
    start = val.indexOf('[mercury-marker]')
    return unless start > -1
    end = val.indexOf('[mercury-marker]', start + 1) - '[mercury-marker]'.length
    @element.val(@element.val().replace(/\[mercury-marker\]/g, ''))
    @select(start, end)


  textContent: ->
    return @text
