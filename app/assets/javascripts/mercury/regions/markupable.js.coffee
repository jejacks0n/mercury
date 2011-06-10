# TODO: 
# Allow system undo history within textarea

class Mercury.Regions.Markupable extends Mercury.Region
  type = 'markupable'

  constructor: (@element, @window, @options = {}) ->
    @type = 'markupable'
    @showdown = new Showdown.converter()
    @markdownPreviewElement = $('<div>').appendTo(@element)
    @markdownInputElement = @element.find('textarea')
    super


  build: ->
    @element.css({minHeight: 20}) if @element.css('minHeight') == '0px'
    @markdownPreviewElement.hide()


  bindEvents: ->
    super

    Mercury.bind 'unfocus:regions', (event) =>
      return if @previewing
      if Mercury.region == @
        @element.removeClass('focus')
        Mercury.trigger('region:blurred', {region: @})

    @element.mouseup =>
      return if @previewing
      @focus()
      Mercury.trigger('region:focused', {region: @})


  focus: ->
    Mercury.region = @
    @element.addClass('focus')


  htmlFromMarkdown: ->
    @showdown.makeHtml(@element.find('textarea').val())


  toggleMarkdownPreview: (convertMarkdown) ->
    if convertMarkdown
      @markdownPreviewElement.html(@htmlFromMarkdown()).show()
      @markdownInputElement.hide()
    else
      @markdownInputElement.show()
      @markdownPreviewElement.hide()
