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

  @type: 'unknown'

  logPrefix: 'Mercury.Region:'

  # Define the region by setting className, type, and supported actions. This also clears any events that might already
  # exist, and sets some useful stuff like logPrefix.
  # Returns itself for chaining.
  #
  @define: (@className, @type, @actions) ->
    @logPrefix = @::logPrefix = "#{@className}:"
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

    # make the element focusable
    @attr(tabindex: 0) if @focusable

    # get the name from the element (default attribute is "id")
    @name ||= @el.attr(@config('regions:identifier'))
    unless @name
      @notify(@t('no name provided for the "%s" region, falling back to random', @constructor.type))
      @name = "#{@constructor.type}#{Math.floor(Math.random() * 10000)}"

    # set defaults
    @previewing ||= false
    @focused ||= false

    @bindDefaultEvents()


  # Binds to various events, which includes the global action event which will be proxied through to the handlers
  # defined in subclasses, and the dropFile event.
  #
  bindDefaultEvents: ->
    @delegateEvents
      focus: => @trigger('focus'); @onFocus?()
      blur: => @trigger('blur'); @onBlur?()

    # handle action events using a custom event handler
    Mercury.on('action', => @handleAction(arguments...))
    @delegateActions($.extend(true, @constructor.actions, @actions ||= {}))

    # delegate file dropping if it looks like we want to allow dropping files
    @delegateDropFile() if typeof(@onDropFile) == 'function'


  # Handles action events by taking the first argument, which should be the action, and passes through to the action
  # handler that's been defined within the subclass.
  #
  handleAction: (args...) ->
    return unless @focused
    @actions[args.shift()]?(args...)


  # Focuses the region, which will call focus on the element and an onFocus method if the subclass implements one. Used
  # externally to manually focus a region (so regions can retain focus with various actions.)
  #
  focus: ->
    @focused = true
    @el.focus()
    @onFocus?()


  # Blurs the region, which will call blur on the element and an onBlur method if the subclass implements one. Used
  # externally to manually blur a region.
  #
  blur: ->
    @focused = false
    @el.blur()
    @onBlur?()


  # Delegate jQuery data.
  #
  data: (key, value) ->
    if value then @el.data(key, value) else @el.data(key)


  # Finds and collect the snippets out of the content.
  # Returns the snippets as an object for serializing.
  #
  snippets: ->
    {}


  # Serializes our content, type, any data, and snippets into an object.
  # Returns an object.
  #
  toJSON: ->
    name: @name
    type: @constructor.type
    value: @html()
    data: @data()
    snippets: @snippets()


  # Releases the instance and triggers a release event. Releasing a region doesn't remove the element, but does remove
  # all event listeners including those that have been added externally.
  #
  release: ->
    @trigger('release')
    @off()


  # Adds the annoying drag events needed to capture when files have been dragged into the browser and dropped on our
  # element. Will call a dropFile method with the files that were dropped -- and is called for you if your subclass
  # implements a dropClass method.
  # Note: This causes conflicts with contentEditable drag/dropping for image movement etc (and I totally blame chrome).
  #
  delegateDropFile: ->
    @el.on('dragenter', (e) -> e.preventDefault())
    @el.on('dragover', (e) -> e.preventDefault())
    @el.on 'drop', (e) =>
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
