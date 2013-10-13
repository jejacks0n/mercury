# Adding functionality.
#
# This file provides examples on how to add functionality to Mercury.
#
# We assign window.Mercury to parent.Mercury in case we're being loaded in an iframe where Mercury isn't being loaded.
#
@Mercury ||= parent.Mercury

# Actions - Toolbars and Actions
#
# For custom toolbar functionality you can create a toolbar and add it to regions that you've added the associated
# custom action to. In this example we're just going to dump some HTML into any region that can handle HTML.
#
# First we define the toolbar. In this example we embed the action information directly in the button, but this may
# not always be optimal and adding a more complex action method is advisable for more complex situations. You can
# override any toolbar button or group using the same technique, just naming it the same as what you want to replace.
# You can read about the various button options in the README.
#
# You'll notice here that we're using an icon character on the button, which maps to a glyph that's defined in the
# font. You can add your own, and there's more info about that in the README.
#
toolbar = twitter: ['Twitter', icon: 'fav', action: ['html', '<a href="http://twitter.com/jejacks0n">jejacks0n</a>']]

# Next we add the new toolbar to the regions that we want to be able to handle it. The toolbar button will be added
# and enabled for any region that we add the toolbar to and that also supports the HTML action. For regions that don't
# support the HTML action it will appear disabled.
#
Mercury.Region.Markdown.addToolbar('links', toolbar)
Mercury.Region.Html.addToolbar('links', toolbar)


# Actions - Actions and Region Configuration
#
# A more complex example of functionality is adding a soft wrap toggle for the markdown region. Like above, we need to
# add a toolbar button, but in this case we want a more complex method that will handle the action.
#
Mercury.Region.Markdown.addToolbar 'settings', wrap: ['Soft Wrap', icon: 'soft-wrap']

# The action handler simply toggles the wrap attribute on the focusable element (which is the common name for text
# based regions.) If you want the button to work like a toggle button check out the next example -- adding context.
#
Mercury.Region.Markdown.addAction 'wrap', -> @$focusable.attr(wrap: if @$focusable.attr('wrap') then null else 'off')


# Actions - Data and Context
#
# This example covers how to add more complex behaviors that understand context and are stored in the element data, so
# it can be serialized on save.
#
# First, we add the toolbar buttons we'll need. When a user sets the direction we want to track what it is, so we're
# going to store it in the element data -- which we can use use later when we render the region from the server.
#
Mercury.Region.Markdown.addToolbar 'directions', direction: ['RTL/LTR', icon: 'direction']

# To have the button highlight under various conditions we need to add a context. The button will highlight when it's
# context is true. Our context simply checks to see if the region has it's direction set to rtl -- which makes our
# button work like a toggle.
#
Mercury.Region.Markdown.addContext 'direction', -> @css('direction') == 'rtl'

# Next, since we're using a data attribute we need to know what to do when it's set. This allows us to restore things
# from the undo/redo stack. Initially this handler will be called with null, and you're expected to set a default --
# which allows specifying defaults as well as resetting it in the case when it's removed.
#
Mercury.Region.Markdown.addData 'direction', (val) -> @css('direction', val || 'ltr')

# And finally we add the action. You'll notice we're going through the #data method when setting this, which will call
# through to the data handler that we defined using the .addData method above. If you attempt to set the element data
# directly you will get inconsistent and unexpected results.
#
Mercury.Region.Markdown.addAction 'direction', ->
  direction = if @data('direction') == 'rtl' then 'ltr' else 'rtl'
  @data(direction: direction)


# Actions - Data and Context (using addBehavior)
#
# After you understand the basic API for adding toolbars, actions, data, and contexts you can consider them as a group
# that comprises a behavior. You can summarize and shortcut the above example with this example, which may be cleaner
# and more concise, depending on the level of logic required for the given behavior.
#
# Note: If this and the above example are both used there will be two buttons that do the same thing and that highlight
# correctly when the other is clicked. That's the benefit of context.
#
Mercury.Region.Markdown.addBehavior 'direction',
  toolbar: ['RTL/LTR', icon: 'direction']
  context: -> @css('direction') == 'rtl'
  data: (val) -> @css('direction', val || 'ltr')
  action: -> @data(direction: if @data('direction') == 'rtl' then 'ltr' else 'rtl')


