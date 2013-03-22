###!
The Markdown region utilizes the Markdown syntax (http://en.wikipedia.org/wiki/Markdown) to generate an html preview.
When saved this region will return the markdown content (unprocessed). This content can be used by your server to render
html content to a user, or to serve the markdown when editing.

Dependencies:
  showdown-1.0 - https://github.com/coreyti/showdown

This is still experimental and could be changed later to provide a way to fetch the markdown content for a given region
via Ajax.
###
class Mercury.Region.Markdown extends Mercury.Region
  @define 'Mercury.Region.Markdown', 'markdown'
  @include Mercury.Region.Modules.DropIndicator
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
    paragraph    : ['\n', '\n']
    blockquote   : ['> ', '']
    bold         : ['**']
    italic       : ['_']
    underline    : ['<u>', '</u>']
    strike       : ['<del>', '</del>']
    sup          : ['<sup>', '</sup>']
    sub          : ['<sub>', '</sub>']
    unorderedList: ['- ', '']
    orderedList  : ['1. ', '', /^\d+. |$/gi]
    link         : ['[', '](%s)', /^\[|\]\([^)]\)/gi]
    image        : ['![', '](%s)', /^!\[|\]\([^)]\)/gi]
    style        : ['<span style="%s">', '</span>', /^(<span style="[^"]*">)|(<\/span>)$/gi]
    class        : ['<span class="%s">', '</span>', /^(<span class="[^"]*">)|(<\/span>)$/gi]

  blocks: ['h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'blockquote', 'unorderedList', 'orderedList']

  constructor: (@el, @options = {}) ->
    try @converter = @options.converter || new Showdown.converter().makeHtml
    catch e
      @notify(@t('requires Showdown'))
      return false

    super


  convertedValue: ->
    @converter(@value())


  onDropFile: (files) ->
    uploader = new Mercury.Uploader(files, mimeTypes: @config('regions:markdown:mimeTypes'))
    uploader.on 'uploaded', (file) =>
      @focus()
      @handleAction('file', file)


  onDropItem: (e, data) ->
    if url = $('<div>').html(data.getData('text/html')).find('img').attr('src')
      e.preventDefault()
      @focus()
      @handleAction('image', url: url)


  onReturnKey: (e) ->
    exp = @expandSelectionToLines(@getSelection())
    val = exp.text

    # unordered lists
    if val.match(/^- /)
      e.preventDefault()
      if val.match(/^- ./) then @replaceSelection('\n- ') else @replaceSelectedLine(exp, '\n')

    # ordered lists
    else if match = val.match(/^(\d+)\. /)
      e.preventDefault()
      next = parseInt(match[1], 10) + 1
      if val.match(/^\d+\. ./) then @replaceSelection("\n#{next}. ") else @replaceSelectedLine(exp, '\n')

    # indentation
    else if match = val.match(/^(> )+/g)
      e.preventDefault()
      if val.match(/^(> )+./g) then @replaceSelection("\n#{match[0]}") else @replaceSelectedLine(exp, '\n')


  actions:

    # todo: add support for video and snippet

    bold:        -> @toggleWrapSelectedWords('bold')
    italic:      -> @toggleWrapSelectedWords('italic')
    underline:   -> @toggleWrapSelectedWords('underline')
    strike:      -> @toggleWrapSelectedWords('strike')
    subscript:   -> @toggleWrapSelectedWords('sub')
    superscript: -> @toggleWrapSelectedWords('sup')
    rule:        -> @replaceSelectionWithParagraph('- - -')
    indent:      -> @wrapSelectedParagraphs('blockquote')
    outdent:     -> @unwrapSelectedParagraphs('blockquote')

    style: (value) ->
      wrapper = if value.indexOf(':') > -1 then 'style' else 'class'
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

    orderedList: ->
      @unwrapSelectedParagraphs(wrapper) for wrapper in ['blockquote', 'unorderedList']
      @wrapSelectedParagraphs('orderedList') unless @unwrapSelectedParagraphs('orderedList')

    unorderedList: ->
      @unwrapSelectedParagraphs(wrapper) for wrapper in ['blockquote', 'orderedList']
      @wrapSelectedParagraphs('unorderedList') unless @unwrapSelectedParagraphs('unorderedList')

    file: (file) ->
      action = if file.isImage() then 'image' else 'link'
      @handleAction(action, url: file.get('url'), text: file.get('name'))

    link: (link) ->
      text = link.get('text')
      @wrapSelected(@processWrapper('link', [link.get('url'), text]), text: text, select: 'end')

    image: (image) ->
      text = image.get('text')
      @wrapSelected(@processWrapper('image', [image.get('url'), text]), text: text, select: 'end')
