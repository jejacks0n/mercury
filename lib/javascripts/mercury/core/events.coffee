(@Mercury ||= {}).Events =

  # Binds to an event. Pass an event name (or space delimited events) and a handler. In general mimicking jQuery style
  # events.
  # Returns self for chaining.
  #
  # on('event', function(e, arg1) { })           => self
  # on('event1 event2', function(e, arg1) { })   => self
  #
  on: (events, handler) ->
    events = events.split(' ')
    calls = @__handlers__ ||= {}
    for name in events
      calls[name] ||= []
      calls[name].push(handler)
    @


  # Binds to an event for only one time. Behaves the same as `on`, but will remove itself after the first time the event
  # is fired.
  # Returns self for chaining.
  #
  # one('event', function(e, arg1) { })          => self
  #
  one: (events, handler) ->
    callback = ->
      @off(events, callback)
      handler.apply(@, arguments)
    @on(events, callback)


  # Unbinds a given event. If no event or handler is provided all event handlers will be removed, and if you provide an
  # event but no handler all handlers for just that event will be removed.
  # Returns self for chaining.
  #
  # off()                                        => self # remove all events and handlers
  # off('event')                                 => self # remove all handlers for this event
  # off('event1 event2')                         => self # remove all handlers for these events
  # off('event', handler)                        => self # remove only this handler for this event
  #
  off: (events, handler) ->
    unless events
      @__handlers__ = {}
      return @
    for name in events.split(' ')
      continue unless list = @__handlers__?[name]
      unless handler
        delete @__handlers__[name]
        continue
      for h, i in list when h is handler
        list = list.slice()
        list.splice(i, 1)
        @__handlers__[name] = list
        break
    @


  # Triggers an event. When you trigger an event, any argument passed will propagate to all handler methods.
  # Returns false when no handlers for the event were found, otherwise true.
  #
  # trigger('event', 1, 2)                       => true
  #
  trigger: (args...) ->
    event = args.shift()
    @log?(event, args)
    return false unless list = @__handlers__?[event]
    for handler in list
      break if handler.apply(@, args) == false
    true
