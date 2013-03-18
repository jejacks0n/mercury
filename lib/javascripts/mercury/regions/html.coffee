###!
The HTML region utilizes the full HTML5 ContentEditable featureset and adds some layers on top of that to normalize it
between browsers and to make it nicer to use.

Dependencies:
  rangy/rangy-core - https://code.google.com/p/rangy/
  rangy/rangy-serializer
  rangy-cssclassapplier
###
class Mercury.HtmlRegion extends Mercury.Region
  @define 'Mercury.HtmlRegion', 'html'
  @include Mercury.Region.Modules.DropIndicator
  @include Mercury.Region.Modules.HtmlSelection
  @include Mercury.Region.Modules.SelectionValue
  @include Mercury.Region.Modules.ContentEditable

  @supported: document.designMode &&                                      # we have designMode
              (!Mercury.support.msie || Mercury.support.msie >= 10) &&    # we're in IE10+
              (window.rangy && window.rangy.supported)                    # rangy is supported

  skipHistoryOnInitialize: true

  events:
    'keydown': 'onKeyEvent'
    'paste': 'onPaste'

  constructor: ->
    try window.rangy.init()
    catch e
      @notify(@t('requires Rangy'))
      return false

    super

  onDropFile: (files, options) ->
    uploader = new Mercury.Uploader(files, mimeTypes: @config('regions:html:mimeTypes'))
    uploader.on 'uploaded', (file) =>
      @focus()
      @handleAction('file', file)


  onDropItem: ->
    @pushHistory()


  onPaste: (e) ->
    console.debug('pasted', e)


  onKeyEvent: (e) ->
    return if e.keyCode >= 37 && e.keyCode <= 40 # arrows
    return if e.metaKey && e.keyCode == 90 # undo / redo

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

    @pushHistory(e.keyCode)


  actions:

    bold:        -> @toggleWrapSelectedWordsInClass('red')
    italic:      -> @toggleWrapSelectedWordsInClass('highlight')
    underline:   -> @toggleWrapSelectedWordsInClass('blue')

    rule:        -> @replaceSelection('<hr/>')

    file: (file) ->
      action = if file.isImage() then 'image' else 'link'
      @handleAction(action, file.get('url'), file.get('name'))

#    link: (url, text, attrs = {}) ->
#      tag = $('<a>', $.extend({href: url, title: text}, attrs))
#      @wrapSelected(tag, text: text, select: 'end')

    image: (url, text, attrs = {}) ->
      tag = $('<img>', $.extend({src: url, alt: text}, attrs))
      @replaceSelection(tag, text: text)
