class Carmenta.Statusbar

  constructor: (@options) ->
    @build()
    @bindEvents()


  build: ->
    @element = $('<div>', {class: 'carmenta-statusbar'}).appendTo('body')


  bindEvents: ->
    @element.mousedown(Carmenta.preventer)


  height: ->
    @element.outerHeight()