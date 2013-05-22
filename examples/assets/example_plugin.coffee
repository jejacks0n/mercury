# Advanced Integration - Defining Plugins
#
# Mercury provides a plugin architecture that allows you to define and register a plugin that enables adding more
# advanced functionality. In this example we'll make a better and more advanced color picker so you can see how to
# integrate more advanced features with plugins.
#
# After reading this example (assuming you've read adding_functionality, and example_snippet) you now have all the
# information to mold Mercury into what you need it to be. Anything beyond this level of documentation requires a solid
# understanding of how Javascript, CSS, and how the browser works. Just go reading through the Mercury code, and review
# the specs to learn more about how you can modify Mercury at a lower level to suit your needs.
#
# Each plugin should define the basic information so plugins can be displayed or understood. Plugins should use a unique
# name, provide a general description and specify a version. Plugins can include css, and that should be mentioned in
# the documentation.
#
# Once you've register a plugin using the Mercury.registerPlugin method, or through Mercury.Plugin.register, a new
# instance of Mercury.Plugin.Definition is created. You can continue to add to the plugin definition after this instance
# has been created, and in this example we do that by defining a Plugin.Palette view -- this view becomes part of the
# definition, and we'll cover that more below.
#
# When a button registers for a plugin a new Mercury.Plugin instance will be created from the Mercury.Plugin.Definition
# instance. This allows for plugins to be specific to buttons, but also allows for a more general case plugin
# architecture as well. If you're interested in how plugins work you should look at the core/plugin.coffee file.
#
# If you want to use this plugin instead of the existing color plugin you can change the name from 'advanced_color', to
# 'color' (where it's being registered), or adjust the color toolbar buttons to use this one instead (in general this is
# how you can change buttons):
#
#Mercury.configure('toolbars:html:color:color', ['Text Color', plugin: 'advancedColor'])
#Mercury.configure('toolbars:html:color:bgcolor', ['Background Color', plugin: 'advancedColor'])
#
Plugin = Mercury.registerPlugin 'advancedColor'
  description: 'Provides a more advanced interface for selecting colors.'
  version: '1.0.0'

  # Specifying actions.
  #
  # Actions specify what actions a region should handle. Actions should be ordered based on preference, the first being
  # the preferred, and every other one as a fallback.
  #
  # When #triggerAction is called, the region is asked for what is supported in the order defined here. When a supported
  # action is determined the callback provided is called with the determined action and any values that were passed to
  # #triggerAction. In addition, you can use the action as defined by the button name by specifying prependButtonAction
  # (eg. if the button is named bgColor, that action will be used if the region supports it. This allows other
  # developers to use your plugin in their own custom regions.
  #
  # Both prependButtonAction and actions should have a handler method. In this example we use a single handler, but you
  # might want to use different handlers for the different action types.
  #
  prependButtonAction: 'insert'
  actions:
    color: 'insert'
    html: 'insert'
    text: 'insert'

  # Configuration.
  #
  # Plugins can use the config key to specify various internal configuration values. These are specific to the plugin,
  # and can be accesses using the #config method within the plugin -- much like the Mercury.config method you can
  # provide a path to an object value. When asking a plugin for a configuration that's also specified in Mercury, the
  # plugin can override the top level value -- but only from within the plugin.
  #
  # Here we're just providing the ability to allow rgba or hex. If you change alpha to false, the hex value will be
  # passed to the handler, otherwise the rgba value will be passed.
  #
  config:
    alpha: true

  # Tying to buttons / adding button behaviors.
  #
  # Plugins are often tied to buttons, or initiated with a button action. This can be achieved when creating a toolbar
  # and specifying the plugin option to a button. When a plugin is specified for a button, this will be called when the
  # button is instantiated. You can add additional configuration or functionality to the button from within this method.
  # In this example we set the subview (which the button tracks), and the type, which can be used for styling.
  #
  # When registerButton is called, the @button will already be assigned.
  #
  registerButton: ->
    @button.set(type: 'color', subview: @bindTo(new Plugin.Palette()))


  # Adding contexts for regions.
  #
  # This plugin changes the button to be a color button, which displays the current color. We can use this to ask the
  # current region if our button should be highlighted, or in this case what color we should be displaying. Here we use
  # the @context, which is defined when a button registers. The @context is really just the name of the button, and like
  # the prependButtonAction option it allows other developers to use this plugin in their custom regions.
  #
  regionContext: ->
    @button.css(color: color) if color = @region.hasContext(@context, true) || @region.hasContext('color', true)


  # Action handlers.
  #
  # When #triggerAction is called it will ask the region which actions it supports. Internally the plugin architecture
  # attempts to identify which action should be triggered, and will call the handler defined in the actions options. To
  # explain that a little more let's say there's a region that supports color, and html actions. The color action will
  # be passed as the first argument, and any other arguments passed to #triggerAction will come through after that. This
  # is to allow a single handler to handle more than one action type.
  #
  # It's common that you would trigger an action event from within the handlers. The action event is picked up by the
  # active region and will be handled, so in our case we could potentially be triggering the button name action, color,
  # html, or text actions here. It sort of doesn't matter a whole lot in this example, but you could have two very
  # different handlers for html and text -- which might get you into custom actions, but that's for a different example.
  #
  # Here we just trigger an action event (with whatever action the region supports), and the color value as hex.
  insert: (name, value) ->
    Mercury.trigger('action', name, "##{value}")


  # This bindTo pattern is something that you can use, but isn't specific to Snippets. When we create a view we can bind
  # to it's events and do custom handling. In this example we're using a custom Palette that's defined below. This is a
  # good example of how to use views within plugins, but it's entirely up to you on how you accomplish that.
  #
  bindTo: (view) ->
    view.on 'color:picked', (value) =>
      @triggerAction(value)
      @button.css(color: "##{value}")


