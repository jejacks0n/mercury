#= require_self
#= require ./editable.selection

class Carmenta.Regions.Editable
  type = 'editable'

  constructor: (@element, @options = {}) ->
    Carmenta.log('making editable', @element, @options)

    @window = @options.window
    @document = @window.document
    @type = @element.data('type')
    @history = new Carmenta.HistoryBuffer()
    @build()
    @bindEvents()
    @pushHistory()


  build: ->
    @element.addClass('carmenta-region')

    # mozilla: set some initial content so everything works correctly
    @html('&nbsp;') if $.browser.mozilla && @html() == ''

    # set overflow just in case
    @element.data({originalOverflow: @element.css('overflow')})
    @element.css({overflow: 'auto'})

    # mozilla: there's some weird behavior when the element isn't a div
    @specialContainer = $.browser.mozilla && @element.get(0).tagName != 'DIV'

    # make it editable
    @element.get(0).contentEditable = true

    # add the basic editor settings to the document (only once)
    unless @document.carmentaEditing
      @document.execCommand('styleWithCSS', false, false)
      @document.execCommand('insertBROnReturn', false, true)
      @document.execCommand('enableInlineTableEditing', false, false)
      @document.execCommand('enableObjectResizing', false, false)
      @document.carmentaEditing = true


  bindEvents: ->
    Carmenta.bind 'mode', (event, options) =>
      @togglePreview() if options.mode == 'preview'

    Carmenta.bind 'focus:frame', =>
      return if @previewing
      return unless Carmenta.region == @
      @focus()

    Carmenta.bind 'action', (event, options) =>
      return if @previewing
      return unless Carmenta.region == @
      @execCommand(options.action, options) if options.action

    @element.bind 'paste', =>
      return if @previewing
      return unless Carmenta.region == @
      Carmenta.changes = true
      html = @html()
      event.preventDefault() if @specialContainer
      setTimeout((=> @handlePaste(html)), 1)

    @element.bind 'drop', =>
      return if @previewing
      console.debug('dropped')

    @element.focus =>
      return if @previewing
      Carmenta.region = @
      Carmenta.trigger('region:focused', {region: @})

    @element.blur =>
      return if @previewing
      Carmenta.trigger('region:blurred', {region: @})

    @element.click (event) =>
      $(event.target).closest('a').attr('target', '_top') if @previewing

    @element.mouseup =>
      return if @previewing
      @pushHistory()
      Carmenta.trigger('region:update', {region: @})

    @element.keydown (event) =>
      return if @previewing
      Carmenta.changes = true
      switch event.keyCode

        when 90 # undo / redo
          return unless event.metaKey
          event.preventDefault()
          if event.shiftKey
            @execCommand('redo')
          else
            @pushHistory()
            @execCommand('undo')

          return

        when 13 # enter
          if $.browser.webkit
            event.preventDefault()
            @document.execCommand('insertlinebreak', false, null)
          else if @specialContainer
            # mozilla: pressing enter in any elemeny besides a div handles strangely
            event.preventDefault()
            @document.execCommand('insertHTML', false, '<br/>')

        when 90 # undo and redo
          break unless event.metaKey
          event.preventDefault()
          if event.shiftKey then @execCommand('redo') else @execCommand('undo')

        when 9 # tab
          event.preventDefault()
          container = @selection().commonAncestor()
          handled = false

          # indent when inside of an li
          if container.closest('li', @element).length
            handled = true
            if event.shiftKey then @execCommand('outdent') else @execCommand('indent')

          @execCommand('insertHTML', {value: '&nbsp; '}) unless handled

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

    @element.keyup =>
      return if @previewing
      Carmenta.trigger('region:update', {region: @})


  html: (value = null, includeMarker = false) ->
    if value
      @element.html(value)
      @selection().selectMarker(@element)
    else
      @element.find('meta').remove()
      if includeMarker
        selection = @selection()
        selection.placeMarker()

      # sanitizes the html before we return it
      container = $('<div>').appendTo(@document.createDocumentFragment())
      container.html(@element.html().replace(/^\s+|\s+$/g, ''))
      html = container.html()

      selection.removeMarker() if includeMarker
      return html


  selection: ->
    return new Carmenta.Regions.Editable.Selection(@window.getSelection(), @document)


  togglePreview: ->
    if @previewing
      @previewing = false
      @element.get(0).contentEditable = true
      @element.addClass('carmenta-region').removeClass('carmenta-region-preview')
      @element.css({overflow: 'auto'})
      @element.focus() if Carmenta.region == @
    else
      @previewing = true
      @element.get(0).contentEditable = false
      @element.addClass('carmenta-region-preview').removeClass('carmenta-region')
      @element.css({overflow: @element.data('originalOverflow')})
      @element.blur()
      Carmenta.trigger('region:blurred', {region: @})


  focus: ->
    @element.focus()
    Carmenta.trigger('region:update', {region: @})


  path: ->
    container = @selection().commonAncestor()
    container.parentsUntil(@element)


  currentElement: ->
    element = @selection().commonAncestor()
    element = element.parent() if element.get(0).nodeType == 3
    return element


  handlePaste: (prePasteHTML) ->
    prePasteHTML = prePasteHTML.replace(/^\<br\>/, '')

    # remove any regions that might have been pasted
    @element.find('.carmenta-region').remove()

    # handle pasting from ms office etc
    html = @html()
    if html.indexOf('<!--StartFragment-->') > -1 || html.indexOf('="mso-') > -1 || html.indexOf('<o:') > -1 || html.indexOf('="Mso') > -1
      cleaned = prePasteHTML.singleDiff(@html()).sanitizeHTML()
      try
        @document.execCommand('undo', false, null)
        @execCommand('insertHTML', {value: cleaned})
      catch error
        @html(prePasteHTML)
        Carmenta.modal '/carmenta/modals/sanitizer', {
          title: 'HTML Sanitizer (Starring Clippy)',
          afterLoad: -> @element.find('textarea').val(cleaned.replace(/<br\/>/g, '\n'))
        }


  execCommand: (action, options = {}) ->
    @element.focus()
    @pushHistory() unless action == 'undo' || action == 'redo'

    Carmenta.log('execCommand', action, options.value)

    # use a custom handler if there's one, otherwise use execCommand
    if handler = Carmenta.config.behaviors[action] || Carmenta.Regions.Editable.actions[action]
      handler.call(@, @selection(), options)
    else
      sibling = @element.get(0).previousSibling if action == 'indent'
      options.value = $('<div>').html(options.value).html() if action == 'insertHTML' && options.value && options.value.get
      try
        @document.execCommand(action, false, options.value)
      catch error
        # mozilla: indenting when there's no br tag handles strangely
        @element.prev().remove() if action == 'indent' && @element.prev() != sibling


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
      @history.push(@html(null, true))
    else if keyCode
      # set a timeout for pushing to the history
      @historyTimeout = setTimeout((=> @history.push(@html(null, true))), waitTime * 1000)
    else
      # push to the history immediately
      @history.push(@html(null, true))

    @lastKnownKeyCode = knownKeyCode



# Custom handled actions (eg. things that execCommand doesn't do, or doesn't do well)
Carmenta.Regions.Editable.actions =

  undo: -> @html(@history.undo())

  redo: -> @html(@history.redo())

  removeformatting: (selection) -> selection.insertTextNode(selection.textContent())

  backcolor: (selection, options) -> selection.wrap("<span style=\"background-color:#{options.value.toHex()}\">", true)

  overline: (selection, options) -> selection.wrap('<span style="text-decoration:overline">', true)

  style: (selection, options) -> selection.wrap("<span class=\"#{options.value}\">", true)

  replaceHTML: (selection, options) -> @html(options.value)

  insertLink: (selection, options) -> selection.insertNode(options.value)

  replaceLink: (selection, options) ->
    selection.selectNode(options.node)
    html = $('<div>').html(selection.content()).find('a').html()
    selection.replace($(options.value, selection.context).html(html))
