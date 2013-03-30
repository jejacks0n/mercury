#= require mercury/core/view
#= require mercury/templates/toolbar

class Mercury.Toolbar extends Mercury.View

  logPrefix: 'Mercury.Toolbar:'
  className: 'mercury-toolbar'
  template: 'toolbar'

  events:
    'interface:hide': 'hide'
    'interface:show': 'show'
    'region:focus': 'onRegionFocus'
    'click .mercury-toolbar-development-collection [data-action]': 'processAction'

  elements:
    toolbar: '.mercury-toolbar-secondary-container'

  build: ->
    @append(new Mercury.ToolbarItem('primary', 'container', @config("toolbars:primary")))
    @append(new Mercury.ToolbarItem('secondary', 'container', {}))


  hide: ->
    @el.css(top: -@el.height())


  show: ->
    @el.css(top: 0)


  onRegionFocus: (region) ->
    return if @region == region
    @region = region
    @$('.mercury-toolbar-collection').remove()
    @buildToolbar(name).updateForRegion(region) for name in region.toolbars || []


  buildToolbar: (name) ->
    toolbar = new Mercury.ToolbarItem(name, 'collection', @config("toolbars:#{name}"))
    toolbar.appendTo(@toolbar)
    toolbar


  processAction: (e) ->
    target = $(e.target)
    act = target.data('action')
    val = target.data('value')
    switch act
      when 'interface'
        @hidden ?= @config('interface:enabled')
        @hidden = !@hidden
        if @hidden then Mercury.trigger('interface:show') else Mercury.trigger('interface:hide')
        Mercury.trigger('mode', 'preview')
      when 'preview'
        Mercury.trigger('mode', 'preview')
      when 'html'
        val = switch val
          when 'html' then '<table>\n  <tr>\n    <td>1</td>\n    <td>2</td>\n  </tr>\n</table>'
          when 'el' then $('<section class="foo"><h1>testing</h1></section>').get(0)
          when 'jquery' then $('<section class="foo"><h1>testing</h1></section>')
        Mercury.trigger('action', act, val)
      else Mercury.trigger('action', act, val)
