@Mercury.tooltip = (forElement, content, options = {}) ->
  Mercury.tooltip.show(forElement, content, options)
  return Mercury.tooltip

jQuery.extend Mercury.tooltip,

  show: (@forElement, @content, @options = {}) ->
    @document = @forElement.get(0).ownerDocument
    @initialize()
    if @visible then @update() else @appear()


  initialize: ->
    return if @initialized
    @build()
    @bindEvents()
    @initialized = true


  build: ->
    @element = jQuery('<div>', {class: 'mercury-tooltip'})
    @element.appendTo(jQuery(@options.appendTo).get(0) ? 'body')


  bindEvents: ->
    Mercury.on 'resize', => @position() if @visible

    @element.on 'mousedown', (event) ->
      event.preventDefault()
      event.stopPropagation()

    for parent in @forElement.parentsUntil(jQuery('body', @document))
      continue unless parent.scrollHeight > parent.clientHeight
      jQuery(parent).on 'scroll', =>
        @position() if @visible

    jQuery(@document).on 'scroll', =>
      @position() if @visible


  appear: ->
    @update()

    @element.show()
    @element.animate {opacity: 1}, 200, 'easeInOutSine', =>
      @visible = true


  update: ->
    @element.html(@content)
    @position()


  position: ->
    offset = @forElement.offset()
    width = @element.width()

    top = offset.top + (Mercury.displayRect.top - jQuery(@document).scrollTop()) + @forElement.outerHeight()
    left = offset.left - jQuery(@document).scrollLeft()

    left = left - (left + width + 25) - Mercury.displayRect.width if (left + width + 25) > Mercury.displayRect.width
    left = if left <= 0 then 0 else left

    @element.css {
      top: top
      left: left
    }


  hide: ->
    return unless @initialized
    @element.hide()
    @visible = false

