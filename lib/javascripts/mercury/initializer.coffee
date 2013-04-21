#
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

  # Provides global method to initialize.
  #
  # This is the standard means to instantiate Mercury Editor. If you need more custom behavior check the configuration,
  # and if that doesn't suit your needs, feel free to instantiate the desired interface yourself.
  #
  @init = (options = {}) ->
    return if @interface
    @trigger('configure')
    @interface = new @[@config('interface:class')](options)

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
    ie10: if isIE = navigator.userAgent.match(/MSIE\s([\d|\.]+)/) then parseFloat(isIE[1], 10) >= 10 else false
  @support.wysiwyg = (document.designMode) &&                                    # we have designMode
                     (!@support.trident || @support.ie10) &&                     # we're in IE10+
                     (window.rangy && window.rangy.supported)                    # rangy is loaded and supported

initialize.call(@MockMercury || @Mercury)
