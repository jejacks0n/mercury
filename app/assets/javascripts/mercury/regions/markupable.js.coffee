# todo:
# make primary tools work -- like inserting media, links, tables
# context for the toolbar buttons and groups needs to change so we can do the following:
# how to handle context for buttons?  if the cursor is within a bold area (**bo|ld**), or selecting it -- it would be
# nice if we could activate the bold button for instance.

class Mercury.Regions.Markupable extends Mercury.Region
  type = 'markupable'

  constructor: (@element, @window, @options = {}) ->
    @type = 'markupable'
    super
    @converter = new Showdown.converter()


  build: ->
    width = @element.width()
    width = '100%' unless width
    height = @element.height()

    value = @element.html().replace(/^\s+|\s+$/g, '')
    @textarea = $('<textarea>', @document).val(value)
    @textarea.attr('class', @element.attr('class')).addClass('mercury-textarea')
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

    @textarea.bind 'dragenter', (event) =>
      return if @previewing
      event.preventDefault()
      event.originalEvent.dataTransfer.dropEffect = 'copy'

    @textarea.bind 'dragover', (event) =>
      return if @previewing
      event.preventDefault()
      event.originalEvent.dataTransfer.dropEffect = 'copy'

    @textarea.bind 'drop', (event) =>
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

    @textarea.focus =>
      return if @previewing
      Mercury.region = @
      @textarea.addClass('focus')
      Mercury.trigger('region:focused', {region: @})

    @textarea.blur =>
      return if @previewing
      @textarea.removeClass('focus')
      Mercury.trigger('region:blurred', {region: @})

    @textarea.keydown (event) =>
      return if @previewing
      Mercury.changes = true
      @resize()
      switch event.keyCode

        when 13 # enter or return
          selection = @selection()
          text = @textarea.val()
          start = text.lastIndexOf('\n', selection.start)
          end = text.indexOf('\n', selection.end)
          end = text.length if end < start
          start = text.lastIndexOf('\n', selection.start - 1) if text[start] == '\n'
          if text[start + 1] == '-'
            selection.replace('\n- ', false, true)
            event.preventDefault()
          if /\d/.test(text[start + 1])
            lineText = text.substring(start, end)
            console.debug(lineText)
            if /(\d+)\./.test(lineText)
              console.debug(2)
              number = parseInt(RegExp.$1)
              selection.replace("\n#{number += 1}. ", false, true)
              event.preventDefault()

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


  html: (value = null, filterSnippets = true) ->
    if value != null
      if $.type(value) == 'string'
        @textarea.val(value)
      else
        @textarea.val(value.html)
        @selection().select(value.selection.start, value.selection.end)
    else
      return @textarea.val()


  togglePreview: ->
    if @previewing
      @element.hide()
      @textarea.show()
    else
      value = @converter.makeHtml(@textarea.val())
      @element.html(value)
      @element.show()
      @textarea.hide()
    super


  execCommand: (action, options = {}) ->
    super

    handler.call(@, @selection(), options) if handler = Mercury.Regions.Markupable.actions[action]
    @resize()


  htmlAndSelection: ->
    return {html: @html(null, false), selection: @selection().serialize()}


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
      @history.push(@htmlAndSelection())
    else if keyCode
      # set a timeout for pushing to the history
      @historyTimeout = setTimeout((=> @history.push(@htmlAndSelection())), waitTime * 1000)
    else
      # push to the history immediately
      @history.push(@htmlAndSelection())

    @lastKnownKeyCode = knownKeyCode


  selection: ->
    return new Mercury.Regions.Markupable.Selection(@textarea)


  resize: ->
