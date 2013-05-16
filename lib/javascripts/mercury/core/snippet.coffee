#= require mercury/core/model
#= require mercury/views/modal

registered = {}

class Mercury.Snippet extends Mercury.Model
  @extend Mercury.I18n

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
    @[key] = value for key, value of @options when key not in ['config']
    throw new Error('must provide a name for snippets') unless @name
    super(@options.defaults)


  initialize: ->
    if @form
      @displayForm()
    else
      @render()


  displayForm: ->
    form = @form
    form = (=> @form(arguments)) if typeof(form) == 'function'
    view = new (@Modal || Mercury.Modal)(title: @get('title'), template: form, width: 600, model: @, hideOnValidSubmit: true)
    view.on('form:success', => @render())
    view


  view: (template) ->
    new Mercury.View(template: template, className: "mercury-#{@name}-snippet")


  render: (options = {}) ->
    options = $.extend({}, @renderOptions, options)
    return @save(options) if @url() && !@renderedView
    @renderView(options.template)


  renderView: (template) ->
    template ||= @template
    closure = (=> template(arguments)) if typeof(template) == 'function'
    @renderedView = @view(closure || template)
    @trigger('rendered', @renderedView)


  saveSuccess: (content) ->
    @renderView(=> @get('preview') || content)


  getRenderedView: (region) ->
    @renderedView


Mercury.Snippet.Module =

  registerSnippet: Mercury.Snippet.register
  getSnippet: Mercury.Snippet.get


class Mercury.Snippet.Definition

  constructor: (@options = {}) ->
    $.extend(@, @options)
    registered[@name] = @


  signature: (functions = true) ->
    sig = $.extend({}, @options, config: @configuration)
    if !functions then for name, value of sig
      delete sig[name] if typeof(value) == 'function'
    sig
