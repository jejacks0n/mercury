#= require mercury/core/config
#= require mercury/core/events
#= require mercury/core/i18n
#= require mercury/core/logger
#= require mercury/core/module
@Mercury ||= {}

registered = {}

class Mercury.Plugin extends Mercury.Module
  @extend  Mercury.Logger
  @extend  Mercury.I18n
  @include Mercury.Config
  @include Mercury.Events
  @include Mercury.I18n
  @include Mercury.Logger

  @logPrefix: 'Mercury.Plugin:'

  @events:
    'mercury:region:focus': 'onRegionFocus'
    'button:click': 'onButtonClick'

  # Register a plugin be providing a name, and options that will be used when instantiating the Mercury.Plugin class.
  # The options are first instantiated as a Definition, which are later used to create plugin instances. This method
  # is exposed as the global Mercury.registerPlugin method.
  # Returns Mercury.Plugin.Definition instance.
  #
  @register: (name, options) ->
    options.name = name
    new Mercury.Plugin.Definition(options)


  # Provides a way to get a plugin definition or a new plugin instance by name. This is available as the global
  # Mercury.getPlugin method. Throws an error if the plugin can't be found.
  # Returns the plugin definition instance, or a new plugin instance.
  #
  @get: (name, instance = false) ->
    definition = registered[name]
    throw new Error("unable to locate the #{name} plugin") unless definition
    if instance
      new Mercury.Plugin(definition.signature())
    else
      definition


  # Returns all registered plugins as an object.
  #
  @all: ->
    registered


  # Unregister a plugin be providing a name. This will remove the plugin from the registered plugins.
  #
  @unregister: (name) ->
    definition = registered[name]
    throw new Error("unable to locate the #{name} plugin") unless definition
    delete registered[name]


  # The plugin constructor expects a name, and one should always be passed in the options. It will throw an error if no
  # name was provided. All options will be assigned as instance variables (and if they're functions their scope will be
  # correct.
  #
  constructor: (@options = {}) ->
    @configuration = @options.config || {}
    @[key] = value for key, value of @options when key not in ['config']
    throw new Error('must provide a name for plugins') unless @name

    @actionsArray = []
    @actions ||= {}
    @events = $.extend({}, @constructor.events, @events)
    @delegateEvents(@events)
    @appendActions(@actions)

    super


  # Is called when the plugin is specified for a button. The button instance will be passed, and assigned here. If you
  # want to do custom handling, provide a #registerButton method.
  #
  buttonRegistered: (@button) ->
    @configuration = $.extend({}, @configuration, @button.get('settings'))
    if @prependButtonAction
      @context = @button.get('actionName')
      @prependAction(@context, @prependButtonAction)
    @registerButton?()


  # Handles detecting if a region has support for one or more of the plugins supported actions.
  # Returns boolean.
  #
  regionSupported: (@region) ->
    for action in @actionsArray
      if @region.hasAction(action[0])
        @regionContext?()
        return true
    return false


  # Triggers an action by first telling Mercury to focus and then by calling the specified handler based on the regions
  # first supported action.
  # Returns true if handled, and false if there's no region or the region doesn't support any of the defined actions.
  #
  triggerAction: (args...) ->
    return false unless @region
    for action in @actionsArray
      if @region.hasAction(action[0])
        args.unshift(action[0])
        Mercury.trigger('focus')
        action[1].apply(@, args)
        return true
    return false


  # Provides an interface to configuration much like the global Mercury.config. Provide a path, and the configuration
  # will be traversed to that path, falling back to the global configuration if one isn't found -- which allows for
  # configuration overrides (limited to within the plugin), as well as a common interface.
  #
  config: (path) ->
    config = @configuration ||= {}
    try config = config[part] for part in path.split(':')
    catch e
      return Mercury.Config.get(path)
    return Mercury.Config.get(path) if typeof(config) == 'undefined'
    config


  # Similar to the global configure method, this allows setting configuration within the scope of the plugin. These
  # configuration options are only applicable within the plugin, and don't effect the global configuration.
  #
  configure: (args...) ->
    path = args.shift()
    value = args.pop()
    merge = args.pop()

    return @configuration = path if typeof(path) == 'object'

    config = @configuration ||= {}
    parts = path.split(':')
    part = parts.shift()
    while part
      if parts.length == 0
        if merge && typeof(config[part]) == 'object'
          config[part] = $.extend(true, config[part], value)
        else
          config[part] = value
        return config[part]
      config = if config[part] then config[part] else config[part] = {}
      part = parts.shift()


  # Removes any global events and calls #off, which will remove any event handlers from external resources.
  #
  release: ->
    Mercury.off(name, method) for name, method of @__global_handlers__ || {}
    @off()


  # Region focus handler, which in the basic case only sets an instance variable so we can handle triggering actions,
  # but can be overridden by subclasses or options.
  #
  onRegionFocus: (@region) ->


  # When a plugin is specified to be used by a button, this handler will be called when the button is clicked. Subviews
  # are handled automatically, but this allows for more advanced features if needed.
  #
  onButtonClick: ->
    #@triggerAction()


  # This works much like Mercury.Region.delegateActions. Actions can be specified and when the region is determined to
  # support a given action that handler will be called. This is done in order in which they appear in the actions object
  # so order them by preference. Handlers are called when #triggerAction is called and the region supports the action.
  #
  # Action Events.
  # html: function() { }                         // call callback when the html action is supported.
  # text: 'handleText'                           // call this.handleText when the text action is supported.
  #
  appendActions: (actions) ->
    for key, method of actions
      if typeof(method) != 'function'
        throw new Error("#{method} doesn't exist") unless @[method]
        method = @[method]
      @actionsArray.push([key, method])


  # Similar to appendActions, but this only takes a key/value and will put the action and handler at the beginning of
  # the array, which allows adding the default button action etc.
  #
  prependAction: (key, method) ->
    if typeof(method) != 'function'
      throw new Error("#{method} doesn't exist") unless @[method]
      method = @[method]
    @actionsArray.unshift([key, method])


  # Resolve events to methods, callbacks or global events. This works much like Mercury.View.delegateEvents, but instead
  # of binding to an element, these are bound to events triggered on the plugin (either externally or internally), as
  # well as global events.
  #
  # Element Events.
  # 'button:click': function() { }               // call callback when the button is clicked
  #
  # Global Events.
  # 'mercury:action': 'handleAction'             // call this.handleAction on the global 'action' event.
  #
  delegateEvents: (events) ->
    @__global_handlers__ ||= {}
    for key, method of events

      if typeof(method) == 'function'
        method = do (method) => =>
          method.apply(@, arguments)
          true # always return true from event handlers
      else
        unless @[method]
          throw new Error("#{method} doesn't exist")
        else
          method = do (method) => =>
            @[method].apply(@, arguments)
            true

      if key.indexOf('mercury:') == 0 # bind to global event
        key = key.replace(/^mercury:/, '')
        @__global_handlers__[key] = method
        Mercury.on(key, method)
        continue

      @on(key, method)


