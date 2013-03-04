class Mercury.MarkdownRegion extends Mercury.Region
  @include Mercury.Region.Modules.DropIndicator

  @supported: true

  @define 'Mercury.MarkdownRegion', 'markdown'

  editableDragOver: true

  className: 'mercury-markdown-region'

  elements:
    preview: '.mercury-markdown-region-preview'

  events:
    'keydown textarea': 'onKeydown'

  constructor: (@el, @options = {}) ->
    return @notify(@t('requires Showdown')) unless window.Showdown
    super

    @converter ||= new Showdown.converter()


  build: ->
    @focusable = @buildTextarea()
    @html(@focusable, '<div class="mercury-markdown-region-preview">')
    @resize()


  buildTextarea: ->
    value = @html().replace(/^\s+|\s+$/g, '').replace('&gt;', '>')
    $('<textarea class="mercury-markdown-region-textarea">').val(value).css(width: '100%', height: @el.height())


  resize: ->
    return unless @config('regions:markdown:autoResize')
    current = $('body').scrollTop()
    height = Math.max(@focusable.get(0).scrollHeight - 10000, 0)
    @focusable.css(height: height).css(height: @focusable.get(0).scrollHeight)
    $('body').scrollTop(current)


  value: (value = null) ->
    if value == null || typeof(value) == 'undefined'
      @focusable.val()
    else
      @focusable.val(value)


  handleAction: ->
    super
    @resize()


  pushHistory: (keyCode = null) ->
    # When the keycode is not set, or is return, delete or backspace push now, otherwise wait for a few seconds.
    knownKeyCode = [13, 46, 8].indexOf(keyCode) if keyCode
    pushNow = true if keyCode == null || (knownKeyCode >= 0 && knownKeyCode != @lastKeyCode)
    @lastKeyCode = knownKeyCode

    clearTimeout(@historyTimeout)
    if pushNow then super else @historyTimeout = @delay(2500, => super)


  onKeydown: (e) ->
    @delay(1, @resize)
    return if e.metaKey && e.keyCode == 90 # undo / redo

    console.debug(e.keyCode)
    if e.metaKey then switch e.keyCode
      when 66 # b
        e.preventDefault()
        return @handleAction('bold')
      when 73 # i
        e.preventDefault()
        return @handleAction('italic')
      when 85 # u
        e.preventDefault()
        return @handleAction('underline')

    @resize()
    @pushHistory(e.keyCode)


  wrapSelection: (before, after = null) ->
    @focusable.surroundSelectedText(before, after || before)


  onDropFile: (files) ->
    uploader = new Mercury.Uploader(files, mimeTypes: @config('regions:markdown:mimeTypes'))
    uploader.on 'uploaded', (file) =>
      @focus()
      @handleAction('insertFile', file)


  actions:

    insertFile: (file) ->
      # todo: it would be nicer if we could drop the images where they were actually dropped
      #       in webkit the cursor moves around with where you're going to drop -- so if the selection is in a collapsed
      #       state moving the cursor to where you dropped and placing them there would make sense.
      action = if file.isImage() then 'insertImage' else 'insertLink'
      @handleAction(action, url: file.get('url'), text: file.get('name'))


    insertLink: (link) ->
      selection = @focusable.getSelection()
      @focusable.replaceSelectedText("[#{selection.text || link.text}](#{link.url})")


    insertImage: (image) ->
      selection = @focusable.getSelection()
      @focusable.replaceSelectedText("![#{selection.text || image.text}](#{image.url})")


    bold: ->
      @wrapSelection('**')


    italic: ->
      @wrapSelection('_')


    underline: ->
      @wrapSelection('<u>', '</u>')


    # needs to be checked

    subscript: ->
      @wrapSelection('<sub>', '</sub>')


    superscript: ->
      @wrapSelection('<sup>', '</sup>')


    insertHTML: (html) ->
      unless typeof(html) == 'string'
        html = if html.get then html.get(0).outerHTML else html.outerHTML
      @focusable.replaceSelectedText(html)


    horizontalRule: ->
      @focusable.replaceSelectedText('\n- - -\n')




#      indent: (selection) ->
#        selection.wrapLine('> ', '', false, true)
#
#      outdent: (selection) ->
#        selection.unWrapLine('> ', '', false, true)
#



