class Carmenta.Toolbar

  constructor: (@options = {}) ->
    @build()
    @bindEvents()
    @resize()


  build: ->
    @element = $('<div>', {class: 'carmenta-toolbar-container', style: 'width:10000px'}).appendTo($(@options.appendTo).get(0) ? 'body')

    for toolbarName, buttons of Carmenta.config.toolbars
      toolbar = $('<div>', {class: "carmenta-toolbar carmenta-#{toolbarName}-toolbar"}).appendTo(@element)
      container = $('<div>', {class: 'carmenta-toolbar-button-container'}).appendTo(toolbar)

      for buttonName, options of buttons
        @buildButton(buttonName, options).appendTo(container)

      if container.css('white-space') == 'nowrap'
        expander = new Carmenta.Toolbar.Expander(toolbarName, {appendTo: toolbar, for: container})
        expander.appendTo(@element)

    @element.css({width: '100%'})

  buildButton: (name, options) ->
    switch $.type(options)

      when 'array' # button
        [title, summary, handled] = options
        new Carmenta.Toolbar.Button(name, title, summary, handled, @)

      when 'object' # button group
        group = new Carmenta.Toolbar.ButtonGroup(name, options)
        for a, o of options
          @buildButton(a, o).appendTo(group) unless a == '_context'
        group

      when 'string' # separator
        $('<hr>', {class: "carmenta-#{if options == '-' then 'line-separator' else 'separator'}"})

      else throw "Unknown button structure -- please provide an array, object, or string for #{name}."


  bindEvents: ->
    $(window).resize => @resize()

    @element.mousedown(Carmenta.preventer)

    @element.click ->
      Carmenta.trigger('hide:dialogs')



  resize: ->


  height: ->
    @element.outerHeight()


  disable: ->
    # disable the entire toolbar
    # disable a specific toolbar
    # disable specific buttons or button groups


  enable: ->
