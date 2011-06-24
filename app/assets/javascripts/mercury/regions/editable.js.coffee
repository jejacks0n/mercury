class @Mercury.Regions.Editable extends Mercury.Region
  type = 'editable'

  constructor: (@element, @window, @options = {}) ->
    @type = 'editable'
    super


  build: ->
    # mozilla: set some initial content so everything works correctly
    @content('&nbsp;') if jQuery.browser.mozilla && @content() == ''

    # set overflow just in case
    @element.data({originalOverflow: @element.css('overflow')})
    @element.css({overflow: 'auto'})

    # mozilla: there's some weird behavior when the element isn't a div
    @specialContainer = jQuery.browser.mozilla && @element.get(0).tagName != 'DIV'

    # make it editable
    # mozilla: this makes double clicking in textareas fail: https://bugzilla.mozilla.org/show_bug.cgi?id=490367
    @element.get(0).contentEditable = true

    # make all snippets not editable, and set their versions to 1
    for element in @element.find('.mercury-snippet')
      element.contentEditable = false
      jQuery(element).attr('data-version', '1')

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
        # setup the table editor if we're inside a table
        table = currentElement.closest('table', @element)
        Mercury.tableEditor(table, currentElement.closest('tr, td'), '&nbsp;') if table.length
        # display a tooltip if we're in an anchor
        anchor = currentElement.closest('a', @element)
        if anchor.length && anchor.attr('href')
          Mercury.tooltip(anchor, "<a href=\"#{anchor.attr('href')}\" target=\"_blank\">#{anchor.attr('href')}</a>", {position: 'below'})
        else
          Mercury.tooltip.hide()

    @element.bind 'dragenter', (event) =>
      return if @previewing
      event.preventDefault() if event.shiftKey
      event.originalEvent.dataTransfer.dropEffect = 'copy'

    @element.bind 'dragover', (event) =>
      return if @previewing
      event.preventDefault() if event.shiftKey
      event.originalEvent.dataTransfer.dropEffect = 'copy'
      if jQuery.browser.webkit
        clearTimeout(@dropTimeout)
        @dropTimeout = setTimeout((=> @element.trigger('possible:drop')), 10)

    @element.bind 'drop', (event) =>
      return if @previewing

      # handle dropping snippets
      clearTimeout(@dropTimeout)
      @dropTimeout = setTimeout((=> @element.trigger('possible:drop')), 1)

      # handle any files that were dropped
      return unless event.originalEvent.dataTransfer.files.length
      event.preventDefault()
      @focus()
      Mercury.uploader(event.originalEvent.dataTransfer.files[0])

    # possible:drop custom event: we have to do this because webkit doesn't fire the drop event unless both dragover and
    # dragstart default behaviors are canceled.. but when we do that and observe the drop event, the default behavior
    # isn't handled (eg, putting the image where it was dropped,) so to allow the browser to do it's thing, and also do
    # our thing we have this little hack.  *sigh*
    # read: http://www.quirksmode.org/blog/archives/2009/09/the_html5_drag.html
    @element.bind 'possible:drop', (event) =>
      return if @previewing
      if snippet = @element.find('img[data-snippet]').get(0)
        @focus()
        Mercury.Snippet.displayOptionsFor(jQuery(snippet).data('snippet'))
        @document.execCommand('undo', false, null)

    # custom paste handling: we have to do some hackery to get the pasted content since it's not exposed normally
    # through a clipboard in firefox (heaven forbid), and to keep the behavior across all browsers, we manually detect
    # what was pasted by running a quick diff, removing it by calling undo, making our adjustments, and then putting the
    # content back.  This is possible, so it doesn't make sense why it wouldn't be exposed in a sensible way.  *sigh*
    @element.bind 'paste', =>
      return if @previewing
      return unless Mercury.region == @
      Mercury.changes = true
      content = @content()
      event.preventDefault() if @specialContainer
      setTimeout((=> @handlePaste(content)), 1)

    @element.focus =>
      return if @previewing
      Mercury.region = @
      setTimeout((=> @selection().forceSelection(@element.get(0))), 1)
      Mercury.trigger('region:focused', {region: @})

    @element.blur =>
      return if @previewing
      Mercury.trigger('region:blurred', {region: @})
      Mercury.tooltip.hide()

    @element.click (event) =>
      jQuery(event.target).closest('a').attr('target', '_top') if @previewing

    @element.dblclick (event) =>
      return if @previewing
      image = jQuery(event.target).closest('img', @element)
      if image.length
        @selection().selectNode(image.get(0), true)
        Mercury.trigger('button', {action: 'insertMedia'})

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
          if event.shiftKey then @execCommand('redo') else @execCommand('undo')
          return

        when 13 # enter
          if jQuery.browser.webkit && @selection().commonAncestor().closest('li, ul', @element).length == 0
            event.preventDefault()
            @document.execCommand('insertLineBreak', false, null)
          else if @specialContainer
            # mozilla: pressing enter in any elemeny besides a div handles strangely
            event.preventDefault()
            @document.execCommand('insertHTML', false, '<br/>')

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
    if Mercury.region != @
      @element.focus()
      selection = @selection().selection.collapseToStart()

    Mercury.trigger('region:focused', {region: @})
    Mercury.trigger('region:update', {region: @})


  content: (value = null, filterSnippets = true, includeMarker = false) ->
    if value != null
      # sanitize the html before we insert it
      container = jQuery('<div>').appendTo(@document.createDocumentFragment())
      container.html(value)

      # fill in the snippet contents
      for element in container.find('[data-snippet]')
        element.contentEditable = false
        element = jQuery(element)
        if snippet = Mercury.Snippet.find(element.data('snippet'))
          unless element.data('version')
            try
              version = parseInt(element.html().match(/\/(\d+)\]/)[1])
              if version
                snippet.setVersion(version)
                element.attr({'data-version': version})
                element.html(snippet.data)
            catch error

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
      container = jQuery('<div>').appendTo(@document.createDocumentFragment())
      container.html(@element.html().replace(/^\s+|\s+$/g, ''))

      # replace snippet contents to be an identifier
      if filterSnippets then for element, index in container.find('[data-snippet]')
        element = jQuery(element)
        if snippet = Mercury.Snippet.find(element.data("snippet"))
          snippet.data = element.html()
        element.html("[#{element.data("snippet")}/#{element.data("version")}]")
        element.attr({contenteditable: null, 'data-version': null})

      # get the html before removing the markers
      content = container.html()

      # remove the markers from the dom
      selection.removeMarker() if includeMarker

      return content


  togglePreview: ->
    if @previewing
      @element.get(0).contentEditable = true
      @element.css({overflow: 'auto'})
    else
      @content(@content())
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
      options.value = jQuery('<div>').html(options.value).html() if action == 'insertHTML' && options.value && options.value.get
      try
        @document.execCommand(action, false, options.value)
      catch error
        # mozilla: indenting when there's no br tag handles strangely
        # todo: mozilla: trying to justify the first line of any contentEditable fails
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
      @history.push(@content(null, false, true))
    else if keyCode
      # set a timeout for pushing to the history
      @historyTimeout = setTimeout((=> @history.push(@content(null, false, true))), waitTime * 1000)
    else
      # push to the history immediately
      @history.push(@content(null, false, true))

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


  handlePaste: (prePasteContent) ->
    prePasteContent = prePasteContent.replace(/^\<br\>/, '')

    # remove any regions that might have been pasted
    @element.find('.mercury-region').remove()

    # handle pasting from ms office etc
    content = @content()
    if content.indexOf('<!--StartFragment-->') > -1 || content.indexOf('="mso-') > -1 || content.indexOf('<o:') > -1 || content.indexOf('="Mso') > -1
      # clean out all the tags from the pasted contents
      cleaned = prePasteContent.singleDiff(@content()).sanitizeHTML()
      try
        # try to undo and put the cleaned html where the selection was
        @document.execCommand('undo', false, null)
        @execCommand('insertHTML', {value: cleaned})
      catch error
        # remove the pasted html and load up the cleaned contents into a modal
        @content(prePasteContent)
        Mercury.modal '/mercury/modals/sanitizer', {
          title: 'HTML Sanitizer (Starring Clippy)',
          afterLoad: -> @element.find('textarea').val(cleaned.replace(/<br\/>/g, '\n'))
        }
    else if Mercury.config.cleanStylesOnPaste
      # strip styles
      pasted = prePasteContent.singleDiff(@content())

      container = jQuery('<div>').appendTo(@document.createDocumentFragment()).html(pasted)
      container.find('[style]').attr({style: null})

      @document.execCommand('undo', false, null)
      @execCommand('insertHTML', {value: container.html()})


  # Custom actions (eg. things that execCommand doesn't do, or doesn't do well)
  @actions: {
    insertRowBefore: -> Mercury.tableEditor.addRow('before')

    insertRowAfter: -> Mercury.tableEditor.addRow('after')

    insertColumnBefore: -> Mercury.tableEditor.addColumn('before')

    insertColumnAfter: -> Mercury.tableEditor.addColumn('after')

    deleteColumn: -> Mercury.tableEditor.removeColumn()

    deleteRow: -> Mercury.tableEditor.removeRow()

    increaseColspan: -> Mercury.tableEditor.increaseColspan()

    decreaseColspan: -> Mercury.tableEditor.decreaseColspan()

    increaseRowspan: -> Mercury.tableEditor.increaseRowspan()

    decreaseRowspan: -> Mercury.tableEditor.decreaseRowspan()

    undo: -> @content(@history.undo())

    redo: -> @content(@history.redo())

    removeFormatting: (selection) -> selection.insertTextNode(selection.textContent())

    backColor: (selection, options) -> selection.wrap("<span style=\"background-color:#{options.value.toHex()}\">", true)

    overline: (selection) -> selection.wrap('<span style="text-decoration:overline">', true)

    style: (selection, options) -> selection.wrap("<span class=\"#{options.value}\">", true)

    replaceHTML: (selection, options) -> @content(options.value)

    insertImage: (selection, options) -> @execCommand('insertHTML', {value: jQuery('<img/>', options.value)})

    insertLink: (selection, options) ->
      anchor = jQuery("<#{options.value.tagName}>", @document).attr(options.value.attrs).html(options.value.content)
      selection.insertNode(anchor)

    replaceLink: (selection, options) ->
      anchor = jQuery("<#{options.value.tagName}>", @document).attr(options.value.attrs).html(options.value.content)
      selection.selectNode(options.node)
      html = jQuery('<div>').html(selection.content()).find('a').html()
      selection.replace(jQuery(anchor, selection.context).html(html))

    insertSnippet: (selection, options) ->
      snippet = options.value
      if (existing = @element.find("[data-snippet=#{snippet.identity}]")).length
        selection.selectNode(existing.get(0))
      selection.insertNode(snippet.getHTML(@document))

    editSnippet: ->
      return unless @snippet
      snippet = Mercury.Snippet.find(@snippet.data('snippet'))
      snippet.displayOptions()

    removeSnippet: ->
      @snippet.remove() if @snippet
      Mercury.trigger('hide:toolbar', {type: 'snippet', immediately: true})
  }


