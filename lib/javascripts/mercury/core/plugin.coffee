#= require mercury/core/config
#= require mercury/core/events
#= require mercury/core/i18n
#= require mercury/core/logger
#= require mercury/core/module
@Mercury ||= {}

class Mercury.Plugin extends Mercury.Module
  @extend  Mercury.Logger
  @extend  Mercury.I18n
  @include Mercury.Config
  @include Mercury.Events
  @include Mercury.I18n
  @include Mercury.Logger

  @logPrefix: 'Mercury.Plugin:'

  registered = {}

  @events:
    'mercury:region:focus': 'onRegionFocus'
    'button:click': 'onButtonClick'

  @register: (name, options) ->
    new Mercury.Plugin(name, options)


  @unregister: (name) ->
    @get(name).release()


  @all: ->
    registered


  @get: (name) ->
    plugin = registered[name]
    throw new Error("unable to locate the #{name} plugin") unless plugin
    plugin


  constructor: (@name, @options = {}) ->
    @configuration = @options.config || {}
    @[key] = value for key, value of @options when key not in ['config']
    throw new Error('must provide a name for plugins') unless @name
    registered[@name] = @

    @delegateEvents($.extend({}, @constructor.events, @events))
    @delegateActions(@actions)

    super


  registerButton: (@button) ->


  regionSupported: (region) ->
    for action, handler of @actions || {}
      return true if region.hasAction(action)
    return false


  onRegionFocus: (@region) ->


  onButtonClick: ->
    @triggerAction()


  triggerAction: (args...) ->
    return unless @region
    for action, handler of @actions || {}
      if @region.hasAction(action)
        args.unshift(action)
        return handler.apply(@, args)


  config: (path) ->
    config = @configuration ||= {}
    try config = config[part] for part in path.split(':')
    catch e
      return Mercury.Config.get(path)
    return Mercury.Config.get(path) if typeof(config) == 'undefined'
    config


  configure: (args...) ->
    path = args.shift()
    value = args.pop()
    merge = args.pop()

    return @configuration = path if !value && typeof(path) == 'object'

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


  release: ->
    Mercury.off(name, method) for name, method of @__global_handlers__ || {}
    @off()


  delegateActions: (actions) ->
    for key, method of actions
      if typeof(method) != 'function'
        throw new Error("#{method} doesn't exist") unless @[method]
        method = @[method]
      @actions[key] = method


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
