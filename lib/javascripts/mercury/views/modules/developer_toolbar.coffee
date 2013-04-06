Mercury.View.Modules.DeveloperToolbar =

  included: ->
    @on('init', @buildDeveloperToolbar)


  buildDeveloperToolbar: ->
    @append(@renderTemplate('developer-toolbar'))
    @delegateEvents 'click .mercury-developer-toolbar [data-action]': 'developerAction'


  developerAction: (e) ->
    target = $(e.target)
    act = target.data('action')
    val = target.data('value')
    switch act
      when 'interface'
        @hidden ?= @config('interface:enabled')
        @hidden = !@hidden
        if @hidden then Mercury.trigger('interface:show') else Mercury.trigger('interface:hide')
        Mercury.trigger('mode', 'preview')
      when 'html'
        val = switch val
          when 'html' then '<table>\n  <tr>\n    <td>1</td>\n    <td>2</td>\n  </tr>\n</table>'
          when 'el' then $('<section class="foo"><h1>testing</h1></section>').get(0)
          when 'jquery' then $('<section class="foo"><h1>testing</h1></section>')
        Mercury.trigger('action', act, val)
      else Mercury.trigger('action', act, val)


@JST ||= {}
JST['/mercury/templates/developer-toolbar'] = (scope) ->
  """
  <ul class="mercury-developer-toolbar">
  <li data-action="interface">toggle interface</li>
  <hr/>
  <li data-action="block" data-value="none">none</li>
  <li data-action="block" data-value="h1">h1</li>
  <li data-action="block" data-value="h2">h2</li>
  <li data-action="block" data-value="h3">h3</li>
  <li data-action="block" data-value="h4">h4</li>
  <li data-action="block" data-value="h5">h5</li>
  <li data-action="block" data-value="h6">h6</li>
  <li data-action="block" data-value="pre">pre</li>
  <li data-action="block" data-value="paragraph">paragraph</li>
  <li data-action="block" data-value="blockquote">blockquote</li>
  <hr/>
  <li data-action="style" data-value="border:1px solid red">style</li>
  <li data-action="style" data-value="foo">class</li>
  <hr/>
  <li data-action="html" data-value="html">html (with html)</li>
  <li data-action="html" data-value="el">html (with element)</li>
  <li data-action="html" data-value="jquery">html (with jQuery)</li>
  <hr/>
  <li data-action="link" data-value='{"url": "https://github.com/jejacks0n/mercury", "text": "Project Home"}'>link</li>
  <li data-action="image" data-value='{"url": "http://goo.gl/sZb1K", "text": "Test Image"}'>image</li>
  <hr/>
  <li><input type="text"/></li>
  </ul>
  """
