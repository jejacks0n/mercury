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

  @events:
    'keydown': 'onKeyEvent'
    'paste': 'onPaste'

  constructor: ->
    try window.rangy.init()
    catch e
      @notify(@t('requires Rangy'))
      return false

    super


  onDropFile: (files) ->
    uploader = new Mercury[@config('interface:uploader')](files, mimeTypes: @config('regions:html:mimeTypes'))
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
        @prevent(e)
        return @handleAction('bold')
      when 73 # i
        @prevent(e)
        return @handleAction('italic')
      when 85 # u
        @prevent(e)
        return @handleAction('underline')

    @pushHistory(e.keyCode)


Mercury.Region.Html.addToolbar
  defined:
    style:         ['Style', plugin: 'styles']
    sep:           ' '
    block:         ['Block Format', plugin: 'blocks']
  color:
    bgcolor:       ['Background Color', plugin: 'color']
    sep:           ' '
    color:         ['Text Color', plugin: 'color']
  decoration:
    bold:          ['Bold']
    italic:        ['Italicize']
    strike:        ['Strikethrough']
    underline:     ['Underline']
  script:
    subscript:     ['Subscript']
    superscript:   ['Superscript']
  justify:
    justifyLeft:   ['Align Left']
    justifyCenter: ['Center']
    justifyRight:  ['Align Right']
    justifyFull:   ['Justify Full']
  list:
    unorderedList: ['Unordered List']
    orderedList:   ['Numbered List']
  indent:
    indent:        ['Increase Indentation']
    outdent:       ['Decrease Indentation']
  rules:
    rule:          ['Horizontal Rule', title: 'Insert a horizontal rule']
  extra:
    clean:         ['Remove Formatting', title: 'Remove formatting for the selection']
    sep:           ' '
    edit:          ['Edit HTML', title: 'Edit the HTML content']
  table:
    rowBefore:     ['Insert Table Row', title: 'Insert a table row before the cursor']
    rowAfter:      ['Insert Table Row', title: 'Insert a table row after the cursor']
    rowDelete:     ['Delete Table Row', title: 'Delete this table row']
    colBefore:     ['Insert Table Column', title: 'Insert a table column before the cursor']
    colAfter:      ['Insert Table Column', title: 'Insert a table column after the cursor']
    colDelete:     ['Delete Table Column', title: 'Delete this table column']
    sep:           ' '
    colIncrease:   ['Increase Cell Columns', title: 'Increase the cells colspan']
    colDecrease:   ['Decrease Cell Columns', title: 'Decrease the cells colspan and add a new cell']
    rowIncrease:   ['Increase Cell Rows', title: 'Increase the cells rowspan']
    rowDecrease:   ['Decrease Cell Rows', title: 'Decrease the cells rowspan and add a new cell']


Mercury.Region.Html.addAction

  bold:          -> @toggleWrapSelectedWordsInClass('red')
  italic:        -> @toggleWrapSelectedWordsInClass('highlight')
  underline:     -> @toggleWrapSelectedWordsInClass('blue')
  rule:          -> @replaceSelection('<hr/>')
  style:         ->
