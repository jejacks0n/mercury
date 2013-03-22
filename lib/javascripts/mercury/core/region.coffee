#= require mercury/core/view
#= require mercury/core/stack
@Mercury ||= {}

class Mercury.Region extends Mercury.View
  @extend  Mercury.Config
  @extend  Mercury.Events
  @extend  Mercury.I18n
  @extend  Mercury.Logger
  @include Mercury.Stack

  @Modules: {}

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
    @::actions = $.extend(@::actions, actions)
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

    type = "#{type}".toLowerCase().toCamelCase(true)
    @notify(@t('unknown "%s" region type, falling back to base region', type)) unless Mercury.Region[type]
    new (Mercury.Region[type] || Mercury.Region)(el)


  # Exposes the ability to add actions to the region type. This allows you to provide your own custom actions that may
  # be tied to a button, or something else.
  #
  @addAction: (action, handler) ->
    obj = {}
    obj[action] = handler
    @actions = $.extend(@actions || {}, obj)


  # The constructor sets up defaults and attempts to get the name from the element. It will notify if the region isn't
  # supported in the given browser or if there's no name to use for serializing.
  #
  constructor: (@el, @options = {}) ->
    unless @constructor.supported
      @notify(@t('is unsupported in this browser'))
      return false

    @options = $.extend({}, JSON.parse(@el.attr(@config('regions:options')) || '{}'), options) if @el.data

    @beforeBuild?()                                        # call the beforeBuild method if it's defined
    super(@options)                                        # let the view do it's thing
    @trigger('build')                                      # trigger the build event
    @attr(tabindex: 0) unless @focusable                   # make the element focusable (unless we've set one ourselves)
    @name ||= @el.attr(@config('regions:identifier'))      # get the name from the element
    @previewing ||= false                                  # assume previewing is false
    @focused ||= false                                     # assume focused is false
    @focusable ||= @el                                     # define @focusable unless it's already defined
    @skipHistoryOn ||= ['redo']                            # we skip pushing to the history on redo by default
    @changed ||= false                                     # you can track changes in subclasses
    @afterBuild?()                                         # call the afterBuild method if it's defined
    @el.data(region: @)                                    # add instance reference to the element data

    unless @name
      @notify(@t('no name provided for the "%s" region, falling back to random', @constructor.type))
      @name = "#{@constructor.type}#{Math.floor(Math.random() * 10000)}"

    @addRegionClassname()
    @pushHistory() unless @skipHistoryOnInitialize
    @bindDefaultEvents()
    @initialValue = JSON.stringify(@toJSON())


  # Adds the classname based on the constructor type to the element.
  #
  addRegionClassname: ->
    @addClass("mercury-#{@constructor.type}-region")


  # Handles action events by taking the first argument, which should be the action, and passes through to the action
  # handler that's been defined within the subclass.
  # Returns false if we shouldn't handle anything, otherwise true.
  #
  handleAction: (args...) ->
    return if !@focused || @previewing
    action = args.shift()
    @pushHistory() unless @skipHistoryOn.indexOf(action) > -1
    @actions[action].apply(@, args) if @actions[action]
    @trigger('action', action)
    return true


  # Handles mode switching -- will look for a togglePreview method for instance if the mode is preview.
  #
  handleMode: (args...) ->
    mode = args.shift()
    @["toggle_#{mode}".toCamelCase()]?(args...)


  # Toggles preview mode, which will trigger a preview event with our current previewing state, will remove or add
  # focusable tabindex and blurs.  Will call an #onTogglePreview method if it exists.
  #
  togglePreview: ->
    @previewing = !@previewing
    @trigger('preview', @previewing)
    if @previewing
      @blur()
      @focusable.removeAttr('tabindex')
    else
      @focusable.attr(tabindex: 0)
    @onTogglePreview?()


  # This is the standard way to push onto the undo stack. The stack is used in regions for custom undo history, but you
  # can bypass this by using #pushStack if you need. You can optionally pass a keyCode, which if it's known (return,
  # delete, backspace) will cause an immediate push, otherwise it will set a timer that will push after a 2.5 seconds,
  # which can be used to not push to the stack for every keypress.
  #
  pushHistory: (keyCode = null) ->
    # When the keycode is not set, or is return, delete or backspace push now, otherwise wait for a few seconds.
    knownKeyCode = [13, 46, 8].indexOf(keyCode) if keyCode
    pushNow = true if keyCode == null || (knownKeyCode >= 0 && knownKeyCode != @lastKeyCode)
    @lastKeyCode = knownKeyCode

    clearTimeout(@historyTimeout)
    if pushNow
      @pushStack(@valueForStack?() ? @value())
    else
      @historyTimeout = @delay(2500, => @pushStack(@valueForStack?() ? @value()))


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
    if typeof(value) != 'undefined' && value != null
      @el.data(key, value)
    else
      @el.data(key)


  # Finds and collect the snippets out of the content.
  # Returns the snippets as an object for serializing.
  #
  snippets: ->
    {}


  # Track if changes have been made since the last save. This method can be overridden to specify change conditions that
  # base doesn't account for. Be default this checks @changed and does a JSON string comparison of what #toJSON is
  # returning.
  #
  hasChanges: ->
    @changed || @initialValue != JSON.stringify(@toJSON())


  # Resets @lastSavePosition and @changed, which should make the region consider itself not changed since the last save.
  #
  onSave: ->
    @initialValue = JSON.stringify(@toJSON())
    @changed = false


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
    data = $.extend({}, @data())
    delete data.region
    name: @name
    type: @constructor.type
    value: @value()
    data: data
    snippets: @snippets()


  # Releases the instance and triggers a release event. Releasing a region doesn't remove the element, but does remove
  # all event listeners including those that have been added externally.
  #
  release: ->
    @el.data(region: null)
    @el.removeClass("mercury-#{@constructor.type}-region")
    @focusable.removeAttr('tabindex')
    @trigger('release')
    @el.off()
    @focusable.off()
    @off()
    @blur()


  # Binds to various events, which includes the global action event which will be proxied through to the handlers
  # defined in subclasses, and the dropFile event.
  #
  bindDefaultEvents: ->
    # handle action events using a custom event handler
    Mercury.on('action', => @handleAction(arguments...))

    # handle mode events using a custom mode handler
    Mercury.on('mode', => @handleMode(arguments...))

    # handle resetting changed/stack position when save is triggered
    Mercury.on('save', => @onSave())

    # delegate all the actions defined in various places
    @delegateActions($.extend(true, @constructor.actions, @constructor.defaultActions, @actions ||= {}))

    # bind various events to the focusable element (which defaults to @el)
    @bindFocusEvents()                                          # binds focus/blur events
    @bindKeyEvents()                                            # binds undo/redo events
    @bindDropEvents() if @onDropFile || @onDropItem             # binds drag/drop events for file/item dropping


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
    @delegateEvents @el,
      dragenter: (e) -> e.preventDefault()
      dragover: (e) => e.preventDefault() unless @editableDropBehavior && Mercury.support.webkit
      drop: (e) =>
        return if @previewing
        data = e.originalEvent.dataTransfer
        if data.files.length && @onDropFile
          e.preventDefault()
          @onDropFile(data.files)
        else if @onDropItem
          @onDropItem(e, data)


  # This works much like Mercury.View.delegateEvents, but instead of binding events to the element we're just resolving
  # the method we want to call on a given action event.
  #
  # Action Events.
  # 'file': function() { }                       // call callback when an action event was triggered with "file".
  # 'file': 'insertFile'                         // call this.insertFile when a "file" action event is triggered.
  #
  delegateActions: (actions) ->
    for key, method of actions

      if typeof(method) != 'function'
        throw new Error("#{method} doesn't exist") unless @[method]
        method = @[method]

      @actions[key] = method
