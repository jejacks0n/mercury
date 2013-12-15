# Extends the global Mercury object with various modules.
#
# In general it's expected that you use the methods provided on the Mercury namespace, and don't call through to the
# modules directly.
#
# A good example of this is the Mercury.I18n module. It's recommended that you use Mercury.t and not Mercury.I18n.t,
# or similarly with Mercury.Logger -- use Mercury.log (or this.log in models and views etc.) instead of
# Mercury.Logger.log as the context may not be the same.
#
initialize = ->

  @version = '2.0.1 pre alpha'

  # Provides a reference to JST that is window independent.
  @JST = window.JST || {}

  # Provides global method to initialize.
  #
  # This is the standard means to instantiate Mercury Editor. If you need more custom behavior check the configuration,
  # and if that doesn't suit your needs, feel free to instantiate the desired interface yourself.
  #
  @init = (options = {}) ->
    return if @interface
    @trigger('configure')
    @interface = new @[@config('interface:class')](options)
    @loadScript()
    @interface

  # Provides global way to load snippets and other data back into Mercury.
  #
  # This allows you to load snippet options back into snippets/the regions they're in, as well as providing an API to
  # load other data. Pass it the JSON hash that was saved and it should be able to handle the rest.
  #
  @load = (json) ->
    @loadedJSON = json if json
    @interface?.load(@loadedJSON)

  # Provides global method to load snippets and other data back into Mercury via Ajax.
  #
  # This allows you to create a server response with the data for the current page being edited.
  #
  @loadUrl = (url) ->
    $.ajax(url, async: false, type: 'get', dataType: 'json', success: (json) => @load(json))

  # Provides global method to load snippets and other data back into Mercury from a json/mercury script tag.
  #
  # This allows you to put the data for the current page within a <script type="json/mercury"> tag.
  #
  @loadScript = ->
    @load(JSON.parse($('script[type="json/mercury"]').text() || 'null'))

  # Provides global method to release.
  #
  # This will remove the interface and restore all regions.
  #
  @release = ->
    return unless @interface
    @trigger('released')
    @interface.release()
    delete(@interface)
    @off()

  # Provides a more consistent way to redirect / set the url.
  #
  # This is because it's impossible to mock location.assign etc. and allows for better testing. Note: untestable.
  #
  @redirect = (url) ->
    window.location.assign(url)

  # Add global configuration methods.
  #
  # Mercury.configure
  # Creates or updates configuration values. Accepts a path (eg. 'localization:preferred') and a value to be set.
  #
  # Mercury.config
  # Get a configuration value by providing a path (much like the setter).
  #
  @Module.extend.call(@, @Config)
  @configure = (args...) ->
    if @configuration
      @trigger('configure')
      @Config.set(args...)
    @one 'configure', -> @Config.set(args[0], true, args[1])

  # Add exernal interface for common api actions.
  #
  # This adds commonly used methods to the global Mercury object. You can call these methods instead of triggering the
  # event -- this is provided as a convenience. The following methods will be on the global object.
  #
  # focus         - restores focus to mercury, which will focus the active region
  # blur          - blur mercury, which will give up focus and blur the region
  # save          - make the save ajax request
  # initialize    - lets mercury know that it can initialize
  # reinitialize  - tells mercury to go find any new regions
  # toggle        - toggles the interface
  # show          - shows the interface if it's hidden
  # hide          - hides the interface if it's visible
  #
  map = ['focus', 'blur', 'save', 'initialize', 'reinitialize', 'interface:toggle', 'interface:show', 'interface:hide']
  (do(e) => @[e.replace('interface:', '')] = -> @trigger(e)) for e in map

  # Add global event handling/triggering.
  #
  # The event engine generally mimics jQuery style of binding and unbinding.
  #
  # Mercury.on
  # Binds to a global event. Not every event is global, but many are piped through globally so you can bind to them.
  #
  # Mercury.one
  # Same as Mercury.on, but will be removed after the first time the event is triggered.
  #
  # Mercury.trigger
  # Trigger a global event.
  #
  # Mercury.off
  # Stop observing a given global event.
  #
  @Module.extend.call(@, @Events)

  # Add global translation.
  #
  # Mercury.t
  # Translate a given string with simple printf-like handling.
  #
  @Module.extend.call(@, @I18n)

  # Add global logger.
  #
  # Mercury.log
  # Logs the provided information using console.log if available.
  #
  # Mercury.notify
  # Logs a given message using console.error (and console.trace) if available, otherwise an exception is thrown.
  #
  @Module.extend.call(@, @Logger)

  # Add global plugin registration.
  #
  # This provides the means to register your plugins dynamically, as well as to get them easily.
  #
  # Mercury.registerPlugin
  # Define a plugin and register it so it can be configured and used.
  #
  # Mercury.getPlugin
  # Allows getting a plugin by name.
  #
  @Module.extend.call(@, @Plugin)

  # Add global snippet registration.
  #
  # This provides the means to register your snippets dynamically (in the same way as plugins), as well as to get them
  # easily.
  #
  # Mercury.registerSnippet
  # Define a snippet and register it so it can be configured and used.
  #
  # Mercury.getSnippet
  # Allows getting a snippet by name.
  #
  @Module.extend.call(@, @Snippet)

  # Do some detection.
  #
  # We need to detect various support, and as nice as it would be to feature detection for all of this, some of the more
  # complex aspects aren't something that you can detect for (eg. drag and drop event propagation).
  #
  @support =
    webkit: navigator.userAgent.indexOf('WebKit') > 0
    safari: navigator.userAgent.indexOf('Safari') > 0 && navigator.userAgent.indexOf('Chrome') == -1
    chrome: navigator.userAgent.indexOf('Chrome') > 0
    gecko: navigator.userAgent.indexOf('Firefox') > 0
    trident: navigator.userAgent.indexOf('MSIE') > 0
    ie10: navigator.userAgent.match(/MSIE\s([\d|\.]+)/) && parseFloat(isIE[1], 10) >= 10
  @support.wysiwyg = (document.designMode) && (!@support.trident || @support.ie10)
  @support.wysiwyg = false if @support.gecko && parseFloat(navigator.userAgent.match(/Firefox\/([\d|\.]+)/)[1], 10) < 22

initialize.call(@MockMercury || @Mercury)
