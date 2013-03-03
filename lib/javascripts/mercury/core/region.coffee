#= require mercury/core/view
#= require mercury/core/stack
@Mercury ||= {}

class Mercury.Region extends Mercury.View
  @extend  Mercury.Config
  @extend  Mercury.Events
  @extend  Mercury.I18n
  @extend  Mercury.Logger
  @include Mercury.Stack

  @supported: true

  @logPrefix: 'Mercury.Region:'

  @type: 'unknown'

  @defaultActions:
    undo: 'onUndo'
    redo: 'onRedo'

  # Define the region by setting className, type, and supported actions. This also clears any events that might already
  # exist, and sets some useful stuff like logPrefix.
  # Returns itself for chaining.
  #
  # If you want to add actions to a given region you have to provide them at the constructor level. By adding actions
  # this way you can create new buttons and have them only enabled on regions that support that action. Action handlers
  # are called within the scope of the region.
  #
  # Mercury.SimpleRegion.actions = {
  #   newAction: function() { }
  # }
  #
  #
  @define: (@className, @type, actions = {}) ->
    @logPrefix = @::logPrefix = "#{@className}:"
    @::actions = actions
    @off()
    @


  # Determines a region type from an element and attempts to create an instance of that region class. Will notify if a
  # type isn't provided or if a matching region class isn't found -- in which case it will fall back to the base region.
  # Returns new instance.
  #
  @create: (el) ->
    el = $(el)
    type = el.attr(@config('regions:attribute'))
    @notify(@t('region type not provided')) unless type

    type = "#{type}_region".toLowerCase().toCamelCase(true)
    @notify(@t('unknown "%s" region type, falling back to base region', type)) unless Mercury[type]
    new (Mercury[type] || Mercury.Region)(el)


  # The constructor sets up defaults, attempts to get the name from the element. It will notify if the region isn't
  # supported in the given browser or if there's no name to use for serializing.
  #
  constructor: (@el, @options = {}) ->
    return @notify(@t('is unsupported in this browser')) unless @constructor.supported

    super(@options)

    # make the element focusable (unless we've set one ourselves)
    @attr(tabindex: 0) unless @focusable

    # get the name from the element (default attribute is "id")
    @name ||= @el.attr(@config('regions:identifier'))
    unless @name
      @notify(@t('no name provided for the "%s" region, falling back to random', @constructor.type))
      @name = "#{@constructor.type}#{Math.floor(Math.random() * 10000)}"

    # set defaults
    @previewing ||= false
    @focused ||= false
    @focusable ||= @el
    @skipHistoryOn ||= ['redo']

    @pushHistory()
    @bindDefaultEvents()


  # Handles action events by taking the first argument, which should be the action, and passes through to the action
  # handler that's been defined within the subclass.
  # Returns false if we shouldn't handle anything, otherwise true.
  #
  handleAction: (args...) ->
    return unless @focused
    action = args.shift()
    @pushHistory() unless @skipHistoryOn.indexOf(action) > -1
    @actions[action]?(args...)
    return true


  # This is the standard way to push onto the undo stack. The stack is used in regions for custom undo history, but you
  # can bypass this by using #pushStack if you need.
  #
  pushHistory: ->
    @pushStack(@value())


  # Focuses the region, which will call focus on the element and an onFocus method if the subclass implements one. Used
  # externally to manually focus a region (so regions can retain focus with various actions.)
  #
  focus: ->
    @focused = true
    @focusable.focus()
    @onFocus?()


  # Blurs the region, which will call blur on the element and an onBlur method if the subclass implements one. Used
  # externally to manually blur a region.
  #
  blur: ->
    @focused = false
    @focusable.blur()
    @onBlur?()


  # Gets or sets the value, with some handling for when the argument is null or undefined. If you pass a value it will
  # be set (by default this proxies to #html), but can be useful to override.
  # Returns the value if no arguments are passed (or null / undefined)
  #
  value: (value = null) ->
    if value == null || typeof(value) == 'undefined'
      @html()
    else
      @html(value)


  # Delegate jQuery data.
  #
  data: (key, value) ->
    if value then @el.data(key, value) else @el.data(key)


  # Finds and collect the snippets out of the content.
  # Returns the snippets as an object for serializing.
  #
  snippets: ->
    {}


  # Default undo behavior. Calls #value with whatever's previous in the stack.
  #
  onUndo: ->
    @value(@undoStack())


  # Default redo behavior. Calls #value with whatever's next in the stack.
  #
  onRedo: ->
    @value(@redoStack())


  # Serializes our content, type, any data, and snippets into an object.
  # Returns an object.
  #
  toJSON: ->
    name: @name
    type: @constructor.type
    value: @value()
    data: @data()
    snippets: @snippets()


  # Releases the instance and triggers a release event. Releasing a region doesn't remove the element, but does remove
  # all event listeners including those that have been added externally.
  #
  release: ->
    @trigger('release')
    @focusable.off()
    @el.off()
    @off()


  # Binds to various events, which includes the global action event which will be proxied through to the handlers
  # defined in subclasses, and the dropFile event.
  #
  bindDefaultEvents: ->
    # handle action events using a custom event handler
    Mercury.on('action', => @handleAction(arguments...))

    # delegate all the actions defined in various places
    @delegateActions($.extend(true, @constructor.actions, @constructor.defaultActions, @actions ||= {}))

    # bind various events to the focusable element (which defaults to @el)
    @bindFocusEvents()                                          # binds focus/blur events
    @bindKeyEvents()                                            # binds undo/redo events
    @bindDropEvents() if typeof(@onDropFile) == 'function'      # binds drag/drop events for file dropping


  # Binds to focus/blur events on focusable so we can track the focused state.
  #
  bindFocusEvents: ->
    @delegateEvents @focusable,
      focus: =>
        @focused = true
        @trigger('focus')
        @onFocus?()
      blur: =>
        @focused = false
        @trigger('blur')
        @onBlur?()


  # Binds to key events on the focusable element so we can handle more complex interactions.
  #
  bindKeyEvents: ->
    @delegateEvents @focusable,
      keydown: (e) =>
        return unless e.metaKey && e.keyCode == 90
        e.preventDefault()
        if e.shiftKey then @handleAction('redo') else @handleAction('undo')


  # Binds the drag/drop events to handle files that have been dragged into the browser and dropped on our focusable
  # element. Will call an onDropFile method with the files that were dropped if your subclass implements that method.
  #
  bindDropEvents: ->
    preventDefault = (e) -> e.preventDefault()
    @delegateEvents @focusable,
      dragenter: preventDefault
      # workaround: Webkit and Firefox do drag and drop differently.
      dragover: if @editableDragOver && Mercury.support.webkit then (->) else preventDefault
      drop: (e) =>
        return unless e.originalEvent.dataTransfer.files.length
        e.preventDefault()
        @onDropFile(e.originalEvent.dataTransfer.files)


  # This works much like Mercury.View.delegateEvents, but instead of binding events to the element we're just resolving
  # the method we want to call on a given action event.
  #
  # Action Events.
  # 'uploadFile': function() { }                 // call callback when an action event was triggered with uploadedFile.
  # 'uploadFile': 'insertFile'                   // call this.insertFile when an uploadedFile action event is triggered.
  #
  delegateActions: (actions) ->
    for key, method of actions

      if typeof(method) == 'function'
        method = do (method) => =>
          method.apply(@, arguments)
          true
      else
        unless @[method]
          throw new Error("#{method} doesn't exist")
        else
          method = do (method) => =>
            @[method].apply(@, arguments)
            true

      @actions[key] = method
