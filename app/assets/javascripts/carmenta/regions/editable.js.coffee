class Carmenta.Regions.Editable
  type = 'editable'

  constructor: (@element, @options = {}) ->
    Carmenta.log('making editable', @element, @options)

    @window = @options.window
    @document = @window.document
    @history = new HistoryBuffer()
    @build()
    @bindEvents()


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

    @document.execCommand('insertbronreturn', false, false)
    @document.execCommand('styleWithCSS', false, false)
    @document.execCommand('enableInlineTableEditing', false, false)


  bindEvents: ->
    @element.focus

    Carmenta.bind 'button', (event, options) =>
      action = options['action']
      return unless action

      # use a custom handler if there's one, otherwise use execCommand
      if handler = Carmenta.config.behaviors[action] || Carmenta.Regions.Editable.actions[action]
        handler.call(@, @selection(), options)
      else
        Carmenta.log('execCommand', action, options.value)
        try
          @document.execCommand(action, null, options.value)
        catch error
          alert(error)


  html: (value = null) ->
    if value then @element.html(value) else @element.html().replace(/^\s+|\s+$/g, '')


  selection: ->
    return new Selection(@window.getSelection(), @document)


Carmenta.Regions.Editable.actions =

  removeformatting: (selection) ->
    selection.insertTextNode(selection.textContent())

  backcolor: (selection, options) ->
    selection.wrap("<span style=\"background-color:#{options.value.toHex()}\">", true)


## TODO
#
# Custom Implementation
#inserthorizontalrule
#inserthtml
#insertimage
#undo
#redo
#overline
#
# Using execCommand
#formatblock
#indent
#outdent
#
# Unhandled
#decreasefontsize
#increasefontsize
#unlink
#createlink
#insertparagraph

## PARTIALLY DONE
#backcolor
#forecolor


## DONE
#
# Custom Implementation
#removeformatting
#
# Using execCommand
#bold
#italic
#justifycenter
#justifyfull
#justifyleft
#justifyright
#subscript
#superscript
#insertorderedlist
#insertunorderedlist
#strikethrough
#underline
