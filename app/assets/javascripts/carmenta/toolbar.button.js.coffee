class Carmenta.Toolbar.Button

  constructor: (@name, @title, @summary = null, @handled = [], @toolbar) ->
    @build()
    @bindEvents()
    return @element


  build: ->
    @element = $('<div>', {title: @summary ? @title, class: "carmenta-button carmenta-#{@name}-button"})
    @element.html("<em>#{@title}</em>")
    @element.data('expander', "<div class=\"carmenta-expander-button\" data-button=\"#{@name}\"><em></em><span>#{@title}</span></div>")

    dialogOptions = {title: @summary || @title, preload: @handled.preload, appendTo: @toolbar.element, for: @element}
    for type, mixed of @handled
      switch type

        when 'preload' then true

        when 'toggle'
          @handled[type] = true

        when 'mode'
          @handled[type] = if mixed == true then @name else mixed

        when 'context'
          @handled[type] = if $.isFunction(mixed) then mixed else Carmenta.Toolbar.Button.contexts[@name]

        when 'palette'
          @element.addClass("carmenta-button-palette")
          url = if $.isFunction(mixed) then mixed.call(@, @name) else mixed
          @handled[type] = new Carmenta.Palette(url, @name, dialogOptions)

        when 'select'
          @element.addClass("carmenta-button-select").find('em').html(@title)
          url = if $.isFunction(mixed) then mixed.call(@, @name) else mixed
          @handled[type] = new Carmenta.Select(url, @name, dialogOptions)

        when 'panel'
          @element.addClass('carmenta-button-panel')
          url = if $.isFunction(mixed) then mixed.call(@, @name) else mixed
          @handled['toggle'] = true
          @handled[type] = new Carmenta.Panel(url, @name, dialogOptions)

        when 'modal'
          @handled[type] = if $.isFunction(mixed) then mixed.apply(@, @name) else mixed

        else throw "Unknown button type #{type} used for the #{@name} button"


  bindEvents: ->
    Carmenta.bind 'region:update', (event, options) =>
      context = Carmenta.Toolbar.Button.contexts[@name]
      if context
        if options.region && $.type(options.region.currentElement) == 'function'
          if context.call(@, options.region.currentElement(), options.region.element)
            @element.addClass('active')
          else
            @element.removeClass('active')
      else
        @element.removeClass('active')

    @element.mousedown (event) =>
      @element.addClass('active')

    @element.click (event) =>
      if @element.closest('.disabled').length then return

      handled = false
      for type, mixed of @handled
        switch type

          when 'toggle'
            @togglePressed()

          when 'mode'
            handled = true
            Carmenta.trigger('mode', {mode: mixed})

          when 'modal'
            handled = true
            Carmenta.modal(@handled['modal'], {title: @summary || @title, handler: @name})

          when 'palette', 'select', 'panel'
            event.stopPropagation()
            handled = true
            @handled[type].toggle()

      Carmenta.trigger('action', {action: @name}) unless handled
      Carmenta.trigger('focus:frame')


  togglePressed: ->
    @element.toggleClass('pressed')



# Button contexts
Carmenta.Toolbar.Button.contexts =

  backcolor: (node) -> @element.css('background-color', node.css('background-color'))

  forecolor: (node) -> @element.css('background-color', node.css('color'))

  bold: (node) ->
    weight = node.css('font-weight')
    weight == 'bold' || weight > 400

  italic: (node) -> node.css('font-style') == 'italic'

  # todo: overline is a bit weird because <u> and <strike> override text-decoration, so we can't always tell
  # todo: maybe walk up the tree if it's not too expensive?
  overline: (node) -> node.css('text-decoration') == 'overline'

  # todo: this should never check for tags, because they could be styled differently
  strikethrough: (node, region) -> node.css('text-decoration') == 'line-through' || node.closest('strike', region).length

  underline: (node, region) -> node.css('text-decoration') == 'underline' || node.closest('u', region).length

  subscript: (node, region) -> node.closest('sub', region).length

  superscript: (node, region) -> node.closest('sup', region).length

  justifyleft: (node) -> node.css('text-align').indexOf('left') > -1

  justifycenter: (node) -> node.css('text-align').indexOf('center') > -1

  justifyright: (node) -> node.css('text-align').indexOf('right') > -1

  justifyfull: (node) -> node.css('text-align').indexOf('justify') > -1

  insertorderedlist: (node, region) -> node.closest('ol', region.element).length

  insertunorderedlist: (node, region) -> node.closest('ul', region.element).length