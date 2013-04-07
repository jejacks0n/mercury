###!
The HTML region utilizes the full HTML5 ContentEditable featureset and adds some layers on top of that to normalize it
between browsers and to make it nicer to use.

Dependencies:
  rangy-core - https://code.google.com/p/rangy/
  rangy-serializer
  rangy-cssclassapplier
###
class Mercury.Region.Html extends Mercury.Region
  @define 'Mercury.Region.Html', 'html'
  @include Mercury.Region.Modules.DropIndicator
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


Mercury.Region.Html.addToolbar 'html',
  defined:
    style:         ['Style', select: '/mercury/templates/style']
    sep1:          ' '
    block:         ['Block Format', select: '/mercury/templates/block']
    sep2:          '-'
  color:
    bgcolor:       ['Background Color', palette: '/mercury/templates/bgcolor']
    sep1:          ' '
    color:         ['Text Color', palette: '/mercury/templates/color']
    sep2:          '-'
  decoration:
    bold:          ['Bold']
    italic:        ['Italicize']
    strike:        ['Strikethrough']
    underline:     ['Underline']
    sep1:          '-'
  script:
    subscript:     ['Subscript']
    superscript:   ['Superscript']
    sep1:          '-'
  justify:
    justifyLeft:   ['Align Left']
    justifyCenter: ['Center']
    justifyRight:  ['Align Right']
    justifyFull:   ['Justify Full']
    sep1:          '-'
  list:
    unorderedList: ['Unordered List']
    orderedList:   ['Numbered List']
    sep1:          '-'
  indent:
    indent:        ['Increase Indentation']
    outdent:       ['Decrease Indentation']
    sep1:          '-'
  rules:
    rule:          ['Horizontal Rule', title: 'Insert a horizontal rule']
    sep1:          '-'
  extra:
    clean:         ['Remove Formatting', title: 'Remove formatting for the selection']
    sep1:          ' '
    edit:          ['Edit HTML', title: 'Edit the HTML content']
    sep2:          '-'
  table:
    rowBefore:     ['Insert Table Row', title: 'Insert a table row before the cursor']
    rowAfter:      ['Insert Table Row', title: 'Insert a table row after the cursor']
    rowDelete:     ['Delete Table Row', title: 'Delete this table row']
    colBefore:     ['Insert Table Column', title: 'Insert a table column before the cursor']
    colAfter:      ['Insert Table Column', title: 'Insert a table column after the cursor']
    colDelete:     ['Delete Table Column', title: 'Delete this table column']
    sep1:          ' '
    colIncrease:   ['Increase Cell Columns', title: 'Increase the cells colspan']
    colDecrease:   ['Decrease Cell Columns', title: 'Decrease the cells colspan and add a new cell']
    rowIncrease:   ['Increase Cell Rows', title: 'Increase the cells rowspan']
    rowDecrease:   ['Decrease Cell Rows', title: 'Decrease the cells rowspan and add a new cell']


Mercury.Region.Html.addAction

  bold:          -> @toggleWrapSelectedWordsInClass('red')
  italic:        -> @toggleWrapSelectedWordsInClass('highlight')
  underline:     -> @toggleWrapSelectedWordsInClass('blue')
  rule:          -> @replaceSelection('<hr/>')
