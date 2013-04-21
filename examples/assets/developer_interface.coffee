#
# Developer interface.
#
# This file provides examples for how to do various things with Mercury.
#
# We can use the Mercury Core library to create things like views, models, regions, etc. Dive into the code to check out
# whats possible. It has a lot of comments and is pretty easy to read.
#
class @DeveloperInterface extends Mercury.View

  template: 'developer-interface'
  className: 'developer-interface'
  tag: 'ul'

  events:
    'mousedown': 'focusMercury'                            # to keep Mercury focused we need to stop the event
    'focusout': 'focusMercury'                             # to keep Mercury focused we need to stop the event
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
      when 'save' then @save()
      when 'toggle_interface' then @toggleInterface()
      when 'reinitialize' then @reinitialize()
      when 'add_new_region' then @addNewRegion()
      when 'release' then @release()
      when 'modal1' then @modal = new Mercury.Modal(width: 300, title: 'Short Lorem Modal', template: 'lorem_short')
      when 'modal2' then @modal = new Mercury.Modal(width: 600, title: 'Long Lorem Modal', template: 'lorem_long')
      when 'release_modal' then @modal?.release()
      when 'lightview1' then @lightview = new Mercury.Lightview(width: 300, height: 200, title: 'Short Lorem Lightview', template: 'lorem_short')
      when 'lightview2' then @lightview = new Mercury.Lightview(width: 600, height: 500, title: 'Long Lorem Lightview', template: 'lorem_long')
      when 'release_lightview' then @lightview?.release()
      when 'panel1' then @panel = new Mercury.Panel(width: 200, title: 'Short Lorem Panel', template: 'lorem_short')
      when 'panel2' then @panel = new Mercury.Panel(width: 300, title: 'Long Lorem Panel', template: 'lorem_long')
      when 'update_panel' then @panel.update(width: Math.round(Math.random() * 400), title: 'Updated Lorem Panel', template: 'lorem_long')
      when 'release_panel' then @panel?.release()
      when 'html'
        value = switch value
          when 'html' then '<table>\n  <tr>\n    <td>1</td>\n    <td>2</td>\n  </tr>\n</table>'
          when 'el' then $('<section class="foo"><h1>testing</h1></section>').get(0)
          when 'jquery' then $('<section class="foo"><h1>testing</h1></section>')
        Mercury.trigger('action', action, value)
      else Mercury.trigger('action', action, value)


  # Focuses Mercury.
  # If you have an interface that you don't want to effect the focused state of Mercury, you will need to handle these
  # events yourself. By triggering the 'focus' event we're telling Mercury that it should refocus it's active region.
  #
  focusMercury: (e) ->
    e.preventDefault()
    Mercury.trigger('focus')


  # Tells Mercury to save. You can do this by calling the save method on the interface, or you can do it by triggering
  # the save event. In this case we simply console debug the value that would be saved.
  #
  save: ->
    # Mercury.trigger('save')
    console.debug(Mercury.interface.save())


  # You can toggle the interface, which will make it appear as though Mercury isn't on the page. This can be useful for
  # various things. You can trigger the 'interface' event, which will toggle for you, or you can call toggleInterface on
  # the interface.
  #
  toggleInterface: ->
    # Mercury.trigger('interface')
    Mercury.interface.toggleInterface()


  # If you reload your page, or have added new regions you can tell Mercury to go looking for new regions by triggering
  # the 'reinitialize' method or by calling the reinitialize method on the interface. Each interface class can implement
  # this differently, but by default this only looks for new regions.
  #
  reinitialize: ->
    # Mercury.trigger('reinitialize')
    Mercury.interface.reinitialize()


  # In our example we want to be able to add and remove regions as an example of how you can use Mercury to create all
  # sorts of complex interactions and page designs. If you provided a complex region management tool you could make the
  # entire page something that can be structured simply with using different region types. In our example we only add
  # new markdown regions into a set place. Once we've added a region we then tell Mercury to reinitialize.
  #
  addNewRegion: ->
    $('#new_regions').after(@renderTemplate('new-region'))
    @reinitialize()


  # Release this view, and tell Mercury to clean itself up.
  #
  release: ->
    $('.region-controls').remove()
    Mercury.release()
    super


@JST ||= {}
JST['/mercury/templates/new-region'] = (scope) ->
  """
  <div class="region">
    <div data-mercury="markdown" id="new_region_#{Math.floor(Math.random() * 10000)}">Lorem ipsum</div>
    <div class="region-controls">
      <a class="delete" onclick="DeveloperInterface.deleteRegion(this)">delete</a>|
      <a class="release" onclick="DeveloperInterface.releaseRegion(this)">release</a>
    </div>
  </div>
  """

JST['/mercury/templates/developer-interface'] = (scope) ->
  """
  <li data-action="save">save</li>
  <li data-action="toggle_interface">toggle interface</li>
  <li data-action="reinitialize">reinitialize</li>
  <li data-action="add_new_region">add new region</li>
  <li data-action="release">release</li>
  <hr/>
  <li data-action="modal1">modal1</li>
  <li data-action="modal2">modal2</li>
  <li data-action="release_modal">release modal</li>
  <hr/>
  <li data-action="lightview1">lightview1</li>
  <li data-action="lightview2">lightview2</li>
  <li data-action="release_lightview">release lightview</li>
  <hr/>
  <li data-action="panel1">panel1</li>
  <li data-action="panel2">panel2</li>
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
@JST ||= {}
JST['/mercury/templates/lorem_short'] = (scope) ->
  """
  Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
  """

JST['/mercury/templates/lorem_long'] = (scope) ->
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
