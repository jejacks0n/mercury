#
# Developer interface.
#
# This file provides examples for how to do various things with Mercury.
#
# We can use the Mercury Core library to create things like views, models, regions, etc. Dive into the code to check out
# whats possible. It has a lot of comments and is pretty easy to read.
#
class @DeveloperInterface extends Mercury.View
  @include Mercury.View.Modules.InterfaceFocusable

  template: 'developer-interface'
  className: 'developer-interface'
  tag: 'ul'

  events:
    'mousedown': 'focusMercury'                            # to keep Mercury focused we need to stop the event
    'click [data-action]': 'delegateAction'                # delegate actions to Mercury with custom handling for some

  # Releases a given region.
  # To remove a region from Mercury we need to call release on the region, which we can access using the data('region')
  # property. Once a region has been released Mercury will no longer track it -- in this case we also remove the
  # data-mercury attribute so it will not be recreated on reinitialize. In this example interface we also remove the
  # controls that allow us to remove/delete the region.
  #
  @releaseRegion: (el) ->
    el = $(el).closest('.region')
    el.find('[data-mercury]').removeAttr('data-mercury').data('region').release()
    el.find('.region-controls').remove()


  # Deletes a given region.
  # Similar to releasing a region, we first have to release the region itself to tell Mercury that it's no longer
  # tracked, and then we remove the entire container.
  #
  @deleteRegion: (el) ->
    el = $(el).closest('.region')
    el.find('[data-mercury]').data('region').release()
    el.closest('.region').remove()


  # Append ourselves to the body.
  #
  build: ->
    @appendTo($('body'))


  # Delegates various actions/events to Mercury, and serves as an example for various ways you can interact with Mercury
  # externally. Check each method that this delegates to, to see more details on how you can potentially interact.
  #
  delegateAction: (e) ->
    target = $(e.target)
    [action, value] = [target.data('action'), target.data('value')]
    switch action

      # general / top level events
      when 'save' then @save()
      when 'toggle_interface' then @toggleInterface()
      when 'reinitialize' then @reinitialize()
      when 'add_new_region' then @addNewRegion()
      when 'release' then @release()

      # dealing with modals
      when 'new_modal'
        @modal?.show()
        @modal ||= new Mercury.Modal(width: 300, title: 'Short Lorem Modal', template: 'lorem_short', releaseOnHide: false)
      when 'update_modal' then @modal?.update(width: Math.round(Math.random() * 700) + 200, title: 'Updated Lorem Modal', template: 'lorem_long')
      when 'size_modal' then @modal?.update(width: 600, title: 'Updated Lorem Modal')
      when 'release_modal' then @modal?.release(); delete(@modal)

      # dealing with lightview (just like modals)
      when 'new_lightview'
        @lightview?.show()
        @lightview ||= new Mercury.Lightview(width: 300, title: 'Short Lorem Lightview', template: 'lorem_short', releaseOnHide: false)
      when 'update_lightview' then @lightview?.update(width: Math.round(Math.random() * 800) + 300, title: 'Updated Lorem Lightview', template: 'lorem_long')
      when 'size_lightview' then @lightview?.update(width: 600, title: 'Updated Lorem Modal')
      when 'release_lightview' then @lightview?.release(); delete(@lightview)

      # dealing with panels (same as modals/lightviews, but not a subclass)
      when 'new_panel'
        @panel?.show()
        @panel ||= new Mercury.Panel(width: 200, title: 'Short Lorem Panel', template: 'lorem_short')
      when 'update_panel' then @panel?.update(width: Math.round(Math.random() * 300) + 100, title: 'Updated Lorem Panel', template: 'lorem_long')
      when 'release_panel' then @panel?.release(); delete(@panel)

      # triggering actions
      when 'html'
        value = switch value
          when 'html' then '<table>\n  <tr>\n    <td>1</td>\n    <td>2</td>\n  </tr>\n</table>'
          when 'el' then $('<section class="foo"><h1>testing</h1></section>').get(0)
          when 'jquery' then $('<section class="foo"><h1>testing</h1></section>')
        Mercury.trigger('action', action, value)
      else Mercury.trigger('action', action, value)


  # Focuses Mercury.
  # If you have an interface that you don't want to effect the focused state of Mercury, you will need to handle these
  # events yourself. By preventing the event we never let Mercury lose focus, and by triggering the 'focus' event we're
  # telling Mercury that it should refocus it's active region. Regions are responsible for reselecting/restoring state
  # if they do not do it automatically. If you have inputs in your view you'll need to let the event go through (by not
  # using preventDefault) and will need to refocus Mercury when it seems appropriate. You can also trigger the 'blur'
  # event, which will blur any regions so that typing in the background isn't possible -- you can see this on modals and
  # lightviews -- and panels do it slightly differently.
  #
  focusMercury: (e) ->
    @prevent(e)
    Mercury.focus() # or Mercury.trigger('focus')


  # Tells Mercury to save. You can do this by calling the save method on the interface, or you can do it by triggering
  # the save event. In this case we simply console debug the value that would be saved.
  #
  save: ->
    #console.debug(Mercury.interface.serialize())
    Mercury.save() # or Mercury.trigger('save')


  # You can toggle the interface, which will make it appear as though Mercury isn't on the page. This can be useful for
  # various things. You can trigger the 'interface' event, which will toggle for you, or you can call toggleInterface on
  # the interface.
  #
  toggleInterface: ->
    Mercury.toggle() # or Mercury.trigger('interface:toggle')


  # If you reload your page, or have added new regions you can tell Mercury to go looking for new regions by triggering
  # the 'reinitialize' method or by calling the reinitialize method on the interface. Each interface class can implement
  # this differently, but by default this only looks for new regions.
  #
  reinitialize: ->
    Mercury.reinitialize() # or Mercury.trigger('reinitialize')


  # In our example we want to be able to add and remove regions as an example of how you can use Mercury to create all
  # sorts of complex interactions and page designs. If you provided a complex region management tool you could make the
  # entire page something that can be structured simply with using different region types. In our example we only add
  # new markdown regions into a set place. Once we've added a region we then tell Mercury to reinitialize.
  #
  addNewRegion: ->
    $('#new_regions').after(@renderTemplate('new-region'))
    @reinitialize()


  # Releases this view, and tells Mercury to clean itself up as well. This is not a typical need, but is here as a way
  # to document it.
  #
  release: ->
    $('.region-controls').remove()
    Mercury.release()
    super


