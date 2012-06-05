# The image region is designed for a single, stand-along image. It
# allows drag & drop uploading of a replacement right into the page,
# but no editing of other DOM attributes at this time.
#
class @Mercury.Regions.Image extends Mercury.Region
  @supported: document.getElementById
  @supportedText: "IE 7+, Chrome 10+, Firefox 4+, Safari 5+, Opera 8+"

  type = 'image'

  constructor: (@element, @window, @options = {}) ->
    @type = 'image'
    super

  build: ->
    # We've going to drive all the interaction with events
    # in bindEvent. Here we just highlight the elements to it
    # appears "changeable" to the user.
#    @element.addClass( Mercury.config.regions.className ).
#      removeClass( "#{Mercury.config.regions.className}-preview" )

  bindEvents: ->
    # This is standard stuff, take from the region parent
    # class. We copy it instead of super() to avoid the snippet
    # code.
    # 
    Mercury.on 'mode', (event, options) => @togglePreview() if options.mode == 'preview'

    Mercury.on 'focus:frame', =>
      return if @previewing || Mercury.region != @
      @focus()

    Mercury.on 'action', (event, options) =>
      return if @previewing || Mercury.region != @
      @execCommand(options.action, options) if options.action

    # The meat. D&D uploading similar to the editable class.
    #
    @element.on 'dragenter', (event) =>
      return if @previewing
      event.preventDefault()
      event.originalEvent.dataTransfer.dropEffect = 'copy'

    @element.on 'dragover', (event) =>
      return if @previewing
      event.preventDefault()
      event.originalEvent.dataTransfer.dropEffect = 'copy'

    @element.on 'drop', (event) =>
      return if @previewing
      # handle any files that were dropped
      if event.originalEvent.dataTransfer.files.length
        event.preventDefault()
        # Mercury.uploader will call a Mercury action of insertImage
        # as a callback. If this region is the currently focused one,
        # then we process the callback. Focus, then fire the upload.
        #
        @focus()
        Mercury.uploader(event.originalEvent.dataTransfer.files[0])

    @element.on 'focus', =>
      @focus()

  togglePreview: ->
    if @previewing
      @previewing = false
      @element.attr(Mercury.config.regions.attribute, @type)
      @build()
    else
      @previewing = true
      @element.removeAttr(Mercury.config.regions.attribute)
      Mercury.trigger('region:blurred', {region: @})
  
  focus: ->
    return if @previewing
    Mercury.region = @
    Mercury.trigger('region:focused', {region: @})
    Mercury.trigger('region:update', {region: @})

  execCommand: (action, options = {}) ->
    # Our history is pushed in the parent.
    #
    super
    handler.call(@, options) if handler = Mercury.Regions.Image.actions[action]

  pushHistory: () ->
    # Store the current image src
    #
    @history.push(src: @element.attr('src'))

  updateSrc: (src) ->
    @element.attr('src', src)

  serialize: ->
    return {
      type: @type
      data: @dataAttributes()
      attributes:
        src: @element.attr('src')
    }

  # Actions. These are all fired by execCommand.
  #
  @actions: {

    undo: -> if prev = @history.undo() then @updateSrc(prev.src)

    redo: -> if next = @history.redo() then @updateSrc(next.src)
    
    insertImage: (options) -> @updateSrc(options.value.src)

  }
