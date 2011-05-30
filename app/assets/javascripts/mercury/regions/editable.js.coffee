#= require_self
#= require ./editable.selection

class Mercury.Regions.Editable extends Mercury.Region
  type = 'editable'

  constructor: (@element, @window, @options = {}) ->
    @type = 'editable'
    super


  build: ->
    # mozilla: set some initial content so everything works correctly
    @html('&nbsp;') if $.browser.mozilla && @html() == ''

    # set overflow just in case
    @element.data({originalOverflow: @element.css('overflow')})
    @element.css({overflow: 'auto'})

    # mozilla: there's some weird behavior when the element isn't a div
    @specialContainer = $.browser.mozilla && @element.get(0).tagName != 'DIV'

    # make it editable
    @element.get(0).contentEditable = true

    # make all snippets not editable
    element.contentEditable = false for element in @element.find('.mercury-snippet')

    # add the basic editor settings to the document (only once)
    unless @document.mercuryEditing
      @document.execCommand('styleWithCSS', false, false)
      @document.execCommand('insertBROnReturn', false, true)
      @document.execCommand('enableInlineTableEditing', false, false)
      @document.execCommand('enableObjectResizing', false, false)
      @document.mercuryEditing = true


  bindEvents: ->
    super

    Mercury.bind 'region:update', =>
      return if @previewing
      return unless Mercury.region == @
      setTimeout((=> @selection().forceSelection(@element.get(0))), 1)
      currentElement = @currentElement()
      if currentElement.length
        table = currentElement.closest('table', @element)
        Mercury.tableEditor(table, currentElement) if table.length

