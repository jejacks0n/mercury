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
            Carmenta.modal(@handled['modal'], {title: @summary || @title})

          when 'palette', 'select', 'panel'
            event.stopPropagation()
            handled = true
            @handled[type].toggle()

      Carmenta.trigger('button', {action: @name}) unless handled


  togglePressed: ->
    @element.toggleClass('pressed')



# Button contexts
Carmenta.Toolbar.Button.contexts =
  backcolor: (node) ->
    @element.css('background-color', node.css('background-color'))

  forecolor: (node) ->
    @element.css('background-color', node.css('color'))

  bold: (node) ->
    weight = node.css('font-weight')
    weight == 'bold' || weight > 400

  italic: (node) ->
    node.css('font-style') == 'italic'

  strikethrough: (node) ->
    node.css('text-decoration') == 'line-through'

  underline: (node) ->
    node.css('text-decoration') == 'underline'

  subscript: (node) ->
    node.closest('sub').length > 0

  superscript: (node) ->
    node.closest('sup').length > 0

  justifyleft: (node) ->
    node.css('text-align').indexOf('left') > -1

  justifycenter: (node) ->
    node.css('text-align').indexOf('center') > -1

  justifyright: (node) ->
    node.css('text-align').indexOf('right') > -1

  justifyfull: (node) ->
    node.css('text-align').indexOf('justify') > -1

  insertorderedlist: (node, region) ->
    node.closest('ol', region.element).length > 0

  insertunorderedlist: (node, region) ->
    node.closest('ul', region.element).length > 0