class Carmenta.Toolbar.Expander extends Carmenta.Palette

  constructor: (@name, @options = {}) ->
    @container = @options.for
    @containerWidth = @container.outerWidth()
    super(null, @name, @options)
    return @element


  build: ->
    @container.css({whiteSpace: 'normal'})
    @trigger = $('<div>', {class: 'carmenta-toolbar-expander'}).appendTo(@options.appendTo)
    @element = $('<div>', {class: "carmenta-palette carmenta-expander carmenta-#{@name}-expander", style: 'display:none'})
    @windowResize()


  bindEvents: ->
    Carmenta.bind 'hide:dialogs', (event, dialog) => @hide() unless dialog == @
    Carmenta.bind 'resize', => @windowResize()

    super

    @trigger.click (event) =>
      event.stopPropagation()
      hiddenButtons = []
      for button in @container.find('.carmenta-button')
        button = $(button)
        hiddenButtons.push(button.data('expander')) if button.offset().top > 5

      @loadContent(hiddenButtons.join(''))
      @toggle()

    @element.click (event) =>
      buttonName = $(event.target).closest('[data-button]').data('button')
      button = @container.find(".carmenta-#{buttonName}-button")
      button.click()


  windowResize: ->
    if @containerWidth > $(window).width() then @trigger.show() else @trigger.hide()
    @hide()


  position: (keepVisible) ->
    @element.css({top: 0, left: 0, display: 'block', visibility: 'hidden'})
    position = @trigger.offset()
    width = @element.width()

    position.left = position.left - width + @trigger.width() if position.left + width > $(window).width()

    @element.css {
      top: position.top + @trigger.height(),
      left: position.left,
      display: if keepVisible then 'block' else 'none',
      visibility: 'visible'
    }
