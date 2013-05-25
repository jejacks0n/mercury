#= require mercury/core/model
#= require mercury/core/view
#= require mercury/views/modal

registered = {}

class Mercury.Snippet extends Mercury.Model

  @logPrefix: 'Mercury.Snippet:'

  # Register a snippet be providing a name, and options that will be used when instantiating the Mercury.Snippet class.
  # The options are first instantiated as a Definition, which are later used to create snippet instances. This method
  # is exposed as the global Mercury.registerSnippet method.
  # Returns Mercury.Snippet.Definition instance.
  #
  @register: (name, options) ->
    options.name = name
    new Mercury.Snippet.Definition(options)


  # Provides a way to get a snippet definition or a new snippet instance by name. This is available as the global
  # Mercury.getSnippet method. Throws an error if the snippet can't be found.
  # Returns the snippet definition instance, or a new snippet instance.
  #
  @get: (name, instance = false) ->
    definition = registered[name]
    throw new Error("unable to locate the #{name} snippet") unless definition
    if instance
      new Mercury.Snippet(definition.signature())
    else
      definition


  # Returns all registered snippets as an object.
  #
  @all: ->
    registered


  # Unregister a snippet by providing a name. This will remove the snippet from the registered plugins.
  #
  @unregister: (name) ->
    definition = registered[name]
    throw new Error("unable to locate the #{name} snippet") unless definition
    delete registered[name]


  # The snippet constructor expects a name, and one should always be passed in the options. It will throw an error if no
  # name was provided. All options will be assigned as instance variables (and if they're functions their scope will be
  # correct, but super will not be available.
  #
  constructor: (@options = {}) ->
    @configuration = @options.config || {}
    @[key] = value for key, value of @options when key not in ['config']
    throw new Error('must provide a name for snippets') unless @name

    @supportedRegions ||= 'all'

    super(@defaults || {})


  # This method is called by the snippet plugin, or elsewhere when a snippet is being inserted. The region should be
  # passed, and is used to determine if the snippet is allowed to be placed in that region. If the snippet is supported
  # it will first display a form (if there's one), otherwise it calls through to #render.
  #
  initialize: (@region) ->
    if @supportedRegions != 'all' && @supportedRegions.indexOf(@region.type()) == -1
      return alert(@t("Unable to use the #{@name} snippet in that region. Supported regions: #{@supportedRegions.join(', ')}"))
    return @displayForm() if @form
    @render()


  # Delegates to setTimeout swapping the argument order, and calling the callback within our scope.
  # Returns the setTimeout so it can be cancelled.
  #
  delay: (ms, callback) ->
    setTimeout((=> callback.call(@)), ms)


  # Displays a modal with the configured form template. You can change which view class that's instantiated by
  # specifying a @Modal attribute. The #render method will be called when form:success is triggered from the view.
  #
  displayForm: (form) ->
    view = new (@Modal || Mercury.Modal)
      title: @get('title')
      template: @templateClosure(form || @form)
      width: 600
      model: @
      hideOnValidSubmit: true
    view.on('form:success', => @render())


  # Renders the view, or calls save if there's a url specified for the model. This allows for synchronous and
  # asynchronous patterns to be used.
  #
  render: (options = {}) ->
    options = $.extend({}, @renderOptions, options)
    return @save(options) if @url() && !@renderedView
    @renderView(options.template)


  # Renders the view by calling #view with the template passed, or the configured template. Triggers a rendered event.
  #
  renderView: (template) ->
    @renderedView = @view(@templateClosure(template || @template))
    @trigger('rendered', @renderedView)
    @delay(1, @afterRender)


  # This method is called directly after the snippet is rendered into a region. You can do post insertion processing
  # with this if needed.
  #
  afterRender: ->
    Mercury.trigger('reinitialize')


  # Provides the view that will be instantiated when the snippet is rendered for a region. Can be overridden if a custom
  # view is needed.
  #
  view: (template) ->
    new Mercury.Snippet.View(template: template, snippet: @)


  # When a save request is made, and is successful, we assume it's responded with either html content, or JSON.
  #
  # When a snippet is saved, it's expected that the server respond with either html content, or with JSON with the
  # preview attribute set to the rendered content.
  #
  saveSuccess: (content) ->
    @renderView(=> @get('preview') || content)


  # Binds the template that will be passed to the views to the snippet instance.
  #
  templateClosure: (template) ->
    closure = (=> template(arguments...)) if typeof(template) == 'function'
    closure || template


  # Public API method for getting the rendered view. Regions use this in their snippet handler to get the content of the
  # snippet.
  #
  getRenderedView: (region) ->
    @renderedView


Mercury.Snippet.Module =

  registerSnippet: Mercury.Snippet.register
  getSnippet: Mercury.Snippet.get


class Mercury.Snippet.Definition

  # This houses the snippet options as a definition so they can be used later when instantiating a Snippet. This class
  # also serves as a convenience for getting the snippet options, etc. and is returns when registering a snippet.
  #
  constructor: (@options = {}) ->
    @name = @options.name
    throw new Error('must provide a name for snippets') unless @name
    @configuration = @options.config
    @title = @options.title
    @description = @options.description
    @version = @options.version
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


class Mercury.Snippet.View extends Mercury.View

  # The base snippet view provides the default classname, and data attributes to be able to select and get a reference
  # to the snippet model.
  #
  build: ->
    @addClass("mercury-#{@snippet.name}-snippet")
    @attr('data-mercury-snippet': @snippet.name)
    @$el.data('snippet': @snippet)
