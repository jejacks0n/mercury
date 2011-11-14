class @Mercury.Toolbar.Button

  constructor: (@name, @title, @summary = null, @types = {}, @options = {}) ->
    @title = Mercury.I18n(@title) if @title
    @summary = Mercury.I18n(@summary) if @summary

    @build()
    @bindEvents()
    return @element


  build: ->
    @element = jQuery('<div>', {title: @summary ? @title, class: "mercury-button mercury-#{@name}-button"}).html("<em>#{@title}</em>")
    @element.data('expander', "<div class=\"mercury-expander-button\" data-button=\"#{@name}\"><em></em><span>#{@title}</span></div>")

    @handled = {}

    for own type, mixed of @types
      switch type
        when 'preload' then true

        when 'regions'
          @element.addClass('disabled')
          @handled[type] = if jQuery.isFunction(mixed) then mixed.call(@, @name) else mixed

        when 'toggle'
          @handled[type] = true

        when 'mode'
          @handled[type] = if mixed == true then @name else mixed

        when 'context'
          @handled[type] = if jQuery.isFunction(mixed) then mixed else Mercury.Toolbar.Button.contexts[@name]

        when 'palette'
          @element.addClass("mercury-button-palette")
          url = if jQuery.isFunction(mixed) then mixed.call(@, @name) else mixed
          @handled[type] = new Mercury.Palette(url, @name, @defaultDialogOptions())

        when 'select'
          @element.addClass("mercury-button-select").find('em').html(@title)
          url = if jQuery.isFunction(mixed) then mixed.call(@, @name) else mixed
          @handled[type] = new Mercury.Select(url, @name, @defaultDialogOptions())

        when 'panel'
          @element.addClass('mercury-button-panel')
          url = if jQuery.isFunction(mixed) then mixed.call(@, @name) else mixed
          @handled['toggle'] = true
          @handled[type] = new Mercury.Panel(url, @name, @defaultDialogOptions())

        when 'modal'
          @handled[type] = if jQuery.isFunction(mixed) then mixed.apply(@, @name) else mixed

        when 'lightview'
          @handled[type] = if jQuery.isFunction(mixed) then mixed.apply(@, @name) else mixed

        else throw Mercury.I18n('Unknown button type \"%s\" used for the \"%s\" button.', type, @name)


  bindEvents: ->
    Mercury.on 'button', (event, options) => @element.click() if options.action == @name
    Mercury.on 'mode', (event, options) => @togglePressed() if @handled.mode == options.mode && @handled.toggle

    Mercury.on 'region:update', (event, options) =>
      if @handled.context && options.region && jQuery.type(options.region.currentElement) == 'function'
        element = options.region.currentElement()
        if element.length && @handled.context.call(@, element, options.region.element)
          @element.addClass('active')
        else
          @element.removeClass('active')
      else
        @element.removeClass('active')

    Mercury.on 'region:focused', (event, options) =>
      if @handled.regions && options.region && options.region.type
        if @handled.regions.indexOf(options.region.type) > -1
          @element.removeClass('disabled')
        else
          @element.addClass('disabled')

    Mercury.on 'region:blurred', =>
      @element.addClass('disabled') if @handled.regions

    @element.on 'mousedown', =>
      @element.addClass('active')

    @element.on 'mouseup', =>
      @element.removeClass('active')

    @element.on 'click', (event) =>
      if @element.closest('.disabled').length then return

      handled = false
      for own type, mixed of @handled
        switch type
          when 'toggle'
            @togglePressed() unless @handled.mode

          when 'mode'
            handled = true
            Mercury.trigger('mode', {mode: mixed})

          when 'modal'
            handled = true
            Mercury.modal(@handled.modal, {title: @summary || @title, handler: @name})

          when 'lightview'
            handled = true
            Mercury.lightview(@handled.lightview, {title: @summary || @title, handler: @name, closeButton: true})

          when 'palette', 'select', 'panel'
            event.stopPropagation()
            handled = true
            @handled[type].toggle()

      Mercury.trigger('action', {action: @name}) unless handled
      Mercury.trigger('focus:frame') if @options['regions'] && @options['regions'].length


  defaultDialogOptions: ->
    return {
      title: @summary || @title
      preload: @types.preload
      appendTo: @options.appendDialogsTo || 'body'
      closeButton: true
      for: @element
    }


  togglePressed: ->
    @element.toggleClass('pressed')



# Button contexts
@Mercury.Toolbar.Button.contexts =

  backColor: (node) -> @element.css('background-color', node.css('background-color'))

  foreColor: (node) -> @element.css('background-color', node.css('color'))

  bold: (node) ->
    weight = node.css('font-weight')
    weight == 'bold' || weight > 400

  italic: (node) -> node.css('font-style') == 'italic'

  # todo: overline is a bit weird because <u> and <strike> override text-decoration, so we can't always tell
  # todo: maybe walk up the tree if it's not too expensive?
  overline: (node) -> node.css('text-decoration') == 'overline'

  strikethrough: (node, region) -> node.css('text-decoration') == 'line-through' || !!node.closest('strike', region).length

  underline: (node, region) -> node.css('text-decoration') == 'underline' || !!node.closest('u', region).length

  subscript: (node, region) -> !!node.closest('sub', region).length

  superscript: (node, region) -> !!node.closest('sup', region).length

  justifyLeft: (node) -> node.css('text-align').indexOf('left') > -1

  justifyCenter: (node) -> node.css('text-align').indexOf('center') > -1

  justifyRight: (node) -> node.css('text-align').indexOf('right') > -1

  justifyFull: (node) -> node.css('text-align').indexOf('justify') > -1

  insertOrderedList: (node, region) -> !!node.closest('ol', region.element).length

  insertUnorderedList: (node, region) -> !!node.closest('ul', region.element).length
