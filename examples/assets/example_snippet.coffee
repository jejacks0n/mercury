# Advanced Integration - Defining Snippets
#
# Mercury has a concept of embedded content. These are refered to as snippets. A snippet could be anything from a simple
# snippet of html, to something much more complex like a custom view with complex javascript interactions. Snippets can
# be one of the more complex aspects of Mercury so a firm understanding of javascript and server interactions is
# expected.
#
# With that being said, Mercury provides a relatively easy way to define snippets, and allows them to be pretty
# flexible. They are defined a lot like plugins, but they're sort of a model view sort of thing.
#
# Anyway, there's a few examples in this file, and they go from simple content, to a fully complex server driven
# snippet.
#
# When a snippet has been registered, that snippet will be visible in the snippet panel, and can be inserted in any
# region that handles snippets. You can insert snippets in two ways -- by dragging/dropping a snippet into a region, or
# by using the "Insert" button in the snippet list.
#
# Snippets inherit from Mercury.Model, so what you're dealing with is technically a model that can both provide a form
# view and one of two possible view types. The simplest is just a template method (or property that references a JST).
# This is called when the snippet is rendered and the snippet content will be generated from it. A more advanced
# approach is to provide a #view method -- which is expected to return a view (typically a Mercury.View). If the view
# method exists it will be called first, and the template method or property will be used as a fallback.
#
# In general you want to treat snippets like a model that has a few additional properties and methods to create the
# views needed to set and render those values. A ModelView or ViewModel.. whatever floats your boat. If that bothers
# you, you can pretty much treat this as a controller and create a view and a model that interact, but that's up to you
# and is a more complex use case -- but if you're that pedantic it's likely you can figure out how to accomplish that.
#
# Ok, so like plugins, you need to provide a name, and then an options object. Title, description and version are
# expected to be included.
#
# Once you've register a snippet using the Mercury.registerSnippet method, or through Mercury.Snippet.register, a new
# instance of Mercury.Snippet.Definition is created. You can continue to add to the snippet definition after this
# instance has been created, and in this example we do that by defining a Snippet.View -- this view becomes part of the
# definition, and we'll cover that more below.
#
# A simple content snippet example.
#
# This example uses a template to display plugins that have been registered with Mercury. It's pretty much a bunny slope
# if we were to use the snow sports metaphore.
#
Mercury.registerSnippet 'plugins',
  title: 'Plugin Snippet'
  description: 'Lists plugins that have been registered with Mercury.'
  version: '1.0.0'

  # The template method is called when rendering the snippet. It can build out whatever string it wants, and that will
  # be used as the snippet content. Like for #form method the #template method can reference a JST:
  #
  # template: 'snippets/plugin' (expects JST['mercury/templates/snippets/plugin'] to be defined)
  #
  template: ->
    plugins = ''
    for name, plugin of Mercury.Plugin.all()
      plugins += """<li>#{plugin.name} v#{plugin.version}<br/><em>#{plugin.description}</em></li>"""
    """<h3>Registered Plugins</h3><ul>#{plugins}</ul>"""


# Full view snippet example.
#
# This example might be considered a green or blue run. It includes a form to collect a twitter username, has validation
# and default values, but it doesn't rely on a server implementation. It also has a custom view that will be used when
# the snippet is rendered -- which could do all sorts of complex view things if you needed it to.
#
TwitterSnippet = Mercury.registerSnippet 'twitter',
  title: 'Twitter Snippet'
  description: 'Twitter feed example (client side only, no server implementation needed).'
  version: '1.0.0'

  form: 'snippets/twitter/form'

  defaults:
    username: 'modeset_'
    checkbox: true

  validate: -> @addError('username', "can't be blank") unless @get('username')

  view: -> new TwitterSnippet.View(snippet: @)


class TwitterSnippet.View extends Mercury.Snippet.View
  className: 'mercury-example-snippet'
  template: ->
    """
    <div id="#{"twitter_feed_#{@snippet.cid}"}"></div>
    <script>
    new TWTR.Widget({
      search: 'from:#{@snippet.get('username')}',
      id: '#{"twitter_feed_#{@snippet.cid}"}',
      loop: false,
      width: 250,
      height: 300,
      theme: {
        shell: {
          background: '#fff',
          color: '#000'
        },
        tweets: {
          background: '#fff',
          color: '#000',
          links: '#00bce5'
        }
      }
    }).render().start();
    </script>
    """


Mercury.JST['/mercury/templates/snippets/twitter/form'] = ->
  """
  <strong>This snippet allows specifying a twitter username and when inserted will display tweets from that user. Note that it has to be an active twitter account and only tweets within the past 5 days will be displayed (this is due to how twitter exposes search).</strong>
  <hr/>
  <form class="form-horizontal">
    <fieldset>
      <div class="control-group string required">
        <label class="string required control-label" for="username">Twitter Username</label>
        <div class="controls">
          <input class="string required" id="username" name="username" size="50" type="text" tabindex="1">
        </div>
      </div>
      <div class="control-group boolean">
        <div class="controls">
          <label class="checkbox required control-label" for="Checkbox"><input class="checkbox" id="checkbox" name="checkbox" type="checkbox" value="1">Foo</label>
        </div>
      </div>
    </fieldset>

    <div class="form-actions">
      <input class="btn btn-primary" name="commit" type="submit" value="Insert Twitter Snippet" tabindex="2">
    </div>
  </form>
  """


