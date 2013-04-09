###!
The Plain region is a simplified single line HTML5 Content Editable region. It restricts paste, drag/drop, and only
provides the ability to do some common actions like bold, italics, and underline. This is a useful region for headings
 and other single line areas.

Dependencies:
  rangy-core - https://code.google.com/p/rangy/
  rangy-serializer
  rangy-cssclassapplier
###
class Mercury.Region.Plain extends Mercury.Region
  @define 'Mercury.Region.Plain', 'plain'
  @include Mercury.Region.Modules.HtmlSelection
  @include Mercury.Region.Modules.SelectionValue
  @include Mercury.Region.Modules.ContentEditable

  @supported: Mercury.support.wysiwyg

  events:
    'keydown': 'onKeyEvent'
    'paste': 'onPaste'

  constructor: ->
    try window.rangy.init()
    catch e
      @notify(@t('requires Rangy'))
      return false

    super
    @actions = {} unless @config('regions:plain:actions')


  onDropItem: (e) ->
    e.preventDefault()


  onPaste: (e) ->
    e.preventDefault()


  onKeyEvent: (e) ->
    return if e.keyCode >= 37 && e.keyCode <= 40 # arrows
    return if e.metaKey && e.keyCode == 90 # undo / redo
    return e.preventDefault() if e.keyCode == 13 # return

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


Mercury.Region.Plain.addToolbar
  decoration:
    bold:          ['Bold']
    italic:        ['Italicize']
    underline:     ['Underline']


Mercury.Region.Plain.addAction

  bold:      -> @toggleWrapSelectedWordsInClass('red')
  italic:    -> @toggleWrapSelectedWordsInClass('highlight')
  underline: -> @toggleWrapSelectedWordsInClass('blue')
