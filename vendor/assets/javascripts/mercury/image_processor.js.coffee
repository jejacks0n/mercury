class @Mercury.ImageProcessor extends Mercury.Dialog

  constructor: ->
    # load file etc
    super


  build: ->
    @overlay = jQuery('<div>', {class: "mercury-image-processor-overlay loading", style: 'display:none'})
    @element = jQuery('<div>', {class: "mercury-image-processor loading", style: 'display:none'})

    @overlay.appendTo(jQuery(@options.appendTo).get(0) ? 'body')
    @element.appendTo(jQuery(@options.appendTo).get(0) ? 'body')


  bindEvents: ->
    super
    # bind to interface elements


  resize: ->
    super

  position: (keepVisible) ->
    ''
    #@element.css({top: 20, left: 20, bottom: 20, right: 20})