# Server backed snippet example.
#
# This example might be considered a blue run. It includes a server based form to collect a name, and your favorive type
# of beer (limited selection, sorry). This example doesn't have a concept of validation, and if you want more
# information about how a server can be used for this example check out the mercury-rails project on github.
#
Mercury.registerSnippet 'beer',
  title: 'Beer Snippet'
  description: 'Server backed snippet example. It requests a form from the server.'
  version: '1.0.0'

  # We haven't specified this template anywhere in JST, so an ajax request will be sent to the server, which is expected
  # to respond to this path (GET). To utilize this you need to ensure that this works you may need to adjust the
  # template configuration. This file is located in examples/templates/snippets/beer/form.haml.
  #
  # The form that's returned could use a ujs handler to submit/get the response back as well, but in our case we're not
  # worrying about validation on the server, so we just need the server to render the form for us.
  #
  form: 'snippets/beer/form'

  # Like the above examples, we can still specify defaults -- or the server can do that for us too, but this shows that
  # it doesn't really matter.
  #
  defaults:
    name: 'jejacks0n'

  # If you want the snippet to save to the server you can provide a url for it. This allows you to take the attributes
  # from the snippet (after the form has been submitted) and pass them to the server. It's up to you how you implement
  # the server portion, but it's expected that the server return a JSON object with a preview attribute set. This file
  # is located in examples/templates/snippets/beer/template.haml.
  #
  url: -> '/mercury/templates/snippets/beer/template'

  # While having the server respond with JSON (with the preview attribute set) is a good solution for sane people, we
  # like breaking rules, so we're not going to return JSON from the server with the preview attribute. Nope, we're going
  # to modify the renderOptions to specify that we accept html back. This is actually to keep the server in this project
  # simple, but it's nice to pretend you're a rule breaking badass sometimes.
  #
  # renderOptions are passed to save, and are also used during the rendering process, but here we're just modifying the
  # ajax options.
  #
  renderOptions:
    dataType: 'html'

  # Here's a bonus example that shows how you can make the modal be some other class -- in this case we're using a
  # Lightview instead of a Modal.
  #
  Modal: Mercury.Lightview


# Editable regions within a snippet.
#
# I'd guess this is sort of a green run, but you're going down that run with explosives strapped to your body. This is a
# commonly asked for feature however, and though I strongly disagree with it because it's just asking to be abused and
# misunderstood, I've provide an example of how you could potentially shoot yourself in the foot -- with the hope that
# you can detmine when to use this and when not to. Good luck with that.
#
# It should be noted that this is only tested with a snippet in the snippet region using markdown and plain regions as
# the sub regions. Markdown and other "textarea" types of regions can't support nested regions because they're textareas
# and thus don't support nested elements.
#
Mercury.registerSnippet 'editable',
  title: 'Editable Snippet'
  description: "Example snippet with editable regions within it. This isn't a good idea, so use it wisely."
  version: '1.0.0'

  # Like the previous examples we have a simple template, but we've added a markdown and an html region. Notice we don't
  # put names on these regions, because it's dynamic (there could be many of these snippets throughout the page), so
  # there's not an easy way in this example to give them a unique name -- which means you may have to resolve some
  # things manually on the server when saving/rerendering the content. It's important to note that you get the raw
  # region element/content -- including all data attributes and whatever else the region has done to the element in the
  # value -- the regions themselves are serialized as a value of the snippet.
  #
  template: ->
    """
    Lorem ipsum dolor sit amet, consectetur adipisicing elit.
    <blockquote>
      <div data-mercury="markdown">Markdown Region</div>
      <div data-mercury="plain">Plain Region</div>
    </blockquote>
    Ad amet architecto eius eligendi eos inventore minus, necessitatibus nobis nulla officiis optio quam quas qui quis quos repellat, sapiente tempore veritatis?
    """

  # The afterRender method is provided for this exact type of thing, and again, is a great way to shoot yourself in the
  # foot. If you're putting regions into your snippets you'll need a deep understanding of each region type, and in our
  # case we have an embedded markdown region, which does some things to the element -- namely replacing it's content
  # with a textarea a preview div. Since we want to keep the value on undo/redo we find any of the textarea elements and
  # reset their parent values so the content can be restored properly.
  #
  # After we've assured that all regions can in fact be loaded we tell Mercury to reinitialize itself to find any new
  # regions -- specifically the ones we know were just added.
  #
  afterRender: ->
    textarea = @renderedView.$('textarea[data-mercury-region]')   # handling for textarea regions -- eg. text/markdown
    textarea.parent().html(textarea.val())
    Mercury.trigger('reinitialize')                               # tell mercury that we have new regions to initialize.

  # We probably want to serialize the content from the region, and we do that here by setting the content attribute by
  # finding the element, getting the region instance, and asking for it to serialize.
  #
  toJSON: ->
    $.extend(true, {}, @attributes, {regions: @subRegions()})

  # Provides a way to serialize the regions into the snippet data. This example should handle any level of nested sub
  # regions -- provided they behave correctly and can allow snippets with editable regions etc.
  #
  subRegions: ->
    regions = {}
    for el in @renderedView?.$('[data-mercury]') || []
      continue unless region = $(el).data('region')
      regions[region.name] = region.toJSON(true)
    regions

