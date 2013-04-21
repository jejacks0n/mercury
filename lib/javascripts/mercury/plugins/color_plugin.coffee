Plugin = Mercury.registerPlugin 'color'
  description: 'Provides interface for selecting colors.'
  version: '1.0.0'

  prependButtonAction: 'insert'

  actions:
    color: 'insert'
    html: 'insert'
    text: 'insert'

  config:
    colors: 'FFFFFF FFCCCC FFCC99 FFFF99 FFFFCC 99FF99 99FFFF CCFFFF CCCCFF FFCCFF CCCCCC FF6666 FF9966 FFFF66 FFFF33 '+
            '66FF99 33FFFF 66FFFF 9999FF FF99FF C0C0C0 FF0000 FF9900 FFCC66 FFFF00 33FF33 66CCCC 33CCFF 6666CC CC66CC '+
            '999999 CC0000 FF6600 FFCC33 FFCC00 33CC00 00CCCC 3366FF 6633FF CC33CC 666666 990000 CC6600 CC9933 999900 '+
            '009900 339999 3333FF 6600CC 993399 333333 660000 993300 996633 666600 006600 336666 000099 333399 663366 '+
            '000000 330000 663300 663333 333300 003300 003333 000066 330099 330033'

  registerButton: ->
    @button.set(type: 'color', subview: @bindTo(new Plugin.Palette()))


  bindTo: (view) ->
    view.on 'color:picked', (value) =>
      @triggerAction(value)
      @button.css(color: "##{value}")


  regionContext: ->
    @button.css(color: color) if color = @region.hasContext(@context, true) || @region.hasContext('color', true)


  insert: (name, value) ->
    Mercury.trigger('action', name, "##{value}")


class Plugin.Palette extends Mercury.ToolbarPalette
  template:  'color'
  className: 'mercury-color-palette'
  events:    'click li': (e) ->
    value = $(e.target).data('value')
    @$('.last-picked').data(value: value).css(background: "##{value}")
    @trigger('color:picked', value)


@JST ||= {}
JST['/mercury/templates/color'] = (scope) ->
  """
  <ul>
    #{("<li data-value='#{color}' style='background:##{color}'></li>" for color in Plugin.config('colors').split(' ')).join('')}
    <li class="last-picked">Last Color Picked</li>
  </ul>
  """