#    adjustedHeight = Math.max(@textarea.get(0).scrollHeight, @textarea.get(0).clientHeight)
#    @textarea.height(adjustedHeight) if adjustedHeight >= @textarea.get(0).clientHeight


  snippets: ->


  # Actions
  @actions: {

    undo: -> @html(@history.undo())

    redo: -> @html(@history.redo())

    insertImage: (selection, options) -> selection.replace('![add alt text](' + encodeURI(options.value.src) + ')', true)

    insertLink: (selection, options) ->
      console.log(selection, options)
    #selection.insertNode(options.value)

    insertunorderedlist: (selection) -> selection.addList('unordered')

    insertorderedlist: (selection) -> selection.addList('ordered')

    style: (selection, options) -> selection.wrap("<span class=\"#{options.value}\">", '</span>')

    formatblock: (selection, options) ->
      wrappers = {
        h1: ['# ', ' #']
        h2: ['## ', ' ##']
        h3: ['### ', ' ###']
        h4: ['#### ', ' ####']
        h5: ['##### ', ' #####']
        h6: ['###### ', ' ######']
        pre: ['    ', '']
        blockquote: ['> ', '']
        p: ['\n', '\n']
      }
      selection.unWrapLine("#{wrapper[0]}", "#{wrapper[1]}") for wrapperName, wrapper of wrappers
      if options.value == 'blockquote'
        Mercury.Regions.Markupable.actions.indent.call(@, selection, options)
        return
      selection.wrapLine("#{wrappers[options.value][0]}", "#{wrappers[options.value][1]}")

    bold: (selection) -> selection.wrap('**', '**')

    italic: (selection) -> selection.wrap('_', '_')

    subscript: (selection) -> selection.wrap('<sub>', '</sub>')

    superscript: (selection) -> selection.wrap('<sup>', '</sup>')

    indent: (selection) ->
      selection.wrapLine('> ', '', false, true)

    outdent: (selection) ->
      selection.unWrapLine('> ', '', false, true)

    horizontalrule: (selection) -> selection.replace('\n- - -\n')

    insertsnippet: (selection, options) ->
      snippet = options.value
      selection.replace(snippet.getText())

    editsnippet: ->
      return unless @snippet
      snippet = Mercury.Snippet.find(@snippet.data('snippet'))
      snippet.displayOptions()

    removesnippet: ->
      @snippet.remove() if @snippet
      Mercury.trigger('hide:toolbar', {type: 'snippet', immediately: true})

  }


# Helper class for managing selection and getting information from it
class Mercury.Regions.Markupable.Selection

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


  wrapLine: (left, right, selectAfter = true, reselect = false) ->
    @getDetails()
    savedSelection = @serialize()
    text = @element.val()
    start = text.lastIndexOf('\n', @start)
    end = text.indexOf('\n', @end)
    end = text.length if end < start
    start = text.lastIndexOf('\n', @start - 1) if text[start] == '\n'
    @select(start + 1, end)
    @replace(left + @text + right, selectAfter)
    @select(savedSelection.start + left.length, savedSelection.end + left.length) if reselect


  unWrapLine: (left, right, selectAfter = true, reselect = false) ->
    @getDetails()
    savedSelection = @serialize()
    text = @element.val()
    start = text.lastIndexOf('\n', @start)
    end = text.indexOf('\n', @end)
    end = text.length if end < start
    start = text.lastIndexOf('\n', @start - 1) if text[start] == '\n'
    @select(start + 1, end)
    window.something = @text
    leftRegExp = new RegExp("^#{left.regExpEscape()}")
    rightRegExp = new RegExp("#{right.regExpEscape()}$")
    changed = @replace(@text.replace(leftRegExp, '').replace(rightRegExp, ''), selectAfter)
    @select(savedSelection.start - left.length, savedSelection.end - left.length) if reselect && changed


  addList: (type) ->
    text = @element.val()
    start = text.lastIndexOf('\n', @start)
    end = text.indexOf('\n', @end)
    end = text.length if end < start
    start = text.lastIndexOf('\n', @start - 1) if text[start] == '\n'
    @select(start + 1, end)
    lines = @text.split('\n')
    if type == 'unordered'
      @replace("- " + lines.join("\n- "), true)
    else
      @replace(("#{index + 1}. #{line}" for line, index in lines).join('\n'), true)



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