#    # possible:drop custom event
#    # we have to do this because webkit doesn't fire the drop event unless both
#    # dragover and dragstart default behaviors are canceled... but when we do
#    # that and observe the drop event, the default behavior isn't handled (eg,
#    # putting the image where it was dropped).. so to allow the browser to do
#    # it's thing, and also do our thing we have this little hack.  *sigh*
#    # read: http://www.quirksmode.org/blog/archives/2009/09/the_html5_drag.html
#    if $.browser.webkit
#      @element.bind 'dragover', (event) =>
#        clearTimeout(@_dropTimeout)
#        @_dropTimeout = setTimeout((=> @element.trigger('snippet:dropped')), 100)
#    else
#      @element.bind 'drop', (event) =>
#        clearTimeout(@_dropTimeout)
#        @_dropTimeout = setTimeout((=> @element.trigger('snippet:dropped')), 1)
#
#    @element.bind 'snippet:dropped', (event, originalEvent) =>


    @element.bind 'dragenter', (event) =>
      return if @previewing
      event.preventDefault() if event.shiftKey
      event.originalEvent.dataTransfer.dropEffect = 'copy'

    @element.bind 'dragover', (event) =>
      return if @previewing
      event.preventDefault() if event.shiftKey
      event.originalEvent.dataTransfer.dropEffect = 'copy'

    @element.bind 'drop', (event) =>
      return if @previewing
      return unless event.originalEvent.dataTransfer.files.length
      event.preventDefault()
      @focus()
      Mercury.uploader(event.originalEvent.dataTransfer.files[0])

    @element.bind 'paste', =>
      return if @previewing
      return unless Mercury.region == @
      Mercury.changes = true
      html = @html()
      event.preventDefault() if @specialContainer
      setTimeout((=> @handlePaste(html)), 1)

    @element.focus =>
      return if @previewing
      Mercury.region = @
      setTimeout((=> @selection().forceSelection(@element.get(0))), 1)
      Mercury.trigger('region:focused', {region: @})

    @element.blur =>
      return if @previewing
      Mercury.trigger('region:blurred', {region: @})

    @element.click (event) =>
      $(event.target).closest('a').attr('target', '_top') if @previewing

    @element.dblclick (event) =>
      return if @previewing
      if image = $(event.target).closest('img')
        @selection().selectNode(image.get(0), true)
        Mercury.trigger('button', {action: 'insertmedia'})

    @element.mouseup =>
      return if @previewing
      @pushHistory()
      Mercury.trigger('region:update', {region: @})

    @element.keydown (event) =>
      return if @previewing
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

        when 13 # enter
          if $.browser.webkit && @selection().commonAncestor().closest('li, ul', @element).length == 0
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
      Mercury.trigger('region:update', {region: @})


  focus: ->
    @element.focus()
    setTimeout((=> @selection().forceSelection(@element.get(0))), 1)
    Mercury.trigger('region:update', {region: @})


  html: (value = null, filterSnippets = true, includeMarker = false) ->
    if value != null
      # get the snippet contents out of the region
      snippets = {}
      for snippet, index in @element.find('.mercury-snippet')
        snippets["[snippet#{index}]"] = $(snippet).html()

      # sanitize the html before we insert it
      container = $('<div>').appendTo(@document.createDocumentFragment())
      container.html(value)

      # fill in the snippet contents
      for snippet in container.find('.mercury-snippet')
        snippet.contentEditable = false
        snippet = $(snippet)
        content = snippets[snippet.html()]
        if content
          delete(snippets[snippet.html()])
          snippet.html(content) if content

      # set the html
      @element.html(container.html())

      # create a selection if there's markers
      @selection().selectMarker(@element)
    else
      # remove any meta tags
      @element.find('meta').remove()

      # place markers for the selection
      if includeMarker
        selection = @selection()
        selection.placeMarker()

      # sanitize the html before we return it
      container = $('<div>').appendTo(@document.createDocumentFragment())
      container.html(@element.html().replace(/^\s+|\s+$/g, ''))

      # replace snippet contents to be an identifier
      if filterSnippets then for snippet, index in container.find('.mercury-snippet')
        snippet = $(snippet)
        snippet.attr({contenteditable: null}).html("[snippet#{index}]")

      # get the html before removing the markers
      html = container.html()

      # remove the markers from the dom
      selection.removeMarker() if includeMarker

      return html


  togglePreview: ->
    if @previewing
      @element.get(0).contentEditable = true
      @element.css({overflow: 'auto'})
    else
      @html(@html())
      @element.get(0).contentEditable = false
      @element.css({overflow: @element.data('originalOverflow')})
      @element.blur()
    super


  execCommand: (action, options = {}) ->
    super

    # use a custom handler if there's one, otherwise use execCommand
    if handler = Mercury.config.behaviors[action] || Mercury.Regions.Editable.actions[action]
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
      @history.push(@html(null, false, true))
    else if keyCode
      # set a timeout for pushing to the history
      @historyTimeout = setTimeout((=> @history.push(@html(null, false, true))), waitTime * 1000)
    else
      # push to the history immediately
      @history.push(@html(null, false, true))

    @lastKnownKeyCode = knownKeyCode


  selection: ->
    return new Mercury.Regions.Editable.Selection(@window.getSelection(), @document)


  path: ->
    container = @selection().commonAncestor()
    return [] unless container
    return if container.get(0) == @element.get(0) then [] else container.parentsUntil(@element)


  currentElement: ->
    element = []
    selection = @selection()
    if selection.range
      element = selection.commonAncestor()
      element = element.parent() if element.get(0).nodeType == 3
    return element


  handlePaste: (prePasteHTML) ->
    prePasteHTML = prePasteHTML.replace(/^\<br\>/, '')

    # remove any regions that might have been pasted
    @element.find('.mercury-region').remove()

    # handle pasting from ms office etc
    html = @html()
    if html.indexOf('<!--StartFragment-->') > -1 || html.indexOf('="mso-') > -1 || html.indexOf('<o:') > -1 || html.indexOf('="Mso') > -1
      # clean out all the tags from the pasted contents
      cleaned = prePasteHTML.singleDiff(@html()).sanitizeHTML()
      try
        # try to undo and put the cleaned html where the selection was
        @document.execCommand('undo', false, null)
        @execCommand('insertHTML', {value: cleaned})
      catch error
        # remove the pasted html and load up the cleaned contents into a modal
        @html(prePasteHTML)
        Mercury.modal '/mercury/modals/sanitizer', {
          title: 'HTML Sanitizer (Starring Clippy)',
          afterLoad: -> @element.find('textarea').val(cleaned.replace(/<br\/>/g, '\n'))
        }



# Custom handled actions (eg. things that execCommand doesn't do, or doesn't do well)
Mercury.Regions.Editable.actions =

  insertrowbefore: -> Mercury.tableEditor.addRow('before')

  insertrowafter: -> Mercury.tableEditor.addRow('after')

  insertcolumnbefore: -> Mercury.tableEditor.addColumn('before')

  insertcolumnafter: -> Mercury.tableEditor.addColumn('after')

  deletecolumn: -> Mercury.tableEditor.removeColumn()

  deleterow: -> Mercury.tableEditor.removeRow()

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

  removesnippet: ->
    @snippet.remove() if @snippet
    Mercury.trigger('hide:toolbar', {type: 'snippet', immediately: true})
