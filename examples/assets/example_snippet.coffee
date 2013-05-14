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
# the snippet is rendered. This custom view could do all sorts of complex view things.
#
Snippet = Mercury.registerSnippet 'twitter',
  title: 'Twitter Snippet'
  description: 'Twitter feed example (client side only, no server implementation needed).'
  version: '1.0.0'

  defaults:
    username: 'modeset_'

  validate: ->
    @addError('username', "can't be blank") unless @get('username')

  form: 'snippets/twitter/form'
  view: -> new Snippet.View(snippet: @)


class Snippet.View extends Mercury.View
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


JST['/mercury/templates/snippets/twitter/form'] = ->
  """
  <h3>This snippet allows specifying a twitter username and when inserted will display tweets from that user. Note that it has to be an active twitter account and only tweets within the past 5 days will be displayed (this is due to how twitter exposes search).</h3>
  <hr/>
  <form class="form-horizontal">
    <fieldset>
      <div class="control-group string required">
        <label class="string required control-label" for="username">Twitter Username</label>
        <div class="controls">
          <input class="string required" id="username" name="username" size="50" type="text" tabindex="1">
        </div>
      </div>
    </fieldset>

    <div class="form-actions">
      <input class="btn btn-primary" name="commit" type="submit" value="Insert Twitter Snippet" tabindex="2">
    </div>
  </form>
  """


