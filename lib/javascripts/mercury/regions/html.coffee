###!
The HTML region utilizes the full HTML5 ContentEditable featureset and adds some layers on top of that to normalize it
between browsers and to make it nicer to use.

Dependencies:
###
class Mercury.HtmlRegion extends Mercury.Region
  @define 'Mercury.HtmlRegion', 'html'
  @include Mercury.Region.Modules.DropIndicator
  @include Mercury.Region.Modules.HtmlSelection
  @include Mercury.Region.Modules.SelectionValue

  @supported: document.designMode &&                                      # we have designMode
              (!Mercury.support.msie || Mercury.support.msie >= 10) &&    # we're in IE10 or greater
              (window.rangy && window.rangy.supported)                    # rangy has been included and is supported

  skipHistoryOnInitialize: true

  events:
    'keydown': 'handleKeyEvent'

  constructor: ->
    try window.rangy.init()
    catch e
      @notify(@t('requires Rangy'))
      return false

    super


  build: ->
    @document = @el.get(0).ownerDocument
    @makeEditable()
    @setEditPreferences()


  makeEditable: ->
    @el.get(0).contentEditable = true


  setEditPreferences: -> try
    @document.execCommand('styleWithCSS', false, false)
    @document.execCommand('insertBROnReturn', false, true)
    @document.execCommand('enableInlineTableEditing', false, false)
    @document.execCommand('enableObjectResizing', false, false)


  handleKeyEvent: (e) ->
    return if e.keyCode >= 37 && e.keyCode <= 40 # arrows
    return if e.metaKey && e.keyCode == 90 # undo / redo
    @onReturnKey?(e) if e.keyCode == 13 # enter / return

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

#    bold:        -> @toggleWrapSelectedWords('bold')
#    italic:      -> @toggleWrapSelectedWords('italic')
#    underline:   -> @toggleWrapSelectedWords('underline')
#    subscript:   -> @toggleWrapSelectedWords('sub')
#    superscript: -> @toggleWrapSelectedWords('sup')
#    rule:        -> @replaceSelectionWithParagraph('- - -')
#    indent:      -> @wrapSelectedParagraphs('blockquote')
#    outdent:     -> @unwrapSelectedParagraphs('blockquote')
