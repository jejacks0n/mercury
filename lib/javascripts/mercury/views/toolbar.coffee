#= require mercury/core/view
#= require mercury/templates/toolbar

class Mercury.Toolbar extends Mercury.View

  logPrefix: 'Mercury.Toolbar:'
  className: 'mercury-toolbar'
  template: 'toolbar'

  events:
    'region:update': 'onRegionUpdate'
    'interface:hide': 'hide'
    'interface:show': 'show'

    'click [data-action]': 'processAction'

  constructor: ->
    super
    @hidden = @config('interface:enabled')


  processAction: (e) ->
    target = $(e.target)
    act = target.data('action')
    val = target.data('value')
    switch act
      when 'interface'
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


  onRegionUpdate: (region) ->
    # do nothing for now


  hide: ->
    @el.css(top: -@el.height())


  show: ->
    @el.css(top: 0)
