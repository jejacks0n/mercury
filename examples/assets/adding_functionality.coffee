# Adding functionality
#
# Adding functionality.
#
# This file provides examples on how to add functionality to Mercury.
#
# For our examples, we need to wait until Mercury is defined and initialized, but if you do this in the file that's
# requiring Mercury, or if you know that frames will never be used you can do this at any point before Mercury.init is
# called.
#
Mercury?.on 'initialize', ->

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
  toolbar = twitter: ['Twitter', icon: '0', action: ['html', '<a href="http://twitter.com/jejacks0n">jejacks0n</a>']]

  # Next we add the new toolbar to the regions that we want to be able to handle it. The toolbar button will be added
  # and enabled for any region that we add the toolbar to and that also supports the HTML action. For regions that don't
  # support the HTML action it will appear disabled.
  Mercury.Region.Markdown.addToolbar('links', toolbar)
  Mercury.Region.Html.addToolbar('links', toolbar)


  # Actions - Actions and Region Configuration
  #
  # A more complex example of functionality is adding a soft wrap toggle for the markdown region. Like above, we need to
  # add a toolbar button, but in this case we want a more complex method that will handle the action.
  Mercury.Region.Markdown.addToolbar 'settings', wrapping: ['Soft Wrap', icon: '1']

  # The action handler simply toggles the wrap attribute on the focusable element (which is the common name for text
  # based regions.) If you want the button to work like a toggle button check out the next example -- adding context.
  Mercury.Region.Markdown.addAction 'wrapping', -> @focusable.attr(wrap: if @focusable.attr('wrap') then null else 'off')


  # Actions - Data and Context
  #
  # This example covers how to add more complex behaviors that understand context and are stored in the element data, so
  # it can be serialized on save.
  #
  # First, we add the toolbar buttons we'll need. When a user sets the direction we want to track what it is, so we're
  # going to store it in the element data -- which we can use use later when we render the region from the server.
  Mercury.Region.Markdown.addToolbar 'directions', direction: ['RTL/LTR', icon: '2']

  # To have the button highlight under various conditions we need to add a context. The button will highlight when it's
  # context is true. Our context simply checks to see if the region has it's direction set to rtl -- which makes our
  # button work like a toggle.
  Mercury.Region.Markdown.addContext 'direction', -> @el.css('direction') == 'rtl'

  # Next, since we're using a data attribute we need to know what to do when it's set. This allows us to restore things
  # from the undo/redo stack. Initially this handler will be called with null, and you're expected to set a default --
  # which allows specifying defaults as well as resetting it in the case when it's removed.
  Mercury.Region.Markdown.addData 'direction', (val) -> @el.css('direction', val || 'ltr')

  # And finally we add the action. You'll notice we're going through the #data method when setting this, which will call
  # through to the data handler that we defined using the .addData method above. If you attempt to set the element data
  # directly you will get inconsistent and unexpected results.
  Mercury.Region.Markdown.addAction 'direction', ->
    direction = if @data('direction') == 'rtl' then 'ltr' else 'rtl'
    @data(direction: direction)


  # Actions - Getting and Replacing Selections
  #
  # In this example we'll work with getting and replacing the selection.
  #
  # Like the previous examples we need a toolbar button / group that we can interact with. It's advisable to always
  # include a separator in your toolbars so they don't clump together with other toolbar buttons.
  Mercury.Region.Markdown.addToolbar 'calculations', calc: ['Calculate', icon: '3']

  # Now we just have to add the action that attempts to calculate the given selection. In this case we replace the
  # selection with whatever was evaled -- note, this also allows for javascript injection, so is intended as an example
  # only.
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
  class Mercury.Action.Person extends Mercury.Action
    name: 'person'
    html: -> """<div class="person"><h1>#{@get('name')}</h1><h2>#{@get('title')}</h2></div>"""
    markdown: -> "\n# #{@get('name')} #\n## #{@get('title')} ##\n"

  # Once we have a custom Action class we can create the action handlers. Now the handlers can be different per region.
  Mercury.Region.Markdown.addAction 'person', (person) -> @replaceSelection(person.markdown())
  Mercury.Region.Html.addAction 'person', (person) -> @replaceSelection(person.html())

  # Now, if we trigger the action it will make it through and can be handled differently based on the region type. This
  # is also true when passing Models. Actions specifically mimic models so they can be interchangable. If you were to
  # pass a model instance to an action it can be used the same as an Action instance.
  toolbar = person: ['Personal Details', icon: '4', action: ['person', name: 'Jeremy', title: 'Developer']]
  Mercury.Region.Markdown.addToolbar('people', toolbar)
  Mercury.Region.Html.addToolbar('people', toolbar)
