class Mercury.MarkdownRegion extends Mercury.Region

  @supported: true

  @define 'Mercury.MarkdownRegion', 'markdown',
    bold: 'onBold'

  className: 'mercury-markdown-region'

  focusable: true

  elements:
    textarea: 'textarea.mercury-markdown-region-textarea'
    preview: '.mercury-markdown-region-preview'

  events:
    'keydown textarea': 'onKeydown'
    'keyup textarea': 'onKeyup'

  constructor: (@el, @options = {}) ->
    return @notify(@t('requires Showdown')) unless window.Showdown
    super
    @converter ||= new Showdown.converter()


  build: ->
    textarea = @buildTextarea()
    @html(textarea, '<div class="mercury-markdown-region-preview">')
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
    height = Math.max(@textarea.get(0).scrollHeight - 10000, 0)
    @textarea.css(height: height).css(height: @textarea.get(0).scrollHeight)
    $('body').scrollTop(current)


  onBold: ->
    console.debug('bolding')


  onKeydown: (e) ->
    @delay(1, @resize)
    switch e.keyCode
      when 90 # undo / redo
        return unless event.metaKey
        e.preventDefault()
        if e.shiftKey then @handleAction('redo') else @handleAction('undo')
        return
      when 9 # tab
        e.preventDefault()
        @handleAction('insertHTML', '  ')

    if event.metaKey then switch event.keyCode
      when 66 # b
        e.preventDefault()
        @handleAction('bold')
      when 73 # i
        e.preventDefault()
        @handleAction('italic')
      when 85 # u
        e.preventDefault()
        @handleAction('underline')
    @resize()



  onKeyup: (e) ->
    @resize()


#      when 13 # enter or return
#        selection = @selection()
#        text = @element.val()
#        start = text.lastIndexOf('\n', selection.start)
#        end = text.indexOf('\n', selection.end)
#        end = text.length if end < start
#        start = text.lastIndexOf('\n', selection.start - 1) if text[start] == '\n'
#        if text[start + 1] == '-'
#          selection.replace('\n- ', false, true)
#          event.preventDefault()
#        if /\d/.test(text[start + 1])
#          lineText = text.substring(start, end)
#          if /(\d+)\./.test(lineText)
#            number = parseInt(RegExp.$1)
#            selection.replace("\n#{number += 1}. ", false, true)
#            event.preventDefault()
#
#    @pushHistory(event.keyCode)