# Defining plugin views.
#
# This it the view that's displayed when a button that's registered for our plugin is clicked. This is provided more as
# an example of how to use some of the base views within plugins than anything else, but also shows how we can add more
# to the plugin definition.
#
# You'll notice that when we register the plugin we assign the return value to Plugin -- this allows us to reference the
# Mercury.Plugin.Definition instance directly and add more to it. This creates a nice closure type of situation where we
# can reference that object from within our plugin options. Anyway, I'll lighten up on commenting the code, and you can
# use the rest of this file as an example of how you could use the base views to create more complex features.
#
class Plugin.Palette extends Mercury.ToolbarPalette
  # We want to be able to style our view, so we add a custom class -- which is added on top of the existing class names.
  className: 'mercury-color-palette'

  # To tell the plugin when a color has been picked we trigger a custom event that the plugin is listening for. Here we
  # get the current color and pass it along.
  events:
    'mousedown': (e) -> e.stopPropagation() # we do this to keep the dialog from closing on interactions.
    'click': (e) -> e.stopPropagation() # we do this to keep the dialog from closing on interactions.
    'click li': (e) ->
      value = $(e.target).data('value')
      @$('.last-picked').data(value: value).css(background: "##{value}")
      @trigger('color:picked', value)

  # Here's our template. Templates can be provided in many ways, and this is just one example. Templates can be JST, in
  # which case it's name should start with '/mercury/templates/' (if the JST isn't found a request to the server can be
  # made if configured to do so), or we could pass the template in as options when we instantiate the class. Check out
  # the core/view.coffee file if you want to know more about how templates are handled.
  #
  template:  ->
    """asdasd"""


# In this example we'll be brief. This example is useful for snippet regions, and instead of using the snippet panel
# we're going to provide a dropdown where snippets can be selected and inserted. It works the same as the panel, but
# might be easier for some users. Who knows, it's an example.
#
SnippetsPlugin = Mercury.registerPlugin 'snippetsSelect'
  description: 'Provides interface for adding snippets by using a dropdown.'
  version: '1.0.0'

  actions:
    snippet: 'insert'

  # You can use "type: 'select'" if you wanted it to look more like a dropdown and less like a button.
  #
  registerButton: ->
    @button.set(type: 'snippets', subview: @bindTo(new SnippetsPlugin.Select()))


  # Typical bindTo pattern used here -- and throughout the examples.
  bindTo: (view) ->
    view.on('insert:snippet', (value) => @triggerAction(value))


  # Inserting a snippet is a little more complex than other things, because it might need to render a form (typically in
  # a modal) to collect information from the user before inserting the modal. For this we have a similar architecture to
  # plugins, but if you're interested in snippets, you should be reading example_snippet.coffee.
  #
  insert: (name, snippetName) ->
    snippet = Mercury.getSnippet(snippetName, true).on('rendered', (view) -> Mercury.trigger('action', name, snippet, view))
    snippet.initialize(@region)


class SnippetsPlugin.Select extends Mercury.ToolbarSelect
  template:   'snippets_select'
  className:  'mercury-snippets-select'
  events:     'click [data-value]': (e) -> @trigger('insert:snippet', $(e.target).closest('[data-value]').data('value'))
  attributes: style: 'width:200px'


Mercury.JST['/mercury/templates/snippets_select'] = ->
  """<ul>#{("<li data-value='#{name}'><b>#{snippet.title}</b><br/><em>#{snippet.description}</em></li>" for name, snippet of Mercury.Snippet.all()).join('')}</ul>"""


# Now we add this plugin to the snippet region. We could now remove the snippet button in the primary region and
# snippets would only be allowed in the snippet region.
#
Mercury.Region.Snippet.addToolbar 'snippets', snippet: ['Snippet', plugin: 'snippetsSelect']
