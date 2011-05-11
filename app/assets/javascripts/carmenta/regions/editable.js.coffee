class Carmenta.Regions.Editable
#  type = 'editable'

  constructor: (@element, @options = {}) ->
    Carmenta.log('making editable', @element, @options)

    @document = @options
    @history = new HistoryBuffer()
    @build()


  build: ->
    @element.addClass('carmenta-region')

    # set some initial content to so mozilla works correctly
    @html('&nbsp;') if $.browser.mozilla && @html() == ''

    if @options.inline
      @element.css({height: 'auto', minHeight: '20px', minWidth: '20px'})
    else
      width = @element.scrollWidth
      @element.css({overflow: 'auto'}) unless @element.css('overflow') == 'hidden'
      @element.css({maxWidth: width}) if width

    @element.get(0).contentEditable = true

#    this.doc.execCommand('styleWithCSS', false, false);
#    this.doc.execCommand('enableInlineTableEditing', false, false);

  html: (value = null) ->
    if value then @element.html(value) else @element.html().replace(/^\s+|\s+$/g, '')