Mercury.Plugin.Module =

  registerPlugin: Mercury.Plugin.register
  getPlugin: Mercury.Plugin.get


class Mercury.Plugin.Definition

  # This houses the plugin options as a definition so they can be used later when instantiating a Plugin. This class
  # also serves as a convenience for getting configuration from the plugin options, etc. and is returns when registering
  # a plugin.
  #
  constructor: (@options = {}) ->
    @configuration = @options.config
    @name = @options.name
    registered[@name] = @


  # Provides a way to get the cloned stored options for the definition. If you change the options from the return value
  # it will not effect the global options. This tracks changes that may have been made to configuration along the way.
  # Returns the options as a cloned object.
  #
  signature: (functions = true) ->
    sig = $.extend({}, @options, config: @configuration)
    if !functions then for name, value of sig
      delete sig[name] if typeof(value) == 'function'
    sig


  # Provides an interface to configuration much like the global Mercury.config. Provide a path, and the configuration
  # will be traversed to that path, falling back to the global configuration if one isn't found -- which allows for
  # configuration overrides (limited to within the plugin), as well as a common interface.
  #
  config: (path) ->
    config = @configuration ||= {}
    try config = config[part] for part in path.split(':')
    catch e
      return Mercury.Config.get(path)
    return Mercury.Config.get(path) if typeof(config) == 'undefined'
    config


  # Similar to the global configure method, this allows setting configuration within the scope of the plugin. These
  # configuration options are only applicable within the plugin, and don't effect the global configuration.
  #
  configure: (args...) ->
    path = args.shift()
    value = args.pop()
    merge = args.pop()

    return @configuration = path if typeof(path) == 'object'

    config = @configuration ||= {}
    parts = path.split(':')
    part = parts.shift()
    while part
      if parts.length == 0
        if merge && typeof(config[part]) == 'object'
          config[part] = $.extend(true, config[part], value)
        else
          config[part] = value
        return config[part]
      config = if config[part] then config[part] else config[part] = {}
      part = parts.shift()
