###!
Markdown provides an easy way to provide some markup abilities without the exposing the ability to edit complex HTML.
Use the markdown sent to the server on save to render the content when not editing, and render the markdown when
editing. Some options are for the converter - more here: https://github.com/chjj/marked

When saved this region will serialize the unprocessed markdown content as well as the processed/converted html content.
This can be used by your server to render html, or to serve the markdown when editing -- it's up to you how you
accomplish this.

The default converter uses Github Flavored Markdown, so your server should implement the same thing.

Dependencies:
  marked - https://github.com/chjj/marked

Configuration:
  regions:markdown:
    autoSize : true                                      # the region will auto-resize to the content within it
    mimeTypes: false                                     # file types - overrides general uploading to allow anything
    wrapping : true                                      # enables/disables soft line wrapping
    sanitize : false                                     # sanitize the output - ignore any html that has been input
    breaks   : true                                      # enable line breaks - new lines will become line breaks
###
#= require_self
#= require marked-0.2.9
class Mercury.Region.Markdown extends Mercury.Region
  @define 'Mercury.Region.Markdown', 'markdown'
  @include Mercury.Region.Modules.DropIndicator
  @include Mercury.Region.Modules.DropItem
  @include Mercury.Region.Modules.SelectionValue
  @include Mercury.Region.Modules.FocusableTextarea
  @include Mercury.Region.Modules.TextSelection

  @supported: true

  wrappers:
    h1           : ['# ', ' #']
    h2           : ['## ', ' ##']
    h3           : ['### ', ' ###']
    h4           : ['#### ', ' ####']
    h5           : ['##### ', ' #####']
    h6           : ['###### ', ' ######']
    pre          : ['```\n', '\n```']
    indentPre    : ['    ', '']
    blockquote   : ['> ', '']
    paragraph    : ['\n', '\n']
    bold         : ['**']
    italic       : ['_']
    underline    : ['<u>', '</u>']
    strike       : ['<del>', '</del>']
    superscript  : ['<sup>', '</sup>']
    subscript    : ['<sub>', '</sub>']
    unorderedList: ['- ', '']
    orderedList  : ['1. ', '', /^\d+. |$/gi]
    link         : ['[', '](%s)', /^\[|\]\([^)]\)/gi]
    image        : ['![', '](%s)', /^!\[|\]\([^)]\)/gi]
    style        : ['<span style="%s">', '</span>', /^(<span style="[^"]*">)|(<\/span>)$/gi]
    class        : ['<span class="%s">', '</span>', /^(<span class="[^"]*">)|(<\/span>)$/gi]

  blocks: ['h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'blockquote', 'unorderedList', 'orderedList']

  constructor: (@el, @options = {}) ->
    @converter = @options.converter ? window.marked
    unless @converter
      @notify(@t('requires a markdown converter'))
      return false

    super
    @setupConverter()


  setupConverter: ->
    @converter.setOptions(@options)


  convertedValue: ->
    @converter(@value())


  toJSON: (forSave = false) ->
    obj = super
    return obj unless forSave
    obj.converted = @convertedValue()
    obj


  onDropFile: (files) ->
    uploader = new Mercury[@config('interface:uploader')](files, mimeTypes: @options.mimeTypes)
    uploader.on 'uploaded', (file) =>
      @focus()
      @handleAction('file', file)


  onReturnKey: (e) ->
    exp = @expandSelectionToLines(@getSelection())
    val = exp.text

    # unordered lists
    if val.match(/^- /)
      @prevent(e)
      if val.match(/^- ./) then @replaceSelection('\n- ') else @replaceSelectedLine(exp, '\n')

    # ordered lists
    else if match = val.match(/^(\d+)\. /)
      @prevent(e)
      next = parseInt(match[1], 10) + 1
      if val.match(/^\d+\. ./) then @replaceSelection("\n#{next}. ") else @replaceSelectedLine(exp, '\n')

    # indentation
    else if match = val.match(/^(> )+/g)
      @prevent(e)
      if val.match(/^(> )+./g) then @replaceSelection("\n#{match[0]}") else @replaceSelectedLine(exp, '\n')

    # pre
    else if match = val.match(/^\s{4}/g)
      @prevent(e)
      if val.match(/^\s{4}./) then @replaceSelection("\n    ") else @replaceSelectedLine(exp, '\n')


Mercury.Region.Markdown.addToolbar

  defined:
    style:         ['Style', plugin: 'styles']
  headings:
    h1:            ['Heading 1', action: ['block', 'h1']]
    h2:            ['Heading 2', action: ['block', 'h2']]
    h3:            ['Heading 3', action: ['block', 'h3']]
    h4:            ['Heading 4', action: ['block', 'h4']]
    h5:            ['Heading 5', action: ['block', 'h5']]
    h6:            ['Heading 6', action: ['block', 'h6']]
    removeHeading: ['No Heading', action: ['block', null]]
  blocks:
    unorderedList: ['Unordered List']
    orderedList:   ['Numbered List']
    blockquote:    ['Blockquote', action: ['block', 'blockquote']]
    sep:           ' '
    pre:           ['Formatted', action: ['block', 'pre']]
  decoration:
    bold:          ['Bold']
    italic:        ['Italicize']
    strike:        ['Strikethrough']
    underline:     ['Underline']
  script:
    subscript:     ['Subscript']
    superscript:   ['Superscript']
  indent:
    indent:        ['Increase Indentation']
    outdent:       ['Decrease Indentation']
  rules:
    rule:          ['Horizontal Rule', title: 'Insert a horizontal rule']


Mercury.Region.Markdown.addAction

  bold:        -> @toggleWrapSelectedWords('bold')
  italic:      -> @toggleWrapSelectedWords('italic')
  underline:   -> @toggleWrapSelectedWords('underline')
  strike:      -> @toggleWrapSelectedWords('strike')
  subscript:   -> @toggleWrapSelectedWords('subscript')
  superscript: -> @toggleWrapSelectedWords('superscript')
  rule:        -> @replaceSelectionWithParagraph('- - -')
  indent:      -> @wrapSelectedParagraphs('blockquote')
  outdent:     -> @unwrapSelectedParagraphs('blockquote')

  orderedList: ->
    @unwrapSelectedParagraphs(wrapper) for wrapper in ['blockquote', 'unorderedList']
    @wrapSelectedParagraphs('orderedList') unless @unwrapSelectedParagraphs('orderedList')

  unorderedList: ->
    @unwrapSelectedParagraphs(wrapper) for wrapper in ['blockquote', 'orderedList']
    @wrapSelectedParagraphs('unorderedList') unless @unwrapSelectedParagraphs('unorderedList')

  style: (value) ->
    wrapper = if (value || '').indexOf(':') > -1 then 'style' else 'class'
    @unwrapSelectedWords(if wrapper == 'style' then 'class' else 'style')
    @toggleWrapSelectedWords(@processWrapper(wrapper, [value]))

  html: (html) ->
    @replaceSelection(html = (html.get && html.get(0) || html).outerHTML || html)

  block: (format) ->
    if format == 'blockquote'
      @unwrapSelectedParagraphs(wrapper) for wrapper in ['orderedList', 'unorderedList']
      @handleAction('indent') unless @unwrapSelectedParagraphs('blockquote')
      return
    if format == 'pre' || format == 'paragraph'
      @unwrapSelectedParagraphs('pre', all: true)
      return @wrapSelectedParagraphs(format, all: true) if @wrappers[format]
    @unwrapSelectedLines(wrapper) for wrapper in @blocks
    @wrapSelectedLines(format) if @wrappers[format]

  character: (html) ->
    @handleAction('html', html)

  table: (table) ->
    @handleAction('html', table.asHtml())

  file: (file) ->
    action = if file.isImage() then 'image' else 'link'
    @handleAction(action, url: file.get('url'), text: file.get('name'))

  link: (link) ->
    @replaceSelection(link.asMarkdown())

  media: (media) ->
    @replaceSelection(media.asMarkdown())


Mercury.Region.Markdown.addContext

  h1:            -> @isWithinLineToken('h1')
  h2:            -> @isWithinLineToken('h2')
  h3:            -> @isWithinLineToken('h3')
  h4:            -> @isWithinLineToken('h4')
  h5:            -> @isWithinLineToken('h5')
  h6:            -> @isWithinLineToken('h6')
  blockquote:    -> @firstLineMatches(/^> /)
  pre:           -> @paragraphMatches(/^```|```$/) || @firstLineMatches(/^(> )*\s{4}/)
  bold:          -> @isWithinToken('bold')
  italic:        -> @isWithinToken('italic')
  underline:     -> @isWithinToken('underline')
  strike:        -> @isWithinToken('strike')
  subscript:     -> @isWithinToken('subscript')
  superscript:   -> @isWithinToken('superscript')
  unorderedList: -> @firstLineMatches(/^(> )*- /)
  orderedList:   -> @firstLineMatches(/^(> )*\d+\./)