# Helper class for managing selection and getting information from it
class Mercury.Regions.Editable.Selection

  constructor: (@selection, @context) ->
    return unless @selection.rangeCount >= 1
    @range = @selection.getRangeAt(0)
    @fragment = @range.cloneContents()
    @clone = @range.cloneRange()


  commonAncestor: (onlyTag = false) ->
    return null unless @range
    ancestor = @range.commonAncestorContainer
    ancestor = ancestor.parentNode if ancestor.nodeType == 3 && onlyTag
    return jQuery(ancestor)


  wrap: (element, replace = false) ->
    element = jQuery(element, @context).html(@fragment)
    @replace(element) if replace
    return element


  textContent: ->
    return @range.cloneContents().textContent


  content: ->
    return @range.cloneContents()


  is: (elementType) ->
    content = @content()
    return jQuery(content.firstChild) if content.childNodes.length == 1 && jQuery(content.firstChild).is(elementType)
    return false


  forceSelection: (element) ->
    return unless jQuery.browser.webkit
    range = @context.createRange()

    # todo: the \00 thing breaks when using uglifier, and is escapped to "0".. it's been fixed, but isn't available yet
    # https://github.com/lautis/uglifier/issues/11
    if @range
      if @commonAncestor(true).closest('.mercury-snippet').length
        lastChild = @context.createTextNode('\00') #\00
        element.appendChild(lastChild)
    else
      if element.lastChild && element.lastChild.nodeType == 3 && element.lastChild.textContent.replace(/^[\s+|\n+]|[\s+|\n+]$/, '') == ''
        lastChild = element.lastChild
        element.lastChild.textContent = '\00' #\00
      else
        lastChild = @context.createTextNode(' ') #\00
        element.appendChild(lastChild)

    if lastChild
      range.setStartBefore(lastChild)
      range.setEndBefore(lastChild)
      @selection.addRange(range)


  selectMarker: (context) ->
    markers = context.find('em.mercury-marker')
    return unless markers.length

    range = @context.createRange()
    range.setStartBefore(markers.get(0))
    range.setEndBefore(markers.get(1)) if markers.length >= 2

    markers.remove()

    @selection.removeAllRanges()
    @selection.addRange(range)


  placeMarker: ->
    return unless @range

    @startMarker = jQuery('<em class="mercury-marker"/>', @context).get(0)
    @endMarker = jQuery('<em class="mercury-marker"/>', @context).get(0)

    # put a single marker (the end)
    rangeEnd = @range.cloneRange()
    rangeEnd.collapse(false)
    rangeEnd.insertNode(@endMarker)

    unless @range.collapsed
      # put a start marker
      rangeStart = @range.cloneRange()
      rangeStart.collapse(true)
      rangeStart.insertNode(@startMarker)

    @selection.removeAllRanges()
    @selection.addRange(@range)


  removeMarker: ->
    jQuery(@startMarker).remove()
    jQuery(@endMarker).remove()


  insertTextNode: (string) ->
    node = @context.createTextNode(string)
    @range.extractContents()
    @range.insertNode(node)
    @range.selectNodeContents(node)
    @selection.addRange(@range)


  insertNode: (element) ->
    element = element.get(0) if element.get
    element = jQuery(element, @context).get(0) if jQuery.type(element) == 'string'

    @range.deleteContents()
    @range.insertNode(element)
    @range.selectNodeContents(element)
    @selection.addRange(@range)


  selectNode: (node, removeExisting = false) ->
    @range.selectNode(node)
    @selection.removeAllRanges() if removeExisting
    @selection.addRange(@range)


  replace: (element) ->
    element = element.get(0) if element.get
    element = jQuery(element, @context).get(0) if jQuery.type(element) == 'string'

    @range.deleteContents()
    @range.insertNode(element)
    @range.selectNodeContents(element)
    @selection.addRange(@range)