# Actions - Getting and Replacing Selections
#
# In this example we'll work with getting and replacing the selection. Like the previous examples we need a toolbar
# that we can interact with.
#
Mercury.Region.Markdown.addToolbar 'calculations', calc: ['Calculate', icon: 'calculate']

# Now we just have to add the action that attempts to calculate the given selection. In this case we replace the
# selection with whatever was evaled -- note, this also allows for javascript injection, so is intended as an example
# only. Now if you select a math equation ("1+2") and click this button, you'll get the result of that ("3") in your
# selection.
#
Mercury.Region.Markdown.addAction 'calc', ->
  try @replaceSelection(eval(@getSelection().text))
  catch e
    @notify('Unable to calcuate the selection -- try selecting a math equation')


# Actions - Custom Actions / Models
#
# When an action is triggered it will be handled by the active region, and arguments can vary. For the simplest case
# (arguments like strings, numbers, etc) the arguments will be passed directly to the action handler. But when the
# argument is a "plain" object, it will be converted to an Action (class), which has a get method much like a model.
#
# A custom Action instance will be created if an Action matching the name of the given action is available, otherwise
# the base Action class will be used. This allows much more complex behavior to be shared between regions. Let's take
# the Action.Image as an example. That action can provide various things, like serializing fully as html, taking into
# account it's alignment, alt text, etc. OR it can just provide those attributes for a region that doesn't understand
# html.
#
# Create a custom Action.
#
class Mercury.Action.Person extends Mercury.Action
  name: 'person'
  html: -> """<div class="person"><h1>#{@get('name')}</h1><h2>#{@get('title')}</h2></div>"""
  markdown: -> "\n# #{@get('name')} #\n## #{@get('title')} ##\n"

# Once we have a custom Action class we can create the action handlers. Now the handlers can be different per region.
#
Mercury.Region.Markdown.addAction 'person', (person) -> @replaceSelection(person.markdown())
Mercury.Region.Html.addAction 'person', (person) -> @replaceSelection(person.html())

# Now, if we trigger the action it will make it through and can be handled differently based on the region type. This
# is also true when passing Models. Actions specifically mimic models so they can be interchangable. If you were to
# pass a model instance to an action it can be used the same as an Action instance.
#
toolbar = person: ['Personal Details', icon: 'user', action: ['person', name: 'Jeremy', title: 'Developer']]
Mercury.Region.Markdown.addToolbar('people', toolbar)
Mercury.Region.Html.addToolbar('people', toolbar)


# Toolbar Interfaces - Custom Elements
#
# Note: This example uses the "range" input, which currently isn't supported in Firefox or IE.
#
# You may want to add more complex toolbar interactions, for instance a more advanced color picker. This is possible
# when defining a button, and naming convention comes into play for doing this.
#
# First, let's create a view that we want to utilize when a given button is clicked. We'll create a slider drop down
# for a hypothetical image brightness control. Obviously we can't fit that much into this example, so it will only be
# mocked. Notice how we name it ToolbarSlider -- this is important, because when we define the button we'll use
# "slider". We're also including the InterfaceFocusable module -- which allows event handling for inputs within the
# toolbar dialogs -- which gets complicated, and is one of the more tedious aspects to contend with. With the
# InterfaceFocusable module you can specify a few things that will make focusing inputs and keeping Mercury focused.
#
class Mercury.ToolbarSlider extends Mercury.ToolbarPalette
  revertFocusOn: 'input'                                           # specify that we want focus reverted on the input.
  events: 'change input': ->                                       # when the input is changed.
    Mercury.trigger('action', 'brightness', @$('input').val())     # trigger action.

