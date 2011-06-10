class Mercury.Toolbar

  constructor: (@options = {}) ->
    @build()
    @bindEvents()


  build: ->
    @element = $('<div>', {class: 'mercury-toolbar-container', style: 'width:10000px'})
    @element.appendTo($(@options.appendTo).get(0) ? 'body')

    for toolbarName, buttons of Mercury.config.toolbars
      continue if buttons._custom
      toolbar = $('<div>', {class: "mercury-toolbar mercury-#{toolbarName}-toolbar"}).appendTo(@element)
      toolbar.attr('data-regions', buttons._regions) if buttons._regions
      container = $('<div>', {class: 'mercury-toolbar-button-container'}).appendTo(toolbar)

      for buttonName, options of buttons
        continue if buttonName == '_regions'
        @buildButton(buttonName, options).appendTo(container)

      if container.css('white-space') == 'nowrap'
        expander = new Mercury.Toolbar.Expander(toolbarName, {appendTo: toolbar, for: container})
        expander.appendTo(@element)

      toolbar.addClass('disabled') unless toolbarName == 'primary'

    @element.css({width: '100%'})


  buildButton: (name, options) ->
    return $('<span>') if name == '_custom'
    switch $.type(options)

      when 'array' # button
        [title, summary, handled] = options
        new Mercury.Toolbar.Button(name, title, summary, handled, {appendDialogsTo: @element})

      when 'object' # button group
        group = new Mercury.Toolbar.ButtonGroup(name, options)
        for a, o of options
          @buildButton(a, o).appendTo(group) unless a == '_context'
        group

      when 'string' # separator
        $('<hr>', {class: "mercury-#{if options == '-' then 'line-separator' else 'separator'}"})

      else throw "Unknown button structure -- please provide an array, object, or string for #{name}."


  bindEvents: ->
    Mercury.bind 'region:focused', (event, options) =>
      for toolbar in @element.find(".mercury-toolbar")
        toolbar = $(toolbar)
        if regions = toolbar.data('regions')
          toolbar.removeClass('disabled') if regions.split(',').indexOf(options.region.type) > -1

    Mercury.bind 'region:blurred', (event, options) =>
#      @element.find(".mercury-#{options.region.type}-toolbar").addClass('disabled')
      for toolbar in @element.find(".mercury-toolbar")
        toolbar = $(toolbar)
        if regions = toolbar.data('regions')
          toolbar.addClass('disabled') if regions.split(',').indexOf(options.region.type) > -1


    @element.click -> Mercury.trigger('hide:dialogs')
    @element.mousedown (event) -> event.preventDefault()


  height: ->
    @element.outerHeight()
