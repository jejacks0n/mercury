class Carmenta.Dialog

  constructor: (@url, @name, @options = {}) ->
    @button = @options.for

    @build()
    @bindEvents()
    @preload()


  build: ->
    @element = $('<div>', {class: "carmenta-dialog carmenta-#{@name}-dialog loading", style: 'display:none'})
    @element.appendTo(@options.appendTo)


  bindEvents: ->
    @element.mousedown (event) -> event.stopPropagation()


  preload: ->
    @load() if @options.preload


  toggle: (element) ->
    if @visible then @hide() else @show()


  resize: ->
    @show()


  show: ->
    Carmenta.trigger('hide:dialogs', @)
    @visible = true
    if @loaded
      @element.css({width: 'auto', height: 'auto'})
      @position(@visible)
      @appear()
    else
      @position()
      @appear()


  position: (keepVisible) ->


  appear: ->
    @element.css({display: 'block', opacity: 0})
    @element.animate {opacity: .95}, 200, 'easeInOutSine', =>
      @load(=> @resize()) unless @loaded


  hide: ->
    @element.hide()
    @visible = false


  load: (callback) ->
    return unless @url
    $.ajax @url, {
      success: (data) =>
        @loadContent(data)
        callback() if callback

# todo: this needs a better structure so it can be coffeescript
#        this.setupFunction = window['midas_setup_' + this.name];
#        if (this.setupFunction) this.setupFunction.call(this);


      error: =>
        @hide()
        @button.removeClass('pressed')
        alert("Carmenta was unable to load #{@url} for the #{@name} dialog.")
    }


  loadContent: (data) ->
    @loaded = true
    @element.removeClass('loading')
    @element.html(data)

# todo: this needs a better architecture -- listening to events should be considered, part of the above todo
#  show: function() {
#    if (this.toolbar.activeRegion) {
#      this.contextClass = this.toolbar.activeRegion.name;
#      this.element.addClassName(this.contextClass);
#    }
#  },
#  hide: function() {
#    if (this.contextClass) {
#      this.element.removeClassName(this.contextClass);
#      this.contextClass = null;
#    }
#  },
#  execute: function(action, options, event) {
#    Midas.fire('button', {action: this.name, event: event, toolbar: this.toolbar, options: options});
#  },
