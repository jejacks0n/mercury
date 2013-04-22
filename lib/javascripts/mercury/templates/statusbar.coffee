@JST ||= {}
JST['/mercury/templates/statusbar'] = ->
  """
  <div class="mercury-statusbar-about">
    <a href="https://github.com/jejacks0n/mercury" target="_blank">Mercury Editor v#{Mercury.version}</a>
  </div>
  <div class="mercury-statusbar-path"></div>
  """
