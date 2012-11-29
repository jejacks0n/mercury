class @Mercury.Toolbar.Expander extends Mercury.Palette

  constructor: (@name, @options) ->
    @container = @options.for
    super(null, @name, @options)
    return @element


  build: ->
    @container.css({whiteSpace: 'normal', visibility: 'hidden', display: 'block'})
    @container.css({visibility: 'visible'})
    @trigger = jQuery('<div>', {class: 'mercury-toolbar-expander'}).appendTo(jQuery(@options.appendTo).get(0) ? 'body')
    @element = jQuery('<div>', {class: "mercury-palette mercury-expander mercury-#{@name}-expander", style: 'display:none'})
    @windowResize()


  bindEvents: ->
    Mercury.on 'hide:dialogs', (event, dialog) => @hide() unless dialog == @
    Mercury.on 'resize', => @windowResize()

    super

    @trigger.click (event) =>
      event.stopPropagation()
      hiddenButtons = []
      for button in @container.find('.mercury-button')
        button = jQuery(button)
        hiddenButtons.push(button.data('expander')) if button.position().top > 5

      @loadContent(hiddenButtons.join(''))
      @toggle()

    @element.click (event) =>
      buttonName = jQuery(event.target).closest('[data-button]').data('button')
      button = @container.find(".mercury-#{buttonName}-button")
      button.click()


  windowResize: ->
    if jQuery(window).width() == @container.outerWidth() then @trigger.show() else @trigger.hide()
    @hide()


  position: (keepVisible) ->
    @element.css({top: 0, left: 0, display: 'block', visibility: 'hidden'})
    position = @trigger.position()
    width = @element.width()

    position.left = position.left - width + @trigger.width() if position.left + width > jQuery(window).width()

    @element.css {
      top: position.top + @trigger.height()
      left: position.left
      display: if keepVisible then 'block' else 'none'
      visibility: 'visible'
    }
