@JST ||= {}
JST['/mercury/templates/editor'] = (scope) ->
  """
  <ul id="mercury_controls">
    <li data-action="preview">Toggle Preview</li>
    <li data-action="undo">Undo</li>
    <li data-action="redo">Redo</li>
    <li data-action="swapDirection">Swap Direction</li>
    <li data-action="bold">Bold</li>
    <li><input type="text"/></li>
  </ul>
  """
