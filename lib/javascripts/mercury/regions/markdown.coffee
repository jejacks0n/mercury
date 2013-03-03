class Mercury.MarkdownRegion extends Mercury.Region

  @supported: true

  @define 'Mercury.MarkdownRegion', 'markdown',
    bold: 'onBold'
    insertImage: 'onInsertImage'
    insertLink: 'onInsertLink'

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
    $('<textarea class="mercury-markdown-region-textarea">').val(value).css
      border: 0
      background: 'transparent'
      display: 'block'
      width: '100%'
      height: @el.outerHeight()
      fontFamily: '"Courier New", Courier, monospace'


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


  onDropFile: (files) ->
    uploader = new Mercury.Uploader([files[0]], mimeTypes: @config('regions:markdown:mimeTypes'))
    uploader.on('uploaded', => @onUploadFile(arguments...))


  onUploadFile: (file) ->
    action = if file.isImage() then 'insertImage' else 'insertLink'
    @focus()
    @handleAction(action, file.get('url'))


  onInsertImage: ->
    console.debug('onInsertImage')


  onInsertLink: ->
    console.debug('onInsertLink')


  onBold: ->
    console.debug('onBold')


  onItalic: ->
    console.debug('onItalic')


  onUnderline: ->
    console.debug('onUnderline')