# Now we need to create a button that will tell Mercury that it should use this new view type for the buttons subview.
# We do the same thing as the previous examples, but this time we're adding an additional configuration property for
# "slider". This directly maps to "Mercury.ToolbarSlider". We're also providing the view with a template to load, and
# in this case it's the brightness_slider template, which we'll define in next. If the value of the subview is a
# string, but we could also provide an object, in which case the entire object would be passed to the constructor for
# our view.
#
Mercury.Region.Image.addToolbar 'filters', brightness: ['Brightness', icon: 'brightness', slider: 'brightness_slider']

# To finish up the ToolbarSlider view we need to define the template that we're telling the ToolbarSlider to use. We
# can define this in the JST namespace, or we can have our server respond -- which is configurable. But for the demo
# we're just going to define a simple string with a slider input.
#
Mercury.JST['/mercury/templates/brightness_slider'] = -> '<input type="range"/>'

# At this point we have the button, the subview and everything we need. If you were to check, the button would still
# be disabled -- because the image region doesn't know what to do with brightness yet. Now we just need to tie it all
# together with an action. If you wanted this to be part of the undo stack you may consider using a data attribute and
# calling @pushHistory after setting it -- though this is a bad example for that since change triggers as the slider
# is moved.
#
Mercury.Region.Image.addAction 'brightness', (val) -> console.debug("brightness set to #{val}")


# Toolbar Interfaces - Customized Buttons
#
# Note: This example uses the "range" input, which currently isn't supported in Firefox or IE.
#
# Now that you know how to make more complex button subviews, you may want to consider replacing buttons themselves
# with more complex views that have additional behavior.
#
# Let's say we aren't happy with a button that has a drop down for selecting brightness. We want to replace the entire
# button with a slider to reduce clicks because we expect it to be a commonly used action.
#
# Well, we can do that, and again we can define that with the button. Also, like the previous example we need to make
# a custom button view. We've simplified this view by building the element ourselves, and we're not using a template.
#
class Mercury.ToolbarSliderButton extends Mercury.View
  @include Mercury.View.Modules.InterfaceFocusable               # minimize events bubbling to toolbar.
  className: 'mercury-toolbar-slider-button'                     # for styling.
  revertFocusOn: 'input'                                         # selector for focus events that revert to mercury.
  events: 'change input': ->                                     # when the input is changed.
    Mercury.trigger('action', 'brightness', @$('input').val())   # trigger action.
  build: -> @append('<input type="range"/>')                     # append the input element.

# Now we need to expose this view by adding it to the toolbar. Notice here how we define the button property, which is
# used to determine which view should be used in place of the button.
#
Mercury.Region.Image.addToolbar 'advanced', brightness: ['Brightness', button: 'slider_button']

# Since we've already provided this action for the image region there's no need to do it again. We're done.


# Advanced Integration - Using Plugins
#
# Let's take a look at a plugin and make some adjustments first. The Character Plugin allows using it within in a
# modal, or it can use a toolbar palette (like the color plugin). This is just one example of how you could write
# plugins, and there's more advanced ones to look into. Reading the existing plugin code is probably the best way to
# figure out how to implement something.
#
# Let's start by adding the toolbar button where we want it -- in this case it's the markdown region. You'll notice
# that we've specified the plugin here as an option to the button.
#
Mercury.Region.Markdown.addToolbar 'extra', character: ['Character', plugin: 'character']

# Additionally, and this is up to the plugin, options can be provided through the button. If you specify a config
# object in the button definition this will be passed to the plugin. Here we want to change it to use a palette and
# not the modal, so we're going to redefine the button we just added to not use a modal -- which means the button in
# the primary toolbar will still use a modal, but the one that we've added to the markdown toolbar will use a palette.
#
Mercury.Region.Markdown.addToolbar 'extra', character: ['Character', plugin: 'character', settings: {modal: false}]

# We can also configure the plugin globally -- much like how we can configure Mercury. Each plugin can be configured
# independently. This is optional for this example.
#
#Mercury.getPlugin('character').configure('modal', false)

# As a final step we might want to remove the existing button (that's in the primary toolbar by default). This is
# optional for this example.
#
#Mercury.configure('toolbars:primary:character', false)
