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


  init: ->
    if @form
      @displayForm()
    else
      setTimeout((=> @trigger('insert')), 50)


  displayForm: ->
    view = new (@Modal || Mercury.Modal)(title: @get('title'), template: @form, width: 600, model: @, hideOnValidSubmit: true)
    view.on('form:success', => @trigger('insert'))
    view


  render: (region) ->
    return @view() if @view
    return new Mercury.View(template: @template, className: "mercury-#{@name}-snippet")


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
