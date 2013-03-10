Mercury.Region.Modules.FocusableTextarea =

  included: ->
    @autoSize = false

    @preview = $("""<div class="mercury-#{@constructor.type}-region-preview">""")
    @focusable = $("""<textarea class="mercury-#{@constructor.type}-region-textarea">""")

    @on('build', @buildFocusable)
    @on('action', @resizeFocusable)
    @on('preview', @toggleFocusablePreview)
    @on('release', @releaseFocusable)


  buildFocusable: ->
    @autoSize = @config("regions:#{@constructor.type}:autoSize")

    value = @html().replace(/^\s+|\s+$/g, '').replace('&gt;', '>')
    resize = if @autoSize then 'none' else 'vertical'

    @el.empty()
    @append(@preview, @focusable.val(value).css(width: '100%', height: @el.height(), resize: resize))
    @resizeFocusable()

    @delegateEvents
      'keydown textarea': 'handleKeyEvent'


  releaseFocusable: ->
    @html(@value(null, true))


  toggleFocusablePreview: ->
    if @previewing
      @focusable.hide()
      @preview.html(@value(null, true)).show()
    else
      @preview.hide()
      @focusable.show()


  resizeFocusable: ->
    return unless @autoSize
    focusable = @focusable.get(0)
    current = $('body').scrollTop()
    @focusable.css(height: 1).css(height: focusable.scrollHeight)
    $('body').scrollTop(current)


  handleKeyEvent: (e) ->
    # arrows
    return if e.keyCode >= 37 && e.keyCode <= 40

    @delay(1, @resizeFocusable)

    # undo / redo
    return if e.metaKey && e.keyCode == 90

    # enter / return
    @onReturnKey?(e) if e.keyCode == 13

    # common actions
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

    @resizeFocusable()
    @pushHistory(e.keyCode)
