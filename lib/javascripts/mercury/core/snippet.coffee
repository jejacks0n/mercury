#= require mercury/core/model
#= require mercury/core/view
#= require mercury/views/modal

registered = {}

class Mercury.Snippet extends Mercury.Model

  @logPrefix: 'Mercury.Snippet:'

  @register: (name, options) ->
    options.name = name
    new Mercury.Snippet.Definition(options)


  @get: (name, instance = false) ->
    definition = registered[name]
    throw new Error("unable to locate the #{name} snippet") unless definition
    if instance
      new Mercury.Snippet(definition.signature())
    else
      definition


  @all: ->
    registered


  @unregister: (name) ->
    definition = registered[name]
    throw new Error("unable to locate the #{name} snippet") unless definition
    delete registered[name]


  constructor: (@options = {}) ->
    @configuration = @options.config || {}
    @[key] = value for key, value of @options when key not in ['config']
    throw new Error('must provide a name for snippets') unless @name

    super(@defaults || {})


  initialize: (@region) ->
    return @displayForm() if @form
    @render()


  displayForm: (form) ->
    view = new (@Modal || Mercury.Modal)
      title: @get('title')
      template: @templateClosure(form || @form)
      width: 600
      model: @
      hideOnValidSubmit: true
    view.on('form:success', => @render())


  render: (options = {}) ->
    options = $.extend({}, @renderOptions, options)
    return @save(options) if @url() && !@renderedView
    @renderView(options.template)


  renderView: (template) ->
    @renderedView = @view(@templateClosure(template || @template))
    @trigger('rendered', @renderedView)


  view: (template) ->
    new Mercury.View(template: template, className: "mercury-#{@name}-snippet")


  saveSuccess: (content) ->
    @renderView(=> @get('preview') || content)


  templateClosure: (template) ->
    closure = (=> template(arguments...)) if typeof(template) == 'function'
    closure || template


  getRenderedView: (region) ->
    @renderedView


Mercury.Snippet.Module =

  registerSnippet: Mercury.Snippet.register
  getSnippet: Mercury.Snippet.get


class Mercury.Snippet.Definition

  constructor: (@options = {}) ->
    @name = @options.name
    throw new Error('must provide a name for snippets') unless @name
    @configuration = @options.config
    @title = @options.title
    @description = @options.description
    @version = @options.version
    registered[@name] = @


  signature: (functions = true) ->
    sig = $.extend({}, @options, config: @configuration)
    if !functions then for name, value of sig
      delete sig[name] if typeof(value) == 'function'
    sig