@JST ||= {}
JST['/mercury/templates/new-region'] = ->
  """
  <div class="region">
    <div data-mercury="markdown" id="new_region_#{Math.floor(Math.random() * 10000)}">Lorem ipsum</div>
    <div class="region-controls">
      <a class="delete" onclick="DeveloperInterface.deleteRegion(this)">delete</a>|
      <a class="release" onclick="DeveloperInterface.releaseRegion(this)">release</a>
    </div>
  </div>
  """
JST['/mercury/templates/developer-interface'] = ->
  """
  <li data-action="save">save</li>
  <li data-action="toggle_interface">toggle interface</li>
  <li data-action="reinitialize">reinitialize</li>
  <li data-action="add_new_region">add new region</li>
  <li data-action="release">release</li>
  <hr/>
  <li data-action="new_modal">new modal</li>
  <li data-action="update_modal">update modal</li>
  <li data-action="size_modal">size modal</li>
  <li data-action="release_modal">release modal</li>
  <hr/>
  <li data-action="new_lightview">new lightview</li>
  <li data-action="update_lightview">update lightview</li>
  <li data-action="size_lightview">size lightview</li>
  <li data-action="release_lightview">release lightview</li>
  <hr/>
  <li data-action="new_panel">new panel</li>
  <li data-action="update_panel">update panel</li>
  <li data-action="release_panel">release panel</li>
  <hr/>
  <li data-action="style" data-value="border:1px solid red">style</li>
  <li data-action="style" data-value="foo">class</li>
  <li data-action="html" data-value="html">html (with html)</li>
  <li data-action="html" data-value="el">html (with element)</li>
  <li data-action="html" data-value="jquery">html (with jQuery)</li>
  <li data-action="link" data-value='{"url": "https://github.com/jejacks0n/mercury", "text": "Project Home"}'>link</li>
  <li data-action="image" data-value='{"url": "http://goo.gl/sZb1K", "text": "Test Image"}'>image</li>
  <hr/>
  <li><input type="text"/></li>
  """
top.JST['/mercury/templates/lorem_short'] = ->
  """
  Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
  """
top.JST['/mercury/templates/lorem_long'] = ->
  """
  Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.<br/><br/>
  Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.<br/><br/>
  Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.<br/><br/>
  Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.<br/><br/>
  Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.<br/><br/>
  Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.<br/><br/>
  Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.<br/><br/>
  Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
  """
